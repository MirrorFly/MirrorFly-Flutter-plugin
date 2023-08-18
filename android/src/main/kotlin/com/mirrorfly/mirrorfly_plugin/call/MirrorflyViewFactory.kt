package com.mirrorfly.mirrorfly_plugin.call

import android.content.Context
import com.mirrorflysdk.flycommons.LogMessage
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.BinaryMessenger

class MirrorflyViewFactory(private var binaryMessenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        val creationParams = args ?: hashMapOf<String?, Any?>()
        val builder = MirrorflyViewBuilder()
        creationParams as Map<String, Any>
        val viewId = creationParams["userJid"] ?: ""
        val view = builder.build(id,context,binaryMessenger,creationParams as Map<String, Any>,MirrorflyViewHashMap.getMirrorflyView(viewId.toString()))
        MirrorflyViewHashMap.saveMirrorflyView(id,viewId.toString(),view)
        LogMessage.d("#FlutterAndroidCall create", "${MirrorflyViewHashMap.getMirrorflyView(viewId.toString())} ${MirrorflyViewHashMap.getMirrorflyViewId(viewId.toString())}")
        return view
    }
}