package com.mirrorfly.fly_chat

import io.flutter.plugin.common.EventChannel

class EventHandlers {

    object MessageReceivedStreamHandler : EventChannel.StreamHandler {

        var onMessageReceived: EventChannel.EventSink? = null


        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            onMessageReceived = events
        }

        override fun onCancel(arguments: Any?) {
            onMessageReceived = null
        }
    }
}