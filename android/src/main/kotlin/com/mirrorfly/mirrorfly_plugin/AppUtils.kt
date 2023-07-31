package com.mirrorfly.mirrorfly_plugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.gson.Gson

object AppUtils {

    const val AUDIO_PERMISSION_REQUEST_CODE = 100
    const val VIDEO_PERMISSION_REQUEST_CODE = 200
    const val CALL_REQUEST = 5
    fun getAppIntent(context: Context, action: String? = null, data: Bundle? = null): Intent? {
        val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)?.cloneFilter()
        intent?.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or Intent.FLAG_ACTIVITY_CLEAR_TOP)
//        intent?.putExtra(FlutterCallkitIncomingPlugin.EXTRA_CALLKIT_CALL_DATA, data)
        intent?.action = action
        return intent
    }
    fun askPermission(activity: Activity, permissions: Array<String>) {
        ActivityCompat.requestPermissions(
            activity,
            permissions,
            AUDIO_PERMISSION_REQUEST_CODE
        )
    }

    fun isPermissionAllowed(context: Context, permission: String): Boolean {
        return ContextCompat.checkSelfPermission(
            context,
            permission
        ) == PackageManager.PERMISSION_GRANTED
    }

}

fun Any.toJsonString(): String {
    return Gson().toJson(this).toString()
}

fun Any.toJson(): String {
    return Gson().toJson(this)
}