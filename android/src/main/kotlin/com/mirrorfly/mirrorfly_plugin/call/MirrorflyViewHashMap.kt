package com.mirrorfly.mirrorfly_plugin.call

import com.mirrorflysdk.flycommons.LogMessage

object MirrorflyViewHashMap {
    private val mirrorflyViews = HashMap<Int,MirrorflyView>()
    private val viewidsforJid = HashMap<String,Int>()

    fun saveMirrorflyView(key: Int,userJid:String, value: MirrorflyView) {
        LogMessage.d("#MirrorflyView Lifecycle","save old ${getMirrorflyViewId(userJid)} new $key")
        mirrorflyViews[key] = value
        viewidsforJid[userJid] = key
        LogMessage.d("#MirrorflyView #Hash","key : $key userJid : $userJid")
    }

    fun getMirrorflyView(userJid: String): MirrorflyView? {
        LogMessage.d("#MirrorflyView #Hash","userJid : $userJid view : ${mirrorflyViews[getMirrorflyViewId(userJid)]}")
        return mirrorflyViews[viewidsforJid[userJid]]
    }

    fun getMirrorflyViewId(userJid:String):Int?{
        LogMessage.d("#MirrorflyView #Hash","userJid : $userJid viewId : ${viewidsforJid[userJid]}")
        return viewidsforJid[userJid]
    }

    fun remove(id:Int,userJid:String){
        mirrorflyViews.remove(id)
        viewidsforJid.remove(userJid)
        LogMessage.d("#MirrorflyView #Hash","removed $mirrorflyViews $viewidsforJid")
    }

    fun clearAll(){
        mirrorflyViews.clear()
        viewidsforJid.clear()
        LogMessage.d("#MirrorflyView #Hash","clearAll $mirrorflyViews $viewidsforJid")
    }

}