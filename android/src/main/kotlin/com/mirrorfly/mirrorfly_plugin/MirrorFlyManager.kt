package com.mirrorfly.mirrorfly_plugin

import android.app.Activity
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel

object MirrorFlyManager {
    lateinit var applicationContext: Context
    var instance: FlyChatPlugin? = null
    private var activity: Activity? = null
    var audioFileResult: MethodChannel.Result? = null
    private var activityBinding: ActivityPluginBinding? = null
    var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null

    fun init(context: Context) {
        applicationContext = context.applicationContext ?: context
    }

    fun getContext(): Context {
        return applicationContext
    }

    fun setPluginBinding(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.applicationContext = flutterPluginBinding.applicationContext
        this.flutterPluginBinding = flutterPluginBinding
    }

    fun setFlyChatInstance(instance: FlyChatPlugin) {
        this.instance = instance
    }

    fun getActivity(): Activity? {
        return activity
    }

    fun setActivityBinding(activityBinding: ActivityPluginBinding?) {
        this.activityBinding = activityBinding
        this.activity = activityBinding?.activity
    }

    fun setMethodResult(audioFileResult: MethodChannel.Result?) {
        this.audioFileResult = audioFileResult
    }
}