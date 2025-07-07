package com.mirrorfly.mirrorfly_plugin.call

import android.content.Context
import android.view.Gravity
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import io.flutter.plugin.common.BinaryMessenger
import org.webrtc.RendererCommon

class MirrorflyViewBuilder {
    fun build(id : Int, context : Context, binaryMessenger : BinaryMessenger,creationParams : Map<String,Any>,mirrorflyView: MirrorflyView?) : MirrorflyView{
        val userJid = creationParams["userJid"] ?: ""
        val newMirrorflyView = mirrorflyView ?: MirrorflyView(binaryMessenger,context,id,userJid.toString(),creationParams)
        val backgroundColor = creationParams["backgroundColor"] ?: ""
        if(creationParams.containsKey("ProfileViewPositioned")){
            newMirrorflyView.setProfileViewConfig(creationParams["ProfileViewPositioned"] as Map<String,Any>)
        }
        if(backgroundColor.toString().isNotEmpty()){
            newMirrorflyView.setBackgroundColor(backgroundColor.toString())
        }
        newMirrorflyView.init()
        if (creationParams.containsKey("scalingType") && !creationParams["scalingType"].toString().isNullOrEmpty()) {
            val scale =
                RendererCommon.ScalingType.valueOf(creationParams["scalingType"].toString())
            newMirrorflyView.setScalingType(scale)
        }else{
            newMirrorflyView.setScalingType("SCALE_ASPECT_FILL")
        }

        if (creationParams.containsKey("alignment")&& !creationParams["alignment"].toString().isNullOrEmpty()) {
            newMirrorflyView.setTextureViewAlignment()
        }else{
            newMirrorflyView.setTextureViewAlignment()
        }
//        if (CallManager.isOnGoingAudioCall()){
//            newMirrorflyView.setProfileView(viewId.toString())
//        }else {
            if (creationParams.containsKey("isLocal") || (userJid.toString() == CallManager.getCurrentUserId())) {
                newMirrorflyView.setLocalTarget()
            }
//            if (creationParams.containsKey("setMirror")) {
//                newMirrorflyView.setMirror(creationParams["setMirror"] as Boolean)
//            }
            if (creationParams.containsKey("isRemote") || (userJid.toString() != CallManager.getCurrentUserId())) {
                newMirrorflyView.setRemoteTarget(userJid.toString())
            }
//        }
        if(creationParams.containsKey("profileSize")){
            newMirrorflyView.setProfileViewSize(creationParams["profileSize"] as Int)
        }
        if(creationParams.containsKey("hideProfileView")){
            newMirrorflyView.setProfileViewHide(creationParams["hideProfileView"] as Boolean)
        }
        if (creationParams.containsKey("alignProfilePictureCenter")){
            val alignProfilePictureCenter = creationParams["alignProfilePictureCenter"] as Boolean
            val center = if(alignProfilePictureCenter) Gravity.CENTER else Gravity.TOP
            newMirrorflyView.setProfileViewAlign(center)
        }
        if(creationParams.containsKey("horizontalGravity")){
            newMirrorflyView.setProfileViewAlign(creationParams["horizontalGravity"] as Int)
        }

        return newMirrorflyView
    }
}