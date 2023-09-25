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
        val userJid = creationParams["userJid"] ?: ""
        val oldViewId = MirrorflyViewHashMap.getMirrorflyViewId(userJid.toString())
        val already = if(oldViewId!=null) oldViewId == id else false
        val view = builder.build(id,context,binaryMessenger,creationParams as Map<String, Any>,if(already) MirrorflyViewHashMap.getMirrorflyView(userJid.toString()) else null)
        LogMessage.d("#MirrorflyView Lifecycle", " create $already ${MirrorflyViewHashMap.getMirrorflyViewId(userJid.toString())} $id $userJid ${MirrorflyViewHashMap.getMirrorflyView(userJid.toString())} ${MirrorflyViewHashMap.getMirrorflyViewId(userJid.toString())}")
        MirrorflyViewHashMap.saveMirrorflyView(id,userJid.toString(),view)
        return view
    }
}