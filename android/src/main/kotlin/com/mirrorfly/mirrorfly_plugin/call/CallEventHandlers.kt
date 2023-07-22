package com.mirrorfly.mirrorfly_plugin.call

import io.flutter.plugin.common.EventChannel

object onLocalVideoTrackAddedStreamHandler : EventChannel.StreamHandler {

    var onLocalVideoTrackAdded: EventChannel.EventSink? = null


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        onLocalVideoTrackAdded = events
    }

    override fun onCancel(arguments: Any?) {
        onLocalVideoTrackAdded = null
    }
}

object onRemoteVideoTrackAddedStreamHandler : EventChannel.StreamHandler {

    var onRemoteVideoTrackAdded: EventChannel.EventSink? = null


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        onRemoteVideoTrackAdded = events
    }

    override fun onCancel(arguments: Any?) {
        onRemoteVideoTrackAdded = null
    }
}

object onTrackAddedStreamHandler : EventChannel.StreamHandler {

    var onTrackAdded: EventChannel.EventSink? = null


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        onTrackAdded = events
    }

    override fun onCancel(arguments: Any?) {
        onTrackAdded = null
    }
}

object onCallStatusUpdatedStreamHandler : EventChannel.StreamHandler{
    var onCallStatusUpdated: EventChannel.EventSink?=null
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        onCallStatusUpdated = events
    }

    override fun onCancel(arguments: Any?) {
        onCallStatusUpdated = null
    }
}
object onCallActionStreamHandler : EventChannel.StreamHandler{
    var onCallAction: EventChannel.EventSink?=null
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        onCallAction = events
    }

    override fun onCancel(arguments: Any?) {
        onCallAction = null
    }
}
object onMuteStatusUpdatedStreamHandler : EventChannel.StreamHandler{
    var onMuteStatusUpdated: EventChannel.EventSink?=null
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        onMuteStatusUpdated = events
    }

    override fun onCancel(arguments: Any?) {
        onMuteStatusUpdated = null
    }
}
object onUserSpeakingStreamHandler : EventChannel.StreamHandler{
    var onUserSpeaking: EventChannel.EventSink?=null
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        onUserSpeaking = events
    }

    override fun onCancel(arguments: Any?) {
        onUserSpeaking = null
    }
}
object onUserStoppedSpeakingStreamHandler : EventChannel.StreamHandler{
    var onUserStoppedSpeaking: EventChannel.EventSink?=null
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        onUserStoppedSpeaking = events
    }

    override fun onCancel(arguments: Any?) {
        onUserStoppedSpeaking = null
    }
}

object FlutterCall{
    /**
     * Listener for show call Ui
     */
    var callUiListener: CallUiFlutterListener? = null
    fun setListener(listener: CallUiFlutterListener){
        callUiListener = listener
    }
}
interface CallUiFlutterListener {
    fun onShowCallUiFlutter(callAction: String?)
}