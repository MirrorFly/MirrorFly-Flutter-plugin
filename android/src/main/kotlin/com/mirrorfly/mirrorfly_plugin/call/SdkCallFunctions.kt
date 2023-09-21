package com.mirrorfly.mirrorfly_plugin.call

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat
import com.mirrorfly.mirrorfly_plugin.AppUtils
import com.mirrorflysdk.api.CallMessenger
import com.mirrorflysdk.api.ChatManager
import com.mirrorflysdk.api.MediaNotificationHelper
import com.mirrorflysdk.api.contacts.ContactManager
import com.mirrorflysdk.api.utils.NameHelper
import com.mirrorflysdk.flycall.call.utils.CallNotificationHelper
import com.mirrorflysdk.flycall.webrtc.AudioDevice
import com.mirrorflysdk.flycall.webrtc.CallType
import com.mirrorflysdk.flycall.webrtc.GroupCallDetails
import com.mirrorflysdk.flycall.webrtc.api.CallActionListener
import com.mirrorflysdk.flycall.webrtc.api.CallHelper
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import com.mirrorflysdk.flycall.webrtc.api.CallNameHelper
import com.mirrorflysdk.flycall.webrtc.api.MissedCallListener
import com.mirrorflysdk.flycommons.Constants
import com.mirrorflysdk.flycommons.LogMessage
import com.mirrorflysdk.flycommons.PendingIntentHelper
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

class SdkCallFunctions(var context: Context): MissedCallListener, MediaNotificationHelper {
    val tag = "#FlutterCall"

    fun initCall(){
        //CallManager.init(context)
//        CallManager.setMissedCallListener(this)
        ChatManager.setMediaNotificationHelper(this)
        CallManager.setCallHelper(object : CallHelper {
            override fun getNotificationContent(callDirection: String): String {
                /*return if (BuildConfig.HIPAA_COMPLIANCE_ENABLED) {
                    when (callDirection) {
                        CallDirection.INCOMING_CALL -> resources.getString(R.string.new_incoming_call)
                        CallDirection.OUTGOING_CALL -> resources.getString(R.string.new_outgoing_call)
                        else -> resources.getString(R.string.new_ongoing_call)
                    }
                } else*/
                return CallNotificationHelper.getNotificationMessage()
            }

            override fun sendCallMessage(
                details: GroupCallDetails,
                users: List<String>,
                invitedUsers: List<String>
            ) {
                CallMessenger.sendCallMessage(details, users, invitedUsers)
            }
        })
        ChatManager.setNameHelper(object : NameHelper {
            override fun getDisplayName(jid: String): String {
                return ContactManager.getDisplayName(jid)
            }

        })
        CallManager.setCallNameHelper(object : CallNameHelper {
            override fun getDisplayName(jid: String): String {
                return ContactManager.getDisplayName(jid)
            }
        })
        CallManager.keepConnectionInForeground(true)
    }

    fun routeTo(call: MethodCall,result: MethodChannel.Result){
        val routeType = call.argument<String>("routeType") ?: ""
        LogMessage.d(tag,"routeType : $routeType")
        val selectedDevice = if(routeType=="receiver") AudioDevice.EARPIECE  else if(routeType=="speaker") AudioDevice.SPEAKER_PHONE else if(routeType=="bluetooth") AudioDevice.BLUETOOTH else if(routeType=="headset") AudioDevice.WIRED_HEADSET else AudioDevice.NONE
        //CallAudioManager.getInstance(context).selectAudioDevice(selectedDevice)
        CallManager.setAudioDevice(selectedDevice)
        LogMessage.d(tag,"selectedDevice : $selectedDevice")
        result.success(true)
    }
    fun getAllAvailableAudioInput(result: MethodChannel.Result){
        val availableAudioDevices = JSONArray()
        var y =1
        for (audioDevice in CallManager.getAudioDevices()) {
            val type = if(audioDevice==AudioDevice.EARPIECE) "receiver" else if(audioDevice==AudioDevice.SPEAKER_PHONE) "speaker" else if(audioDevice==AudioDevice.BLUETOOTH) "bluetooth" else if(audioDevice==AudioDevice.WIRED_HEADSET) "headset" else "none"
            val obj = JSONObject()
            obj.put("id",y.toString())
            obj.put("type",type)
            obj.put("name",audioDevice)
            y++
            availableAudioDevices.put(obj)
        }
        LogMessage.d(tag,"availableAudioDevices : $availableAudioDevices")
        result.success(availableAudioDevices.toString())
    }

    fun makeVoiceCall(call: MethodCall,result: MethodChannel.Result){
        val userJid: String = call.argument("user_jid") ?: ""
        println("permission ${CallManager.isAudioCallPermissionsGranted(skipBlueToothPermission = false)}")
        LogMessage.d("makeVoiceCall", "permission granted ${CallManager.isAudioCallPermissionsGranted(skipBlueToothPermission = false)}")
        if (CallManager.isAudioCallPermissionsGranted(false)) {
            CallManager.makeVoiceCall(userJid, object : CallActionListener {
                override fun onResponse(isSuccess: Boolean, message: String) {
                    LogMessage.d("makeCall", "success $isSuccess message $message")
                    if(isSuccess) {
                        result.success(true)
                    }else{
                        result.error("500", message,"")
                    }
                }
            })
        }else{
            result.error("500","Audio call permissions not granted","")
        }
    }

    fun makeVideoCall(call: MethodCall,result: MethodChannel.Result){
        val userJid: String = call.argument("user_jid") ?: ""
        LogMessage.d("makeVideoCall", "permission granted ${CallManager.isVideoCallPermissionsGranted(skipBlueToothPermission = false)}")
        if(CallManager.isVideoCallPermissionsGranted(skipBlueToothPermission = false)) {
            CallManager.makeVideoCall(userJid, object : CallActionListener {
                override fun onResponse(isSuccess: Boolean, message: String) {
                    LogMessage.d("makeVideoCall", "success $isSuccess message $message")
                    if(isSuccess) {
                        result.success(true)
                    }else{
                        result.error("500", message,"")
                    }
                }

            })
        }else{
            result.error("500","Video call permissions not granted","")
        }
    }

    fun answerCall(result: MethodChannel.Result){
        if(CallManager.getCallType()==CallType.AUDIO_CALL && !CallManager.isAudioCallPermissionsGranted(false)){
            LogMessage.d("answerCall", "call type ${CallManager.getCallType()} permission granted ${CallManager.isAudioCallPermissionsGranted(false)}")
            return
        }else if(CallManager.getCallType()==CallType.VIDEO_CALL && !CallManager.isVideoCallPermissionsGranted(false)){
            LogMessage.d("answerCall", "call type ${CallManager.getCallType()} permission granted ${CallManager.isVideoCallPermissionsGranted(false)}")
            return
        }
        CallManager.answerCall(object : CallActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                LogMessage.d("answerCall","success $isSuccess message $message")
                result.success(isSuccess)
            }

        })
    }

    fun declineCall(){
        CallManager.declineCall()
        LogMessage.d("declineCall","called")
    }

    fun disconnectCall(result: MethodChannel.Result){
//        if (checkIsUserInCall()) {
            CallManager.disconnectCall()
            result.success(true)
       /* }else{
            result.success(true)
        }*/
        LogMessage.d("disconnectCall","called")
    }

    private fun checkIsUserInCall(): Boolean {
//        return CallManager.isOnGoingCall() || (CallManager.isCallConnected() && CallManager.is()) || isInPIPMode()
        return true
    }

    fun muteAudio(call: MethodCall, result: MethodChannel.Result) {
        LogMessage.d(tag,"muteAudio")
        val muteAudio = call.argument<Boolean>("muteAudio") ?: false
        CallManager.muteAudio(muteAudio)
        result.success(true)
    }
    fun muteVideo(call: MethodCall, result: MethodChannel.Result) {
        LogMessage.d(tag,"muteVideo")
        val muteVideo = call.argument<Boolean>("muteVideo") ?: false
        CallManager.muteVideo(muteVideo,object : CallActionListener{
            override fun onResponse(isSuccess: Boolean, message: String) {
                LogMessage.d(tag,"$muteVideo ${CallManager.getCurrentUserId()} ${MirrorflyViewHashMap.getMirrorflyView(CallManager.getCurrentUserId())}")
                if(MirrorflyViewHashMap.getMirrorflyView(CallManager.getCurrentUserId())!=null && isSuccess) {
                    if (muteVideo) {
                        MirrorflyViewHashMap.getMirrorflyView(CallManager.getCurrentUserId())
                            ?.setProfileView(CallManager.getCurrentUserId())
                    } else {
                        MirrorflyViewHashMap.getMirrorflyView(CallManager.getCurrentUserId())
                            ?.setLocalTarget()
                    }
                }
                result.success(isSuccess)
            }

        })
    }

    fun makeGroupVoiceCall(call: MethodCall,result: MethodChannel.Result){
        if (CallManager.isAudioCallPermissionsGranted(false)) {
            val groupJid = call.argument<String>("groupJid") ?: ""
            val jidList = call.argument<String>("jidList") ?: ""
            CallManager.makeGroupVoiceCall(jidList.split(",") as ArrayList<String>, groupJid, object : CallActionListener {
                override fun onResponse(isSuccess: Boolean, message: String) {
                    LogMessage.d("makeGroupVoiceCall", "success $isSuccess message $message")
                    result.success(isSuccess)
                }
            })
        }
    }
    fun makeGroupVideoCall(call: MethodCall,result: MethodChannel.Result){
        LogMessage.d(tag,"muteVideo")
        val groupJid = call.argument<String>("groupJid") ?: ""
        val jidList = call.argument<String>("jidList") ?: ""
        CallManager.makeGroupVideoCall(jidList.split(",") as ArrayList<String>,groupJid,object: CallActionListener{
            override fun onResponse(isSuccess: Boolean, message: String) {
                LogMessage.d("makeGroupVideoCall", "success $isSuccess message $message")
                result.success(isSuccess)
            }

        })
    }

    fun isUserAudioMuted(call: MethodCall,result: MethodChannel.Result){
        val userJid = call.argument<String>("userJid") ?: ""
        val response = if (userJid.isEmpty() || userJid == CallManager.getCurrentUserId())
            CallManager.isAudioMuted()
        else CallManager.isRemoteAudioMuted(userJid)
        result.success(response)
    }
    fun isUserVideoMuted(call: MethodCall,result: MethodChannel.Result){
        val userJid = call.argument<String>("userJid") ?: ""
        val response = if (userJid.isEmpty() || userJid == CallManager.getCurrentUserId())
            CallManager.isVideoMuted()
        else CallManager.isRemoteVideoMuted(userJid)
        result.success(response)
    }

    fun getCallUsersList(call: MethodCall,result: MethodChannel.Result) {
        val json = JSONArray()
        val users = CallManager.getCallUsersList()
        if (!users.contains(CallManager.getCurrentUserId()) && CallManager.getCurrentUserId().isNotEmpty()){
            val obj = JSONObject()
            obj.put("userJid",CallManager.getCurrentUserId())
            obj.put("callStatus",CallManager.getCallStatus(CallManager.getCurrentUserId()))
            obj.put("isAudioMuted",CallManager.isAudioMuted())
            obj.put("isVideoMuted",CallManager.isVideoMuted())
            json.put(obj)
        }
        users.forEach {jid->
            val obj = JSONObject()
            obj.put("userJid",jid)
            obj.put("callStatus",CallManager.getCallStatus(jid))
            obj.put("isAudioMuted",CallManager.isRemoteAudioMuted(jid))
            obj.put("isVideoMuted",CallManager.isRemoteVideoMuted(jid))
            json.put(obj)
        }
        result.success(json.toString())
    }

    override fun onMissedCall(
        isOneToOneCall: Boolean,
        userJid: String,
        groupId: String?,
        callType: String,
        userList: ArrayList<String>
    ) {
        val notificationContent = getMissedCallNotificationContent(isOneToOneCall, userJid, groupId, callType, userList)
        LogMessage.d("onMissedCall",notificationContent.toString())
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
        json.put("isOneToOneCall",isOneToOneCall)
        json.put("userJid",userJid)
        json.put("groupId",groupId)
        json.put("callType",callType)
        json.put("userList",userList.joinToString(","))
        onMissedCallNotificationStreamHandler.onMissedCall?.success(json.toString())
    }

    override fun setMediaNotificationIntentAction(
        notificationCompatBuilder: NotificationCompat.Builder, jidList: List<String>) {
        notificationCompatBuilder.setContentIntent(getPendingIntent(jidList))
    }
    private fun getPendingIntent(toUsers: List<String>): PendingIntent {
        val notificationIntent = AppUtils.getAppIntent(context)//Intent(this, ChatManager.startActivity)
        notificationIntent!!.flags = (Intent.FLAG_ACTIVITY_CLEAR_TASK
                or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        notificationIntent.putExtra(Constants.IS_FROM_NOTIFICATION, true)
        notificationIntent.putExtra("jid", if (toUsers.count() == 1) toUsers.elementAt(0) else Constants.EMPTY_STRING)
        val requestID = System.currentTimeMillis().toInt()
        return PendingIntentHelper.getActivity(context, requestID, notificationIntent)
    }
    private fun getMissedCallNotificationContent( isOneToOneCall: Boolean, userJid: String, groupId: String?, callType: String,
                                                  userList: ArrayList<String>): Pair<String, String> {
        val messageContent : String
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

    private fun getDisplayName(jid : String):String{
        return ContactManager.getProfileDetails(jid)?.name ?: ContactManager.getProfileDetails(jid)?.nickName ?: ""
    }

}
