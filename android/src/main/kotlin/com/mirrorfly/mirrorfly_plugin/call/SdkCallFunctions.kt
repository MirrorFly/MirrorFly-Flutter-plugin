package com.mirrorfly.mirrorfly_plugin.call

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import com.mirrorflysdk.api.CallMessenger
import com.mirrorflysdk.api.ChatManager
import com.mirrorflysdk.api.GroupManager
import com.mirrorflysdk.api.contacts.ContactManager
import com.mirrorflysdk.api.utils.NameHelper
import com.mirrorflysdk.flycall.call.utils.CallNotificationHelper
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

    fun makeVoiceCall(userJid:String){
        LogMessage.d("makeVoiceCall", "permission granted ${CallManager.isAudioCallPermissionsGranted(skipBlueToothPermission = false)}")
        if (CallManager.isAudioCallPermissionsGranted(false)) {
            CallManager.makeVoiceCall(userJid, object : CallActionListener {
                override fun onResponse(isSuccess: Boolean, message: String) {
                    LogMessage.d("makeCall", "success $isSuccess message $message")
                }
            })
        }
    }

    fun makeVideoCall(userJid: String,result: MethodChannel.Result){
        LogMessage.d("makeVideoCall", "permission granted ${CallManager.isVideoCallPermissionsGranted(skipBlueToothPermission = false)}")
        if(CallManager.isVideoCallPermissionsGranted(skipBlueToothPermission = false)) {
            CallManager.makeVideoCall(userJid, object : CallActionListener {
                override fun onResponse(isSuccess: Boolean, message: String) {
                    LogMessage.d("makeVideoCall", "success $isSuccess message $message")
                    result.success(isSuccess)
                }

            })
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

}
