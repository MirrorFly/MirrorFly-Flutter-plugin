package com.mirrorfly.mirrorfly_plugin.call

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import org.webrtc.RendererCommon

class MirrorflyViewBuilder {
    fun build(id : Int, context : Context, binaryMessenger : BinaryMessenger,creationParams : Map<String,Any>) : MirrorflyView{
        val mirrorflyView = MirrorflyView(binaryMessenger,context,id,creationParams)
        mirrorflyView.init()
        if (creationParams.containsKey("scalingType")) {
            val scale =
                RendererCommon.ScalingType.valueOf(creationParams["scalingType"].toString())
            mirrorflyView.setScalingType(scale)
        }
        if (creationParams.containsKey("isLocal")){
            mirrorflyView.setLocalTarget()
        }
        if(creationParams.containsKey("setMirror")){
            mirrorflyView.setMirror(creationParams["setMirror"] as Boolean)
        }
        if (creationParams.containsKey("isRemote")){
            mirrorflyView.setRemoteTarget(creationParams["userJid"].toString())
        }
        return mirrorflyView
    }
}