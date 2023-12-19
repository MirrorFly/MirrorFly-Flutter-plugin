package com.mirrorfly.mirrorfly_plugin.call

import android.content.Context
import android.content.Intent
import android.content.res.Resources
import android.graphics.drawable.Drawable
import android.net.Uri
import android.view.View
import android.widget.ImageView
import androidx.core.content.ContextCompat
import androidx.core.view.isGone
import com.bumptech.glide.Glide
import com.bumptech.glide.Priority
import com.bumptech.glide.load.DataSource
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.load.engine.GlideException
import com.bumptech.glide.request.RequestListener
import com.bumptech.glide.request.RequestOptions
import com.bumptech.glide.request.target.Target
import com.mirrorfly.mirrorfly_plugin.Constants
import com.mirrorfly.mirrorfly_plugin.R
import com.mirrorfly.mirrorfly_plugin.call.widgets.CircleImageView
import com.mirrorfly.mirrorfly_plugin.call.widgets.SetDrawable
import com.mirrorfly.mirrorfly_plugin.toJsonString
import com.mirrorflysdk.api.contacts.ContactManager
import com.mirrorflysdk.api.contacts.ProfileDetails
import com.mirrorflysdk.flycall.call.utils.CallConstants
import com.mirrorflysdk.flycommons.LogMessage
import com.mirrorflysdk.media.MediaUploadHelper
import com.mirrorflysdk.utils.ChatUtils
import com.mirrorflysdk.utils.Utils
import com.mirrorflysdk.utils.Utils.returnEmptyStringIfNull
import java.lang.ref.WeakReference
import java.util.ArrayList
import java.util.regex.Matcher
import java.util.regex.Pattern


class Utils {

    companion object {

        @JvmStatic
        fun dpToPx(dp: Float): Float {
            return dp * Resources.getSystem().displayMetrics.density
        }

        @JvmStatic
        fun pxToDp(px: Float): Float {
            return px / Resources.getSystem().displayMetrics.density
        }

        @JvmStatic
        fun getScreenWidth(): Int {
            return Resources.getSystem().displayMetrics.widthPixels
        }

        @JvmStatic
        fun getScreenHeight(): Int {
            return Resources.getSystem().displayMetrics.heightPixels
        }

        fun getNavigationBarHeight(context: Context): Int {
            val resources = context.resources
            val id = resources.getIdentifier(
                "navigation_bar_height", "dimen", "android"
            )
            return if (id > 0) {
                resources.getDimensionPixelSize(id)
            } else 0
        }

        fun getStatusBarHeight(context: Context): Int {
            val resources = context.resources
            val id: Int =
                resources.getIdentifier("status_bar_height", "dimen", "android")
            return if (id > 0) {
                resources.getDimensionPixelSize(id)
            } else 0
        }

        fun backToForeground(context: Context) {
            val packageName = context.packageName
            val intent = context.packageManager.getLaunchIntentForPackage(packageName)?.cloneFilter()
            intent?.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
            intent?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
        }

        fun <T, C : MutableCollection<WeakReference<T>>> C.reapCollection(): C {
            this.removeAll {
                it.get() == null
            }
            return this
        }

        fun loadGlideImage(mContext: Context,imageView: CircleImageView,name: String, imageUrl: String,isGroup: Boolean){
            val defaultImage = imageView.getDrawableForProfile(name)
            val options = RequestOptions().placeholder(imageView.drawable ?: defaultImage).error(defaultImage).priority(
                Priority.HIGH)
                .diskCacheStrategy(DiskCacheStrategy.ALL)
            if(imageUrl.isNotEmpty()){
                val imgURL = if (isValidURL(imageUrl)) imageUrl else Uri.parse(MediaUploadHelper.UPLOAD_ENDPOINT).buildUpon().appendPath(Uri.parse(imageUrl).lastPathSegment).build().toString()
                LogMessage.d("imgURL",imgURL)
                val requestBuilder = Glide.with(mContext).asDrawable().sizeMultiplier(0.1f)
                Glide.with(mContext).load(imgURL).thumbnail(requestBuilder).apply(options)
                    .listener(object : RequestListener<Drawable> {
                        override fun onLoadFailed(e: GlideException?, model: Any?, target: Target<Drawable>?,
                                                  isFirstResource: Boolean): Boolean {
                            LogMessage.e("onLoadFailed", e.toString())
                            return if (e?.message != null && e.message!!.contains("FileNotFoundException")) {
                                LogMessage.e("MediaUtils", e.message)
                                true
                            } else
                                false
                        }

                        override fun onResourceReady(resource: Drawable?, model: Any?, target: Target<Drawable>?,
                                                     dataSource: DataSource?, isFirstResource: Boolean): Boolean {
                            return false
                        }
                    }).dontAnimate().dontTransform().into(imageView)
            }else{
                Glide.with(mContext).load(if(!isGroup)defaultImage else R.drawable.ic_grp_bg).apply(options).into(imageView)
//            profileView.setDrawableForProfile(name)
            }
        }
        private fun isValidURL(url: String?):Boolean {
            // Regex to check valid URL
            val regex = ("((http|https)://)(www.)?"
                    + "[a-zA-Z0-9@:%._\\+~#?&//=]"
                    + "{2,256}\\.[a-z]"
                    + "{2,6}\\b([-a-zA-Z0-9@:%"
                    + "._\\+~#?&//=]*)")

            // Compile the ReGex
            val p = Pattern.compile(regex)

            // If the string is empty
            // return false
            if (url == null) {
                return false
            }

            // Find match between given string
            // and regular expression
            // using Pattern.matcher()
            val m: Matcher = p.matcher(url)

            // Return if the string
            // matched the ReGex
            return m.matches()
        }


        fun View.show() {
            let { visibility = View.VISIBLE }
        }

        fun View.hide() {
            let { visibility = View.INVISIBLE }
        }

        fun View.gone() {
            let { visibility = View.GONE }
        }
        fun makeViewsGone(vararg views: View) {
            views.map { it.gone() }
        }

        private fun getNameAndProfileDetails(jid: String): Pair<String, ProfileDetails?> {
            val profileDetails = ContactManager.getProfileDetails(jid)
            val name = if (profileDetails != null) {
                returnEmptyStringIfNull(profileDetails.getDisplayName())
            } else Utils.getFormattedPhoneNumber(ChatUtils.getUserFromJid(jid)) ?: Constants.EMPTY_STRING
            return Pair(name, profileDetails)
        }
        private fun getActualMemberName(stringBuilder: java.lang.StringBuilder): Pair<StringBuilder, Boolean> {
            return if (stringBuilder.length > Constants.MAX_NAME_LENGTH)
                Pair(
                    StringBuilder(stringBuilder.substring(0, Constants.MAX_NAME_LENGTH)).append("..."),
                    false
                )
            else
                Pair(stringBuilder, true)
        }

        private fun loadUserProfilePic(
            context: Context,
            callMember: CircleImageView,
            pair: Pair<String, ProfileDetails?>
        ) {
            if (pair.second != null) callMember.loadUserProfileImage(context, pair.second!!)
            else callMember.setImageDrawable(ContextCompat.getDrawable(context, R.drawable.profile_img))
        }
        fun setGroupMemberProfile(
            context: Context,
            callUsers: ArrayList<String>,
            imageCallMember1: CircleImageView,
            imageCallMember2: CircleImageView,
            imageCallMember3: CircleImageView,
            imageCallMember4: CircleImageView
        ): StringBuilder {
            makeViewsGone(imageCallMember2, imageCallMember3, imageCallMember4)
            var membersName = StringBuilder("")
            var isMaxMemberNameNotReached = true
            var spaceAvailable = true;
            for (i in callUsers.indices) {
                val pair = getNameAndProfileDetails(callUsers[i])
                LogMessage.d("pair",pair.first+" : "+pair.second?.toJsonString())
                /*if(i == 1){
                    imageCallMember2.show()
                    loadUserProfilePic(context, imageCallMember2, pair)
                }else if(i == 2){
                    imageCallMember3.show()
                    loadUserProfilePic(context, imageCallMember3, pair)
                }*/
                if (i == 0) {
                    val actualMemberName = getActualMemberName(StringBuilder(pair.first))
                    LogMessage.d("actualMemberName$i",actualMemberName.first.toString()+" : "+actualMemberName.second)
                    membersName = actualMemberName.first
                    isMaxMemberNameNotReached = actualMemberName.second
                    spaceAvailable = membersName.length < Constants.MAX_NAME_LENGTH;
                    imageCallMember1.show()
                    loadUserProfilePic(context, imageCallMember1, pair)
                } else if (spaceAvailable && isMaxMemberNameNotReached && i == 1) {
                    membersName.append(", ").append(pair.first)
                    val actualMemberName = getActualMemberName(membersName)
                    LogMessage.d("actualMemberName$i",actualMemberName.first.toString()+" : "+actualMemberName.second)
                    membersName = actualMemberName.first
                    isMaxMemberNameNotReached = actualMemberName.second
                    spaceAvailable = membersName.length < Constants.MAX_NAME_LENGTH;
                    imageCallMember2.show()
                    loadUserProfilePic(context, imageCallMember2, pair)
                } else if (spaceAvailable && isMaxMemberNameNotReached && i == 2) {
                    membersName.append(", ").append(pair.first)
                    val actualMemberName = getActualMemberName(membersName)
                    LogMessage.d("actualMemberName$i",actualMemberName.first.toString()+" : "+actualMemberName.second)
                    membersName = actualMemberName.first
                    spaceAvailable = membersName.length < Constants.MAX_NAME_LENGTH;
                    imageCallMember3.show()
                    loadUserProfilePic(context, imageCallMember3, pair)
                } else {
                    membersName.append(" (+").append(callUsers.size - i).append(")")
                    LogMessage.d("actualMemberName$i",membersName.toString())
                    imageCallMember4.show()
                    val text = "+${callUsers.size - i}"
                    val setDrawable = SetDrawable(context)
                    imageCallMember4.setImageDrawable(setDrawable.setDrawableForCustomName(text))
                    break
                }
            }
            return membersName
        }

        /**
         * Load local image with glide with [Drawable] as a placeholder.
         *
         * @param context  Instance of the context
         * @param imgUrl   image url
         * @param imgView  Image view to display the image
         * @param errorImg Display the drawable, if url return null
         */
        @JvmStatic
        fun loadImageWithGlide(context: Context, imgUrl: String?, imgView: ImageView, errorImg: Drawable?) {
            if (imgUrl != null && imgUrl.isNotEmpty()) {
                val options = RequestOptions().placeholder(imgView.drawable ?: errorImg)
                    .error(errorImg).diskCacheStrategy(DiskCacheStrategy.ALL).priority(Priority.HIGH)
                val requestBuilder = Glide.with(context).asDrawable().sizeMultiplier(0.1f)
                val imgURL = if (isValidURL(imgUrl)) imgUrl else Uri.parse(MediaUploadHelper.UPLOAD_ENDPOINT).buildUpon().appendPath(Uri.parse(imgUrl).lastPathSegment).build().toString()
                LogMessage.d("imgURL",imgURL)
                Glide.with(context).load(imgUrl).thumbnail(requestBuilder).apply(options)
                    .into(imgView)
            } else imgView.setImageDrawable(errorImg)
        }

        val tokenError = "Token refresh error"
        /**
         * Load image with [Drawable] as a placeholder.
         *
         * @param context  Instance of the context
         * @param imageUrl   image url
         * @param imageView  Image view to display the image
         * @param defaultImage Display the drawable, if url return null
         */
        fun loadImage(context: Context, imageUrl: String?, imageView: ImageView, defaultImage: Drawable?) {
            var options = RequestOptions().placeholder(imageView.drawable ?: defaultImage).error(defaultImage).priority(Priority.HIGH)
                .diskCacheStrategy(DiskCacheStrategy.ALL)
            if (imageUrl != null && imageUrl.isNotEmpty()) {
                val imgURL = if (isValidURL(imageUrl)) imageUrl else Uri.parse(MediaUploadHelper.UPLOAD_ENDPOINT).buildUpon().appendPath(Uri.parse(imageUrl).lastPathSegment).build().toString()
                LogMessage.d("imgURL",imgURL)
//                val imgURL = Uri.parse(MediaUploadHelper.UPLOAD_ENDPOINT).buildUpon().appendPath(Uri.parse(imageUrl).lastPathSegment).build().toString()
                val requestBuilder = Glide.with(context).asDrawable().sizeMultiplier(0.1f)
                Glide.with(context).load(imgURL).thumbnail(requestBuilder).apply(options)
                    .listener(object : RequestListener<Drawable> {
                        override fun onLoadFailed(e: GlideException?, model: Any?, target: Target<Drawable>?,
                                                  isFirstResource: Boolean): Boolean {
                            return if (e?.message != null && e.message!!.contains("FileNotFoundException")) {
                                LogMessage.e("MediaUtils", tokenError)
                                true
                            } else
                                false
                        }

                        override fun onResourceReady(resource: Drawable?, model: Any?, target: Target<Drawable>?,
                                                     dataSource: DataSource?, isFirstResource: Boolean): Boolean {
                            return false
                        }
                    }).dontAnimate().dontTransform().into(imageView)
            } else
                Glide.with(context).load(defaultImage).apply(options).into(imageView)
        }
    }
}