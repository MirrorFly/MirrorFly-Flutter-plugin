package com.mirrorfly.mirrorfly_plugin.call

import android.content.Context
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import io.flutter.plugin.common.BinaryMessenger
import org.webrtc.RendererCommon

class MirrorflyViewBuilder {
    fun build(id : Int, context : Context, binaryMessenger : BinaryMessenger,creationParams : Map<String,Any>,mirrorflyView: MirrorflyView?) : MirrorflyView{
        val viewId = creationParams["userJid"] ?: ""
        val newMirrorflyView = mirrorflyView ?: MirrorflyView(binaryMessenger,context,id,viewId.toString(),creationParams)
        if(mirrorflyView==null) {
            newMirrorflyView.init()
        }
        val backgroundColor = creationParams["backgroundColor"] ?: ""
        if (CallManager.isOnGoingAudioCall()){
            if(backgroundColor.toString().isNotEmpty()){
                newMirrorflyView.setBackgroundColor(backgroundColor.toString())
            }
            newMirrorflyView.setProfileView(viewId.toString())
        }else {
            if (creationParams.containsKey("scalingType")) {
                val scale =
                    RendererCommon.ScalingType.valueOf(creationParams["scalingType"].toString())
                newMirrorflyView.setScalingType(scale)
            }
            if (creationParams.containsKey("isLocal") || (viewId.toString() == CallManager.getCurrentUserId() && CallManager.isOnGoingVideoCall())) {
                newMirrorflyView.setLocalTarget()
            }
            if (creationParams.containsKey("setMirror")) {
                newMirrorflyView.setMirror(creationParams["setMirror"] as Boolean)
            }
            if (creationParams.containsKey("isRemote") || (viewId.toString() != CallManager.getCurrentUserId() && CallManager.isOnGoingVideoCall())) {
                newMirrorflyView.setRemoteTarget(creationParams["userJid"].toString())
            }
        }
        return newMirrorflyView
    }
}