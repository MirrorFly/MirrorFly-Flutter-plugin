package com.mirrorfly.mirrorfly_plugin.call

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.lifecycle.Lifecycle
import com.mirrorfly.mirrorfly_plugin.*
import com.mirrorflysdk.api.ChatManager
import com.mirrorflysdk.flycall.call.utils.CallConstants
import com.mirrorflysdk.flycall.webrtc.*
import com.mirrorflysdk.flycall.webrtc.api.*
import com.mirrorflysdk.flycommons.LogMessage
import com.mirrorflysdk.media.MediaUploadDownloadManager.handler
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject


class FlyCallPlugin : MethodChannel.MethodCallHandler,
    CallEventsListener, CallUiListener {
    val tag = "#FlutterCallMethods"
    val context: Context by lazy { MirrorFlyManager.applicationContext }
    private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? by lazy { MirrorFlyManager.flutterPluginBinding }

    fun init() {
        Logger.d("$tag init")
        CallManager.setCallEventsListener(this)
        CallManager.setCallUiListener(this)
    }


    fun initChannels() {
        flutterPluginBinding?.binaryMessenger?.let {
            MethodChannel(
                it,
                Constants.callMethodChannel
            ).setMethodCallHandler(this)
        }
        flutterPluginBinding?.binaryMessenger?.let { FlyMethodConstants.initializeCallListeners(it) }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        FlyMethodConstants.callMethodHandlers[call.method]?.let { methodHandler ->
            Log.d(tag, "Method call ${call.method}")
            methodHandler.invoke(call, result)
        }
    }

    override fun onCallStatusUpdated(callStatus: String, userJid: String) {
        Log.d(tag, "#onCallStatusUpdated callStatus $callStatus userJid $userJid")
        //Adding this condition to match the iOS, but this scenario is not occurred till now. Even though Adding this for exceptional cases.
        var userJID = userJid
        if (userJID == "") {
            userJID = CallManager.getCurrentUserId()
        }
        val json = JSONObject()
        json.put("callStatus", callStatus)
        json.put("userJid", userJID)
        json.put("callType", CallManager.getCallType())
        json.put("callMode", CallManager.getCallMode())
        FlutterCall.callUiListener?.onCallStatusUpdated(callStatus, userJID)
        //Call on hold if user attended other call in ongoing call after then ON_RESUME called
        if (callStatus == CallStatus.CALL_TIME_OUT && CallManager.isCallConnected()) {
            Log.d(
                "#onCallStatusUpdated",
                "CALL_TIME_OUT connected ${CallManager.isCallConnected()}"
            )
            //FlutterCall.callUiListener?.onCallStatusUpdated(callStatus, userJID)
//            handleCallStatusMessages(callStatus,json)
//            CallManager.getTimeOutUsersList().forEach {
//                json.put("userJid",it)
            //FlutterCall.callUiListener?.onCallStatusUpdated(callStatus, it)
            handleCallStatusMessages(callStatus, json)
//            }
        } else if (callStatus != CallStatus.OUTGOING_CALL_TIME_OUT && callStatus != CallStatus.INCOMING_CALL_TIME_OUT && callStatus != CallStatus.INVITE_CALL_TIME_OUT) {
            Log.d("#onCallStatusUpdated", "$callStatus connected ${CallManager.isCallConnected()}")
            //FlutterCall.callUiListener?.onCallStatusUpdated(callStatus, userJID)
            handleCallStatusMessages(callStatus, json)
        }
        if (userJID != CallManager.getCurrentUserId() && (callStatus == CallStatus.CONNECTED || callStatus == CallStatus.RECONNECTED)) {
            Log.d(
                tag,
                "Connected and Not Me userJid $userJID video ${
                    CallManager.getRemoteProxyVideoSink(userJID)
                } video mute ${CallManager.isRemoteVideoMuted(userJID)} video paused ${
                    CallManager.isRemoteVideoPaused(
                        userJID
                    )
                }"
            )

        }
    }

    private fun handleCallStatusMessages(@CallStatus callEvent: String, json: JSONObject) {
        LogMessage.d(tag, "callEvent : $callEvent json : $json")
        json.put("callStatus", callEvent)
        when (callEvent) {
            CallStatus.CONNECTING -> {}
            CallStatus.RINGING -> {}
            CallStatus.CONNECTED -> {}
            CallStatus.DISCONNECTED -> {}
            CallStatus.ON_HOLD -> {}
            CallStatus.ON_RESUME -> {}
            CallStatus.USER_JOINED -> {}
            CallStatus.USER_LEFT -> {
                FlutterCall.callUiListener?.onShowCallUiFlutter(
                    CallStatus.USER_LEFT,
                    json.getString("userJid")
                )
            }
            CallStatus.INVITE_CALL_TIME_OUT -> {}
            CallStatus.OUTGOING_CALL_TIME_OUT -> {
                json.put("callStatus", "CALL TIME OUT")
            }
            CallStatus.CALL_TIME_OUT -> {
                json.put("callStatus", "CALL TIME OUT")
                FlutterCall.callUiListener?.onShowCallUiFlutter(
                    CallStatus.INCOMING_CALL_TIME_OUT,
                    json.getString("userJid")
                )
            }
            CallStatus.INCOMING_CALL_TIME_OUT -> {
                FlutterCall.callUiListener?.onShowCallUiFlutter(
                    CallStatus.INCOMING_CALL_TIME_OUT,
                    json.getString("userJid")
                )
            }
            CallStatus.RECONNECTING -> {}
            CallStatus.RECONNECTED -> {
                val userJid = json.getString("userJid")
                val isVideoMuted =
                    if (CallManager.getCurrentUserId() != userJid) CallManager.isRemoteVideoMuted(
                        userJid
                    ) else CallManager.isVideoMuted()
                LogMessage.d(
                    tag,
                    "${CallStatus.RECONNECTED} CallManager.isCallConversionRequestAvailable() " + CallManager.isCallConversionRequestAvailable() + " Reconnected isVideoMuted $isVideoMuted userJid : $userJid"
                )
                if (CallManager.getCurrentUserId() != userJid && CallManager.isRemoteVideoMuted(
                        userJid
                    )
                ) {
                    if (MirrorflyViewHashMap.getMirrorflyView(userJid) != null) {
                        MirrorflyViewHashMap.getMirrorflyView(userJid)?.setProfileView(userJid)
                    }
                } else {
                    if (CallManager.isCallConversionRequestAvailable() && CallManager.isOneToOneCall()) {
                        val jsons = JSONObject()
                        jsons.put("callAction", "ACTION_VIDEO_CALL_CONVERSION")
                        jsons.put("userJid", CallManager.getEndCallerJid())
                        jsons.put("callType", CallManager.getCallType())
                        jsons.put("callMode", CallManager.getCallMode())
//                        onCallActionStreamHandler.onCallAction?.success(jsons.toString())
                        FlyMethodConstants.updateCallSinkValue(
                            Constants.onCallAction,
                            jsons.toString()
                        )
                    }
                }
            }
            CallStatus.CALLING -> {
                //Calling status not in iOS so here we sent Trying to Connect status
                json.put("callStatus", "Trying to Connect")
            }
            CallStatus.CALLING_10S -> {}
            CallStatus.CALLING_AFTER_10S -> {}
        }
//        onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(json.toString())
        FlyMethodConstants.updateCallSinkValue(Constants.onCallStatusUpdated, json.toString())


    }

    override fun onCallAction(callAction: String, userJid: String) {
        Log.d(tag, "#onCallAction callAction $callAction userJid $userJid")
        val json = JSONObject()
        json.put(
            "callAction",
            if (userJid == ChatManager.getCurrentUserJid() && callAction == CallAction.ACTION_REMOTE_HANGUP) CallAction.ACTION_LOCAL_HANGUP else callAction
        )
        json.put("userJid", userJid)
        json.put("callType", CallManager.getCallType())
        json.put("callMode", CallManager.getCallMode())
        FlutterCall.callUiListener?.onShowCallUiFlutter(callAction, userJid)
        if (callAction == CallAction.ACTION_REMOTE_VIDEO_STATUS) {
            if (CallManager.isRemoteVideoPaused(userJid)) {
                json.put("callAction", "REMOTE_VIDEO_PAUSED")
                if (MirrorflyViewHashMap.getMirrorflyView(userJid) != null) {
                    MirrorflyViewHashMap.getMirrorflyView(userJid)?.setProfileView(userJid)
                }
            } else if (!CallManager.isRemoteVideoPaused(userJid)) {
                json.put("callAction", "REMOTE_VIDEO_RESUMED")
                if (MirrorflyViewHashMap.getMirrorflyView(userJid) != null && !CallManager.isRemoteVideoMuted(
                        userJid
                    )
                ) {
                    MirrorflyViewHashMap.getMirrorflyView(userJid)?.setRemoteTarget(userJid)
                }
            }
        }
        if (callAction == CallAction.ACTION_VIDEO_CALL_CONVERSION_ACCEPTED) {
            LogMessage.d(
                "#onCallAction",
                "CallManager.isRemoteVideoPaused($userJid) ${CallManager.isRemoteVideoPaused(userJid)} ${
                    MirrorflyViewHashMap.getMirrorflyView(userJid)
                }"
            )
            if (MirrorflyViewHashMap.getMirrorflyView(CallManager.getCurrentUserId()) != null && !CallManager.isVideoMuted()) {
                MirrorflyViewHashMap.getMirrorflyView(CallManager.getCurrentUserId())
                    ?.setLocalTarget()
            }
            if (!CallManager.isRemoteVideoPaused(userJid)) {
                if (MirrorflyViewHashMap.getMirrorflyView(userJid) != null && !CallManager.isRemoteVideoMuted(
                        userJid
                    )
                ) {
                    MirrorflyViewHashMap.getMirrorflyView(userJid)?.setRemoteTarget(userJid)
                }
            }
        }
//        if(callAction == CallAction.ACTION_VIDEO_CALL_CONVERSION_REJECTED || callAction == CallAction.ACTION_VIDEO_CALL_CANCEL_CONVERSION || callAction == CallAction.ACTION_VIDEO_CALL_CONVERSION_ACCEPTED){
        //CallAudioManager.getInstance(context).stopIncomingRequestTone()
//        }
        //sendCallStatusUpdate(callAction,userJid)
        if (userJid == ChatManager.getCurrentUserJid() && callAction == CallAction.ACTION_REMOTE_HANGUP) {
            sendCallStatusForLocalJidInRemoteHangUP(callAction, userJid)
        } else {
//            onCallActionStreamHandler.onCallAction?.success(json.toString())
            FlyMethodConstants.updateCallSinkValue(Constants.onCallAction, json.toString())
        }
    }

    private fun sendCallStatusForLocalJidInRemoteHangUP(callAction: String, userJid: String) {
        Log.d(
            tag,
            "#onCallAction sendCallStatusForLocalJidInRemoteHangUP $callAction userJid $userJid"
        )
        if (userJid == ChatManager.getCurrentUserJid() && callAction == CallAction.ACTION_REMOTE_HANGUP) {
            if (!CallManager.isCallConnected()) {
                val json = JSONObject()
                json.put("userJid", userJid)
                json.put("callType", CallManager.getCallType())
                json.put("callMode", CallManager.getCallMode())
                json.put("callStatus", CallStatus.DISCONNECTED)
//                onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(json.toString())
                FlyMethodConstants.updateCallSinkValue(
                    Constants.onCallStatusUpdated,
                    json.toString()
                )
            }
        }
    }

    private fun sendCallStatusUpdate(status: String, userJid: String) {
        val json = JSONObject()
        json.put("userJid", userJid)
        json.put("callType", CallManager.getCallType())
        json.put("callMode", CallManager.getCallMode())
        when (status) {
            CallAction.ACTION_REMOTE_HANGUP -> {
                if (CallManager.isOneToOneCall()) {
                    json.put("callStatus", "Disconnected")
//                    onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(json.toString())
                    FlyMethodConstants.updateCallSinkValue(
                        Constants.onCallStatusUpdated,
                        json.toString()
                    )
                }
            }
            CallAction.ACTION_REMOTE_BUSY -> {
                if (CallManager.isOneToOneCall()) {
                    json.put("callStatus", "Disconnected")
//                    onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(json.toString())
                    FlyMethodConstants.updateCallSinkValue(
                        Constants.onCallStatusUpdated,
                        json.toString()
                    )
                }
            }
        }

    }

    override fun onVideoTrackAdded(userJid: String) {
        Log.d(
            tag,
            "#onVideoTrackAdded userJid $userJid  ${MirrorflyViewHashMap.getMirrorflyView(userJid)} ${
                MirrorflyViewHashMap.getMirrorflyViewId(userJid)
            } isCallConversionRequestAvailable : ${CallManager.isCallConversionRequestAvailable()} video ${
                CallManager.getRemoteProxyVideoSink(
                    userJid
                )
            }"
        )
        if (!CallManager.isCallConversionRequestAvailable()) {
            val json = JSONObject()
            json.put("userJid", userJid)
//            onRemoteVideoTrackAddedStreamHandler.onRemoteVideoTrackAdded?.success(json.toString())
            FlyMethodConstants.updateCallSinkValue(
                Constants.onRemoteVideoTrackAdded,
                json.toString()
            )
            if (MirrorflyViewHashMap.getMirrorflyView(userJid) != null) {
                MirrorflyViewHashMap.getMirrorflyView(userJid)?.setRemoteTarget(userJid)
            } else {
                Log.d(tag, "#onVideoTrackAdded view not created")
            }
//            onTrackAddedStreamHandler.onTrackAdded?.success(json.toString())
            FlyMethodConstants.updateCallSinkValue(Constants.onTrackAdded, json.toString())
        }
    }

    override fun onLocalVideoTrackAdded() {
        Log.d(
            tag,
            "#onLocalVideoTrackAdded mirrorflyViews.size ${
                MirrorflyViewHashMap.getMirrorflyView(ChatManager.getCurrentUserJid())
            } ${MirrorflyViewHashMap.getMirrorflyView(ChatManager.getCurrentUserJid())}"
        )
        val json = JSONObject()
        json.put("userJid", ChatManager.getCurrentUserJid())
//        onLocalVideoTrackAddedStreamHandler.onLocalVideoTrackAdded?.success(json.toString())
        FlyMethodConstants.updateCallSinkValue(Constants.onLocalVideoTrackAdded, json.toString())
        if (MirrorflyViewHashMap.getMirrorflyView(ChatManager.getCurrentUserJid()) != null) {
            MirrorflyViewHashMap.getMirrorflyView(ChatManager.getCurrentUserJid())?.setLocalTarget()
        } else {
            Log.d(tag, "#onVideoTrackAdded view not created")
        }
//        onTrackAddedStreamHandler.onTrackAdded?.success(json.toString())
        FlyMethodConstants.updateCallSinkValue(Constants.onTrackAdded, json.toString())
    }

    override fun onMuteStatusUpdated(muteEvent: String, userJid: String) {
        Log.d(
            tag,
            "#onMuteStatusUpdated muteEvent $muteEvent userJid $userJid  ${
                MirrorflyViewHashMap.getMirrorflyView(userJid)
            }"
        )
        val json = JSONObject()
        json.put("muteEvent", muteEvent)
        json.put("userJid", userJid)
        if (muteEvent == MuteEvent.ACTION_REMOTE_VIDEO_MUTE) {
            if (MirrorflyViewHashMap.getMirrorflyView(userJid) != null) {
                MirrorflyViewHashMap.getMirrorflyView(userJid)?.setProfileView(userJid)
            }
        } else if (muteEvent == MuteEvent.ACTION_REMOTE_VIDEO_UN_MUTE) {
            if (MirrorflyViewHashMap.getMirrorflyView(userJid) != null && !CallManager.isCallConversionRequestAvailable()) {
                MirrorflyViewHashMap.getMirrorflyView(userJid)?.setRemoteTarget(userJid)
            }
        }
//        onMuteStatusUpdatedStreamHandler.onMuteStatusUpdated?.success(json.toString())
        FlyMethodConstants.updateCallSinkValue(Constants.onMuteStatusUpdated, json.toString())
    }

    override fun onUserSpeaking(userJid: String, audioLevel: Int) {
        Log.d(tag, "#onUserSpeaking audioLevel $audioLevel userJid $userJid")
        val json = JSONObject()
        json.put("audioLevel", audioLevel)
        json.put("userJid", userJid)
        if (MirrorflyViewHashMap.getMirrorflyView(userJid) != null) {
            MirrorflyViewHashMap.getMirrorflyView(userJid)?.userSpeaking(userJid)
        }
//        onUserSpeakingStreamHandler.onUserSpeaking?.success(json.toString())
        FlyMethodConstants.updateCallSinkValue(Constants.onUserSpeaking, json.toString())
    }

    override fun onUserStoppedSpeaking(userJid: String) {
        Log.d(tag, "#onUserStoppedSpeaking $userJid")
        if (MirrorflyViewHashMap.getMirrorflyView(userJid) != null) {
            MirrorflyViewHashMap.getMirrorflyView(userJid)?.userStoppedSpeaking(userJid)
        }
//        onUserStoppedSpeakingStreamHandler.onUserStoppedSpeaking?.success(userJid)
        FlyMethodConstants.updateCallSinkValue(Constants.onUserStoppedSpeaking, userJid)
    }

    override fun getCallAttendedPendingIntent(): PendingIntent {
        val intent: Intent? = AppUtils.getAppIntent(context)
//        LogMessage.d(tag,"getCallAttendedPendingIntent $intent")
        return PendingIntent.getActivity(context, 0, intent, AppUtils.getFlagPendingIntent())
    }

    override fun getCallNotAttendedPendingIntent(): PendingIntent {
        val intent = Intent(context, CallKitUiActivity::class.java)
        intent.action = CallConstants.ACTION_SHOW_CALL_UI
        intent.putExtra(CallConstants.ACCEPT_CALL, false)
        intent.putExtra("FROM", "getCallNotAttendedPendingIntent")
        return PendingIntent.getActivity(context, 0, intent, AppUtils.getFlagPendingIntent())
    }

    override fun getCallAcceptPendingIntent(): PendingIntent {
        val intentTransparent = Intent(context, CallKitUiActivity::class.java)/*TransparentActivity.getIntent(
            context,
            Constants.ACTION_CALL_ACCEPT,
            null
        )*/
        intentTransparent.action = CallConstants.ACCEPT_CALL
        intentTransparent.putExtra(CallConstants.ACCEPT_CALL, true)
        intentTransparent.putExtra("FROM", CallConstants.ACCEPT_CALL)
        return PendingIntent.getActivity(
            context,
            AppUtils.CALL_REQUEST,
            intentTransparent,
            AppUtils.getFlagPendingIntent()
        )
    }


    override fun onShowCallUi(callAction: String?) {
        LogMessage.d(tag, "#onShowCallUi $callAction")
        FlutterCall.callUiListener?.onShowCallUiFlutter(callAction, null)
        if (callAction != null) {
            when (callAction) {
                CallConstants.ACTION_SHOW_CALL_UI -> {
                    LogMessage.d(CallConstants.ACTION_SHOW_CALL_UI, CallManager.getCallDirection())
                    if (CallManager.getCallDirection() == CallDirection.INCOMING_CALL) {
                        LogMessage.d(tag, "#onShowCallUi start Activity $context")
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
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
                        LogMessage.d(
                            tag,
                            "#onShowCallUi ${Build.VERSION.SDK_INT} ${Build.VERSION_CODES.Q} need to accept ${CallManager.getCallType()} call ${CallManager.isCallConnected()}"
                        )
                        answerCall()
                    } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                        answerCall()
                    } else {
                        handler.post {
//                            onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(
//                                json.toString()
//                            )
                            FlyMethodConstants.updateCallSinkValue(
                                Constants.onCallStatusUpdated,
                                json.toString()
                            )
                        }
                    }
                }
                CallAction.CALL_REQUEST_RESPONSE -> {
                    handler.post {
                        LogMessage.d(
                            tag,
                            "#onShowCallUi CallManager.isVideoMuted() ${CallManager.isVideoMuted()} CallManager.getLocalProxyVideoSink() ${CallManager.getLocalProxyVideoSink()}"
                        )
                        if (MirrorflyViewHashMap.getMirrorflyView(CallManager.getCurrentUserId()) != null && !CallManager.isVideoMuted() && CallManager.getLocalProxyVideoSink() != null) {
                            MirrorflyViewHashMap.getMirrorflyView(CallManager.getCurrentUserId())
                                ?.setLocalTarget()
                        }
                        LogMessage.d(
                            tag,
                            "#onShowCallUi CallManager.isRemoteVideoPaused(${CallManager.getEndCallerJid()}) ${
                                CallManager.isRemoteVideoPaused(CallManager.getEndCallerJid())
                            } CallManager.isRemoteVideoMuted(${CallManager.getEndCallerJid()}) ${
                                CallManager.isRemoteVideoMuted(
                                    CallManager.getEndCallerJid()
                                )
                            }"
                        )
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
        } else {
            LogMessage.d(
                tag,
                "#onShowCallUi isCallConversionRequestAvailable ${CallManager.isCallConversionRequestAvailable()}"
            )
            if (CallManager.isCallConversionRequestAvailable() && CallManager.isOneToOneCall()) {
                //CallAudioManager.getInstance(context).playIncomingRequestTone()
                val json = JSONObject()
                json.put("callAction", "ACTION_VIDEO_CALL_CONVERSION")
                json.put("userJid", CallManager.getEndCallerJid())
                json.put("callType", CallManager.getCallType())
                json.put("callMode", CallManager.getCallMode())
                handler.post {
//                    onCallActionStreamHandler.onCallAction?.success(json.toString())
                    FlyMethodConstants.updateCallSinkValue(Constants.onCallAction, json.toString())
                }
            }
        }
    }

    private fun answerCall() {
        val json = JSONObject()
        json.put("callStatus", "Attended")
        json.put("userJid", CallManager.getCurrentUserId())
        json.put("callType", CallManager.getCallType())
        json.put("callMode", CallManager.getCallMode())
        if (CallManager.getCallType().isNotEmpty()) {
            if (CallManager.isAudioCall() && CallManager.isAudioCallPermissionsGranted()) {
                LogMessage.d(
                    tag,
                    "#onShowCallUi ${Build.VERSION.SDK_INT} ${Build.VERSION_CODES.Q} need to accept audio call"
                )
                val y = AppUtils.getAppIntent(context)
                y?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(y)
                handler.post {
//                    onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(
//                        json.toString()
//                    )
                    FlyMethodConstants.updateCallSinkValue(
                        Constants.onCallStatusUpdated,
                        json.toString()
                    )
                }

            } else if (CallManager.isVideoCall() && CallManager.isVideoCallPermissionsGranted()) {
                LogMessage.d(
                    tag,
                    "#onShowCallUi ${Build.VERSION.SDK_INT} ${Build.VERSION_CODES.Q} need to accept video call"
                )
                val y = AppUtils.getAppIntent(context)
                y?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(y)
                handler.post {
//                    onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(
//                        json.toString()
//                    )
                    FlyMethodConstants.updateCallSinkValue(
                        Constants.onCallStatusUpdated,
                        json.toString()
                    )
                }
            } else {
                LogMessage.d(
                    tag,
                    "#onShowCallUi ${Build.VERSION.SDK_INT} ${Build.VERSION_CODES.Q} need Permissions to accept call"
                )
                val t = Intent(context, CallKitUiActivity::class.java)
                t.putExtra("FROM", CallConstants.ACTION_SHOW_CALL_UI)
                t.putExtra(CallConstants.ACCEPT_CALL, false)
                t.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(t)
            }
        }

        /*CallManager.answerCall(object : CallActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                LogMessage.d(tag,"isSuccess $isSuccess message $message")
                if (isSuccess) {
                    val json = JSONObject()
                    json.put("callStatus", "Attended")
                    json.put("userJid", CallManager.getCurrentUserId())
                    json.put("callType", CallManager.getCallType())
                    json.put("callMode", CallManager.getCallMode())
                }
            }

        })*/
    }
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