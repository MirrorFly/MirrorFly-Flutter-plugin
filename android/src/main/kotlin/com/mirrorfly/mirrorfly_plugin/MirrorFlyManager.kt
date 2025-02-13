package com.mirrorfly.mirrorfly_plugin

import android.app.Activity
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference

object MirrorFlyManager {
    private var applicationContextRef: WeakReference<Context>? = null
    private var activityRef: WeakReference<Activity>? = null
    private var instanceRef: WeakReference<FlyChatPlugin>? = null
    var audioFileResult: MethodChannel.Result? = null
    var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null

    fun init(context: Context) {
        applicationContextRef = WeakReference(context.applicationContext)
    }

    fun getContext(): Context {
        return applicationContextRef!!.get()!!
    }

    fun setPluginBinding(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContextRef = WeakReference(flutterPluginBinding.applicationContext)
        this.flutterPluginBinding = flutterPluginBinding
    }

    fun setFlyChatInstance(instance: FlyChatPlugin) {
        this.instanceRef = WeakReference(instance)
    }

    fun getFlyChatInstance(): FlyChatPlugin? {
        return instanceRef?.get()
    }

    fun getActivity(): Activity? {
        return activityRef?.get()
    }

    fun setActivityBinding(activityBinding: ActivityPluginBinding?) {
        activityBinding?.activity?.let {
            activityRef = WeakReference(it)
        }
    }

    fun setMethodResult(audioFileResult: MethodChannel.Result?) {
        this.audioFileResult = audioFileResult
    }
}