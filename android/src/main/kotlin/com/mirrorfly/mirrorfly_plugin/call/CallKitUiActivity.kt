package com.mirrorfly.mirrorfly_plugin.call

import android.Manifest
import android.app.Activity
import android.app.PendingIntent
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.widget.ImageView
import android.widget.TextView
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.mirrorfly.mirrorfly_plugin.AppUtils
import com.mirrorfly.mirrorfly_plugin.Constants
import com.mirrorfly.mirrorfly_plugin.FlyChatPlugin
import com.mirrorfly.mirrorfly_plugin.R
import com.mirrorfly.mirrorfly_plugin.call.widgets.CircleImageView
import com.mirrorflysdk.api.FlyCore
import com.mirrorflysdk.api.contacts.ContactManager
import com.mirrorflysdk.flycall.call.utils.CallConstants
import com.mirrorflysdk.flycall.webrtc.CallAction
import com.mirrorflysdk.flycall.webrtc.CallDirection
import com.mirrorflysdk.flycall.webrtc.CallType
import com.mirrorflysdk.flycall.webrtc.api.CallActionListener
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import com.mirrorflysdk.flycommons.LogMessage
import org.json.JSONObject


class CallKitUiActivity : Activity(), CallUiFlutterListener {
    private val tag = "CallKitUiActivity"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_call_kit_ui)
        CallManager.configureCallActivity(this)
//        CallManager.setCallUiListener(this)
        FlutterCall.setListener(this)
        LogMessage.d("CallKitUiActivity", "onCreate")
        val userName = findViewById<TextView>(R.id.tvNameCaller)
        val userImage = findViewById<CircleImageView>(R.id.ivAvatar)
        val accept = findViewById<ImageView>(R.id.ivAcceptCall)
        accept.setOnClickListener { attendCall() }
        val decline = findViewById<ImageView>(R.id.ivDeclineCall)
        decline.setOnClickListener { declineCall() }

        if (CallManager.isOneToOneCall()) {
            val user = CallManager.getCallUsersList()[0]
            val name = ContactManager.getDisplayName(user)
            userName.text = name
            val profile = FlyCore.getUserProfile(user)
            Utils.loadGlideImage(this,userImage,name, profile?.image ?: "")
        }

        setUpCallDataAndUI()
    }
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        LogMessage.i(tag, "CALL_UI onNewIntent()")
        setUpCallDataAndUI()
    }

    private fun setUpCallDataAndUI(){
        LogMessage.d(tag,"FlyChatPlugin.hasInstance : ${FlyChatPlugin.hasInstance()}")
        LogMessage.d(tag,"isActivityBExists : ${isActivityBExists()}")
        LogMessage.d(tag,"FROM : ${intent.extras?.getString("FROM").toString()}")
        val acceptCall = intent.extras?.getBoolean(CallConstants.ACCEPT_CALL)
        LogMessage.d(tag,"${CallConstants.ACCEPT_CALL} : ${acceptCall.toString()}")
        if (acceptCall!=null && acceptCall){
            attendCall()
        }
    }

    private fun isActivityBExists(): Boolean {
       val intent = AppUtils.getAppIntent(this)//Intent()
//        intent?.component = ComponentName(this.packageName, activityBClassName)

        // Get the PackageManager
        val packageManager = packageManager

        // Check if the Activity B is found
        val resolveInfo = packageManager.resolveActivity(intent!!, PackageManager.MATCH_DEFAULT_ONLY)
        return resolveInfo != null
    }

    override fun onStart() {
        super.onStart()
        // Bind to the service. If the service is in foreground mode, this signals to the service
        // that since this activity is in the foreground, the service can exit foreground mode.
        // for showing call notification
        CallManager.bindCallService()
        checkPermission()
    }

    override fun onStop() {
        // Unbind from the service. This signals to the service that this activity is no longer
        // in the foreground, and the service can respond by promoting itself to a foreground
        // service.
        // for showing call notification
        CallManager.unbindCallService()
        super.onStop()
    }

    private fun checkPermission() {
        if (CallManager.getCallDirection() == CallDirection.INCOMING_CALL) {
            if (CallManager.getCallType() == CallType.AUDIO_CALL && !CallManager.isAudioCallPermissionsGranted(false)) {
                //ask Audio call Permission
                val permissionsToRequest = mutableListOf<String>()
                val recordPermissionGranted = AppUtils.isPermissionAllowed(this,Manifest.permission.RECORD_AUDIO)
                val bluetoothPermissionGranted = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    AppUtils.isPermissionAllowed(this,Manifest.permission.BLUETOOTH_CONNECT)
                } else {
                    true
                }
                val phoneStatePermissionGranted = AppUtils.isPermissionAllowed(this,Manifest.permission.READ_PHONE_STATE)
                if(!recordPermissionGranted){
                    permissionsToRequest.add(Manifest.permission.RECORD_AUDIO)
                }
                if(!phoneStatePermissionGranted){
                    permissionsToRequest.add(Manifest.permission.READ_PHONE_STATE)
                }
                if(!bluetoothPermissionGranted && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    permissionsToRequest.add(Manifest.permission.BLUETOOTH_CONNECT)
                }
                if(permissionsToRequest.isNotEmpty()) {
                    AppUtils.askPermission(this,permissionsToRequest.toTypedArray())
                }
            }else if (CallManager.getCallType() == CallType.VIDEO_CALL && !CallManager.isVideoCallPermissionsGranted(false)) {
                //ask Audio and Video call Permission
                val hasCameraPermission = AppUtils.isPermissionAllowed(this,Manifest.permission.CAMERA)
                val hasMicPermission = AppUtils.isPermissionAllowed(this,Manifest.permission.RECORD_AUDIO)
                val hasPhoneStatePermission = AppUtils.isPermissionAllowed(this,Manifest.permission.READ_PHONE_STATE)
                val hasBluetoothPermission = CallManager.isBluetoothPermissionsGranted()

                val permissionsToRequest = mutableListOf<String>()
                if (!hasCameraPermission) {
                    permissionsToRequest.add(Manifest.permission.CAMERA)
                }
                if (!hasMicPermission) {
                    permissionsToRequest.add(Manifest.permission.RECORD_AUDIO)
                }
                if (!hasPhoneStatePermission) {
                    permissionsToRequest.add(Manifest.permission.READ_PHONE_STATE)
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !hasBluetoothPermission) {
                    permissionsToRequest.add(Manifest.permission.BLUETOOTH_CONNECT)
                }
                if(permissionsToRequest.isNotEmpty()) {
                    AppUtils.askPermission(this,permissionsToRequest.toTypedArray())
                }
            }
        }
    }

    private fun attendCall() {
        if (CallManager.getCallType() == CallType.AUDIO_CALL && !CallManager.isAudioCallPermissionsGranted()) {
            return
        }
        if (CallManager.getCallType() == CallType.VIDEO_CALL && !CallManager.isVideoCallPermissionsGranted()) {
            return
        }
        Log.d("attendCall", "onclick")
        CallManager.answerCall(object : CallActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                if (isSuccess) {
                    /*val json = JSONObject()
            json.put("callAction", CallAction.ACTION_ANSWER_CALL)
            json.put("userJid", CallManager.getCallUsersList().joinToString(","))
            onCallActionStreamHandler.onCallAction?.success(json)*/
                    val json = JSONObject()
                    json.put("callStatus","Attended")
                    json.put("userJid",CallManager.getCurrentUserId())
                    json.put("callType",CallManager.getCallType())
                    json.put("callMode",CallManager.getCallMode())
                    onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(json.toString())
                    finishTask()
                    val intent = AppUtils.getAppIntent(this@CallKitUiActivity)
                    startActivity(intent)
                }
            }

        })
    }

    private fun declineCall() {
        CallManager.declineCall()
        finishTask()
    }

    private fun finishDelayed() {
        Handler(Looper.getMainLooper()).postDelayed({
            finishTask()
        }, 1000)
    }

    private fun finishTask() {
        Log.d("disconnect", "finishTask")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            finishAndRemoveTask()
        } else {
            finish()
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
//        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            AppUtils.AUDIO_PERMISSION_REQUEST_CODE -> if (grantResults.isNotEmpty()) {
                val permissionsToRequest = mutableListOf<String>()
                val recordPermissionGranted = AppUtils.isPermissionAllowed(this,Manifest.permission.RECORD_AUDIO)
                val bluetoothPermissionGranted = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    AppUtils.isPermissionAllowed(this,Manifest.permission.BLUETOOTH_CONNECT)
                } else {
                    true
                }
                val phoneStatePermissionGranted = AppUtils.isPermissionAllowed(this,Manifest.permission.READ_PHONE_STATE)
                if(!recordPermissionGranted){
                    permissionsToRequest.add(Manifest.permission.RECORD_AUDIO)
                }
                if(!phoneStatePermissionGranted){
                    permissionsToRequest.add(Manifest.permission.READ_PHONE_STATE)
                }
                if(!bluetoothPermissionGranted && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    permissionsToRequest.add(Manifest.permission.BLUETOOTH_CONNECT)
                }
                if(permissionsToRequest.isNotEmpty()) {
                    AppUtils.askPermission(this,permissionsToRequest.toTypedArray())
                }
            }
            AppUtils.VIDEO_PERMISSION_REQUEST_CODE -> if (grantResults.isNotEmpty()){
                val hasCameraPermission = AppUtils.isPermissionAllowed(this,Manifest.permission.CAMERA)
                val hasMicPermission = AppUtils.isPermissionAllowed(this,Manifest.permission.RECORD_AUDIO)
                val hasPhoneStatePermission = AppUtils.isPermissionAllowed(this,Manifest.permission.READ_PHONE_STATE)
                val hasBluetoothPermission = CallManager.isBluetoothPermissionsGranted()

                val permissionsToRequest = mutableListOf<String>()
                if (!hasCameraPermission) {
                    permissionsToRequest.add(Manifest.permission.CAMERA)
                }
                if (!hasMicPermission) {
                    permissionsToRequest.add(Manifest.permission.RECORD_AUDIO)
                }
                if (!hasPhoneStatePermission) {
                    permissionsToRequest.add(Manifest.permission.READ_PHONE_STATE)
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !hasBluetoothPermission) {
                    permissionsToRequest.add(Manifest.permission.BLUETOOTH_CONNECT)
                }
                if (!hasCameraPermission || !hasMicPermission)
                    CallManager.sendCallPermissionDenied()
                else
                    CallManager.startVideoCapture()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            AppUtils.CALL_REQUEST -> {
                attendCall()
                LogMessage.d(tag,"onActivityResult $data")
            }
        }
    }

//    override fun onShowCallUi(callAction: String?) {
    override fun onShowCallUiFlutter(callAction: String?) {
        LogMessage.d(tag, "#onShowCallUi $callAction")
        when(callAction){
            CallConstants.ACTION_SHOW_CALL_UI->{}
            CallConstants.ACTION_INVITE_CALL_MESSAGE_RECEIVED->{}
            CallConstants.ACTION_MEDIA_CALL_MESSAGE_RECEIVED->{}
            CallConstants.ACTION_START_VIDEO_CAPTURE->{}
            CallAction.ACTION_INVITE_USERS->{}
            CallAction.ACTION_ANSWER_CALL->{

            }
            CallAction.ACTION_DENY_CALL->{}
            CallAction.ACTION_LOCAL_HANGUP->{}
            CallAction.ACTION_REMOTE_HANGUP->{
                if(CallManager.isOneToOneCall()){
                    CallManager.disconnectCall()
                    finish()
                }
            }
            CallAction.ACTION_REMOTE_OTHER_BUSY->{}
            CallAction.ACTION_REMOTE_BUSY->{}
            CallAction.ACTION_REMOTE_ENGAGED->{}
            CallAction.ACTION_CALL_AGAIN->{}
            CallAction.ACTION_CANCEL_CALL_AGAIN->{}
            CallAction.ACTION_SWITCH_CAMERA->{}
            CallAction.ACTION_REMOTE_VIDEO_STATUS->{}
            CallAction.CHANGE_TO_AUDIO_CALL->{}
            CallAction.ACTION_VIDEO_CALL_CANCEL_CONVERSION->{}
            CallAction.ACTION_VIDEO_CALL_CONVERSION_ACCEPTED->{}
            CallAction.ACTION_VIDEO_CALL_CONVERSION_REJECTED->{}
            CallAction.ACTION_REMOTE_VIDEO_ADDED->{}
            CallAction.ACTION_AUDIO_DEVICE_CHANGED->{}
            CallAction.ACTION_CAMERA_SWITCH_SUCCESS->{}
            CallAction.ACTION_CAMERA_SWITCH_FAILURE->{}
            CallAction.ACTION_PERMISSION_DENIED->{}
            CallAction.CALL_REQUEST_RESPONSE->{}
            CallAction.USER_SPEAKING->{}
            CallAction.USER_STOPPED_SPEAKING->{}
            CallAction.ACTION_MAKE_SERVER_CONNECTION->{}
            CallAction.ACTION_CLOSE_SERVER_CONNECTION->{}
        }
    }

    /*override fun onShowCallUiFlutter(callAction: String?) {
        TODO("Not yet implemented")
    }*/
}
