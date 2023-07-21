package com.mirrorfly.mirrorfly_plugin.call

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import com.mirrorfly.mirrorfly_plugin.AppUtils
import com.mirrorfly.mirrorfly_plugin.Constants
import com.mirrorfly.mirrorfly_plugin.FlyChatPlugin
import com.mirrorfly.mirrorfly_plugin.toJson
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import com.mirrorflysdk.flycommons.LogMessage
import org.json.JSONObject

class TransparentActivity : Activity() {

    companion object {
        fun getIntent(context: Context, action: String, data: Bundle?): Intent {
            val intent = Intent(context, TransparentActivity::class.java)
            intent.action = action
            intent.putExtra("data", data)
            intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION)
            intent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
            return intent
        }
    }


    override fun onStart() {
        super.onStart()
        setVisible(false)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        LogMessage.d("Transparent action", intent.action.toString())
//        val data = intent.getBundleExtra("data")

        /*val broadcastIntent = CallkitIncomingBroadcastReceiver.getIntent(this, intent.action!!, data)
        broadcastIntent.addFlags(Intent.FLAG_RECEIVER_FOREGROUND)
        sendBroadcast(broadcastIntent)*/
        if(intent.action == Constants.ACTION_CALL_INCOMING){

        }else {
            val json = JSONObject()
            json.put("callStatus", "Attended")
            json.put("userJid", CallManager.getCurrentUserId())
            json.put("callType", CallManager.getCallType())
            json.put("callMode", CallManager.getCallMode())

            val bundle = Bundle()
            bundle.putString("callStatus", "Attended")
            bundle.putString("userJid", CallManager.getCurrentUserId())
            bundle.putString("callType", CallManager.getCallType())
            bundle.putString("callMode", CallManager.getCallMode())
            LogMessage.d("Transparent", json.toString())
            LogMessage.d("Transparent action", intent.action.toString())
            FlyChatPlugin.sendEvent(intent.action.toString(), json)
            val activityIntent = AppUtils.getAppIntent(this, intent.action, bundle)
            startActivity(activityIntent)

            finish()
            overridePendingTransition(0, 0)
        }
    }
}