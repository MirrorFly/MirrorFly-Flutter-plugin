package com.mirrorfly.mirrorfly_plugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.view.View
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.android.material.snackbar.Snackbar
import com.google.gson.Gson
import android.provider.Settings
import android.net.Uri
import android.util.Log
import com.mirrorflysdk.flycommons.LogMessage


object AppUtils {

    const val AUDIO_PERMISSION_REQUEST_CODE = 100
    const val VIDEO_PERMISSION_REQUEST_CODE = 200
    const val CALL_REQUEST = 5
    fun getAppIntent(context: Context, action: String? = null, data: Bundle? = null): Intent? {
        val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)?.cloneFilter()
        intent?.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT or Intent.FLAG_ACTIVITY_CLEAR_TOP)
//        intent?.putExtra(FlutterCallkitIncomingPlugin.EXTRA_CALLKIT_CALL_DATA, data)
        intent?.action = action
        return intent
    }
    fun showPermissionSnackBar(activity: Activity, view: View, message: String, permissions: Array<String>? = null) {
        val snackBar = Snackbar.make(
            view,
            message,
            Snackbar.LENGTH_INDEFINITE
        )

        if (permissions != null) {
            val deniedPermissions = permissions.filter {
                isPermissionAllowed(activity, it) == PermissionStatus.DENIED
            }

            val permanentlyDeniedPermissions = permissions.filter {
                isPermissionAllowed(activity, it) == PermissionStatus.PERMANENTLY_DENIED
            }

            LogMessage.d("showPermissionSnackBar", "permanentlyDeniedPermissions $permanentlyDeniedPermissions deniedPermissions $deniedPermissions")
            if (permanentlyDeniedPermissions.isNotEmpty()) {
                snackBar.setAction("OK") {
                    snackBar.dismiss()
                    openAppSettings(activity)
                }
            }else if (deniedPermissions.isNotEmpty()) {
                snackBar.setAction("OK") {
                    snackBar.dismiss()
                    askPermission(activity, deniedPermissions.toTypedArray())
                }
            }
        }

        snackBar.show()
    }

    fun openAppSettings(activity: Activity) {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
        val uri: Uri = Uri.fromParts("package", activity.packageName, null)
        intent.data = uri
        activity.startActivity(intent)
    }

    fun askPermission(activity: Activity, permissions: Array<String>) {
        ActivityCompat.requestPermissions(
            activity,
            permissions,
            AUDIO_PERMISSION_REQUEST_CODE
        )
    }

//    fun isPermissionAllowed(context: Context, permission: String): Boolean {
//        return ContextCompat.checkSelfPermission(
//            context,
//            permission
//        ) == PackageManager.PERMISSION_GRANTED
//    }

    private fun isPermissionAllowed(context: Context, permission: String): PermissionStatus {
        val permissionStatus = ContextCompat.checkSelfPermission(context, permission)
        val shouldShowRationale = ActivityCompat.shouldShowRequestPermissionRationale(context as Activity, permission)

        Log.d("isPermissionAllowed", "$permission--->$permissionStatus shouldShowRationale $shouldShowRationale")
        return when {
            permissionStatus == PackageManager.PERMISSION_GRANTED -> PermissionStatus.GRANTED
            shouldShowRationale || permissionStatus == PackageManager.PERMISSION_DENIED -> PermissionStatus.DENIED
            else -> PermissionStatus.PERMANENTLY_DENIED
        }
    }

    fun checkAndAddPermissions(context: Context, permissions: List<String>): Pair<List<String>, List<String>> {
        val deniedPermissions = mutableListOf<String>()
        val permanentlyDeniedPermissions = mutableListOf<String>()

        for (permission in permissions) {
            when (isPermissionAllowed(context, permission)) {
                PermissionStatus.DENIED -> deniedPermissions.add(permission)
                PermissionStatus.PERMANENTLY_DENIED -> permanentlyDeniedPermissions.add(permission)
                else -> Unit // Permission is granted or has no action needed
            }
        }


        return Pair(deniedPermissions, permanentlyDeniedPermissions)
    }

    enum class PermissionStatus {
        GRANTED,
        DENIED,
        PERMANENTLY_DENIED
    }


}

fun Any.toJsonString(): String {
    return Gson().toJson(this).toString()
}

fun Any.toJson(): String {
    return Gson().toJson(this)
}