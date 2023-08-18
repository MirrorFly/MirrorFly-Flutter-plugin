package com.mirrorfly.mirrorfly_plugin.call

import com.mirrorflysdk.flycommons.LogMessage

object MirrorflyViewHashMap {
    private val mirrorflyViews = HashMap<Int,MirrorflyView>()
    private val viewidsforJid = HashMap<String,Int>()

    fun saveMirrorflyView(key: Int,userJid:String, value: MirrorflyView) {
        mirrorflyViews[key] = value
        viewidsforJid[userJid] = key
        LogMessage.d("#FlutterAndroidCall #Hash","key : $key userJid : $userJid")
    }

    fun getMirrorflyView(userJid: String): MirrorflyView? {
        LogMessage.d("#FlutterAndroidCall #Hash","userJid : $userJid view : ${mirrorflyViews[getMirrorflyViewId(userJid)]}")
        return mirrorflyViews[viewidsforJid[userJid]]
    }

    fun getMirrorflyViewId(userJid:String):Int?{
        LogMessage.d("#FlutterAndroidCall #Hash","userJid : $userJid viewId : ${viewidsforJid[userJid]}")
        return viewidsforJid[userJid]
    }

    fun clearAll(){
        mirrorflyViews.clear()
        viewidsforJid.clear()
    }

}