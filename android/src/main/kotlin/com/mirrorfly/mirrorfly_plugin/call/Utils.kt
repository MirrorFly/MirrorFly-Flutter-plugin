package com.mirrorfly.mirrorfly_plugin.call

import android.content.Context
import android.content.Intent
import android.content.res.Resources
import android.graphics.drawable.Drawable
import android.net.Uri
import android.view.View
import com.bumptech.glide.Glide
import com.bumptech.glide.Priority
import com.bumptech.glide.load.DataSource
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.load.engine.GlideException
import com.bumptech.glide.request.RequestListener
import com.bumptech.glide.request.RequestOptions
import com.bumptech.glide.request.target.Target
import com.mirrorfly.mirrorfly_plugin.call.widgets.CircleImageView
import com.mirrorflysdk.flycommons.LogMessage
import com.mirrorflysdk.media.MediaUploadHelper
import java.lang.ref.WeakReference


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

        fun loadGlideImage(mContext: Context,imageView: CircleImageView,name: String, imageUrl: String){
            val defaultImage = imageView.getDrawableForProfile(name)
            val options = RequestOptions().placeholder(imageView.drawable ?: defaultImage).error(defaultImage).priority(
                Priority.HIGH)
                .diskCacheStrategy(DiskCacheStrategy.ALL)
            if(imageUrl.isNotEmpty()){
                val url = Regex("r\"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\\-\\.]+\\.[a-zA-Z]{2,6}(\\:[0-9]{1,5})*(/(\$|[a-zA-Z0-9\\.\\,\\;\\?\\'\\\\\\+&amp;%\\\$#\\=~_\\-]+))*\$\"")
                val imgURL = if (imageUrl.matches(url)) imageUrl else Uri.parse(MediaUploadHelper.UPLOAD_ENDPOINT).buildUpon().appendPath(Uri.parse(imageUrl).lastPathSegment).build().toString()
                LogMessage.d("imgURL",imgURL)
                val requestBuilder = Glide.with(mContext).asDrawable().sizeMultiplier(0.1f)
                Glide.with(mContext).load(imgURL).thumbnail(requestBuilder).apply(options)
                    .listener(object : RequestListener<Drawable> {
                        override fun onLoadFailed(e: GlideException?, model: Any?, target: Target<Drawable>?,
                                                  isFirstResource: Boolean): Boolean {
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
                Glide.with(mContext).load(defaultImage).apply(options).into(imageView)
//            profileView.setDrawableForProfile(name)
            }
        }
    }
}