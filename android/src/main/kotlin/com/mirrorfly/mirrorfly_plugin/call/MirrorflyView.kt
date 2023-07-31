package com.mirrorfly.mirrorfly_plugin.call

import android.content.Context
import android.graphics.Color
import android.view.*
import com.mirrorfly.mirrorfly_plugin.R
import com.mirrorfly.mirrorfly_plugin.call.widgets.CircleImageView
import com.mirrorflysdk.api.FlyCore
import com.mirrorflysdk.flycall.webrtc.Logger
import com.mirrorflysdk.flycall.webrtc.TextureViewRenderer
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import com.mirrorflysdk.flycommons.LogMessage
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import org.webrtc.RendererCommon

class MirrorflyView(
    binaryMessenger: BinaryMessenger,
    context: Context?,
    private var id: Int,
    private var jid:String,
    private var creationParams: Any
) : PlatformView, MethodChannel.MethodCallHandler {
    private var textureView: TextureViewRenderer
    private var profileView : CircleImageView
    private var view : View
    private var mContext:Context? = context
    private val tag = "#FlutterAndroidCall"
    private val textureViewStart = 100
    private val imageViewStart = 200

    init {
        mContext = context
        MethodChannel(binaryMessenger, "mirrorfly_view_android_$jid").setMethodCallHandler(this)
        this.view = LayoutInflater.from(context).inflate(R.layout.mirrofly_profile_layout, null, false)
        this.textureView = view.findViewById(R.id.textureView)//TextureViewRenderer(context)
        this.textureView.setTag(jid)
        this.profileView =  view.findViewById(R.id.circleImageView)
        this.profileView.setTag(id)
        LogMessage.d(tag,"creationParams $id : $creationParams")
    }
    override fun getView(): View {
        return view
    }

    override fun dispose() {
        LogMessage.d("#FlutterAndroidCall","dispose")
        getTextureViewByTag(jid)?.release()
        MirrorflyViewHashMap.clearAll()
    }

    fun init(){
        textureView.init(CallManager.getRootEglBase()?.eglBaseContext, null)
    }

    fun setScalingType(scalingType: RendererCommon.ScalingType){
        getTextureViewByTag(jid)?.setScalingType(scalingType)
    }

    fun setLocalTarget(){
        LogMessage.d(tag,"Target set $id $jid")
        getTextureViewByTag(jid)?.visibility=View.VISIBLE
        getImageViewByTag(id)?.visibility=View.GONE
        CallManager.getLocalProxyVideoSink()?.setTarget(getTextureViewByTag(jid))
//        Logger.d("#FlutterCall","getLocalTarget ${CallManager.getLocalProxyVideoSink()?.getTarget()}")
    }

    fun setMirror(isMirror:Boolean){
        LogMessage.d(tag,"Mirror set $id $jid")
        getTextureViewByTag(jid)?.setMirror(isMirror)
    }

    fun setRemoteTarget(userJid:String){
        LogMessage.d(tag,"Remote set $id $userJid ${CallManager.getRemoteProxyVideoSink(userJid)} ${CallManager.isRemoteVideoMuted(userJid)}")
        getTextureViewByTag(userJid)?.visibility=View.VISIBLE
        getImageViewByTag(id)?.visibility=View.GONE
        if(CallManager.getRemoteProxyVideoSink(userJid)!=null) {
            CallManager.getRemoteProxyVideoSink(userJid)?.setTarget(getTextureViewByTag(userJid))
        }else{
            LogMessage.d(tag,"video null $id $userJid ${CallManager.getRemoteProxyVideoSink(userJid)}")
        }
//        Logger.d("#FlutterCall","getRemoteTarget ${CallManager.getRemoteProxyVideoSink(userJid)?.getTarget()}")
    }

    fun setProfileView(userJid: String){
        LogMessage.d(tag,"ProfileView set $id $userJid ${CallManager.isRemoteVideoMuted(userJid)}")
        val profile = FlyCore.getUserProfile(userJid)
        val name = if(!profile?.name.isNullOrEmpty()) profile?.name ?: "" else profile?.nickName ?: ""
        val imageUrl = profile?.image ?: ""
        getTextureViewByTag(userJid)?.visibility=View.GONE
        getImageViewByTag(id)?.visibility=View.VISIBLE
        LogMessage.d("imageUrl ",imageUrl)
        Utils.loadGlideImage(mContext!!,getImageViewByTag(id)!!,name, imageUrl)
    }

    fun getArgs(): Any {
        return creationParams
    }

    private fun getImageViewByTag(id: Int): CircleImageView? {
        return view.findViewWithTag<CircleImageView>(id)
    }
    private fun getTextureViewByTag(id: Any): TextureViewRenderer? {
        return view.findViewWithTag<TextureViewRenderer>(id)
    }
    fun setBackgroundColor(color: String){
        LogMessage.d(tag,"initial setBackgroundColor set $id $color")
        view.setBackgroundColor(Color.parseColor(color))
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method.toString()){
            "isLocal" ->{
                LogMessage.d(tag,"isLocal set $id")
                Logger.d("#FlutterCall","setLocalTarget")
                setLocalTarget()
                result.success(true)
            }
            "isRemote" ->{
                LogMessage.d(tag,"isRemote set $id")
                Logger.d("#FlutterCall","setRemoteTarget")
                val userJid = call.argument<String>("user_jid") ?: ""
                setRemoteTarget(userJid)
                result.success(true)
            }
        }
    }

}