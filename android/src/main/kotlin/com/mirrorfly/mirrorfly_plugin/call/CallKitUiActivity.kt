package com.mirrorfly.mirrorfly_plugin.call

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.core.app.ActivityCompat
import com.mirrorfly.mirrorfly_plugin.AppUtils
import com.mirrorfly.mirrorfly_plugin.AppUtils.checkAndAddPermissions
import com.mirrorfly.mirrorfly_plugin.Constants
import com.mirrorfly.mirrorfly_plugin.FlyChatPlugin
import com.mirrorfly.mirrorfly_plugin.R
import com.mirrorfly.mirrorfly_plugin.call.widgets.CircleImageView
import com.mirrorflysdk.api.chat.ProfileEventsListener
import com.mirrorflysdk.api.contacts.ContactManager
import com.mirrorflysdk.api.contacts.ProfileDetails
import com.mirrorflysdk.flycall.call.utils.CallConstants
import com.mirrorflysdk.flycall.webrtc.CallAction
import com.mirrorflysdk.flycall.webrtc.CallDirection
import com.mirrorflysdk.flycall.webrtc.CallStatus
import com.mirrorflysdk.flycall.webrtc.CallType
import com.mirrorflysdk.flycall.webrtc.api.CallActionListener
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import com.mirrorflysdk.flycommons.LogMessage
import org.json.JSONObject


class CallKitUiActivity : Activity(), CallUiFlutterListener, ProfileEventsListener {
    private val tag = "CallKitUiActivity"
    private lateinit var callStatusTextView : TextView
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_call_kit_ui)
        CallManager.configureCallActivity(this)
//        CallManager.setCallUiListener(this)
        FlutterCall.setListener(this)
        LogMessage.d("CallKitUiActivity", "onCreate")
        val userName = findViewById<TextView>(R.id.tvNameCaller)
        callStatusTextView = findViewById<TextView>(R.id.tvNumber)
        val imageCallMember1 = findViewById<CircleImageView>(R.id.image_call_member_1)
        val imageCallMember2 = findViewById<CircleImageView>(R.id.image_call_member_2)
        val imageCallMember3 = findViewById<CircleImageView>(R.id.image_call_member_3)
        val imageCallMember4 = findViewById<CircleImageView>(R.id.image_call_member_4)
        val userImage = findViewById<CircleImageView>(R.id.ivAvatar)
        val accept = findViewById<ImageView>(R.id.ivAcceptCall)
        accept.setOnClickListener { attendCall() }
        val decline = findViewById<ImageView>(R.id.ivDeclineCall)
        decline.setOnClickListener { declineCall() }

        /*if (CallManager.isOneToOneCall()) {
            if(CallManager.getCallUsersList().isNotEmpty()) {
                if(CallManager.getCallUsersList().size == 1) {
                    val user = CallManager.getCallUsersList()[0]
                    val name = ContactManager.getDisplayName(user)
                    userName.text = name
                    val profile = ContactManager.getProfileDetails(user)
                    Utils.loadGlideImage(this, userImage, name, profile?.image ?: "")
                }
            }else{
                finish()
            }
        }else{
            userImage.visibility = View.INVISIBLE
            val membersName = Utils.setGroupMemberProfile(
                this,
                CallManager.getCallUsersList(),
                imageCallMember1,
                imageCallMember2,
                imageCallMember3,
                imageCallMember4
            )
            userName.text = membersName
        }*/
        updateUsersProfile()

        setUpCallDataAndUI()
    }

    private fun updateUsersProfile(){
        LogMessage.d(tag,CallManager.getCallUsersList().joinToString(","))
        val imageCallMember1 = findViewById<CircleImageView>(R.id.image_call_member_1)
        val imageCallMember2 = findViewById<CircleImageView>(R.id.image_call_member_2)
        val imageCallMember3 = findViewById<CircleImageView>(R.id.image_call_member_3)
        val imageCallMember4 = findViewById<CircleImageView>(R.id.image_call_member_4)
        val userImage = findViewById<CircleImageView>(R.id.ivAvatar)
        val userName = findViewById<TextView>(R.id.tvNameCaller)
        val participants = findViewById<TextView>(R.id.participants)
        val users = CallManager.getCallUsersList()
        LogMessage.d(tag,"getCallUsersList : "+users.joinToString(","))
        if(users.isNotEmpty()) {
            if(!CallManager.isOneToOneCall()) {
                if(CallManager.getGroupID().isNotEmpty()){
                    val membersName = Utils.setGroupMemberProfile(
                        this,
                        users,
                        imageCallMember1,
                        imageCallMember2,
                        imageCallMember3,
                        imageCallMember4
                    )
                    participants.text = membersName
                    participants.visibility = View.VISIBLE

                    Utils.makeViewsGone(imageCallMember2, imageCallMember3, imageCallMember4)
                    userImage.visibility = View.VISIBLE
                    userName.visibility = View.VISIBLE
                    val profile = ContactManager.getProfileDetails(CallManager.getGroupID())
                    val name = ContactManager.getDisplayName(CallManager.getGroupID())
                    userName.text = profile.getDisplayName()
                    Utils.loadGlideImage(this, userImage, profile.getDisplayName(), profile?.image ?: "",true)
                }else {
                    userImage.visibility = View.GONE
                    participants.visibility = View.GONE
                    val membersName = Utils.setGroupMemberProfile(
                        this,
                        users,
                        imageCallMember1,
                        imageCallMember2,
                        imageCallMember3,
                        imageCallMember4
                    )
                    LogMessage.d("membersName ${users.joinToString(",")} ",membersName.toString());
                    userName.text = membersName
                    userName.visibility = View.VISIBLE
                }
            }else{
                Utils.makeViewsGone(imageCallMember2, imageCallMember3, imageCallMember4)
                userName.visibility = View.VISIBLE
                userImage.visibility = View.VISIBLE
                val profile = ContactManager.getProfileDetails(CallManager.getEndCallerJid())
                val name = ContactManager.getDisplayName(CallManager.getEndCallerJid())
                userName.text = profile.getDisplayName()
                Utils.loadGlideImage(this, userImage, profile.getDisplayName(), profile?.image ?: "",false)
            }
        }else{
            finish()
        }

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
        updateCallStatus()
        val acceptCall = intent.extras?.getBoolean(CallConstants.ACCEPT_CALL)
        LogMessage.d(tag,"${CallConstants.ACCEPT_CALL} : ${acceptCall.toString()}")
        if (acceptCall!=null && acceptCall){
            attendCall(fromIntent = true)
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
        Log.d(tag,"onStart")
        // Bind to the service. If the service is in foreground mode, this signals to the service
        // that since this activity is in the foreground, the service can exit foreground mode.
        // for showing call notification
        //CallManager.bindCallService()
        AppUtils.checkPermission(this,this,findViewById(R.id.actions))
    }

    override fun onStop() {
        Log.d(tag,"onStop")
        // Unbind from the service. This signals to the service that this activity is no longer
        // in the foreground, and the service can respond by promoting itself to a foreground
        // service.
        // for showing call notification
        //CallManager.unbindCallService()
        super.onStop()
    }

    override fun onDestroy() {
        super.onDestroy()
        FlutterCall.setListener(null)
    }

    /*private fun checkPermission() {
        if (CallManager.getCallDirection() == CallDirection.INCOMING_CALL) {
            if (CallManager.getCallType() == CallType.AUDIO_CALL && (!CallManager.isAudioCallPermissionsGranted(false) || !CallManager.isNotificationPermissionsGranted())) {
                //ask Audio call Permission
                val permissionsToCheck = mutableListOf<String>()
                permissionsToCheck.add(Manifest.permission.RECORD_AUDIO)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    permissionsToCheck.add(Manifest.permission.BLUETOOTH_CONNECT)
                }
                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU){
                    permissionsToCheck.add(Manifest.permission.POST_NOTIFICATIONS)
                }

                permissionsToCheck.add(Manifest.permission.READ_PHONE_STATE)

                val (deniedPermissions, permanentlyDeniedPermissions) = checkAndAddPermissions(this, permissionsToCheck)

                LogMessage.d("Returned denied Permissions", deniedPermissions.toString())
                LogMessage.d("Returned permanently denied Permissions", permanentlyDeniedPermissions.toString())
                var message = Constants.AUDIO_CALL_PERMISSION
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S){
                    message = Constants.AUDIO_CALL_PERMISSION12
                }

                if (permanentlyDeniedPermissions.isNotEmpty() || deniedPermissions.isNotEmpty()) {
                    AppUtils.showPermissionSnackBar(this, findViewById(R.id.actions), message, permissionsToCheck.toTypedArray())
                }


            }else if (CallManager.getCallType() == CallType.VIDEO_CALL && (!CallManager.isVideoCallPermissionsGranted(false) || !CallManager.isNotificationPermissionsGranted())) {

                val permissionsToCheck = mutableListOf<String>()
                permissionsToCheck.add(Manifest.permission.CAMERA)
                permissionsToCheck.add(Manifest.permission.RECORD_AUDIO)
                permissionsToCheck.add(Manifest.permission.READ_PHONE_STATE)

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    permissionsToCheck.add(Manifest.permission.BLUETOOTH_CONNECT)
                }
                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU){
                    permissionsToCheck.add(Manifest.permission.POST_NOTIFICATIONS)
                }


                val (deniedPermissions, permanentlyDeniedPermissions) = checkAndAddPermissions(this, permissionsToCheck)

                LogMessage.d("Returned denied Permissions", deniedPermissions.toString())
                LogMessage.d("Returned permanently denied Permissions", permanentlyDeniedPermissions.toString())
                var message = Constants.VIDEO_CALL_PERMISSION
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S){
                    message = Constants.VIDEO_CALL_PERMISSION12
                }
                if (permanentlyDeniedPermissions.isNotEmpty() || deniedPermissions.isNotEmpty()) {
                    AppUtils.showPermissionSnackBar(this, findViewById(R.id.actions), message, permissionsToCheck.toTypedArray())
                }
            }
        }
    }*/

    private fun attendCall(fromIntent: Boolean = false) {
        if (CallManager.getCallType() == CallType.AUDIO_CALL && (!CallManager.isAudioCallPermissionsGranted() || !CallManager.isNotificationPermissionsGranted())) {
            AppUtils.checkPermission(this,this,findViewById(R.id.actions))
            return
        }
        if (CallManager.getCallType() == CallType.VIDEO_CALL && (!CallManager.isVideoCallPermissionsGranted() || !CallManager.isNotificationPermissionsGranted())) {
            AppUtils.checkPermission(this,this,findViewById(R.id.actions))
            return
        }
        Log.d("attendCall", "onclick")

        CallManager.answerCall(object : CallActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                LogMessage.d(tag,"isSuccess $isSuccess message $message")
                if (isSuccess) {
                    if(fromIntent) {
                        val json = JSONObject()
                        json.put("callStatus", "Attended")
                        json.put("userJid", CallManager.getCurrentUserId())
                        json.put("callType", CallManager.getCallType())
                        json.put("callMode", CallManager.getCallMode())
                        onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(json.toString())
                        finishTask()
                        val intent = AppUtils.getAppIntent(this@CallKitUiActivity)
                        startActivity(intent)
                    }else{
                        finishTask()
                    }
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
        LogMessage.d(" onRequestPermissionsResult", "${grantResults[0]}")
        LogMessage.d(" onRequestPermissionsResult", "$grantResults")
//        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            AppUtils.AUDIO_PERMISSION_REQUEST_CODE -> if (grantResults.isNotEmpty()) {

                val permissionsToCheck = mutableListOf<String>()
                val permanentlyDeniedPermissions = mutableListOf<String>()

                    for (i in permissions.indices) {
                        val permission = permissions[i]
                        val grantResult = grantResults[i]

                        Log.d("permission result loop", permission)
                        Log.d("permission result loop grantResult", grantResult.toString())
                        when {
                            grantResult == PackageManager.PERMISSION_GRANTED -> {
                                Log.d("PermissionResult", "$permission is granted")
                            }
                            !ActivityCompat.shouldShowRequestPermissionRationale(this, permission) -> {
                                Log.d("PermissionResult", "$permission is permanently denied")
                                permanentlyDeniedPermissions.add(permission)
                            }
                            else -> {
                                Log.d("PermissionResult", "$permission is denied")
                                permissionsToCheck.add(permission)
                            }
                        }
                    }

                if (permanentlyDeniedPermissions.isNotEmpty()){
                    AppUtils.openAppSettings(this)
                }else if(permissionsToCheck.isNotEmpty()){
                    AppUtils.askPermission(this, permissionsToCheck.toTypedArray())
                }



                /*val permissionsToRequest = mutableListOf<String>()
                val recordPermissionGranted = AppUtils.isPermissionAllowed(this,Manifest.permission.RECORD_AUDIO)
                val bluetoothPermissionGranted = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    AppUtils.isPermissionAllowed(this,Manifest.permission.BLUETOOTH_CONNECT)
                } else {
                    true
                }
                val postNotificationPermissionGranted = if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU){
                    AppUtils.isPermissionAllowed(this,
                        Manifest.permission.POST_NOTIFICATIONS)
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
                if(!postNotificationPermissionGranted && Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    permissionsToRequest.add(Manifest.permission.POST_NOTIFICATIONS)
                }
                if(permissionsToRequest.isNotEmpty()) {
                    AppUtils.askPermission(this,permissionsToRequest.toTypedArray())
                }*/
            }
            AppUtils.VIDEO_PERMISSION_REQUEST_CODE -> if (grantResults.isNotEmpty()){

                val permissionsToCheck = mutableListOf<String>()
                permissionsToCheck.add(Manifest.permission.CAMERA)
                permissionsToCheck.add(Manifest.permission.RECORD_AUDIO)
                permissionsToCheck.add(Manifest.permission.READ_PHONE_STATE)

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    permissionsToCheck.add(Manifest.permission.BLUETOOTH_CONNECT)
                }
                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU){
                    permissionsToCheck.add(Manifest.permission.POST_NOTIFICATIONS)
                }


                val (deniedPermissions, permanentlyDeniedPermissions) = checkAndAddPermissions(this, permissionsToCheck)

                if (permanentlyDeniedPermissions.isNotEmpty() || deniedPermissions.isNotEmpty()) {
                    CallManager.sendCallPermissionDenied()
//                    AppUtils.showPermissionSnackBar(this, findViewById(android.R.id.content), Constants.AUDIO_CALL_PERMISSION, permissionsToCheck.toTypedArray())
                }else{
                    CallManager.startVideoCapture()
                }

                /*val hasCameraPermission = AppUtils.isPermissionAllowed(this,Manifest.permission.CAMERA)
                val hasMicPermission = AppUtils.isPermissionAllowed(this,Manifest.permission.RECORD_AUDIO)
                val hasPhoneStatePermission = AppUtils.isPermissionAllowed(this,Manifest.permission.READ_PHONE_STATE)
                val hasBluetoothPermission = CallManager.isBluetoothPermissionsGranted()
                val postNotificationPermissionGranted = if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU){
                    AppUtils.isPermissionAllowed(this,
                        Manifest.permission.POST_NOTIFICATIONS)
                } else {
                    true
                }
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
                if(!postNotificationPermissionGranted && Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    permissionsToRequest.add(Manifest.permission.POST_NOTIFICATIONS)
                }*/
//                if (!hasCameraPermission || !hasMicPermission || !postNotificationPermissionGranted)
//                    CallManager.sendCallPermissionDenied()
//                else
//                    CallManager.startVideoCapture()
            }
        }
    }
    private fun handleCallStatusMessages(@CallStatus callEvent: String, userJid: String){
        LogMessage.d(tag,"callEvent : $callEvent userJid : $userJid")
        updateCallStatus()
        when (callEvent) {
            CallStatus.CONNECTING ->{}
            CallStatus.RINGING ->{}
            CallStatus.CONNECTED ->{}
            CallStatus.DISCONNECTED ->{}
            CallStatus.ON_HOLD ->{}
            CallStatus.ON_RESUME ->{}
            CallStatus.USER_JOINED ->{}
            CallStatus.USER_LEFT ->{}
            CallStatus.INVITE_CALL_TIME_OUT ->{}
            CallStatus.OUTGOING_CALL_TIME_OUT ->{}
            CallStatus.INCOMING_CALL_TIME_OUT ->{}
            CallStatus.RECONNECTING ->{}
            CallStatus.RECONNECTED ->{}
            CallStatus.CALLING ->{}
            CallStatus.CALLING_10S ->{}
            CallStatus.CALLING_AFTER_10S ->{}
        }
    }

    private fun updateCallStatus(){
        LogMessage.d(tag,"CallManager.getOnGoingCallStatus(this) ${CallManager.getOnGoingCallStatus(this)}")
        callStatusTextView.text = CallManager.getOnGoingCallStatus(this)
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            AppUtils.CALL_REQUEST -> {
                attendCall(fromIntent = true)
                LogMessage.d(tag,"onActivityResult $data")
            }
        }
    }

//    override fun onShowCallUi(callAction: String?) {
    override fun onShowCallUiFlutter(callAction: String?,userJid: String?) {
        LogMessage.d(tag, "#onShowCallUi $callAction ${Build.VERSION.SDK_INT} ${Build.VERSION_CODES.Q}")
        when(callAction){
            CallStatus.INCOMING_CALL_TIME_OUT->{
                if(CallManager.isOneToOneCall()){
                    CallManager.disconnectCall()
                    finish()
                }
            }
            CallConstants.ACTION_SHOW_CALL_UI->{}
            CallConstants.ACTION_INVITE_CALL_MESSAGE_RECEIVED->{}
            CallConstants.ACTION_MEDIA_CALL_MESSAGE_RECEIVED->{}
            CallConstants.ACTION_START_VIDEO_CAPTURE->{}
            CallAction.ACTION_INVITE_USERS->{}
            CallAction.ACTION_ANSWER_CALL->{
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    val y = AppUtils.getAppIntent(this)
                    y?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    this.startActivity(y)
                }
            }
            CallAction.ACTION_DENY_CALL->{
                if(CallManager.isOneToOneCall()){
                    CallManager.disconnectCall()
                    finish()
                }
            }
            CallAction.ACTION_LOCAL_HANGUP->{
//                if(CallManager.isOneToOneCall()){
//                    CallManager.disconnectCall()
                    finish()
//                }
            }
            CallAction.ACTION_REMOTE_HANGUP->{
                if(CallManager.isOneToOneCall()){
                    CallManager.disconnectCall()
                    finish()
                }
            }
            CallAction.ACTION_REMOTE_OTHER_BUSY->{
                updateUsersProfile()
            }
            CallStatus.USER_LEFT ->{
                updateUsersProfile()
                if (userJid!=null && userJid.isNotEmpty()) {
                    val name = ContactManager.getProfileDetails(CallManager.getGroupID()).getDisplayName()
                    Toast.makeText(this, "$name Left",Toast.LENGTH_SHORT).show()
                }
            }
            CallAction.ACTION_REMOTE_BUSY->{
                updateUsersProfile()
                if (userJid!=null && userJid.isNotEmpty()) {
                    val name = ContactManager.getProfileDetails(CallManager.getGroupID()).getDisplayName()
                    Toast.makeText(this, "$name is Busy",Toast.LENGTH_SHORT).show()
                }
            }
            CallAction.ACTION_REMOTE_ENGAGED->{
                updateUsersProfile()
                if (userJid!=null && userJid.isNotEmpty()) {
                    val name = ContactManager.getProfileDetails(CallManager.getGroupID()).getDisplayName()
                    Toast.makeText(this, "$name is on another call",Toast.LENGTH_SHORT).show()
                }
            }
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

    override fun onCallStatusUpdated(callStatus: String, userJid: String){
        handleCallStatusMessages(callStatus,userJid)
    }

    override fun blockedThisUser(jid: String) {
        TODO("Not yet implemented")
    }

    override fun myProfileUpdated(isSuccess: Boolean) {
        TODO("Not yet implemented")
    }

    override fun onAdminBlockedOtherUser(jid: String, type: String, status: Boolean) {
        TODO("Not yet implemented")
    }

    override fun onAdminBlockedUser(jid: String, status: Boolean) {
        TODO("Not yet implemented")
    }

    override fun onContactSyncComplete(isSuccess: Boolean) {
        TODO("Not yet implemented")
    }

    override fun onLoggedOut() {
        TODO("Not yet implemented")
    }

    override fun unblockedThisUser(jid: String) {
        TODO("Not yet implemented")
    }

    override fun userBlockedMe(jid: String) {
        TODO("Not yet implemented")
    }

    override fun userCameOnline(jid: String) {
        TODO("Not yet implemented")
    }

    override fun userDeletedHisProfile(jid: String) {
        TODO("Not yet implemented")
    }

    override fun userProfileFetched(jid: String, profileDetails: ProfileDetails) {
        TODO("Not yet implemented")
    }

    override fun userUnBlockedMe(jid: String) {
        TODO("Not yet implemented")
    }

    override fun userUpdatedHisProfile(jid: String) {
        updateUsersProfile()
    }

    override fun userWentOffline(jid: String) {
        TODO("Not yet implemented")
    }

    override fun usersIBlockedListFetched(jidList: List<String>) {
        TODO("Not yet implemented")
    }

    override fun usersProfilesFetched() {
        TODO("Not yet implemented")
    }

    override fun usersWhoBlockedMeListFetched(jidList: List<String>) {
        TODO("Not yet implemented")
    }

    /*override fun onShowCallUiFlutter(callAction: String?) {
        TODO("Not yet implemented")
    }*/
}