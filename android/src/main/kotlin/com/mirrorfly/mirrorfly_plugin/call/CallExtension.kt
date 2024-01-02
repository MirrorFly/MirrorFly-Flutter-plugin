package com.mirrorfly.mirrorfly_plugin.call

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.drawable.Drawable
import android.text.TextUtils
import android.widget.ImageView
import androidx.core.content.ContextCompat
import com.mirrorfly.mirrorfly_plugin.Constants
import com.mirrorfly.mirrorfly_plugin.R
import com.mirrorfly.mirrorfly_plugin.call.widgets.CustomDrawable
import com.mirrorfly.mirrorfly_plugin.call.widgets.SetDrawable
import com.mirrorflysdk.api.ChatManager
import com.mirrorflysdk.api.contacts.ProfileDetails
import com.mirrorflysdk.flycall.call.utils.GroupCallUtils.getEndCallerJid
import com.mirrorflysdk.flycall.webrtc.CallDirection
import com.mirrorflysdk.flycall.webrtc.CallStatus
import com.mirrorflysdk.flycall.webrtc.CallType
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import com.mirrorflysdk.flycommons.ChatType
import com.mirrorflysdk.flycommons.ContactType
import com.mirrorflysdk.flycommons.LogMessage
import com.mirrorflysdk.utils.ChatUtils
import com.mirrorflysdk.utils.MediaUtils
import com.mirrorflysdk.utils.Utils
import kotlin.math.abs

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
    callStatus.isNotBlank() && (callStatus == CallStatus.CALL_TIME_OUT || callStatus == CallStatus.OUTGOING_CALL_TIME_OUT)


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

fun ImageView.loadUserProfileImage(context: Context, userProfileDetails: ProfileDetails) {
    val drawable: Drawable?
    var imageUrl = if (!userProfileDetails.thumbImage.isNullOrEmpty()) {
        userProfileDetails.thumbImage
    } else userProfileDetails.image ?: Constants.EMPTY_STRING
    if (userProfileDetails.isBlockedMe || userProfileDetails.isAdminBlocked) {
        imageUrl = Constants.EMPTY_STRING
        drawable = CustomDrawable(context).getDefaultDrawable(userProfileDetails)
    } else if (userProfileDetails.isDeletedContact()) {
        imageUrl = userProfileDetails.image ?: Constants.EMPTY_STRING
        drawable = CustomDrawable(context).getDefaultDrawable(userProfileDetails)
    } else if (TextUtils.isEmpty(imageUrl) || this.drawable == null)
        drawable = CustomDrawable(context).getDefaultDrawable(userProfileDetails)
    else
        drawable = CustomDrawable(context).getDefaultDrawable(userProfileDetails)
    if (imageUrl.startsWith(Constants.STORAGE))
        com.mirrorfly.mirrorfly_plugin.call.Utils.loadImageWithGlide(context, imageUrl, this, drawable)
    else
        com.mirrorfly.mirrorfly_plugin.call.Utils.loadImage(context, imageUrl, this, drawable)
}

fun ProfileDetails.isUnknownContact() =
//    if (BuildConfig.CONTACT_SYNC_ENABLED)
//        !isDeletedContact() && !isItSavedContact() && !isGroupProfile
//    else
        !isGroupProfile && !isLiveContact() && !isDeletedContact() && mobileNumber.isNotNumber()

fun String.isNotNumber(): Boolean {
    return try {
        this.toDouble()
        false
    } catch (e: NumberFormatException) {
        true
    }
}

fun ProfileDetails?.getDisplayName() : String {
    if(this==null) {
        return "Guest User"
    }
    else {
        /*if (!name.isNullOrEmpty()) {
            return name
        } else if (!nickName.isNullOrEmpty()) {
            return nickName
        } else {
            return ChatUtils.getUserFromJid(jid)
        }*/
        return if ((name ?: jid).isNotBlank())
            name ?: ChatUtils.getUserFromJid(jid)
        else
            ChatUtils.getUserFromJid(jid)
    }
    /*return if ((name ?: jid).isNotBlank())
        name ?: ChatUtils.getUserFromJid(jid)
    else
        ChatUtils.getUserFromJid(jid)*/
}

fun ProfileDetails.isDeletedContact() = contactType == ContactType.DELETED_CONTACT
fun ProfileDetails.isLiveContact() = contactType == ContactType.LIVE_CONTACT
fun ProfileDetails.getChatType(): String {
    return when {
        isGroupProfile -> ChatType.TYPE_GROUP_CHAT
        else -> ChatType.TYPE_CHAT
    }
}
@SuppressLint("DefaultLocale")
fun CustomDrawable.getDefaultDrawable(profileDetails: ProfileDetails): Drawable {
    return when {
        profileDetails.isGroupProfile -> this.context.getDefaultDrawable(ChatType.TYPE_GROUP_CHAT)
        else -> {
            if(!profileDetails.isBlockedMe && !profileDetails.isAdminBlocked && !profileDetails.isDeletedContact() && profileDetails.nickName != null)
                SetDrawable(context, profileDetails).setDrawableForProfile(profileDetails.getDisplayName())
            else
                this.context.getDefaultDrawable(profileDetails.getChatType())
        }

    }
}

fun Context.drawable(drawable: Int): Drawable = ContextCompat.getDrawable(this, drawable)!!

fun Context.getDefaultDrawable(chatType: String): Drawable {
    return when (chatType) {
        ChatType.TYPE_CHAT -> drawable(R.drawable.ic_sng_bg)
        ChatType.TYPE_GROUP_CHAT -> drawable(R.drawable.ic_grp_bg)
//        ChatType.TYPE_BROADCAST_CHAT -> drawable(R.drawable.ic_broadcast)
        else -> drawable(R.drawable.profile_img)
    }
}

fun String?.getColourCode(): Int {
    if (this != null && this == Constants.YOU)
        return ContextCompat.getColor(ChatManager.applicationContext, R.color.color_black)

    val colorsArray = ChatManager.applicationContext.resources.getIntArray(R.array.colour_code)
    val hashcode = this.hashCode()
    val rand = hashcode % colorsArray.size
    return colorsArray[abs(rand)]
}




