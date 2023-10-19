package com.mirrorfly.mirrorfly_plugin.call

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.lifecycle.Lifecycle
import com.mirrorfly.mirrorfly_plugin.AppUtils
import com.mirrorfly.mirrorfly_plugin.Constants
import com.mirrorflysdk.api.ChatManager
import com.mirrorflysdk.flycall.call.utils.CallConstants
import com.mirrorflysdk.flycall.webrtc.*
import com.mirrorflysdk.flycall.webrtc.api.CallEventsListener
import com.mirrorflysdk.flycall.webrtc.api.CallLogManager
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import com.mirrorflysdk.flycall.webrtc.api.CallUiListener
import com.mirrorflysdk.flycommons.LogMessage
import com.mirrorflysdk.media.MediaUploadDownloadManager.handler
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject


class FlyCall(private var context: Context, flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) :  MethodChannel.MethodCallHandler ,
    CallEventsListener,CallUiListener {
    private var tag = "#FlutterAndroidCall"
    private var sdk = SdkCallFunctions(context)
    init {
        Logger.d("$tag init")
//        EventChannel(binaryMessenger,Constants.onCallReceiving).setStreamHandler(OnCallReceivingStreamHandler)
        EventChannel(flutterPluginBinding.binaryMessenger,Constants.onLocalVideoTrackAdded).setStreamHandler(onLocalVideoTrackAddedStreamHandler)
        EventChannel(flutterPluginBinding.binaryMessenger,Constants.onRemoteVideoTrackAdded).setStreamHandler(onRemoteVideoTrackAddedStreamHandler)
        EventChannel(flutterPluginBinding.binaryMessenger,Constants.onTrackAdded).setStreamHandler(onTrackAddedStreamHandler)
        EventChannel(flutterPluginBinding.binaryMessenger,Constants.onCallStatusUpdated).setStreamHandler(onCallStatusUpdatedStreamHandler)
        EventChannel(flutterPluginBinding.binaryMessenger,Constants.onCallAction).setStreamHandler(onCallActionStreamHandler)
        EventChannel(flutterPluginBinding.binaryMessenger,Constants.onMuteStatusUpdated).setStreamHandler(onMuteStatusUpdatedStreamHandler)
        EventChannel(flutterPluginBinding.binaryMessenger,Constants.onUserSpeaking).setStreamHandler(onUserSpeakingStreamHandler)
        EventChannel(flutterPluginBinding.binaryMessenger,Constants.onUserStoppedSpeaking).setStreamHandler(onUserStoppedSpeakingStreamHandler)
        EventChannel(flutterPluginBinding.binaryMessenger,Constants.onMissedCall).setStreamHandler(onMissedCallNotificationStreamHandler)
        MethodChannel(flutterPluginBinding.binaryMessenger, Constants.callMethodChannel).setMethodCallHandler(this)
        CallManager.setCallEventsListener(this)
        CallManager.setCallUiListener(this)

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getCallDirection"-> {
                val direction = if(CallDirection.INCOMING_CALL == CallManager.getCallDirection()) "Incoming" else "Outgoing"
                result.success(direction)
            }
            "isOnGoingCall"-> {
                result.success(CallManager.isOnGoingCall())
            }
            "isOnGoingAudioCall"-> {
                result.success(CallManager.isOnGoingAudioCall())
            }
            "isOnGoingVideoCall"-> {
                result.success(CallManager.isOnGoingVideoCall())
            }
            "getCallUsersList"-> {
                sdk.getCallUsersList(call,result)
            }
            "getAllAvailableAudioInput"-> {
                sdk.getAllAvailableAudioInput(result)
            }
            "selectedAudioDevice" -> {
                val type = when(CallAudioManager.getInstance(context).selectedAudioDevice){
                    AudioDevice.EARPIECE->"receiver"
                    AudioDevice.SPEAKER_PHONE->"speaker"
                    AudioDevice.BLUETOOTH-> "bluetooth"
                    AudioDevice.WIRED_HEADSET-> "headset"
                    else -> "none"
                }
                result.success(type)
            }
            "routeAudioTo" ->{
                sdk.routeTo(call,result)
            }
            "makeVoiceCall" -> {
                sdk.makeVoiceCall(call,result)
            }
            "makeVideoCall" -> {
                sdk.makeVideoCall(call,result)
            }
            "answerCall" -> {
                sdk.answerCall(result)
            }
            "declineCall" -> {
                sdk.declineCall()
            }
            "disconnectCall" -> {
                sdk.disconnectCall(result)
            }
            "muteAudio" -> {
                sdk.muteAudio(call,result)
            }
            "isAudioMuted"->{
                result.success(CallManager.isAudioMuted())
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
            "makeGroupVoiceCall"->{
                sdk.makeGroupVoiceCall(call,result)
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
            "getGroupID"->{
                result.success(CallManager.getGroupID())
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
            "getOnGoingCallDisplayStatus"->{
                result.success(CallManager.getOnGoingCallStatus(context))
            }
            "getUnreadMissedCallCount" -> {
                result.success(CallLogManager.getUnreadMissedCallCount())
            }
            "requestVideoCallSwitch" -> {
                sdk.requestVideoCallSwitch(call, result)
            }
            "cancelVideoCallSwitch" -> {
                sdk.cancelVideoCallSwitch(call, result)
            }
            "acceptVideoCallSwitchRequest" -> {
                sdk.acceptVideoCallSwitchRequest(call, result)
            }
            "declineVideoCallSwitchRequest" -> {
                sdk.declineVideoCallSwitchRequest(call, result)
            }
            "getMaxCallUsersCount" -> {
                result.success(CallManager.getMaxCallUsersCount())
            }
            /*"changeCallType" -> {
                sdk.changeCallType(call, result)
            }
            "reRouteAudio" -> {
                sdk.reRouteAudio(call, result)
            }*/
        }
    }
    override fun onCallStatusUpdated(callStatus: String, userJid: String) {
        Log.d(tag,"#onCallStatusUpdated callStatus $callStatus userJid $userJid")
        //Adding this condition to match the iOS, but this scenario is not occurred till now. Even though Adding this for exceptional cases.
        var userJID = userJid
        if (userJID == ""){
            userJID = CallManager.getCurrentUserId()
        }
        val json = JSONObject()
        json.put("callStatus",callStatus)
        json.put("userJid",userJID)
        json.put("callType",CallManager.getCallType())
        json.put("callMode",CallManager.getCallMode())
        //Call on hold if user attended other call in ongoing call after then ON_RESUME called
        if(callStatus == CallStatus.OUTGOING_CALL_TIME_OUT && CallManager.isCallConnected()){
            Log.d("#onCallStatusUpdated","OUTGOING_CALL_TIME_OUT connected ${CallManager.isCallConnected()}")
            FlutterCall.callUiListener?.onCallStatusUpdated(callStatus, userJID)
//            handleCallStatusMessages(callStatus,json)
            CallManager.getTimeOutUsersList().forEach {
                json.put("userJid",it)
                FlutterCall.callUiListener?.onCallStatusUpdated(callStatus, it)
                handleCallStatusMessages(callStatus, json)
            }
        }else {
            Log.d("#onCallStatusUpdated","$callStatus connected ${CallManager.isCallConnected()}")
            FlutterCall.callUiListener?.onCallStatusUpdated(callStatus, userJID)
            handleCallStatusMessages(callStatus, json)
        }
    }
    private fun handleCallStatusMessages(@CallStatus callEvent: String, json: JSONObject){
        LogMessage.d(tag,"callEvent : $callEvent json : $json")
        json.put("callStatus",callEvent)
        when (callEvent) {
            CallStatus.CONNECTING ->{}
            CallStatus.RINGING ->{}
            CallStatus.CONNECTED ->{}
            CallStatus.DISCONNECTED ->{}
            CallStatus.ON_HOLD ->{}
            CallStatus.ON_RESUME ->{}
            CallStatus.USER_JOINED ->{}
            CallStatus.USER_LEFT ->{}
            CallStatus.INVITE_CALL_TIME_OUT ->{}
            CallStatus.OUTGOING_CALL_TIME_OUT ->{
                json.put("callStatus","CALL TIME OUT")
            }
            CallStatus.INCOMING_CALL_TIME_OUT ->{
                FlutterCall.callUiListener?.onShowCallUiFlutter(CallStatus.INCOMING_CALL_TIME_OUT)
            }
            CallStatus.RECONNECTING ->{}
            CallStatus.RECONNECTED ->{}
            CallStatus.CALLING ->{
                json.put("callStatus","Trying to Connect")
            }
            CallStatus.CALLING_10S ->{}
            CallStatus.CALLING_AFTER_10S ->{}
        }
        onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(json.toString())

    }

    override fun onCallAction(callAction: String, userJid: String) {
        Log.d(tag,"#onCallAction callAction $callAction userJid $userJid")
        val json = JSONObject()
        json.put("callAction",callAction)
        json.put("userJid",userJid)
        json.put("callType",CallManager.getCallType())
        json.put("callMode",CallManager.getCallMode())
        onCallActionStreamHandler.onCallAction?.success(json.toString())
        FlutterCall.callUiListener?.onShowCallUiFlutter(callAction)
        if(callAction == CallAction.ACTION_REMOTE_VIDEO_STATUS){
            if (CallManager.isRemoteVideoPaused(userJid)){
                json.put("callAction","REMOTE_VIDEO_PAUSED")
                if(MirrorflyViewHashMap.getMirrorflyView(userJid)!=null) {
                    MirrorflyViewHashMap.getMirrorflyView(userJid)?.setProfileView(userJid)
                }
            }else if(!CallManager.isRemoteVideoPaused(userJid)){
                json.put("callAction","REMOTE_VIDEO_RESUMED")
                if(MirrorflyViewHashMap.getMirrorflyView(userJid)!=null && !CallManager.isRemoteVideoMuted(userJid)) {
                    MirrorflyViewHashMap.getMirrorflyView(userJid)?.setRemoteTarget(userJid)
                }
            }
        }
        if(callAction == CallAction.ACTION_VIDEO_CALL_CONVERSION_ACCEPTED){
            if(MirrorflyViewHashMap.getMirrorflyView(CallManager.getCurrentUserId())!=null && !CallManager.isVideoMuted()) {
                MirrorflyViewHashMap.getMirrorflyView(CallManager.getCurrentUserId())
                    ?.setLocalTarget()
            }
            if(!CallManager.isRemoteVideoPaused(userJid)){
                if(MirrorflyViewHashMap.getMirrorflyView(userJid)!=null && !CallManager.isRemoteVideoMuted(userJid)) {
                    MirrorflyViewHashMap.getMirrorflyView(userJid)?.setRemoteTarget(userJid)
                }
            }
        }
        if(callAction == CallAction.ACTION_VIDEO_CALL_CONVERSION_REJECTED || callAction == CallAction.ACTION_VIDEO_CALL_CANCEL_CONVERSION || callAction == CallAction.ACTION_VIDEO_CALL_CONVERSION_ACCEPTED){
            //CallAudioManager.getInstance(context).stopIncomingRequestTone()
        }
        //sendCallStatusUpdate(callAction,userJid)
    }

    private fun sendCallStatusUpdate(status: String,userJid: String){
        val json = JSONObject()
        json.put("userJid",userJid)
        json.put("callType",CallManager.getCallType())
        json.put("callMode",CallManager.getCallMode())
        when(status){
            CallAction.ACTION_REMOTE_HANGUP-> {
                if(CallManager.isOneToOneCall()) {
                    json.put("callStatus", "Disconnected")
                    onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(json.toString())
                }
            }
            CallAction.ACTION_REMOTE_BUSY->{
                if(CallManager.isOneToOneCall()) {
                    json.put("callStatus", "Disconnected")
                    onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(json.toString())
                }
            }
        }

    }

    override fun onVideoTrackAdded(userJid: String) {
        Log.d(tag,"#onVideoTrackAdded userJid $userJid  ${MirrorflyViewHashMap.getMirrorflyView(userJid)} ${MirrorflyViewHashMap.getMirrorflyViewId(userJid)} isCallConversionRequestAvailable : ${CallManager.isCallConversionRequestAvailable()}")
        if(!CallManager.isCallConversionRequestAvailable()) {
            val json = JSONObject()
            json.put("userJid", userJid)
            onRemoteVideoTrackAddedStreamHandler.onRemoteVideoTrackAdded?.success(json.toString())
            if (MirrorflyViewHashMap.getMirrorflyView(userJid) != null) {
                MirrorflyViewHashMap.getMirrorflyView(userJid)?.setRemoteTarget(userJid)
            } else {
                Log.d(tag, "#onVideoTrackAdded view not created")
            }
            onTrackAddedStreamHandler.onTrackAdded?.success(json.toString())
        }
    }

    override fun onLocalVideoTrackAdded() {
        Log.d(tag,"#onLocalVideoTrackAdded mirrorflyViews.size ${MirrorflyViewHashMap.getMirrorflyView(ChatManager.getCurrentUserJid())} ${MirrorflyViewHashMap.getMirrorflyView(ChatManager.getCurrentUserJid())}")
        val json = JSONObject()
        json.put("userJid",ChatManager.getCurrentUserJid())
        onLocalVideoTrackAddedStreamHandler.onLocalVideoTrackAdded?.success(json.toString())
        if(MirrorflyViewHashMap.getMirrorflyView(ChatManager.getCurrentUserJid())!=null) {
            MirrorflyViewHashMap.getMirrorflyView(ChatManager.getCurrentUserJid())?.setLocalTarget()
        }else{
            Log.d(tag,"#onVideoTrackAdded view not created")
        }
        onTrackAddedStreamHandler.onTrackAdded?.success(json.toString())
    }

    override fun onMuteStatusUpdated(muteEvent: String, userJid: String) {
        Log.d(tag,"#onMuteStatusUpdated muteEvent $muteEvent userJid $userJid  ${MirrorflyViewHashMap.getMirrorflyView(userJid)}")
        val json = JSONObject()
        json.put("muteEvent",muteEvent)
        json.put("userJid",userJid)
        if(muteEvent==MuteEvent.ACTION_REMOTE_VIDEO_MUTE){
            if(MirrorflyViewHashMap.getMirrorflyView(userJid)!=null) {
                MirrorflyViewHashMap.getMirrorflyView(userJid)?.setProfileView(userJid)
            }
        }else if(muteEvent==MuteEvent.ACTION_REMOTE_VIDEO_UN_MUTE){
            if(MirrorflyViewHashMap.getMirrorflyView(userJid)!=null&& !CallManager.isCallConversionRequestAvailable()) {
                MirrorflyViewHashMap.getMirrorflyView(userJid)?.setRemoteTarget(userJid)
            }
        }
        onMuteStatusUpdatedStreamHandler.onMuteStatusUpdated?.success(json.toString())
    }

    override fun onUserSpeaking(userJid: String, audioLevel: Int) {
        Log.d(tag,"#onUserSpeaking audioLevel $audioLevel userJid $userJid")
        val json = JSONObject()
        json.put("audioLevel",audioLevel)
        json.put("userJid",userJid)
        if(MirrorflyViewHashMap.getMirrorflyView(userJid)!=null) {
            MirrorflyViewHashMap.getMirrorflyView(userJid)?.userSpeaking(userJid)
        }
        onUserSpeakingStreamHandler.onUserSpeaking?.success(json.toString())
    }

    override fun onUserStoppedSpeaking(userJid: String) {
        Log.d(tag,"#onUserStoppedSpeaking $userJid")
        if(MirrorflyViewHashMap.getMirrorflyView(userJid)!=null) {
            MirrorflyViewHashMap.getMirrorflyView(userJid)?.userStoppedSpeaking(userJid)
        }
        onUserStoppedSpeakingStreamHandler.onUserStoppedSpeaking?.success(userJid)
    }

    override fun getCallAttendedPendingIntent(): PendingIntent {
        val intent: Intent? = AppUtils.getAppIntent(context)
        LogMessage.d(tag,"getCallAttendedPendingIntent $intent")
        return PendingIntent.getActivity(context, 0, intent, getFlagPendingIntent())
    }

    override fun getCallNotAttendedPendingIntent(): PendingIntent {
        val intent = Intent(context,CallKitUiActivity::class.java)
        intent.action=CallConstants.ACTION_SHOW_CALL_UI
        intent.putExtra(CallConstants.ACCEPT_CALL,false)
        intent.putExtra("FROM","getCallNotAttendedPendingIntent")
        return PendingIntent.getActivity(context, 0, intent, getFlagPendingIntent())
    }

    override fun getCallAcceptPendingIntent(): PendingIntent {
        val intentTransparent = Intent(context,CallKitUiActivity::class.java)/*TransparentActivity.getIntent(
            context,
            Constants.ACTION_CALL_ACCEPT,
            null
        )*/
        intentTransparent.action=CallConstants.ACCEPT_CALL
        intentTransparent.putExtra(CallConstants.ACCEPT_CALL,true)
        intentTransparent.putExtra("FROM",CallConstants.ACCEPT_CALL)
        return PendingIntent.getActivity(context, AppUtils.CALL_REQUEST, intentTransparent, getFlagPendingIntent())
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
        if(callAction!=null) {
            when (callAction) {
                CallConstants.ACTION_SHOW_CALL_UI -> {
                    LogMessage.d(CallConstants.ACTION_SHOW_CALL_UI, CallManager.getCallDirection())
                    if (CallManager.getCallDirection() == CallDirection.INCOMING_CALL) {
                        val t = Intent(context, CallKitUiActivity::class.java)
                        t.putExtra("FROM", CallConstants.ACTION_SHOW_CALL_UI)
                        t.putExtra(CallConstants.ACCEPT_CALL, false)
                        t.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        context.startActivity(t)
                    }
                }
                CallAction.ACTION_ANSWER_CALL -> {
                    LogMessage.d(
                        tag,
                        "#onShowCallUi ${Build.VERSION.SDK_INT} ${Build.VERSION_CODES.R}"
                    )
                    val json = JSONObject()
                    json.put("callStatus", "Attended")
                    json.put("userJid", CallManager.getCurrentUserId())
                    json.put("callType", CallManager.getCallType())
                    json.put("callMode", CallManager.getCallMode())
                    if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.R) {
                        val y = AppUtils.getAppIntent(context)
                        y?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        context.startActivity(y)
                        handler.post {
                            onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(
                                json.toString()
                            )
                        }

                    } else {
                        handler.post {
                            onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(
                                json.toString()
                            )
                        }
                    }
                }
                CallAction.CALL_REQUEST_RESPONSE->{
                    handler.post {
                        if (MirrorflyViewHashMap.getMirrorflyView(CallManager.getCurrentUserId()) != null && !CallManager.isVideoMuted() && CallManager.getLocalProxyVideoSink()!=null) {
                            MirrorflyViewHashMap.getMirrorflyView(CallManager.getCurrentUserId())
                                ?.setLocalTarget()
                        }
                        if (!CallManager.isRemoteVideoPaused(CallManager.getEndCallerJid())) {
                            if (MirrorflyViewHashMap.getMirrorflyView(CallManager.getEndCallerJid()) != null && !CallManager.isRemoteVideoMuted(
                                    CallManager.getEndCallerJid()
                                )
                            ) {
                                MirrorflyViewHashMap.getMirrorflyView(CallManager.getEndCallerJid())
                                    ?.setRemoteTarget(CallManager.getEndCallerJid())
                            }
                        }
                    }
                }
                /*CallConstants.ACTION_INVITE_CALL_MESSAGE_RECEIVED->{}
            CallConstants.ACTION_MEDIA_CALL_MESSAGE_RECEIVED->{}
            CallConstants.ACTION_START_VIDEO_CAPTURE->{}
            CallAction.ACTION_INVITE_USERS->{}
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
            CallAction.ACTION_CLOSE_SERVER_CONNECTION->{}*/
            }
        }else{
            LogMessage.d(tag, "#onShowCallUi isCallConversionRequestAvailable ${CallManager.isCallConversionRequestAvailable()}")
            if(CallManager.isCallConversionRequestAvailable()){
                //CallAudioManager.getInstance(context).playIncomingRequestTone()
                val json = JSONObject()
                json.put("callAction","ACTION_VIDEO_CALL_CONVERSION")
                json.put("userJid",CallManager.getEndCallerJid())
                json.put("callType",CallManager.getCallType())
                json.put("callMode",CallManager.getCallMode())
                handler.post {
                    onCallActionStreamHandler.onCallAction?.success(json.toString())
                }
            }
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


/** Provides a static method for extracting lifecycle objects from Flutter plugin bindings.  */
object FlutterLifecycleAdapter {
    /**
     * Returns the lifecycle object for the activity a plugin is bound to.
     *
     *
     * Returns null if the Flutter engine version does not include the lifecycle extraction code.
     * (this probably means the Flutter engine version is too old).
     */
    fun getActivityLifecycle(
        activityPluginBinding: ActivityPluginBinding
    ): Lifecycle {
        val reference = activityPluginBinding.lifecycle as HiddenLifecycleReference
        return reference.lifecycle
    }
}