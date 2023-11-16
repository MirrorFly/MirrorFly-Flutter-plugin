package com.mirrorfly.mirrorfly_plugin.call.widgets

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapShader
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.ColorFilter
import android.graphics.Matrix
import android.graphics.Outline
import android.graphics.Paint
import android.graphics.Rect
import android.graphics.RectF
import android.graphics.Shader
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.util.AttributeSet
import android.util.Log
import android.view.View
import android.view.ViewOutlineProvider
import androidx.annotation.ColorInt
import androidx.annotation.DrawableRes
import androidx.annotation.RequiresApi
import androidx.appcompat.widget.AppCompatImageView
import androidx.core.content.ContextCompat
import com.mirrorfly.mirrorfly_plugin.R
import com.mirrorflysdk.api.ChatManager
import com.mirrorflysdk.flycommons.Constants
import com.mirrorflysdk.flycommons.LogMessage
import java.util.ArrayList
import java.util.regex.Pattern
import kotlin.math.abs

class CircleImageView : AppCompatImageView {
    private val mDrawableRect = RectF()
    private val mBorderRect = RectF()
    private val mShaderMatrix = Matrix()
    private val mBitmapPaint = Paint()
    private val mBorderPaint = Paint()
    private val mCircleBackgroundPaint = Paint()
    private var mBorderColor = DEFAULT_BORDER_COLOR
    private var mBorderWidth = DEFAULT_BORDER_WIDTH
    private var mBitmap: Bitmap? = null
    private var mBitmapShader: BitmapShader? = null
    private var mBitmapWidth = 0
    private var mBitmapHeight = 0
    private var mDrawableRadius = 0f
    private var mBorderRadius = 0f
    private var mColorFilter: ColorFilter? = null
    private var mReady = false
    private var mSetupPending = false
    private var shape: Shape? = null
    private val userList = ArrayList<String>()
    private var context1: Context

    private val emojiPattern: Pattern = Pattern.compile("^[\\s\n\r]*(?:(?:[\u00a9\u00ae\u203c\u2049\u2122\u2139\u2194-\u2199\u21a9-\u21aa\u231a-\u231b\u2328\u23cf\u23e9-\u23f3\u23f8-" +
            "\u23fa\u24c2\u25aa-\u25ab\u25b6\u25c0\u25fb-\u25fe\u2600-\u2604\u260e\u2611\u2614-\u2615\u2618\u261d\u2620\u2622-\u2623\u2626\u262a\u262e-\u262f\u2638-\u263a\u2648-" +
            "\u2653\u2660\u2663\u2665-\u2666\u2668\u267b\u267f\u2692-\u2694\u2696-\u2697\u2699\u269b-\u269c\u26a0-\u26a1\u26aa-\u26ab\u26b0-\u26b1\u26bd-\u26be\u26c4-" +
            "\u26c5\u26c8\u26ce-\u26cf\u26d1\u26d3-\u26d4\u26e9-\u26ea\u26f0-\u26f5\u26f7-\u26fa\u26fd\u2702\u2705\u2708-\u270d\u270f\u2712\u2714\u2716\u271d\u2721\u2728\u2733-" +
            "\u2734\u2744\u2747\u274c\u274e\u2753-\u2755\u2757\u2763-\u2764\u2795-\u2797\u27a1\u27b0\u27bf\u2934-\u2935\u2b05-\u2b07\u2b1b-" +
            "\u2b1c\u2b50\u2b55\u3030\u303d\u3297\u3299\ud83c\udc04\ud83c\udccf\ud83c\udd70-\ud83c\udd71\ud83c\udd7e-\ud83c\udd7f\ud83c\udd8e\ud83c\udd91-\ud83c\udd9a\ud83c\ude01-" +
            "\ud83c\ude02\ud83c\ude1a\ud83c\ude2f\ud83c\ude32-\ud83c\ude3a\ud83c\ude50-\ud83c\ude51\u200d\ud83c\udf00-\ud83d\uddff\ud83d\ude00-\ud83d\ude4f\ud83d\ude80-" +
            "\ud83d\udeff\ud83e\udd00-\ud83e\uddff\udb40\udc20-\udb40\udc7f]|\u200d[\u2640\u2642]|[\ud83c\udde6-\ud83c\uddff]{2}|.[\u20e0\u20e3\ufe0f]+)+[\\s\n\r]*)+$")


    /**
     * Instantiates a new circular image view.
     *
     * @param context the startupActivityContext
     */
    constructor(context: Context) : super(context) {
        this.context1 = context
        init()
    }

    /**
     * Instantiates a new circular image view.
     *
     * @param context the startupActivityContext
     * @param attrs   the attrs
     */
    constructor(context: Context, attrs: AttributeSet?) : this(context, attrs, 0) {
        this.context1 = context
    }

    /**
     * Instantiates a new circular image view.
     *
     * @param context  the startupActivityContext
     * @param attrs    the attrs
     * @param defStyle the def style
     */
    constructor(context: Context, attrs: AttributeSet?, defStyle: Int) : super(context, attrs, defStyle) {
        this.context1 = context
        val attributes = context.obtainStyledAttributes(attrs,
            R.styleable.CircularImageView, defStyle, 0)
        if (attributes.getBoolean(R.styleable.CircularImageView_border, true)) {
            borderWidth = attributes.getDimensionPixelOffset(R.styleable.CircularImageView_border_width, 0)
            setBorderColor(attributes.getColor(R.styleable.CircularImageView_border_color, Color.WHITE))
        }
        mBorderWidth = attributes.getDimensionPixelSize(R.styleable.CircularImageView_border_width,
            DEFAULT_BORDER_WIDTH)
        mBorderColor = attributes.getColor(R.styleable.CircularImageView_border_color, Color.WHITE)
        shape = if (attributes.getBoolean(R.styleable.CircularImageView_is_circle, true)) Shape.CIRCLE else Shape.RECTANGLE
        attributes.recycle()
        init()
    }

    /**
     * method to initialize view
     */
    private fun init() {
        super.setScaleType(SCALE_TYPE)
        mReady = true
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            outlineProvider = OutlineProvider()
        }
        if (mSetupPending) {
            setup()
            mSetupPending = false
        }
        borderWidth = 1
        setBorderColor(Color.LTGRAY)
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
//        if (shape == Shape.RECTANGLE) refresh()
    }

    /**
     * recreate CustomMultiDrawable and set it as Bitmaps to ImageView
     */
    /*private fun refresh() {
        val customDrawable: Drawable = CustomMultiDrawable(userList, context1)
        setImageDrawable(customDrawable)
    }*/

    /**
     * Remove all previous bitmaps
     */
    fun clear() {
        userList.clear()
//        refresh()
    }

    /**
     * to get scale type of an image
     *
     * @return the [ScaleType]
     */
    override fun getScaleType(): ScaleType {
        return SCALE_TYPE
    }

    /**
     * Set scale type of an image
     *
     * @param scaleType enum to set
     */
    override fun setScaleType(scaleType: ScaleType) {
        require(scaleType == SCALE_TYPE) { String.format("ScaleType %s not supported.", scaleType) }
    }

    /**
     * Set this to true if you want the ImageView to adjust its bounds
     * to preserve the aspect ratio of its drawable.
     *
     * @param adjustViewBounds Whether to adjust the bounds of this view
     * to preserve the original aspect ratio of the drawable.
     */
    override fun setAdjustViewBounds(adjustViewBounds: Boolean) {
        require(!adjustViewBounds) { "adjustViewBounds not supported." }
    }

    /**
     * Implement this to do your drawing.
     *
     * @param canvas the canvas on which the background will be drawn
     */
    override fun onDraw(canvas: Canvas) {
        try {
            if (shape == Shape.RECTANGLE) {
                if (drawable != null) {
                    super.onDraw(canvas)
                }
            } else {
                if (mBitmap == null) {
                    return
                }
                canvas.drawCircle(mDrawableRect.centerX(), mDrawableRect.centerY(), mDrawableRadius, mBitmapPaint)
                if (mBorderWidth > 0) {
                    canvas.drawCircle(mBorderRect.centerX(), mBorderRect.centerY(), mBorderRadius, mBorderPaint)
                }
            }
        } catch (e: Exception) {
            Log.i("CircleImageView", "Catch Canvas: trying to use a recycled bitmap")
        }
    }

    override fun onSizeChanged(w: Int, h: Int, oldw: Int, oldh: Int) {
        super.onSizeChanged(w, h, oldw, oldh)
        if (shape != Shape.RECTANGLE) setup()
    }

    override fun setPadding(left: Int, top: Int, right: Int, bottom: Int) {
        super.setPadding(left, top, right, bottom)
        if (shape != Shape.RECTANGLE) setup()
    }

    override fun setPaddingRelative(start: Int, top: Int, end: Int, bottom: Int) {
        super.setPaddingRelative(start, top, end, bottom)
        if (shape != Shape.RECTANGLE) setup()
    }

    private fun setBorderColor(@ColorInt borderColor: Int) {
        if (borderColor == mBorderColor) {
            return
        }
        mBorderColor = borderColor
        mBorderPaint.color = mBorderColor
        invalidate()
    }

    var borderWidth: Int
        get() = mBorderWidth
        private set(borderWidth) {
            if (borderWidth == mBorderWidth) {
                return
            }
            mBorderWidth = borderWidth
            setup()
        }

    override fun setImageBitmap(bm: Bitmap) {
        super.setImageBitmap(bm)
        if (shape != Shape.RECTANGLE) initializeBitmap()
    }

    override fun setImageDrawable(drawable: Drawable?) {
        super.setImageDrawable(drawable)
        if (shape != Shape.RECTANGLE) initializeBitmap()
    }

    override fun setImageResource(@DrawableRes resId: Int) {
        super.setImageResource(resId)
        if (shape != Shape.RECTANGLE) initializeBitmap()
    }

    override fun setImageURI(uri: Uri?) {
        super.setImageURI(uri)
        if (shape != Shape.RECTANGLE) initializeBitmap()
    }

    override fun getColorFilter(): ColorFilter {
        return mColorFilter!!
    }

    override fun setColorFilter(cf: ColorFilter) {
        if (cf === mColorFilter) {
            return
        }
        mColorFilter = cf
        applyColorFilter()
        invalidate()
    }

    private fun applyColorFilter() {
        mBitmapPaint.colorFilter = mColorFilter
    }

    private fun getBitmapFromDrawable(drawable: Drawable?): Bitmap? {
        if (drawable == null) {
            return null
        }
        return if (drawable is BitmapDrawable) {
            drawable.bitmap
        } else try {
            val bitmap: Bitmap
            bitmap = if (drawable is ColorDrawable) {
                Bitmap.createBitmap(COLORDRAWABLE_DIMENSION, COLORDRAWABLE_DIMENSION, BITMAP_CONFIG)
            } else {
                Bitmap.createBitmap(drawable.intrinsicWidth,
                    drawable.intrinsicHeight, BITMAP_CONFIG)
            }
            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            bitmap
        } catch (e: Exception) {
            Log.e("CircleImageView",e.toString())
            null
        }
    }

    fun setDrawableForProfile(name: String?){
        val drawable = getDrawableForProfile(name)
        super.setImageDrawable(drawable)
        if (shape != Shape.RECTANGLE) initializeBitmap()
    }
    fun getDrawableForProfile(name: String?): Drawable {
        var nameValue = name
        val icon = CustomDrawable(context!!)
        if (nameValue.isNullOrBlank()) {
            //default
            icon.setDrawableColour(R.color.colorSecondary)
            icon.setText("")
            return icon
        }
        nameValue = nameValue.trim { it <= ' ' }
        val initialName = nameValue.split("\\s+".toRegex()).toTypedArray()
        LogMessage.d("initialName",initialName.toString())
        return if (initialName.size == 1) {
            val username = initialName[0].trim { it <= ' ' }
            when {
                username.isEmpty() -> {
                    icon.setDrawableColour(R.color.colorSecondary)
                    icon.setText("")
                    icon
                }
                username.length == 1 -> {
                    icon.setText(username.uppercase())
                    icon.setDrawableProfileColour(username.uppercase().getColourCode())
                    icon
                }
                else -> {
                    icon.setText(getProfileNameIcon(username))
                    icon.setDrawableProfileColour(getProfileNameIcon(username).getColourCode())
                    icon
                }
            }
        } else {
            var firstletter = ""
            if (initialName[0].trim { it <= ' ' }.isNotEmpty()) {
                firstletter = String(Character.toChars(initialName[0].trim { it <= ' ' }.codePointAt(0)))
            }
            var secondletter = ""
            if (initialName[1].trim { it <= ' ' }.isNotEmpty()) {
                secondletter = String(Character.toChars(initialName[1].trim { it <= ' ' }.codePointAt(0)))
            }
            val nm = firstletter.uppercase() + secondletter.uppercase()
            icon.setText(nm)
            icon.setDrawableProfileColour(nm.getColourCode())
            icon
        }
    }
    private fun String?.getColourCode(): Int {
        if (this != null && this == Constants.YOU)
            return ContextCompat.getColor(ChatManager.applicationContext, R.color.color_black)

        val colorsArray = ChatManager.applicationContext.resources.getIntArray(R.array.colour_code)
        val hashcode = this.hashCode()
        val rand = hashcode % colorsArray.size
        return colorsArray[abs(rand)]
    }

    private fun isEmojiOnly(string: String): Boolean? {
        return emojiPattern.matcher(string).find()
    }
    private fun getProfileNameIcon(username: String): String {
        var profileLetters = username.substring(0, 2)
        LogMessage.d("profileLetters ",profileLetters)
        if (isEmojiOnly(profileLetters) == true) {
            profileLetters = if (isEmojiOnly(username.substring(0, 4)) == true) username.substring(0, 4) else username.substring(0, 3)
        }
        return profileLetters.toUpperCase()
    }

    private fun initializeBitmap() {
        mBitmap = getBitmapFromDrawable(drawable)
        setup()
    }

    private fun setup() {
        if (!mReady) {
            mSetupPending = true
            return
        }
        if (width == 0 && height == 0) {
            return
        }
        if (mBitmap == null) {
            invalidate()
            return
        }
        mBitmapShader = BitmapShader(mBitmap!!, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP)
        mBitmapPaint.isAntiAlias = true
        mBitmapPaint.shader = mBitmapShader
        mBorderPaint.style = Paint.Style.STROKE
        mBorderPaint.isAntiAlias = true
        mBorderPaint.color = mBorderColor
        mBorderPaint.strokeWidth = mBorderWidth.toFloat()
        mCircleBackgroundPaint.style = Paint.Style.FILL
        mCircleBackgroundPaint.isAntiAlias = true
        mBitmapHeight = mBitmap!!.height
        mBitmapWidth = mBitmap!!.width
        mBorderRect.set(calculateBounds())
        mBorderRadius = Math.min((mBorderRect.height() - mBorderWidth) / 2.0f,
            (mBorderRect.width() - mBorderWidth) / 2.0f)
        mDrawableRect.set(mBorderRect)
        mDrawableRadius = Math.min(mDrawableRect.height() / 2.0f, mDrawableRect.width() / 2.0f)
        applyColorFilter()
        updateShaderMatrix()
        invalidate()
    }

    private fun calculateBounds(): RectF {
        val availableWidth = width - paddingLeft - paddingRight
        val availableHeight = height - paddingTop - paddingBottom
        val sideLength = Math.min(availableWidth, availableHeight)
        val left = paddingLeft + (availableWidth - sideLength) / 2f
        val top = paddingTop + (availableHeight - sideLength) / 2f
        return RectF(left, top, left + sideLength, top + sideLength)
    }

    private fun updateShaderMatrix() {
        val scale: Float
        var dx = 0f
        var dy = 0f
        mShaderMatrix.set(null)
        if (mBitmapWidth * mDrawableRect.height() > mDrawableRect.width() * mBitmapHeight) {
            scale = mDrawableRect.height() / mBitmapHeight.toFloat()
            dx = (mDrawableRect.width() - mBitmapWidth * scale) * 0.5f
        } else {
            scale = mDrawableRect.width() / mBitmapWidth.toFloat()
            dy = (mDrawableRect.height() - mBitmapHeight * scale) * 0.5f
        }
        mShaderMatrix.setScale(scale, scale)
        mShaderMatrix.postTranslate((dx + 0.5f).toInt() + mDrawableRect.left, (dy + 0.5f).toInt() + mDrawableRect.top)
        mBitmapShader!!.setLocalMatrix(mShaderMatrix)
    }

    fun addImage(userList: ArrayList<String>?) {
        this.userList.clear()
        this.userList.addAll(userList!!.filter { it.isNotEmpty() })
//        refresh()
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    private inner class OutlineProvider : ViewOutlineProvider() {
        override fun getOutline(view: View, outline: Outline) {
            val bounds = Rect()
            mBorderRect.roundOut(bounds)
            outline.setRoundRect(bounds, bounds.width() / 2.0f)
        }
    }

    /**
     * Enum for CircleImageView Shape
     */
    enum class Shape {
        CIRCLE, RECTANGLE, NONE
    }

    companion object {
        private val SCALE_TYPE = ScaleType.CENTER_CROP
        private val BITMAP_CONFIG = Bitmap.Config.ARGB_8888
        private const val COLORDRAWABLE_DIMENSION = 2
        private const val DEFAULT_BORDER_WIDTH = 0
        private const val DEFAULT_BORDER_COLOR = Color.BLACK
    }
}