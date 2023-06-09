package com.mirrorfly.mirrorfly_plugin.call

import android.content.Context
import android.view.*
import com.mirrorflysdk.flycall.webrtc.Logger
import com.mirrorflysdk.flycall.webrtc.TextureViewRenderer
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import org.webrtc.RendererCommon

class MirrorflyView(
    binaryMessenger: BinaryMessenger,
    context: Context?,
    private var id: Int,
    creationParams: Any
) : PlatformView, MethodChannel.MethodCallHandler {
    private var textureView: TextureViewRenderer
//    private var mContext:Context? = context

    init {
        MethodChannel(binaryMessenger, "mirrorfly_view_android_$id").setMethodCallHandler(this)
        this.textureView = TextureViewRenderer(context)
        println("creationParams $id : $creationParams")
    }
    override fun getView(): View {
        return textureView
    }

    override fun dispose() {

    }

    fun getViewById(id: Int):TextureViewRenderer{
        return textureView.findViewById(id)
    }

    fun init(){
        textureView.init(CallManager.getRootEglBase()?.eglBaseContext, null)
    }

    fun setScalingType(scalingType: RendererCommon.ScalingType){
        this.textureView.setScalingType(scalingType)
    }

    fun setLocalTarget(){
        println("initial Target set $id")
        CallManager.getLocalProxyVideoSink()?.setTarget(textureView)
//        Logger.d("#FlutterCall","getLocalTarget ${CallManager.getLocalProxyVideoSink()?.getTarget()}")
    }

    fun setMirror(isMirror:Boolean){
        println("initial Mirror set $id")
        textureView.setMirror(isMirror)
    }

    fun setRemoteTarget(userJid:String){
        println("initial Remote set $id $userJid")
        CallManager.getRemoteProxyVideoSink(userJid)?.setTarget(textureView)
//        Logger.d("#FlutterCall","getRemoteTarget ${CallManager.getRemoteProxyVideoSink(userJid)?.getTarget()}")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method.toString()){
            "isLocal" ->{
                println("isLocal set $id")
                Logger.d("#FlutterCall","setLocalTarget")
                setLocalTarget()
                result.success(true)
            }
            "isRemote" ->{
                println("isRemote set $id")
                Logger.d("#FlutterCall","setRemoteTarget")
                val userJid = call.argument<String>("user_jid") ?: ""
                setRemoteTarget(userJid)
                result.success(true)
            }
        }
    }

}