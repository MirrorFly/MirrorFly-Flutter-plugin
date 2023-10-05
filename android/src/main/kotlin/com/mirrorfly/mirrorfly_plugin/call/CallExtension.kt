package com.mirrorfly.mirrorfly_plugin.call

import android.content.Context
import com.mirrorfly.mirrorfly_plugin.R
import com.mirrorflysdk.flycall.call.utils.GroupCallUtils.getEndCallerJid
import com.mirrorflysdk.flycall.webrtc.CallDirection
import com.mirrorflysdk.flycall.webrtc.CallStatus
import com.mirrorflysdk.flycall.webrtc.CallType
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import com.mirrorflysdk.flycommons.Constants
import com.mirrorflysdk.flycommons.LogMessage

fun CallManager.getEndCallerJid() : String {
    return try {
        if (getCallUsersList()
                .isNotEmpty()) getCallUsersList().first() else ""
    } catch (e: Exception) {
        LogMessage.e("getEndCallerJid", "$e")
        ""
    }
}
fun CallManager.isAudioCall() = getCallType() == CallType.AUDIO_CALL
fun CallManager.isOutgoingCall() = getCallDirection() == CallDirection.OUTGOING_CALL

fun CallManager.isInComingCall() = getCallDirection() == CallDirection.INCOMING_CALL

fun CallManager.isVideoCall() = getCallType() == CallType.VIDEO_CALL

fun CallManager.getInComingCallStatus(context: Context): String {
    return if (isAudioCall())
        if (isOneToOneCall())
            context.getString(R.string.incoming_audio_call)
        else
            context.getString(R.string.incoming_audio_group_call)
    else
        if (isOneToOneCall())
            context.getString(R.string.incoming_video_call)
        else
            context.getString(R.string.incoming_video_group_call)
}
fun CallManager.getOnGoingCallStatus(context: Context): String {
    when {
        isCallConnected() -> return getCallConnectedStatus(context)
        isOutgoingCall() -> return getOutGoingCallStatus(context)
        isInComingCall() -> return getInComingCallStatus(context)
    }
    return Constants.EMPTY_STRING
}


fun CallManager.getCallConnectedStatus(context: Context): String {
    return if (isOneToOneCall()) {
        when (val localCallStatus = getCallStatus(getCurrentUserId())) {
            CallStatus.ON_HOLD -> localCallStatus
            CallStatus.RECONNECTING -> context.getString(R.string.reconnecting)
            else -> {
                when (val remoteCallStatus = getCallStatus(getEndCallerJid())) {
                    CallStatus.CALLING, CallStatus.RINGING, CallStatus.ON_HOLD -> remoteCallStatus
                    else -> Constants.EMPTY_STRING
                }
            }
        }
    } else
        CallStatus.CONNECTED
}

fun isCallTryingToConnect(callStatus: String) = callStatus.isEmpty()
        || callStatus == CallStatus.DISCONNECTED
fun isCallTimeOut(callStatus: String) =
    callStatus.isNotBlank() && callStatus == CallStatus.OUTGOING_CALL_TIME_OUT

fun isCallConnecting(callStatus: String) = callStatus == CallStatus.CONNECTING || callStatus == CallStatus.CONNECTED


fun CallManager.getOutGoingCallStatus(context: Context): String {
    val localCallStatus = getCallStatus(getCurrentUserId())
    return when {
        isCallTryingToConnect(localCallStatus) -> context.getString(R.string.trying_to_connect)
        isCallTimeOut(localCallStatus) -> context.getString(R.string.call_try_again_info)
        isCallConnecting(localCallStatus) -> CallStatus.RINGING
        else -> localCallStatus
    }
}



