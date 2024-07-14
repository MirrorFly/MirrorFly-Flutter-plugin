package com.mirrorfly.mirrorfly_plugin.call

import android.Manifest
import android.content.pm.PackageManager
import androidx.core.content.ContextCompat
import com.mirrorfly.mirrorfly_plugin.*
import com.mirrorflysdk.api.ChatActionListener
import com.mirrorflysdk.api.ChatManager
import com.mirrorflysdk.api.contacts.ContactManager
import com.mirrorflysdk.api.utils.NameHelper
import com.mirrorflysdk.flycall.call.joincall.JoinCallListener
import com.mirrorflysdk.flycall.call.utils.CallNotificationHelper
import com.mirrorflysdk.flycall.webrtc.*
import com.mirrorflysdk.flycall.webrtc.api.*
import com.mirrorflysdk.flycommons.Error
import com.mirrorflysdk.flycommons.LogMessage
import com.mirrorflysdk.flycommons.exception.FlyException
import com.mirrorflysdk.flycommons.models.CallMetaData
import com.mirrorflysdk.helpers.Permissions
import io.flutter.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import org.webrtc.VideoTrack

class FlyCallMethods : MissedCallListener,JoinCallListener {
    val tag = "#FlutterCallEvents"
//    var context : Context = MirrrflyFlyManager.getContext()

    fun initCall() {
        //CallManager.init(context)
//        CallManager.setMissedCallListener(this)
//        ChatManager.setMediaNotificationHelper(this)
        CallManager.setCallHelper(object : CallHelper {
            override fun getNotificationContent(callDirection: String,callMetaDataArray: Array<CallMetaData>?): String {
                /*return if (BuildConfig.HIPAA_COMPLIANCE_ENABLED) {
                    when (callDirection) {
                        CallDirection.INCOMING_CALL -> resources.getString(R.string.new_incoming_call)
                        CallDirection.OUTGOING_CALL -> resources.getString(R.string.new_outgoing_call)
                        else -> resources.getString(R.string.new_ongoing_call)
                    }
                } else*/
                return CallNotificationHelper.getNotificationMessage()
            }

            /*override fun sendCallMessage(
                details: GroupCallDetails,
                users: List<String>,
                invitedUsers: List<String>
            ) {
                CallMessenger.sendCallMessage(details, users, invitedUsers)
            }*/
        })
        ChatManager.setNameHelper(object : NameHelper {
            override fun getDisplayName(jid: String): String {
                return ContactManager.getProfileDetails(jid)
                    .getDisplayName()//ContactManager.getDisplayName(jid)
            }

        })
        CallManager.setCallNameHelper(object : CallNameHelper {
            override fun getDisplayName(jid: String,callMetaDataArray: Array<CallMetaData>?): String {
                return ContactManager.getProfileDetails(jid)
                    .getDisplayName()//ContactManager.getDisplayName(jid)
            }
        })
//        CallManager.keepConnectionInForeground(false)
    }

    fun getCallDirection(call: MethodCall, result: MethodChannel.Result) {
        val direction =
            if (CallDirection.INCOMING_CALL == CallManager.getCallDirection()) "Incoming" else "Outgoing"
        result.success(direction)
    }

    fun isOnGoingCall(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.isOnGoingCall())
    }

    fun isOnGoingAudioCall(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.isOnGoingAudioCall())
    }

    fun isOnGoingVideoCall(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.isOnGoingVideoCall())
    }

    fun routeAudioTo(call: MethodCall, result: MethodChannel.Result) {
        val routeType = call.argument<String>("routeType") ?: ""
        LogMessage.d(tag, "routeType : $routeType")
        val selectedDevice =
            if (routeType == "receiver") AudioDevice.EARPIECE else if (routeType == "speaker") AudioDevice.SPEAKER_PHONE else if (routeType == "bluetooth") AudioDevice.BLUETOOTH else if (routeType == "headset") AudioDevice.WIRED_HEADSET else AudioDevice.NONE
        //CallAudioManager.getInstance(context).selectAudioDevice(selectedDevice)
        CallManager.setAudioDevice(selectedDevice)
        LogMessage.d(tag, "selectedDevice : $selectedDevice")
        result.success(true)
    }

    fun getAllAvailableAudioInput(call: MethodCall, result: MethodChannel.Result) {
        val availableAudioDevices = JSONArray()
        var y = 1
        for (audioDevice in CallManager.getAudioDevices()) {
            val type =
                if (audioDevice == AudioDevice.EARPIECE) "receiver" else if (audioDevice == AudioDevice.SPEAKER_PHONE) "speaker" else if (audioDevice == AudioDevice.BLUETOOTH) "bluetooth" else if (audioDevice == AudioDevice.WIRED_HEADSET) "headset" else "none"
            val obj = JSONObject()
            obj.put("id", y.toString())
            obj.put("type", type)
            obj.put("name", audioDevice)
            y++
            availableAudioDevices.put(obj)
        }
        LogMessage.d(tag, "availableAudioDevices : $availableAudioDevices")
        result.success(availableAudioDevices.toString())
    }

    fun makeVoiceCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            val userJid: String = call.argument("user_jid") ?: ""
            println("permission ${CallManager.isAudioCallPermissionsGranted(skipBlueToothPermission = false)}")
            LogMessage.d(
                "makeVoiceCall",
                "permission granted ${CallManager.isAudioCallPermissionsGranted(skipBlueToothPermission = false)}"
            )
            if (CallManager.isAudioCallPermissionsGranted(false)) {
                CallManager.makeVoiceCall(calleeJid = userJid, listener = object : CallActionListener {
                    override fun onResponse(isSuccess: Boolean, flyException: FlyException?) {
                        LogMessage.d("makeCall", "success $isSuccess message ${flyException?.message}")
                        if (isSuccess) {
                            result.success(true)
                        } else {
                            result.error("500", flyException?.message, flyException)
                        }
                    }
                })
            } else {
                result.error("500", "Audio call permissions not granted", "")
            }
        }catch(exception: Exception){
            if (exception is FlyException) {
                exception as FlyException
                result.error("500", exception.message, exception)
            }
        }
    }

    fun makeVideoCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            val userJid: String = call.argument("user_jid") ?: ""
            LogMessage.d(
                "makeVideoCall",
                "permission granted ${CallManager.isVideoCallPermissionsGranted(skipBlueToothPermission = false)}"
            )
            if (CallManager.isVideoCallPermissionsGranted(skipBlueToothPermission = false)) {
                CallManager.makeVideoCall(calleeJid = userJid, listener = object : CallActionListener {
                    override fun onResponse(isSuccess: Boolean, flyException: FlyException?) {
                        LogMessage.d(
                            "makeVideoCall",
                            "success $isSuccess message ${flyException?.message}"
                        )
                        if (isSuccess) {
                            result.success(true)
                        } else {
                            result.error("500", flyException?.message, flyException)
                        }
                    }

                })
            } else {
                result.error("500", "Video call permissions not granted", "")
            }
        }catch(exception: Exception){
            if (exception is FlyException) {
                exception as FlyException
                result.error("500", exception.message, exception)
            }
        }
    }

    fun answerCall(call: MethodCall, result: MethodChannel.Result) {
        if (CallManager.getCallType() == CallType.AUDIO_CALL && !CallManager.isAudioCallPermissionsGranted(
                false
            )
        ) {
            LogMessage.d(
                "answerCall",
                "call type ${CallManager.getCallType()} permission granted ${
                    CallManager.isAudioCallPermissionsGranted(false)
                }"
            )
            return
        } else if (CallManager.getCallType() == CallType.VIDEO_CALL && !CallManager.isVideoCallPermissionsGranted(
                false
            )
        ) {
            LogMessage.d(
                "answerCall",
                "call type ${CallManager.getCallType()} permission granted ${
                    CallManager.isVideoCallPermissionsGranted(false)
                }"
            )
            return
        }
        CallManager.answerCall(object : CallActionListener {
            override fun onResponse(isSuccess: Boolean, flyException: FlyException?) {
                LogMessage.d("answerCall", "success $isSuccess message ${flyException?.message}")
                if (isSuccess) {
                    result.success(isSuccess)
                } else {
                    result.error("500", flyException?.message, flyException)
                }
            }

        })
    }

    fun declineCall(call: MethodCall, result: MethodChannel.Result) {
        CallManager.declineCall()
        LogMessage.d("declineCall", "called")
    }

    fun disconnectCall(call: MethodCall, result: MethodChannel.Result) {
//        if (checkIsUserInCall()) {
        CallManager.disconnectCall(object : CallActionListener {
            override fun onResponse(isSuccess: Boolean, flyException: FlyException?) {
                if (isSuccess) {
                    result.success(true)
                } else {
                    result.error("500", flyException?.message, flyException)
                }
            }

        })

        /* }else{
             result.success(true)
         }*/
        LogMessage.d("disconnectCall", "called")
    }

    private fun checkIsUserInCall(): Boolean {
//        return CallManager.isOnGoingCall() || (CallManager.isCallConnected() && CallManager.is()) || isInPIPMode()
        return true
    }

    fun muteAudio(call: MethodCall, result: MethodChannel.Result) {
        LogMessage.d(tag, "muteAudio")
        val muteAudio = call.argument<Boolean>("muteAudio") ?: false
        CallManager.muteAudio(muteAudio)
        result.success(true)
        sentMuteStatus(if(muteAudio) "LOCAL_AUDIO_MUTE" else "LOCAL_AUDIO_UN_MUTE")
    }

    private fun sentMuteStatus(muteEvent: String){
        val userJid =CallManager.getCurrentUserId()
        when (muteEvent){
            "LOCAL_VIDEO_MUTE" ->{
                if (MirrorflyViewHashMap.getMirrorflyView(userJid) != null) {
                    MirrorflyViewHashMap.getMirrorflyView(userJid)?.setProfileView(userJid)
                }
            }
            "LOCAL_VIDEO_UN_MUTE" ->{
                if (MirrorflyViewHashMap.getMirrorflyView(userJid) != null) {
                    MirrorflyViewHashMap.getMirrorflyView(userJid)?.setLocalTarget()
                }
            }
        }
        val json = JSONObject()
        json.put("muteEvent", muteEvent)
        json.put("userJid", userJid)

//        onMuteStatusUpdatedStreamHandler.onMuteStatusUpdated?.success(json.toString())
        FlyMethodConstants.updateCallSinkValue(Constants.onMuteStatusUpdated, json.toString())
    }

    fun muteVideo(call: MethodCall, result: MethodChannel.Result) {
        LogMessage.d(tag, "muteVideo")
        val muteVideo = call.argument<Boolean>("muteVideo") ?: false
        CallManager.muteVideo(muteVideo, object : CallActionListener {
            override fun onResponse(isSuccess: Boolean, flyException: FlyException?) {
                LogMessage.d(
                    tag,
                    "$muteVideo ${CallManager.getCurrentUserId()} ${
                        MirrorflyViewHashMap.getMirrorflyView(CallManager.getCurrentUserId())
                    }"
                )
                if (isSuccess) {
                    sentMuteStatus(if(muteVideo) "LOCAL_VIDEO_MUTE" else "LOCAL_VIDEO_UN_MUTE")
                    result.success(true)
                } else {
                    result.error("500", flyException?.message, flyException)
                }
            }

        })
    }

    fun makeGroupVoiceCall(call: MethodCall, result: MethodChannel.Result) {
        try {
//            if (CallManager.isAudioCallPermissionsGranted(false)) {
                val groupJid = call.argument<String>("groupJid") ?: ""
                val jidList = call.argument<List<String>>("jidList")
                CallManager.makeGroupVoiceCall(
                        jidList = jidList as ArrayList<String>,
                        groupId = groupJid,
                        listener = object : CallActionListener {
                            override fun onResponse(isSuccess: Boolean, flyException: FlyException?) {
                                LogMessage.d(
                                        "makeGroupVoiceCall",
                                        "success $isSuccess message ${flyException?.message}"
                                )
                                if (isSuccess) {
                                    result.success(true)
                                } else {
                                    result.error("500", flyException?.message, flyException)
                                }
                            }
                        })
//            result.success(true)
//            }
        }catch(exception: Exception){
            if (exception is FlyException) {
                exception as FlyException
                result.error("500", exception.message, exception)
            }
        }
    }

    fun makeGroupVideoCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            LogMessage.d(tag, "muteVideo")
            val groupJid = call.argument<String>("groupJid") ?: ""
            val jidList = call.argument<List<String>>("jidList")
            CallManager.makeGroupVideoCall(
                jidList = jidList as ArrayList<String>,
                groupId = groupJid,
                listener = object : CallActionListener {
                    override fun onResponse(isSuccess: Boolean, flyException: FlyException?) {
                        LogMessage.d(
                            "makeGroupVideoCall",
                            "success $isSuccess message ${flyException?.message}"
                        )
                        if (isSuccess) {
                            result.success(isSuccess)
                        } else {
                            result.error("500", flyException?.message, flyException)
                        }
                    }

                })
//            result.success(true)
        }catch(exception: Exception){
            if (exception is FlyException) {
                exception as FlyException
                result.error("500", exception.message, exception)
            }
        }
    }

    fun isUserAudioMuted(call: MethodCall, result: MethodChannel.Result) {
        val userJid = call.argument<String>("userJid") ?: ""
        val response = if (userJid.isEmpty() || userJid == CallManager.getCurrentUserId())
            CallManager.isAudioMuted()
        else CallManager.isRemoteAudioMuted(userJid)
        result.success(response)
    }

    fun isUserVideoMuted(call: MethodCall, result: MethodChannel.Result) {
        val userJid = call.argument<String>("userJid") ?: ""
        val response = if (userJid.isEmpty() || userJid == CallManager.getCurrentUserId())
            CallManager.isVideoMuted()
        else CallManager.isRemoteVideoMuted(userJid)
        result.success(response)
    }

    fun getCallUsersList(call: MethodCall, result: MethodChannel.Result) {
        LogMessage.d(tag, "getCallUsersList : " + CallManager.getCallUsersList().toJsonString())
        val json = JSONArray()
        val users = CallManager.getCallUsersList()
        if (users.isNotEmpty()) {
            users.forEachIndexed { index, jid ->
                var obj = JSONObject()
                obj.put("userJid", jid)
                //Calling status not in iOS so here we sent Trying to Connect status
                obj.put(
                        "callStatus",
                        if (CallManager.getCallStatus(jid) == CallStatus.CALLING) "Trying to Connect" else CallManager.getCallStatus(
                                jid
                        )
                )
                obj.put("isAudioMuted", CallManager.isRemoteAudioMuted(jid))
                obj.put("isVideoMuted", CallManager.isRemoteVideoMuted(jid))
                json.put(obj)
                if (index == users.lastIndex) {
                    if (!users.contains(CallManager.getCurrentUserId()) && CallManager.getCurrentUserId()
                                    .isNotEmpty()
                    ) {
                        obj = JSONObject()
                        obj.put("userJid", CallManager.getCurrentUserId())
                        obj.put(
                                "callStatus",
                                if (CallManager.getCallStatus(CallManager.getCurrentUserId()) == CallStatus.CALLING) "Trying to Connect" else CallManager.getCallStatus(
                                        CallManager.getCurrentUserId()
                                )
                        )
                        obj.put("isAudioMuted", CallManager.isAudioMuted())
                        obj.put("isVideoMuted", CallManager.isVideoMuted())
                        json.put(obj)
                    }
                }
            }
        }else{
            //added for call link join call
            val obj = JSONObject()
            obj.put("userJid", CallManager.getCurrentUserId())
            obj.put(
                    "callStatus",
                    if (CallManager.getCallStatus(CallManager.getCurrentUserId()) == CallStatus.CALLING) "Trying to Connect" else CallManager.getCallStatus(
                            CallManager.getCurrentUserId()
                    )
            )
            obj.put("isAudioMuted", CallManager.isAudioMuted())
            obj.put("isVideoMuted", CallManager.isVideoMuted())
            json.put(obj)
        }

        result.success(json.toString())
    }

    fun selectedAudioDevice(call: MethodCall, result: MethodChannel.Result) {
        val type =
            when (CallAudioManager.getInstance(MirrorFlyManager.getContext()).selectedAudioDevice) {
                AudioDevice.EARPIECE -> "receiver"
                AudioDevice.SPEAKER_PHONE -> "speaker"
                AudioDevice.BLUETOOTH -> "bluetooth"
                AudioDevice.WIRED_HEADSET -> "headset"
                else -> "none"
            }
        result.success(type)
    }

    fun isVideoMuted(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.isVideoMuted())
    }

    fun isRemoteVideoMuted(call: MethodCall, result: MethodChannel.Result) {
        val userJid: String = call.argument("user_jid") ?: ""
        result.success(CallManager.isRemoteVideoMuted(userJid))
    }

    fun isRemoteVideoPaused(call: MethodCall, result: MethodChannel.Result) {
        val userJid: String = call.argument("user_jid") ?: ""
        result.success(CallManager.isRemoteVideoPaused(userJid))
    }

    fun switchCamera(call: MethodCall, result: MethodChannel.Result) {
        CallManager.switchCamera()
        result.success(true)
    }

    fun isCallOnHold(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.isCallOnHold())
    }

    fun isOneToOneCall(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.isOneToOneCall())
    }

    fun getGroupID(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.getGroupID())
    }

    fun getCallType(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.getCallType())
    }

    fun isCallConnected(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.isCallConnected())
    }

    fun isVideoCall(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.getCallType() == CallType.VIDEO_CALL)
    }

    fun isAudioCall(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.getCallType() == CallType.AUDIO_CALL)
    }

    fun isCallNotConnected(call: MethodCall, result: MethodChannel.Result) {
        result.success(!CallManager.isCallConnected() && !CallManager.isCallAnswered())
    }

    fun getOnGoingCallDisplayStatus(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.getOnGoingCallStatus(MirrorFlyManager.getContext()))
    }

    fun getUnreadMissedCallCount(call: MethodCall, result: MethodChannel.Result) {
        try {
            if (!ChatManager.getBaseURL().isNullOrEmpty()) {
                result.success(CallLogManager.getUnreadMissedCallCount())
            } else {
                result.error("500", "SDK not isInitialised", null)
            }
        } catch (e: java.lang.Exception) {
            result.error("500", e.toString(), null)
        }

    }

    fun getMaxCallUsersCount(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.getMaxCallUsersCount())
    }

    fun isOnTelephonyCall(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.isOnTelephonyCall(MirrorFlyManager.getContext()))
    }

    fun markAllUnreadMissedCallsAsRead(call: MethodCall, result: MethodChannel.Result) {
        if (!ChatManager.getBaseURL().isNullOrEmpty()) {
            CallLogManager.markAllUnreadMissedCallsAsRead()
            LogMessage.d("markAllUnreadMissedCallsAsRead", "called")
            result.success(true)
        } else {
            result.error("500", "SDK not isInitialised", null)
        }
    }

    fun isCallConversionRequestAvailable(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.isCallConversionRequestAvailable())
    }

    override fun onMissedCall(
        isOneToOneCall: Boolean,
        userJid: String,
        groupId: String?,
        callType: String,
        userList: ArrayList<String>, callMeta: Array<CallMetaData>?
    ) {
        val notificationContent =
            getMissedCallNotificationContent(isOneToOneCall, userJid, groupId, callType, userList)
        LogMessage.d("onMissedCall", notificationContent.toString())
        /*CallNotificationUtils.createNotification(
            getContext(),
            notificationContent.first, //Title Missed call Notification
            notificationContent.second //Message Content Missed call from whom
        )*/
        val json = JSONObject()
        /*json.put("title",notificationContent.first)
        json.put("content",notificationContent.second)
        LogMessage.d("MissedCallNotification",json.toString())
        onMissedCallNotificationStreamHandler.onMissedCall?.success(json)*/
        json.put("isOneToOneCall", isOneToOneCall)
        json.put("userJid", userJid)
        json.put("groupId", groupId)
        json.put("callType", callType)
        json.put("userList", userList.joinToString(","))
        /*

        Instead of doing the string concatenation above, we can try this below

        val json = JSONObject()

        // Convert the array to a JSON array and add it to the JSON object
        val jsonArray = JSONArray(userList)
        json.put("userList", jsonArray)
         */
//        onMissedCallNotificationStreamHandler.onMissedCall?.success(json.toString())
        FlyMethodConstants.updateCallSinkValue(
            com.mirrorfly.mirrorfly_plugin.Constants.onMissedCall,
            json.toString()
        )
    }

    private fun getMissedCallNotificationContent(
        isOneToOneCall: Boolean, userJid: String, groupId: String?, callType: String,
        userList: ArrayList<String>
    ): Pair<String, String> {
        val messageContent: String
        val missedCallMessage = StringBuilder()
        missedCallMessage.append("You missed ")
        if (isOneToOneCall && groupId.isNullOrEmpty()) {
            if (callType == CallType.AUDIO_CALL) {
                missedCallMessage.append("an ")
            } else {
                missedCallMessage.append("a ")
            }
            missedCallMessage.append(callType).append(" call")
            messageContent = getDisplayName(userJid)
        } else {
            missedCallMessage.append("a group ").append(callType).append(" call")
            messageContent = if (!groupId.isNullOrBlank()) {
                getDisplayName(groupId)
            } else {
                getCallUsersName(userList).toString()
            }
        }
//        if (BuildConfig.HIPAA_COMPLIANCE_ENABLED)
//            messageContent = resources.getString(R.string.new_missed_call)
        return Pair(missedCallMessage.toString(), messageContent)
    }

    private fun getCallUsersName(callUsers: java.util.ArrayList<String>): StringBuilder {
        var name = StringBuilder("")
        for (i in callUsers.indices) {
            if (i == 2) {
                name.append(" and (+").append(callUsers.size - i).append(")")
                break
            } else if (i == 1) {
                name.append(", ").append(getDisplayName(callUsers[i]))
            } else {
                name = StringBuilder(getDisplayName(callUsers[i]))
            }
        }
        return name
    }

    private fun getDisplayName(jid: String): String {
        return ContactManager.getProfileDetails(jid)?.name
            ?: ContactManager.getProfileDetails(jid)?.nickName ?: ""
    }

    fun requestVideoCallSwitch(call: MethodCall, result: MethodChannel.Result) {
        CallManager.requestVideoCallSwitch()
        result.success(true)
    }

    fun cancelVideoCallSwitch(call: MethodCall, result: MethodChannel.Result) {
        CallManager.cancelVideoCallSwitchRequest()
        result.success(true)
    }

    fun acceptVideoCallSwitchRequest(call: MethodCall, result: MethodChannel.Result) {
        CallManager.acceptVideoCallSwitchRequest()
        result.success(true)
        val json = JSONObject()
        json.put("muteEvent", MuteEvent.ACTION_REMOTE_VIDEO_UN_MUTE)
        json.put("userJid", CallManager.getEndCallerJid())
//        onMuteStatusUpdatedStreamHandler.onMuteStatusUpdated?.success(json.toString())
        FlyMethodConstants.updateCallSinkValue(
            com.mirrorfly.mirrorfly_plugin.Constants.onMuteStatusUpdated,
            json.toString()
        )
    }

    fun declineVideoCallSwitchRequest(call: MethodCall, result: MethodChannel.Result) {
        CallManager.declineVideoCallSwitchRequest()
        result.success(true)
    }

    fun inviteUsersToOngoingCall(call: MethodCall, result: MethodChannel.Result) {
        val jidList = call.argument<List<String>>("jidList") ?: arrayListOf()
        CallManager.inviteUsersToOngoingCall(jidList as ArrayList<String>,
            object : CallActionListener {
                override fun onResponse(isSuccess: Boolean, flyException: FlyException?) {
                    LogMessage.d("invite**", "$isSuccess : $flyException")
                    if (isSuccess) {
                        result.success(isSuccess)
                    } else {
                        result.error("500", flyException?.message, flyException)
                    }
                }

            })
    }

    fun getInvitedUsersList(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.getInvitedUsersList().toJsonString())
    }

    /*fun changeCallType(call: MethodCall, result: MethodChannel.Result) {
        val callType = call.argument<String>("callType") ?: ""
        if (callType == "video"){

            //in iOS there is a methods mentioned below 3 lines. need to do in Android
//            CallManager.setCallType(callType: .Video)
//            CallManager.enableVideo()
//            AudioManager.shared().autoReRoute()
            CallManager.muteVideo(false)

        }else{
//in iOS there is a methods mentioned below 3 lines. need to do in Android
//            CallManager.setCallType(callType: .Audio)
//            CallManager.disableVideo()
//            AudioManager.shared().autoReRoute()
            CallManager.muteVideo(true)
        }
        result.success(true)
    }


    fun reRouteAudio(call: MethodCall, result: MethodChannel.Result) {

//        AudioManager.shared().autoReRoute()

    }*/

    fun getCallLogsList(call: MethodCall, result: MethodChannel.Result) {

        /*if (AppUtils.isNetConnected(mContext)) {
*/
        val currentPage = call.argument("currentPage") ?: 1

        CallManager.getCallLogs(currentPage) { isSuccess, throwable, data ->
            if (isSuccess) {
                LogMessage.d("callLogsList Normal: ", data.toJsonString())
                result.success(data.toJsonString())
            } else {
                println("call logs error : " + throwable.toString())
                result.error("400", throwable?.message.toString(), "")
            }
        }

        /*} else {
            Toast.makeText(mContext, "Please Check Your Internet connection", Toast.LENGTH_SHORT).show()
        }*/
    }

    fun getLocalCallLogs(call: MethodCall, result: MethodChannel.Result) {
        val callLogsList = CallLogManager.getCallLogs()
        LogMessage.d("getLocalCallLogs: ", callLogsList.toJsonString())
        val map = HashMap<String, Any>()
        map["data"] = callLogsList
        result.success(map.toJsonString())

    }

    fun deleteCallLog(call: MethodCall, result: MethodChannel.Result) {
        val jidList = call.argument<List<String>>("jidList") ?: arrayListOf()
        val isClearAll = call.argument<Boolean>("isClearAll") ?: false
        ChatManager.deleteCallLog(isClearAll, jidList, object : ChatActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                LogMessage.d("deleteCallLog : ", "Response $isSuccess")
                if (isSuccess) {
                    result.success(true)
                } else {
                    result.error("400", "deleteCallLog error", message)
                }
            }
        })
    }

    fun syncCallLogs(call: MethodCall, result: MethodChannel.Result) {
        CallLogManager.uploadUnSyncedCallLogs()
        result.success(true)
    }

    //#Meet Link Starts Here
    fun createMeetLink(call: MethodCall, result: MethodChannel.Result) {
        CallManager.createMeetLink { isSuccess, throwable, data ->
            if (isSuccess) {
                val meetLink = data["data"]
                result.success(meetLink)
            } else {
                result.error("500", throwable?.message.toString(), throwable)
            }
        }
    }

    fun getCallLink(call: MethodCall, result: MethodChannel.Result) {
        result.success(CallManager.getCallLink())
    }

    fun joinCall(call: MethodCall, result: MethodChannel.Result) {
        CallManager.joinCall(object : JoinCallActionListener {
            override fun onFailure(error: Error) {
                result.error(error.code.toString(), error.description, error)
            }

            override fun onSuccess() {
                result.success(true)
            }
        })
    }

    fun initializeMeet(call: MethodCall, result: MethodChannel.Result) {
        if(!CallManager.isOnJoinCallViaLink()) {
            CallManager.setupJoinCallViaLink()
            CallManager.setJoinCallEventsListener(this)
        }
//        if(CallManager.isVideoCallPermissionsGranted(true)){
//            startVideoCapture()
//        }
        subscribeCallEvents(call,result)
    }

    private fun subscribeCallEvents(call: MethodCall, result: MethodChannel.Result) {
        val callLink = call.argument<String>("callLink") ?: ""
        val userName = call.argument<String>("userName") ?: ""
        CallManager.subscribeCallEvents(callLink,userName,object : JoinCallActionListener {
            override fun onFailure(error: Error) {
               result.error(error.code.toString(), error.description, error.toJsonString())
            }

            override fun onSuccess() {
                result.success(true)
            }
        })
    }

    fun startVideoCapture(call: MethodCall? = null, result: MethodChannel.Result? = null) {
        if(CallManager.isVideoCallPermissionsGranted()){
            CallManager.startVideoCapture()
            result?.success(true)
        }else{
            result?.error("500", "Camera and Microphone Permission is not granted", "")
        }
    }

    fun disposePreview(call: MethodCall, result: MethodChannel.Result) {
        CallManager.cleanUpJoinCallViaLink()
        result.success(true)
    }

    fun getMeetUsername(call: MethodCall, result: MethodChannel.Result) {
        val userJid = call.argument<String>("userJid") ?: ""
        result.success(CallManager.getUserName(userJid))
    }

    override fun onSubscribeSuccess() {
        //enable join call UI button here
        FlyMethodConstants.updateCallSinkValue(
               Constants.onSubscribeSuccess,
                true
        )
    }

    override fun onConnectedToSignalServer() {
//        FlyMethodConstants.updateCallSinkValue(
//                Constants.onConnectedToSignalServer,
//                true
//        )
    }

    override fun onError(error: Error) {
        //show error message in ui
        val json = JSONObject()
        json.put("code", error.code)
        json.put("description", error.description)
        FlyMethodConstants.updateCallSinkValue(
                Constants.onError,
                json.toString()
        )
    }

    override fun onLocalTrack(videoTrack: VideoTrack?) {
        videoTrack?.addSink(CallManager.getLocalProxyVideoSink())
        Log.d(
                "#CallLink",
                "#onLocalTrack mirrorflyViews.size ${
                    MirrorflyViewHashMap.getMirrorflyView(ChatManager.getCurrentUserJid())
                } ${MirrorflyViewHashMap.getMirrorflyView(ChatManager.getCurrentUserJid())}"
        )
        val json = JSONObject()
        json.put("userJid", ChatManager.getCurrentUserJid())
        FlyMethodConstants.updateCallSinkValue(Constants.onLocalVideoTrackAdded, json.toString())
        if (MirrorflyViewHashMap.getMirrorflyView(ChatManager.getCurrentUserJid()) != null) {
            MirrorflyViewHashMap.getMirrorflyView(ChatManager.getCurrentUserJid())?.setLocalTarget()
        } else {
            Log.d(tag, "#onVideoTrackAdded view not created")
        }
        FlyMethodConstants.updateCallSinkValue(Constants.onTrackAdded, json.toString())
//        FlyMethodConstants.updateCallSinkValue(Constants.onLocalTrack, json.toString())
    }

    override fun onUsersUpdated(usersList: List<String>) {
        // update the users list in ui here
        FlyMethodConstants.updateCallSinkValue(
                Constants.onUsersUpdated,
                usersList.toJsonString()
        )
    }

    //#Meet Link Ends Here

}
