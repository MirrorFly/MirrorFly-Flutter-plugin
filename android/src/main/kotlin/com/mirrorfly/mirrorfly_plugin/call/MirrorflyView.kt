package com.mirrorfly.mirrorfly_plugin.call

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.Drawable
import android.net.Uri
import android.view.*
import android.widget.LinearLayout
import com.bumptech.glide.Glide
import com.bumptech.glide.Priority
import com.bumptech.glide.load.DataSource
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.load.engine.GlideException
import com.bumptech.glide.request.RequestListener
import com.bumptech.glide.request.RequestOptions
import com.bumptech.glide.request.target.Target
import com.mirrorfly.mirrorfly_plugin.R
import com.mirrorfly.mirrorfly_plugin.call.widgets.CircleImageView
import com.mirrorflysdk.api.FlyCore
import com.mirrorflysdk.api.contacts.ContactManager
import com.mirrorflysdk.flycall.webrtc.Logger
import com.mirrorflysdk.flycall.webrtc.TextureViewRenderer
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import com.mirrorflysdk.flycommons.LogMessage
import com.mirrorflysdk.media.MediaUploadHelper
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
    creationParams: Any
) : PlatformView, MethodChannel.MethodCallHandler {
    private var textureView: TextureViewRenderer
    private var profileView : CircleImageView
    private var view : View
    private var mContext:Context? = context

    init {
        mContext = context
        MethodChannel(binaryMessenger, "mirrorfly_view_android_$jid").setMethodCallHandler(this)
        this.view = LayoutInflater.from(context).inflate(R.layout.mirrofly_profile_layout, null, false)
        this.textureView = view.findViewById(R.id.textureView)//TextureViewRenderer(context)
        this.profileView =  view.findViewById(R.id.circleImageView)
        this.profileView.setTag(id)
        println("creationParams $id : $creationParams")
    }
    override fun getView(): View {
        return view
    }

    override fun dispose() {
        this.textureView.release()
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
        textureView.visibility=View.VISIBLE
        profileView.visibility=View.GONE
        CallManager.getLocalProxyVideoSink()?.setTarget(textureView)
//        Logger.d("#FlutterCall","getLocalTarget ${CallManager.getLocalProxyVideoSink()?.getTarget()}")
    }

    fun setMirror(isMirror:Boolean){
        println("initial Mirror set $id")
        textureView.setMirror(isMirror)
    }

    fun setRemoteTarget(userJid:String){
        println("initial Remote set $id $userJid")
        textureView.visibility=View.VISIBLE
        profileView.visibility=View.GONE
        CallManager.getRemoteProxyVideoSink(userJid)?.setTarget(textureView)
//        Logger.d("#FlutterCall","getRemoteTarget ${CallManager.getRemoteProxyVideoSink(userJid)?.getTarget()}")
    }

    fun setProfileView(userJid: String){
        println("initial ProfileView set $id $userJid")
        val profile = FlyCore.getUserProfile(userJid)
        val name = if(!profile?.name.isNullOrEmpty()) profile?.name ?: "" else profile?.nickName ?: ""
        val imageUrl = profile?.image ?: ""
        textureView.visibility=View.GONE
        getImageViewbyTag(id)?.visibility=View.VISIBLE
        LogMessage.d("imageUrl ",imageUrl)
        Utils.loadGlideImage(mContext!!,getImageViewbyTag(id)!!,name, imageUrl)
    }

    fun getImageViewbyTag(id: Int): CircleImageView? {
        return view.findViewWithTag<CircleImageView>(id)
    }
    fun setBackgroundColor(color: String){
        println("initial setBackgroundColor set $id $color")
        view.setBackgroundColor(Color.parseColor(color))
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