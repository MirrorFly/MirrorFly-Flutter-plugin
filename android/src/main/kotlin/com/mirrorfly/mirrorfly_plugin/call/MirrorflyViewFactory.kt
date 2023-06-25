package com.mirrorfly.mirrorfly_plugin.call

import android.content.Context
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.BinaryMessenger

class MirrorflyViewFactory(private var binaryMessenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    val mirrorflyViews = HashMap<String,MirrorflyView>()
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        val creationParams = args ?: hashMapOf<String?, Any?>()
        val builder = MirrorflyViewBuilder()
        val view = builder.build(id,context,binaryMessenger,creationParams as Map<String, Any>)
        val viewId = creationParams["viewId"] ?: ""
        mirrorflyViews[viewId.toString()]=view
        return view
    }
}