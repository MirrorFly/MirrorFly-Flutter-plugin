package com.mirrorfly.mirrorfly_plugin.call

import android.content.Context
import android.graphics.Color
import android.graphics.Paint.Align
import android.text.Layout.Alignment
import android.util.DisplayMetrics
import android.util.TypedValue
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.widget.RelativeLayout
import com.mirrorfly.mirrorfly_plugin.R
import com.mirrorfly.mirrorfly_plugin.call.widgets.CircleImageView
import com.mirrorfly.mirrorfly_plugin.call.widgets.RippleBackgroundView
import com.mirrorfly.mirrorfly_plugin.toJsonString
import com.mirrorflysdk.api.ChatEventsManager
import com.mirrorflysdk.api.ChatManager
import com.mirrorflysdk.api.FlyCore
import com.mirrorflysdk.api.contacts.ContactManager
import com.mirrorflysdk.api.chat.ProfileEventsListener
import com.mirrorflysdk.api.contacts.ContactManager
import com.mirrorflysdk.api.contacts.ProfileDetails
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
    private var creationParams: Map<String,Any>
) : PlatformView, MethodChannel.MethodCallHandler,FlutterProfileEventsListener {
    private var textureView: TextureViewRenderer
    private var profileView : CircleImageView
    private var speakingRipple : RippleBackgroundView
    private var layout : RelativeLayout
    private var view : View
    private var mContext:Context? = context
    private val tag = "#MirrorflyView"
    private val textureViewStart = 100
    private val imageViewStart = 200

    init {
        mContext = context
        MethodChannel(binaryMessenger, "mirrorfly_view_android_$jid").setMethodCallHandler(this)
        this.view = LayoutInflater.from(context).inflate(R.layout.mirrofly_profile_layout, null, false)
        this.view.tag = jid+"_view"
        this.textureView = view.findViewById(R.id.textureView)//TextureViewRenderer(context)
        this.textureView.tag = jid
        this.layout = view.findViewById(R.id.layout_profile)//TextureViewRenderer(context)
        this.layout.tag = jid+"_layout"
        this.profileView =  view.findViewById(R.id.circleImageView)
        this.profileView.tag = jid +"_image"
        this.speakingRipple =  view.findViewById(R.id.speakingRipple)
        this.speakingRipple.tag = jid +"_ripple"
        FlutterChat.setListener(this)
        LogMessage.d(tag,"creationParams $id : $creationParams")
    }
    override fun getView(): View {
        return view
    }

    override fun dispose() {
        LogMessage.d("$tag Lifecycle","dispose $id ${MirrorflyViewHashMap.getMirrorflyViewId(jid)}")
        if(id == MirrorflyViewHashMap.getMirrorflyViewId(jid)!!) {
            MirrorflyViewHashMap.remove(id,jid)
            LogMessage.d("$tag Lifecycle","dispose")
            getTextureViewByTag(jid)?.release()
        }else{
            LogMessage.d("$tag Lifecycle","not dispose")
        }
    }

    fun init(){
        textureView.init(CallManager.getRootEglBase()?.eglBaseContext, null)
    }

    fun setScalingType(scalingType: RendererCommon.ScalingType){
        getTextureViewByTag(jid)?.setScalingType(scalingType)
    }

    fun setLocalTarget(){
        if(!CallManager.isVideoMuted()) {
            LogMessage.d(tag, "Target set $id $jid")
            getTextureViewByTag(jid)?.visibility = View.VISIBLE
            getImageViewByTag(jid)?.visibility = View.GONE
            CallManager.getLocalProxyVideoSink()?.setTarget(getTextureViewByTag(jid))
//        Logger.d("#FlutterCall","getLocalTarget ${CallManager.getLocalProxyVideoSink()?.getTarget()}")
        }else{
            setProfileView(jid)
        }
    }

    fun setMirror(isMirror:Boolean){
        LogMessage.d(tag,"Mirror set $id $jid")
        getTextureViewByTag(jid)?.setMirror(isMirror)
    }

    fun setRemoteTarget(userJid:String){
        LogMessage.d(tag,"Remote set $id $userJid ${CallManager.getRemoteProxyVideoSink(userJid)} ${CallManager.isRemoteVideoMuted(userJid)}")
        getTextureViewByTag(userJid)?.visibility=View.VISIBLE
        getImageViewByTag(jid)?.visibility=View.GONE
        getSpeakingRippleView(jid)?.visibility=View.GONE
        if(CallManager.getRemoteProxyVideoSink(userJid)!=null && !CallManager.isRemoteVideoPaused(userJid)) {
            CallManager.getRemoteProxyVideoSink(userJid)?.setTarget(getTextureViewByTag(userJid))
        }else{
            LogMessage.d(tag,"video null $id $userJid ${CallManager.getRemoteProxyVideoSink(userJid)} ${CallManager.isRemoteVideoPaused(userJid)}")
        }
//        Logger.d("#FlutterCall","getRemoteTarget ${CallManager.getRemoteProxyVideoSink(userJid)?.getTarget()}")
    }

    fun setProfileView(userJid: String){
        LogMessage.d(tag,"ProfileView set $id $userJid ${CallManager.isRemoteVideoMuted(userJid)}")
        val profile = ContactManager.getProfileDetails(userJid)
        val name = if(!profile?.name.isNullOrEmpty()) profile?.name ?: "" else profile?.nickName ?: ""
        val imageUrl = profile?.image ?: ""
        getTextureViewByTag(userJid)?.visibility=View.GONE
        getImageViewByTag(jid)?.visibility=if(viewAble()) View.VISIBLE else View.GONE
        getSpeakingRippleView(jid)?.visibility=if(viewAble()) View.VISIBLE else View.GONE
        LogMessage.d("imageUrl ",imageUrl)
        if (profile != null) {
            LogMessage.d("profile ",profile.toJsonString())
        }
        if(viewAble()) {
            Utils.loadGlideImage(mContext!!, getImageViewByTag(jid)!!, name, imageUrl,false)
        }
    }

    fun userSpeaking(userJid: String){
        if(RippleViewAble()) {
            getSpeakingRippleView(userJid)?.onUserSpeaking()
        }
    }

    fun userStoppedSpeaking(userJid: String){
        if(RippleViewAble()) {
            getSpeakingRippleView(userJid)?.onUserStoppedSpeaking()
        }
    }

    fun getArgs(): Any {
        return creationParams
    }

    fun getImageViewByTag(jid: String): CircleImageView? {
        return getView().findViewWithTag<CircleImageView>(jid+"_image")
    }
    private fun getLayoutViewByTag(jid: String): RelativeLayout? {
        return getView().findViewWithTag<RelativeLayout>(jid + "_layout")
    }
    private fun getSpeakingRippleView(jid: String): RippleBackgroundView? {
        return getView().findViewWithTag<RippleBackgroundView>(jid +"_ripple")
    }
    private fun getTextureViewByTag(id: Any): TextureViewRenderer? {
        return getView().findViewWithTag<TextureViewRenderer>(id)
    }
    fun setBackgroundColor(color: String){
        LogMessage.d(tag,"initial setBackgroundColor set $id $color")
        getView().setBackgroundColor(Color.parseColor(color))
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

    fun setProfileViewSize(size: Int) {
        val intrinsicSize = getIntrinsicSize(size,getImageViewByTag(jid)!!.context);
        LogMessage.d(tag,"setProfileViewSize $id $size $intrinsicSize")
        val layoutParams = getImageViewByTag(jid)?.layoutParams as (RelativeLayout.LayoutParams)
        layoutParams.width = intrinsicSize
        layoutParams.height = intrinsicSize
        // Apply the updated layout parameters to the ImageView
        getImageViewByTag(jid)?.layoutParams = layoutParams
//        speakingRippleSize(size)
    }

    private fun speakingRippleSize(size: Int){
        val extra = 20
        val intrinsicSize = getIntrinsicSize((size+extra)*2,getSpeakingRippleView(jid)!!.context);
        LogMessage.d(tag,"speakingRippleSize $jid ${(size+extra)*2} $intrinsicSize")
        val layoutParams = getSpeakingRippleView(jid)?.layoutParams as (RelativeLayout.LayoutParams)
        layoutParams.width = intrinsicSize
        layoutParams.height = intrinsicSize
        // Apply the updated layout parameters to the ImageView
        getSpeakingRippleView(jid)?.layoutParams = layoutParams
    }

    private fun viewAble() : Boolean {
        if(creationParams.containsKey("hideProfileView")) {
            return !(creationParams["hideProfileView"] as Boolean)
        }else {
            return true
        }
    }
    private fun RippleViewAble() : Boolean {
        if(creationParams.containsKey("showSpeakingRipple")) {
            return (creationParams["showSpeakingRipple"] as Boolean)
        }else {
            return false
        }
    }
    fun setProfileViewHide(hide : Boolean){
        if(hide) {
            getImageViewByTag(jid)?.visibility = View.GONE
//            getSpeakingRippleView(jid)?.visibility = View.GONE
        }
    }

    fun setSpeakingViewHide(show : Boolean){
        if(!show) {
            getSpeakingRippleView(jid)?.visibility = View.GONE
        }
    }

    fun setProfileViewAlign(gravity: Int){
        val layoutParams = getLayoutViewByTag(jid)?.layoutParams as (RelativeLayout.LayoutParams)
        if(gravity == Gravity.TOP) {
            layoutParams.topMargin = getIntrinsicSize(70,mContext!!)
            // Update the attributes
            layoutParams.addRule(
                RelativeLayout.ALIGN_PARENT_TOP,
                RelativeLayout.TRUE
            )
            layoutParams.addRule(
                RelativeLayout.CENTER_IN_PARENT,
                RelativeLayout.TRUE
            )
        }else if(gravity == Gravity.CENTER){
            // Update the attributes
            layoutParams.addRule(
                RelativeLayout.ALIGN_PARENT_TOP,
                0
            )
            layoutParams.addRule(
                RelativeLayout.CENTER_IN_PARENT,
                RelativeLayout.TRUE
            )
        }else if(gravity == Gravity.BOTTOM){
            // Update the attributes
            layoutParams.addRule(
                RelativeLayout.ALIGN_PARENT_BOTTOM,
                RelativeLayout.TRUE
            )
            layoutParams.addRule(
                RelativeLayout.CENTER_IN_PARENT,
                RelativeLayout.TRUE
            )
        }
        // Apply the updated layout parameters to the ImageView
//        getImageViewByTag(jid)?.layoutParams = layoutParams
        getLayoutViewByTag(jid)?.layoutParams = layoutParams
//        getSpeakingRippleView(jid)?.layoutParams = layoutParams

    }

    /**
     * This method converts device specific pixels to density independent pixels.
     *
     * @param px A value in px (pixels) unit. Which we need to convert into db
     * @param context Context to get resources and device specific display metrics
     * @return A float value to represent dp equivalent to px value
     */
    fun convertPixelsToDp(px: Float, context: Context): Float {
        return px / (context.resources.displayMetrics.densityDpi.toFloat() / DisplayMetrics.DENSITY_DEFAULT)
    }
    fun pxToDp(px: Int, context: Context): Int {
        val displayMetrics: DisplayMetrics = context.getResources().getDisplayMetrics()
        return Math.round(px / (displayMetrics.xdpi / DisplayMetrics.DENSITY_DEFAULT))
    }

    fun dpToPx(dp: Int,context: Context): Int {
        val displayMetrics: DisplayMetrics = context.getResources().getDisplayMetrics()
        return Math.round(dp * (displayMetrics.xdpi / DisplayMetrics.DENSITY_DEFAULT))
    }

    private fun getIntrinsicSize(dp: Int, context: Context): Int{
        return  TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp.toFloat(), context.resources.displayMetrics).toInt();
    }

    fun setProfileViewConfig(map: Map<String, Any>) {
        val left = (map["left"] ?: 0) as Int
        val top = (map["top"] ?: 0) as Int
        val right =(map["right"] ?: 0) as Int
        val bottom = (map["bottom"] ?: 0) as Int
        val width = (map["width"] ?: 0) as Int
        val height = (map["height"] ?: 0) as Int
        if(width!=0 && height != 0) {
            this.profileView.tag = id
            val layoutParams = getImageViewByTag(jid)?.layoutParams as (RelativeLayout.LayoutParams)
            layoutParams.leftMargin = getIntrinsicSize(left, mContext!!)
            layoutParams.topMargin = getIntrinsicSize(top, mContext!!)
            layoutParams.rightMargin = getIntrinsicSize(right, mContext!!)
            layoutParams.bottomMargin = getIntrinsicSize(bottom, mContext!!)
            if (left == 0 && right == 0 && top == 0 && bottom == 0) {
                layoutParams.addRule(
                    RelativeLayout.CENTER_IN_PARENT,
                    RelativeLayout.TRUE
                )
            } else {
                if (left == 0 && right == 0 && top != 0) {
                    layoutParams.addRule(
                        RelativeLayout.ALIGN_PARENT_TOP,
                        RelativeLayout.TRUE
                    )
                    layoutParams.addRule(
                        RelativeLayout.CENTER_IN_PARENT,
                        RelativeLayout.TRUE
                    )
                } else if (left == 0 && right == 0 && bottom != 0) {
                    layoutParams.addRule(
                        RelativeLayout.ALIGN_PARENT_BOTTOM,
                        RelativeLayout.TRUE
                    )
                    layoutParams.addRule(
                        RelativeLayout.CENTER_IN_PARENT,
                        RelativeLayout.TRUE
                    )
                } else if (top == 0 && right != 0 && bottom == 0) {
                    layoutParams.addRule(
                        RelativeLayout.ALIGN_PARENT_RIGHT,
                        RelativeLayout.TRUE
                    )
                    layoutParams.addRule(
                        RelativeLayout.CENTER_IN_PARENT,
                        RelativeLayout.TRUE
                    )
                } else if (top == 0 && left != 0 && bottom == 0) {
                    layoutParams.addRule(
                        RelativeLayout.ALIGN_PARENT_LEFT,
                        RelativeLayout.TRUE
                    )
                    layoutParams.addRule(
                        RelativeLayout.CENTER_IN_PARENT,
                        RelativeLayout.TRUE
                    )
                }else{

                }
            }
            val intrinsicWidth = getIntrinsicSize(width, getImageViewByTag(jid)!!.context);
            val intrinsicHeight = getIntrinsicSize(height, getImageViewByTag(jid)!!.context);
            layoutParams.width = intrinsicWidth
            layoutParams.height = intrinsicHeight
            LogMessage.d(
                "setProfileViewConfig",
                "left : $left, right : $right, top : $top, bottom : $bottom, width : $intrinsicWidth, height : $intrinsicHeight"
            )
            // Apply the updated layout parameters to the ImageView
            getImageViewByTag(jid)?.layoutParams = layoutParams
            getImageViewByTag(jid)?.visibility = if(viewAble()) View.VISIBLE else View.GONE
            getSpeakingRippleView(jid)?.visibility = if(viewAble()) View.VISIBLE else View.GONE
        }
    }

    override fun blockedThisUser(jid: String) {
    }

    override fun myProfileUpdated(isSuccess: Boolean) {
    }

    override fun onAdminBlockedOtherUser(jid: String, type: String, status: Boolean) {
    }

    override fun onAdminBlockedUser(jid: String, status: Boolean) {
    }

    override fun onContactSyncComplete(isSuccess: Boolean) {
    }

    override fun onLoggedOut() {
    }

    override fun unblockedThisUser(jid: String) {
    }

    override fun userBlockedMe(jid: String) {
    }

    override fun userCameOnline(jid: String) {
    }

    override fun userDeletedHisProfile(jid: String) {
    }

    override fun userProfileFetched(jid: String, profileDetails: ProfileDetails) {
    }

    override fun userUnBlockedMe(jid: String) {
    }

    override fun userUpdatedHisProfile(jid: String) {
        LogMessage.d(tag,"userUpdatedHisProfile $jid ${this.jid} ${MirrorflyViewHashMap.getMirrorflyView(jid)} ${MirrorflyViewHashMap.getMirrorflyView(jid)?.getImageViewByTag(jid)}")
        val profile = ContactManager.getProfileDetails(jid)
        if (profile != null && MirrorflyViewHashMap.getMirrorflyView(jid)!=null ) {
            Utils.loadGlideImage(mContext!!, MirrorflyViewHashMap.getMirrorflyView(jid)?.getImageViewByTag(jid)!!, profile.getDisplayName(), profile.image,false)
        }
    }

    override fun userWentOffline(jid: String) {
    }

    override fun usersIBlockedListFetched(jidList: List<String>) {
    }

    override fun usersProfilesFetched() {
    }

    override fun usersWhoBlockedMeListFetched(jidList: List<String>) {
    }
}