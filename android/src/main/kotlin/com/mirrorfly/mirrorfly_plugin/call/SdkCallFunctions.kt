package com.mirrorfly.mirrorfly_plugin.call

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import com.mirrorfly.mirrorfly_plugin.toJson
import com.mirrorflysdk.api.CallMessenger
import com.mirrorflysdk.api.ChatManager
import com.mirrorflysdk.api.GroupManager
import com.mirrorflysdk.api.contacts.ContactManager
import com.mirrorflysdk.api.utils.NameHelper
import com.mirrorflysdk.flycall.call.utils.CallNotificationHelper
import com.mirrorflysdk.flycall.webrtc.AudioDevice
import com.mirrorflysdk.flycall.webrtc.CallDirection
import com.mirrorflysdk.flycall.webrtc.CallType
import com.mirrorflysdk.flycall.webrtc.GroupCallDetails
import com.mirrorflysdk.flycall.webrtc.Logger
import com.mirrorflysdk.flycall.webrtc.api.CallActionListener
import com.mirrorflysdk.flycall.webrtc.api.CallHelper
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import com.mirrorflysdk.flycall.webrtc.api.CallNameHelper
import com.mirrorflysdk.flycall.webrtc.api.MissedCallListener
import com.mirrorflysdk.flycommons.LogMessage
import io.flutter.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

class SdkCallFunctions(var context: Context) {
    val tag = "#FlutterCall"

    fun initCall(){
        CallManager.init(context)
        CallManager.setMissedCallListener(object : MissedCallListener {
            override fun onMissedCall(
                isOneToOneCall: Boolean,
                userJid: String,
                groupId: String?,
                callType: String,
                userList: ArrayList<String>
            ){}
        })

        CallManager.setCallHelper(object : CallHelper {
            override fun getNotificationContent(callDirection: String): String {
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
        GroupManager.setNameHelper(object : NameHelper {
            override fun getDisplayName(jid: String): String {
                return ContactManager.getDisplayName(jid)
            }

        })
        CallManager.setCallNameHelper(object : CallNameHelper {
            override fun getDisplayName(jid: String): String {
                return ContactManager.getDisplayName(jid)
            }
        })
    }

    fun routeTo(call: MethodCall){
        val routeType = call.argument<String>("routeType") ?: ""
        LogMessage.d(tag,"routeType : $routeType")
        val selectedDevice = if(routeType=="receiver") AudioDevice.EARPIECE  else if(routeType=="speaker") AudioDevice.SPEAKER_PHONE else if(routeType=="bluetooth") AudioDevice.BLUETOOTH else if(routeType=="headset") AudioDevice.WIRED_HEADSET else AudioDevice.NONE
        //CallAudioManager.getInstance(context).selectAudioDevice(selectedDevice)
        CallManager.setAudioDevice(selectedDevice);
        LogMessage.d(tag,"selectedDevice : $selectedDevice")
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

    fun muteAudio(call: MethodCall, result: MethodChannel.Result) {
        LogMessage.d(tag,"muteAudio")
        val muteAudio = call.argument<Boolean>("muteAudio") ?: false
        CallManager.muteAudio(muteAudio)
        result.success(true)
    }
    fun muteVideo(call: MethodCall, result: MethodChannel.Result) {
        LogMessage.d(tag,"muteVideo")
        val muteVideo = call.argument<Boolean>("muteVideo") ?: false
        CallManager.muteVideo(muteVideo)
        result.success(true)
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
        val response = if (userJid == CallManager.getCurrentUserId())
            CallManager.isAudioMuted()
        else CallManager.isRemoteAudioMuted(userJid)
        result.success(response)
    }
    fun isUserVideoMuted(call: MethodCall,result: MethodChannel.Result){
        val userJid = call.argument<String>("userJid") ?: ""
        val response = if (userJid == CallManager.getCurrentUserId())
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
            json.put(obj)
        }
        users.forEach {jid->
            val obj = JSONObject()
            obj.put("userJid",jid)
            obj.put("callStatus",CallManager.getCallStatus(jid))
            json.put(obj)
        }
        result.success(json.toString())
    }

}
