package com.mirrorfly.mirrorfly_plugin

import android.content.Context
import android.content.Intent
import android.os.Bundle
import com.google.gson.Gson

object AppUtils {
    fun getAppIntent(context: Context, action: String? = null, data: Bundle? = null): Intent? {
        val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)?.cloneFilter()
        intent?.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or Intent.FLAG_ACTIVITY_CLEAR_TOP)
//        intent?.putExtra(FlutterCallkitIncomingPlugin.EXTRA_CALLKIT_CALL_DATA, data)
        intent?.action = action
        return intent
    }
}

fun Any.toJsonString(): String {
    return Gson().toJson(this).toString()
}

fun Any.toJson(): String {
    return Gson().toJson(this)
}