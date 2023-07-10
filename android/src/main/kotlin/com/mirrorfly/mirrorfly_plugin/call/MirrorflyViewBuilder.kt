package com.mirrorfly.mirrorfly_plugin.call

import android.content.Context
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import io.flutter.plugin.common.BinaryMessenger
import org.webrtc.RendererCommon

class MirrorflyViewBuilder {
    fun build(id : Int, context : Context, binaryMessenger : BinaryMessenger,creationParams : Map<String,Any>) : MirrorflyView{
        val viewId = creationParams["viewId"] ?: ""
        val mirrorflyView = MirrorflyView(binaryMessenger,context,id,viewId.toString(),creationParams)
        mirrorflyView.init()
        val backgroundColor = creationParams["backgroundColor"] ?: ""
        if (CallManager.isOnGoingAudioCall()){
            if(backgroundColor.toString().isNotEmpty()){
                mirrorflyView.setBackgroundColor(backgroundColor.toString())
            }
            mirrorflyView.setProfileView(viewId.toString())
        }else {
            if (creationParams.containsKey("scalingType")) {
                val scale =
                    RendererCommon.ScalingType.valueOf(creationParams["scalingType"].toString())
                mirrorflyView.setScalingType(scale)
            }
            if (creationParams.containsKey("isLocal") || (viewId.toString() == CallManager.getCurrentUserId() && CallManager.isOnGoingVideoCall())) {
                mirrorflyView.setLocalTarget()
            }
            if (creationParams.containsKey("setMirror")) {
                mirrorflyView.setMirror(creationParams["setMirror"] as Boolean)
            }
            if (creationParams.containsKey("isRemote") || (viewId.toString() != CallManager.getCurrentUserId() && CallManager.isOnGoingVideoCall())) {
                mirrorflyView.setRemoteTarget(creationParams["userJid"].toString())
            }
        }
        return mirrorflyView
    }
}