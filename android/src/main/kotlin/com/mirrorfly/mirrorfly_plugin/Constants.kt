package com.mirrorfly.mirrorfly_plugin

object Constants {
    //call Method channel constants
    private const val domain = "contus.mirrorfly"
    const val callMethodChannel = "$domain/flyCall"
    const val onCallReceiving = "$domain/onCallReceiving"
    const val onLocalVideoTrackAdded = "$domain/onLocalVideoTrackAdded"
    const val onVideoTrackAdded = "$domain/onVideoTrackAdded"
    const val onCallStatusUpdated = "$domain/onCallStatusUpdated"
    const val onCallAction = "$domain/onCallAction"
    const val onMuteStatusUpdated = "$domain/onMuteStatusUpdated"
    const val onUserSpeaking = "$domain/onUserSpeaking"
    const val onUserStoppedSpeaking = "$domain/onUserStoppedSpeaking"
}