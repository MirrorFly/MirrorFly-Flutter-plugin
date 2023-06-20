package com.mirrorfly.mirrorfly_plugin.call

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.Intent.FLAG_ACTIVITY_NEW_TASK
import android.os.Build
import com.mirrorfly.mirrorfly_plugin.AppUtils
import com.mirrorfly.mirrorfly_plugin.Constants
import com.mirrorflysdk.flycall.call.utils.CallConstants
import com.mirrorflysdk.flycall.webrtc.CallAction
import com.mirrorflysdk.flycall.webrtc.CallAudioManager
import com.mirrorflysdk.flycall.webrtc.CallType
import com.mirrorflysdk.flycall.webrtc.Logger
import com.mirrorflysdk.flycall.webrtc.api.CallEventsListener
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import com.mirrorflysdk.flycall.webrtc.api.CallUiListener
import com.mirrorflysdk.flycommons.LogMessage
import io.flutter.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.util.Collections

class FlyCall(private var context: Context, binaryMessenger: BinaryMessenger) :  MethodChannel.MethodCallHandler ,
    CallEventsListener,CallUiListener {
    private var tag = "#FlutterAndroidCall"
    private var sdk = SdkCallFunctions(context)
    init {
        Logger.d("$tag init")
        EventChannel(binaryMessenger,Constants.onCallReceiving).setStreamHandler(OnCallReceivingStreamHandler)
        EventChannel(binaryMessenger,Constants.onLocalVideoTrackAdded).setStreamHandler(onLocalVideoTrackAddedStreamHandler)
        EventChannel(binaryMessenger,Constants.onRemoteVideoTrackAdded).setStreamHandler(onRemoteVideoTrackAddedStreamHandler)
        EventChannel(binaryMessenger,Constants.onCallStatusUpdated).setStreamHandler(onCallStatusUpdatedStreamHandler)
        EventChannel(binaryMessenger,Constants.onCallAction).setStreamHandler(onCallActionStreamHandler)
        EventChannel(binaryMessenger,Constants.onMuteStatusUpdated).setStreamHandler(onMuteStatusUpdatedStreamHandler)
        EventChannel(binaryMessenger,Constants.onUserSpeaking).setStreamHandler(onUserSpeakingStreamHandler)
        EventChannel(binaryMessenger,Constants.onUserStoppedSpeaking).setStreamHandler(onUserStoppedSpeakingStreamHandler)
        MethodChannel(binaryMessenger, Constants.callMethodChannel).setMethodCallHandler(this)
        CallManager.setCallEventsListener(this)
        CallManager.setCallUiListener(this)

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getCallUsersList"-> {
                val users = CallManager.getCallUsersList()
                result.success(users.joinToString(","))
            }
            "getAudioDevices"-> {
                val audioDevices = CallManager.getAudioDevices()
                result.success(audioDevices.joinToString(","))
            }
            "selectedAudioDevice" -> {
                val selectedAudioDevice = CallAudioManager.getInstance(context).selectedAudioDevice
                result.success(selectedAudioDevice)
            }
            "selectAudioDevice" ->{
                val selectedDevice = call.argument<String>("selectedDevice")
                CallAudioManager.getInstance(context).selectAudioDevice(selectedDevice)
            }
            "makeCall" -> {
                val userJid: String = call.argument("user_jid") ?: ""
                sdk.makeCall(userJid)
            }
            "makeVideoCall" -> {
                val userJid: String = call.argument("user_jid") ?: ""
                sdk.makeVideoCall(userJid,result)
            }
            "answerCall" -> {
                sdk.answerCall(result)
            }
            "declineCall" -> {
                sdk.declineCall()
            }
            "muteAudio" -> {
                sdk.muteAudio(call,result)
            }
            "muteVideo" -> {
                sdk.muteVideo(call, result)
            }
            "isVideoMuted" -> {
                result.success(CallManager.isVideoMuted())
            }
            "isRemoteVideoMuted" -> {
                val userJid: String = call.argument("user_jid") ?: ""
                result.success(CallManager.isRemoteVideoMuted(userJid))
            }
            "isRemoteVideoPaused" -> {
                val userJid: String = call.argument("user_jid") ?: ""
                result.success(CallManager.isRemoteVideoPaused(userJid))
            }
            "makeGroupVideoCall"->{
                sdk.makeGroupVideoCall(call,result)
            }
            "switchCamera" -> {
                CallManager.switchCamera()
                result.success(true)
            }
            "isCallOnHold"->{
                result.success(CallManager.isCallOnHold())
            }
            "isOneToOneCall"->{
                result.success(CallManager.isOneToOneCall())
            }
            "getCallType"->{
                result.success(CallManager.getCallType())
            }
            "isCallConnected"->{
                result.success(CallManager.isCallConnected())
            }
            "isVideoCall"->{
                result.success(CallManager.getCallType() == CallType.VIDEO_CALL)
            }
            "isAudioCall"->{
                result.success(CallManager.getCallType() == CallType.AUDIO_CALL)
            }
            "isCallNotConnected"->{
                result.success(!CallManager.isCallConnected() && !CallManager.isCallAnswered())
            }
            "isUserAudioMuted"->{
                sdk.isUserAudioMuted(call,result)
            }
            "isUserVideoMuted"->{
                sdk.isUserVideoMuted(call,result)
            }
        }
    }
    override fun onCallStatusUpdated(callStatus: String, userJid: String) {
        Log.d(tag,"#onCallStatusUpdated callStatus $callStatus userJid $userJid")
        val json = JSONObject()
        json.put("callStatus",callStatus)
        json.put("userJid",userJid)
        onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(json)
    }

    override fun onCallAction(callAction: String, userJid: String) {
        Log.d(tag,"#onCallAction callAction $callAction userJid $userJid")
        val json = JSONObject()
        json.put("callAction",callAction)
        json.put("userJid",userJid)
        onCallActionStreamHandler.onCallAction?.success(json)
    }

    override fun onVideoTrackAdded(userJid: String) {
        Log.d(tag,"#onVideoTrackAdded userJid $userJid")
        onRemoteVideoTrackAddedStreamHandler.onRemoteVideoTrackAdded?.success(userJid)
    }

    override fun onLocalVideoTrackAdded() {
        Log.d(tag,"#onLocalVideoTrackAdded")
        onLocalVideoTrackAddedStreamHandler.onLocalVideoTrackAdded?.success(true)
    }

    override fun onMuteStatusUpdated(muteEvent: String, userJid: String) {
        Log.d(tag,"#onMuteStatusUpdated muteEvent $muteEvent userJid $userJid")
        val json = JSONObject()
        json.put("muteEvent",muteEvent)
        json.put("userJid",userJid)
        onMuteStatusUpdatedStreamHandler.onMuteStatusUpdated?.success(json)
    }

    override fun onUserSpeaking(userJid: String, audioLevel: Int) {
        Log.d(tag,"#onUserSpeaking audioLevel $audioLevel userJid $userJid")
        val json = JSONObject()
        json.put("audioLevel",audioLevel)
        json.put("userJid",userJid)
        onUserSpeakingStreamHandler.onUserSpeaking?.success(json)
    }

    override fun onUserStoppedSpeaking(userJid: String) {
        Log.d(tag,"#onUserStoppedSpeaking $userJid")
        onUserStoppedSpeakingStreamHandler.onUserStoppedSpeaking?.success(userJid)
    }

    override fun getCallAttendedPendingIntent(): PendingIntent {
        val intent: Intent? = AppUtils.getAppIntent(context)
        return PendingIntent.getActivity(context, 0, intent, getFlagPendingIntent())
    }

    override fun getCallNotAttendedPendingIntent(): PendingIntent {

        val intent = Intent(context,CallKitUiActivity::class.java)
        return PendingIntent.getActivity(context, 0, intent, getFlagPendingIntent())
    }
    private fun getFlagPendingIntent(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
    }


    override fun onShowCallUi(callAction: String?) {
        LogMessage.d(tag, "#onShowCallUi $callAction")
        FlutterCall.callUiListener?.onShowCallUiFlutter(callAction)
        when(callAction){
            CallConstants.ACTION_SHOW_CALL_UI->{
                val t= Intent(context,CallKitUiActivity::class.java)
                t.addFlags(FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(t)
            }
            CallConstants.ACTION_INVITE_CALL_MESSAGE_RECEIVED->{}
            CallConstants.ACTION_MEDIA_CALL_MESSAGE_RECEIVED->{}
            CallConstants.ACTION_START_VIDEO_CAPTURE->{}
            CallAction.ACTION_INVITE_USERS->{}
            CallAction.ACTION_ANSWER_CALL->{}
            CallAction.ACTION_DENY_CALL->{}
            CallAction.ACTION_LOCAL_HANGUP->{}
            CallAction.ACTION_REMOTE_HANGUP->{}
            CallAction.ACTION_REMOTE_OTHER_BUSY->{}
            CallAction.ACTION_REMOTE_BUSY->{}
            CallAction.ACTION_REMOTE_ENGAGED->{}
            CallAction.ACTION_CALL_AGAIN->{}
            CallAction.ACTION_CANCEL_CALL_AGAIN->{}
            CallAction.ACTION_SWITCH_CAMERA->{}
            CallAction.ACTION_REMOTE_VIDEO_STATUS->{}
            CallAction.CHANGE_TO_AUDIO_CALL->{}
            CallAction.ACTION_VIDEO_CALL_CANCEL_CONVERSION->{}
            CallAction.ACTION_VIDEO_CALL_CONVERSION_ACCEPTED->{}
            CallAction.ACTION_VIDEO_CALL_CONVERSION_REJECTED->{}
            CallAction.ACTION_REMOTE_VIDEO_ADDED->{}
            CallAction.ACTION_AUDIO_DEVICE_CHANGED->{}
            CallAction.ACTION_CAMERA_SWITCH_SUCCESS->{}
            CallAction.ACTION_CAMERA_SWITCH_FAILURE->{}
            CallAction.ACTION_PERMISSION_DENIED->{}
            CallAction.CALL_REQUEST_RESPONSE->{}
            CallAction.USER_SPEAKING->{}
            CallAction.USER_STOPPED_SPEAKING->{}
            CallAction.ACTION_MAKE_SERVER_CONNECTION->{}
            CallAction.ACTION_CLOSE_SERVER_CONNECTION->{}
        }
    }

    /*override fun onCallReceiving(
        callAction: String?,
        callType: String,
        callUsers: ArrayList<String>,
        roomId: String,
        groupId: String?,
        callDirection: String?
    ) {
        Log.d(tag,"callAction $callAction callType $callType callUsers $callUsers roomId $roomId groupId $groupId callDirection $callDirection")
        val json = hashMapOf<String,String?>()
        json("callAction") = callAction
        json("callType") = callType
        json("callUsers") = callUsers.joinToString(",")
        json("roomId") = roomId
        json("groupId") = groupId
        json("callDirection") = callDirection
        runOnUiThread {
            //call the methodChannel.invokeMethod here to avoid @UiThread exception
            OnCallReceivingStreamHandler.onCallReceiving?.success(json)
        }
    }*/

}