package com.mirrorfly.mirrorfly_plugin.call

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import com.mirrorflysdk.api.CallMessenger
import com.mirrorflysdk.api.GroupManager
import com.mirrorflysdk.api.contacts.ContactManager
import com.mirrorflysdk.api.utils.NameHelper
import com.mirrorflysdk.flycall.call.utils.CallNotificationHelper
import com.mirrorflysdk.flycall.webrtc.GroupCallDetails
import com.mirrorflysdk.flycall.webrtc.Logger
import com.mirrorflysdk.flycall.webrtc.api.CallActionListener
import com.mirrorflysdk.flycall.webrtc.api.CallHelper
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import com.mirrorflysdk.flycall.webrtc.api.CallNameHelper
import com.mirrorflysdk.flycall.webrtc.api.MissedCallListener
import io.flutter.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class SdkCallFunctions(var context: Context) {
    val tag = "#FlutterCall"

    fun initCall(){
        CallManager.init(context)
        CallManager.setCallActivityClass(CallKitUiActivity::class.java)
//        CallManager.configureCallActivity(context)
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

    fun makeCall(userJid:String){
        if (ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.RECORD_AUDIO
            ) != PackageManager.PERMISSION_GRANTED || ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.READ_PHONE_STATE
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return
        }
        CallManager.makeVoiceCall(userJid,object : CallActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                Log.d("makeCall","success $isSuccess message $message")
            }
        })
    }

    fun makeVideoCall(userJid: String,result: MethodChannel.Result){
        if (ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.CAMERA
            ) != PackageManager.PERMISSION_GRANTED || ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.RECORD_AUDIO
            ) != PackageManager.PERMISSION_GRANTED || ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.READ_PHONE_STATE
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            Log.d("makeVideoCall","permission denied")
            return
        }
        CallManager.makeVideoCall(userJid,object : CallActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                Log.d("makeVideoCall","success $isSuccess message $message")
                result.success(isSuccess)
            }

        })
    }

    fun answerCall(result: MethodChannel.Result){
        CallManager.answerCall(object : CallActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                Log.d("answerCall","success $isSuccess message $message")
                result.success(isSuccess)
            }

        })
    }

    fun declineCall(){
        CallManager.declineCall()
        Log.d("declineCall","success true")
    }

    fun muteAudio(call: MethodCall, result: MethodChannel.Result) {
        Logger.d(tag,"muteAudio")
        val muteAudio = call.argument<Boolean>("muteAudio") ?: false
        CallManager.muteAudio(muteAudio)
        result.success(true)
    }
    fun muteVideo(call: MethodCall, result: MethodChannel.Result) {
        Logger.d(tag,"muteVideo")
        val muteVideo = call.argument<Boolean>("muteVideo") ?: false
        CallManager.muteVideo(muteVideo)
        result.success(true)
    }
    fun makeGroupVideoCall(call: MethodCall,result: MethodChannel.Result){
        Logger.d(tag,"muteVideo")
        val groupJid = call.argument<String>("groupJid") ?: ""
        val jidList = call.argument<String>("jidList") ?: ""
        CallManager.makeGroupVideoCall(jidList.split(",") as ArrayList<String>,groupJid,object: CallActionListener{
            override fun onResponse(isSuccess: Boolean, message: String) {
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
