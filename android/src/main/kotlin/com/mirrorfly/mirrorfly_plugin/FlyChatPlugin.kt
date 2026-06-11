package com.mirrorfly.mirrorfly_plugin

import android.annotation.SuppressLint
import android.app.Activity
import android.app.KeyguardManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.*
import androidx.annotation.NonNull
import androidx.core.app.NotificationCompat
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import com.mirrorfly.mirrorfly_plugin.call.*
import com.mirrorflysdk.api.*
import com.mirrorflysdk.api.chat.*
import com.mirrorflysdk.api.contacts.ContactManager
import com.mirrorflysdk.api.contacts.ProfileDetails
import com.mirrorflysdk.api.models.*
import com.mirrorflysdk.backup.BackupListener
import com.mirrorflysdk.backup.BackupManager
import com.mirrorflysdk.backup.RestoreListener
import com.mirrorflysdk.backup.RestoreManager
/*import com.mirrorflysdk.flycall.webrtc.CallType
import com.mirrorflysdk.flycall.webrtc.api.CallLogManager
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import com.mirrorflysdk.flycall.webrtc.api.MissedCallListener*/
import com.mirrorflysdk.flycommons.*
import com.mirrorflysdk.flycommons.exception.FlyException
import com.mirrorflysdk.flycommons.models.CallMetaData
import com.mirrorflysdk.utils.*
import com.mirrorflysdk.xmpp.chat.listener.TypingStatusListener
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference
import io.flutter.plugin.common.*
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import kotlin.collections.ArrayList


/** FlyChatPlugin */
class FlyChatPlugin : FlutterPlugin, MethodCallHandler, ChatEvents, GroupEventsListener,
    ProfileEventsListener, ChatConnectionListener, MessageEventsListener, LoginEventsListener,
    TypingEventListener, TypingStatusListener, ActivityAware, DefaultLifecycleObserver,
    PluginRegistry.NewIntentListener, PluginRegistry.ActivityResultListener,
    AvailableFeaturesCallback,/* MissedCallListener, CallLogManager.CallLogsListener,*/
    MediaNotificationHelper, MuteEventsListener {

    //    var instance: FlyChatPlugin = FlyChatPlugin()
    init {
        Log.d("#FlyChatEvents", " FlyChatPlugin init")
        Log.d("#Mirror-Fly Android Internal Release", " Running on sdk:mirrorflysdk:7.13.26_pre_8")
    }

    companion object {
        @SuppressLint("StaticFieldLeak")
        private lateinit var instance: FlyChatPlugin

        /*public fun getInstance(): FlyChatPlugin {
            return instance
        }

        public fun hasInstance(): Boolean {
            return ::instance.isInitialized
        }*/

        fun sharePluginWithRegister(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
            Log.d("#FlyChatEvents", "sharePluginWithRegister")
//            val factory = MirrorflyViewFactory(flutterPluginBinding.binaryMessenger)
//            flutterPluginBinding.platformViewRegistry.registerViewFactory(
//                Constants.mirrorflyView,
//                factory
//            )
            MirrorFlyManager.init(flutterPluginBinding.applicationContext)
            MirrorFlyManager.setPluginBinding(flutterPluginBinding)
//            CallManager.init(flutterPluginBinding.applicationContext)
            initSharedInstance(
                flutterPluginBinding.applicationContext,
                flutterPluginBinding.binaryMessenger
            )
        }

        private val methodChannels = mutableMapOf<BinaryMessenger, MethodChannel>()
        private fun initSharedInstance(context: Context, binaryMessenger: BinaryMessenger) {
            Log.d("#FlyChatEvents", "initSharedInstance")
            Log.d("#MirrorFlyManager", "$MirrorFlyManager")
            if (!::instance.isInitialized) {
                Log.d("#FlyChatEvents", "!::instance.isInitialized " + (::instance.isInitialized))
                instance = FlyChatPlugin()
                instance.mContext = context
                MirrorFlyManager.setFlyChatInstance(instance)
            }
            instance.mContext = context
            initChannels(binaryMessenger)
//            FlyCallPlugin().init()

            /**
             * Attach Event Listeners should add at the SDK Initialisation and
             * should not added here as it will cause issues like improper updates
             **/

            ChatConnectionManager.addChatConnectionListener(instance)
//            CallManager.setMissedCallListener(instance)
            ChatEventsManager.setupMessageEventListener(instance)
            ChatManager.setMediaNotificationHelper(instance)
            ChatManager.setAvailableFeaturesCallback(instance)
            SharedPreferenceManager().init(context)
        }

        private fun initChannels(binaryMessenger: BinaryMessenger) {
            Log.d("initChannels", "FlyChatPlugin")
            val channel = MethodChannel(binaryMessenger, Constants.MirrorflyMethodChannel)
            methodChannels[binaryMessenger] = channel
            channel.setMethodCallHandler(instance)
            initMethodAndEvent(binaryMessenger)
//            FlyCallPlugin().initChannels()
        }

        //        private val eventHandlers = mutableListOf<WeakReference<EventCallbackHandler>>()
        fun sendEvent(event: String, body: JSONObject) {
            Log.d("sendEvent", "event : $event body : $body")
            if (event == Constants.ACTION_CALL_ACCEPT) {
//                onCallStatusUpdatedStreamHandler.onCallStatusUpdated?.success(body.toString())
                FlyMethodConstants.updateCallSinkValue(
                    Constants.onCallStatusUpdated,
                    body.toString()
                )
            }
        }

        private fun initMethodAndEvent(binaryMessenger: BinaryMessenger) {
            Log.d("#FlyChatEvents", "initMethodAndEvent")
            FlyMethodConstants.initializeChatListeners(binaryMessenger)
        }
    }

    private val TAG = "#FlyChatEvents"

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var mContext: Context
    private lateinit var lifecycle: Lifecycle

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onAttachedToEngine")
        sharePluginWithRegister(flutterPluginBinding)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        Log.d(TAG, "onMethodCall ==> ${call.method}")
        when (call.method) {
            "appLaunchedDetails" -> {
                appLaunchedDetails(result)
                return
            }

            "appLaunchedFromMissedCall" -> {
                val fromCall = instance.fromCallNotification
                instance.fromCallNotification = false
                Log.d("appLaunchedFromMissedCall", fromCall.toString())
                result.success(fromCall)
                return
            }

            "appLaunchedFromMediaNotification" -> {
                val jid = instance.mediaClickedJid
                instance.mediaClickedJid = ""
                Log.d("appLaunchedFromMediaNotification", jid)
                result.success(jid)
                return
            }

            "isLockScreen" -> {

                val keyguardManager: KeyguardManager = instance.mContext.getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
                val inKeyguardRestrictedInputMode: Boolean = keyguardManager.inKeyguardRestrictedInputMode()

                val isLocked = if (inKeyguardRestrictedInputMode) {
                    true
                } else {
                    val powerManager: PowerManager = instance.mContext.getSystemService(Context.POWER_SERVICE) as PowerManager
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT_WATCH) {
                        !powerManager.isInteractive
                    } else {
                        !powerManager.isScreenOn
                    }
                }
                return result.success(isLocked)
            }

            "init", "initializeSDK" -> {
                ChatEventsManager.attachProfileEventsListener(instance)
                ChatEventsManager.attachGroupEventsListener(instance)
                ChatEventsManager.attachLoginEventsListener(instance)
                ChatEventsManager.attachTypingEventListener(instance)
                ChatEventsManager.attachMuteEventsListener(instance)
            }
        }
        FlyMethodConstants.chatMethodHandlers[call.method]?.let { methodHandler ->
            Log.d(TAG, "Method call ${call.method}")
            methodHandler.invoke(call, result)
        }

        if (FlyMethodConstants.chatMethodHandlers[call.method] == null) {
            when {
                call.method == "getPlatformVersion" -> {
                    result.success("Android ${Build.VERSION.RELEASE}")
                }

                call.method.equals("getNonChatUsers") -> {
                    val nonchatusers = FlyCore.getNonChatUsers()
                    result.success(nonchatusers.toJsonString())
                }

                call.method.equals("doesFetchingMembersListFromServedRequired") -> {
                    val groupJid = call.argument<String>("groupJid") ?: ""
                    result.success(GroupManager.doesFetchingMembersListFromServedRequired(groupJid))
                }

                call.method.equals("getMembersCountOfGroup") -> {
                    val groupJid = call.argument<String>("groupJid") ?: ""
                    result.success(GroupManager.getMembersCountOfGroup(groupJid))
                }

                call.method.equals("getUsersListToAddMembersInOldGroup") -> {
                    val groupJid = call.argument<String>("groupJid") ?: ""
                    result.success(GroupManager.getUsersListToAddMembersInOldGroup(groupJid))
                }

                call.method.equals("getUsersListToAddMembersInNewGroup") -> {
                    result.success((GroupManager.getUsersListToAddMembersInNewGroup()).toJsonString())
                }

                call.method.equals("getGroupMessageStatusCount") -> {
                    val messageid: String = call.argument("messageid") ?: ""
                    result.success(FlyMessenger.getGroupMessageStatusCount(messageid))
                }

                call.method.equals("deleteOfflineGroup") -> {
                    val groupJid = call.argument<String>("groupJid") ?: ""
                    GroupManager.deleteOfflineGroup(groupJid)
                }

                call.method.equals("getIsProfileBlockedByAdmin") -> {
                    result.success(FlyCore.getIsProfileBlockedByAdmin())
                }

                call.method.equals("getArchivedChatsFromServer") -> {
                    FlyCore.getArchivedChatsFromServer()
                }

                call.method.equals("getMessageActions") -> {
                    val messageIdlist =
                        call.argument<List<String>>("messageidlist") ?: arrayListOf()
                    result.success(ChatManager.getMessageActions(messageIdlist).toJsonString())
                }

                call.method.equals("copyTextMessages") -> {
                    val messageIdlist =
                        call.argument<List<String>>("messageidlist") ?: arrayListOf()
                    ChatManager.copyTextMessages(messageIdlist).toJsonString()
                }

                call.method.equals("setCustomValue") -> {
                    val mid = call.argument<String>("message_id") ?: ""
                    val key = call.argument<String>("key") ?: ""
                    val value = call.argument<String>("value") ?: ""
                    FlyMessenger.setCustomValue(mid, key, value)
                }

                call.method.equals("getCustomValue") -> {
                    val mid = call.argument<String>("message_id") ?: ""
                    val key = call.argument<String>("key") ?: ""
                    result.success(FlyMessenger.getCustomValue(mid, key))
                }

                call.method.equals("removeCustomValue") -> {
                    val mid = call.argument<String>("message_id") ?: ""
                    val key = call.argument<String>("key") ?: ""
                    FlyMessenger.removeCustomValue(mid, key)
                }

                call.method.equals("inviteUserViaSMS") -> {
                    val mobile_no = call.argument<String>("mobile_no") ?: ""
                    val message = call.argument<String>("message") ?: ""
                    ContactManager.inviteUserViaSMS(mobile_no, message)
                }

                call.method.equals("clearAllSDKData") -> {
                    FlyCore.clearAllSDKData()
                }

                call.method.equals("getLastNUnreadMessages") -> {
                    val messagescount = call.argument<Int>("messagesCount") ?: 0
                    result.success(
                        FlyMessenger.getLastNUnreadMessages(messagescount).toJsonString()
                    )
                }

                call.method.equals("getNUnreadMessagesOfEachUsers") -> {
                    val messagescount = call.argument<Int>("messagesCount") ?: 0
                    val usersWithMessage: Map<String, List<ChatMessage>> =
                        FlyMessenger.getNUnreadMessagesOfEachUsers(messagescount)
                    result.success(usersWithMessage.toJsonString())
                }

                call.method.equals("getUnreadMessagesCount") -> {
                    result.success(FlyMessenger.getUnreadMessagesCount())
                }

                call.method.equals("get_message_using_ids") -> {
//                getMessageUsingIds(call, result)
                }

                else -> {
                    result.notImplemented()
                }

            }
        }
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onDetachedFromEngine")
        methodChannels.remove(binding.binaryMessenger)?.setMethodCallHandler(null)
    }

    private inline fun <reified T : Parcelable> Intent.parcelable(key: String): T? = when {
        Build.VERSION.SDK_INT >= 33 -> getParcelableExtra(key, T::class.java)
        else -> @Suppress("DEPRECATION") getParcelableExtra(key) as? T
    }

    override fun onDeleteGroup(groupJid: String) {
        LogMessage.d(TAG, "onDeleteGroup : groupJid $groupJid")
//        onDeleteGroupStreamHandler.onDeleteGroup?.success(groupJid)
        FlyMethodConstants.updateChatSinkValue(
            Constants.onDeleteGroupChannel,
            groupJid
        )
    }

    override fun onFetchingGroupListCompleted(noOfGroups: Int) {
        LogMessage.d(TAG, "onFetchingGroupListCompleted : noOfGroups : $noOfGroups")
//        onFetchingGroupListCompletedStreamHandler.onFetchingGroupListCompleted?.success(
//            noOfGroups
//        )
        FlyMethodConstants.updateChatSinkValue(
            Constants.onFetchingGroupListCompletedChannel,
            noOfGroups
        )
    }

    override fun onFetchingGroupMembersCompleted(groupJid: String) {
        LogMessage.d(TAG, "onFetchingGroupMembersCompleted : $groupJid")
//        onFetchingGroupMembersCompletedStreamHandler.onFetchingGroupMembersCompleted?.success(
//            groupJid
//        )
        FlyMethodConstants.updateChatSinkValue(
            Constants.onFetchingGroupMembersCompletedChannel,
            groupJid
        )
    }

    override fun onGroupDeletedLocally(groupJid: String) {
        LogMessage.d(TAG, "onGroupDeletedLocally : $groupJid")
//        onGroupDeletedLocallyStreamHandler.onGroupDeletedLocally?.success(groupJid)
        FlyMethodConstants.updateChatSinkValue(
            Constants.onGroupDeletedLocallyChannel,
            groupJid
        )
    }


    override fun onGroupNotificationMessage(message: ChatMessage) {
        LogMessage.d(TAG, "onGroupNotificationMessage : ${message.toJsonString()}")
//        onGroupNotificationMessageStreamHandler.onGroupNotificationMessage?.success(message.toJsonString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.onGroupNotificationMessageChannel,
            message.toJsonString()
        )
    }

    override fun onGroupProfileFetched(groupJid: String) {
        LogMessage.d(TAG, "onGroupProfileFetched : $groupJid")
//        onGroupProfileFetchedStreamHandler.onGroupProfileFetched?.success(groupJid)
        FlyMethodConstants.updateChatSinkValue(
            Constants.onGroupProfileFetchedChannel,
            groupJid
        )
    }

    override fun onGroupProfileUpdated(groupJid: String) {
        LogMessage.d(TAG, "onGroupProfileUpdated : $groupJid")
        //LogMessage.d("our GroupProfileUpdated", groupJid)
//        onGroupProfileUpdatedStreamHandler.onGroupProfileUpdated?.success(groupJid)
        FlyMethodConstants.updateChatSinkValue(
            Constants.onGroupProfileUpdatedChannel,
            groupJid
        )
    }

    override fun onLeftFromGroup(groupJid: String, leftUserJid: String) {
        LogMessage.d(TAG, "onLeftFromGroup : groupJid $groupJid leftUserJid $leftUserJid")
        val map = JSONObject()
        map.put("groupJid", groupJid)
        map.put("leftUserJid", leftUserJid)
//        onLeftFromGroupStreamHandler.onLeftFromGroup?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.onLeftFromGroupChannel,
            map.toString()
        )
    }

    override fun onMemberMadeAsAdmin(
        groupJid: String,
        newAdminMemberJid: String,
        madeByMemberJid: String
    ) {
        LogMessage.d(
            TAG,
            "onMemberMadeAsAdmin : $groupJid newAdminMemberJid $newAdminMemberJid madeByMemberJid $madeByMemberJid"
        )
        val map = JSONObject()
        map.put("groupJid", groupJid)
        map.put("newAdminMemberJid", newAdminMemberJid)
        map.put("madeByMemberJid", madeByMemberJid)
//        onMemberMadeAsAdminStreamHandler.onMemberMadeAsAdmin?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.onMemberMadeAsAdminChannel,
            map.toString()
        )
    }

    override fun onRevokedAdminAccess(
        groupJid: String,
        revokedAdminMemberJid: String,
        revokedByMemberJid: String
    ) {
        LogMessage.d(
            TAG,
            "onRevokedAdminAccess : groupJid $groupJid revokedAdminMemberJid $revokedAdminMemberJid revokedByMemberJid $revokedByMemberJid"
        )
        val map = JSONObject()
        map.put("groupJid", groupJid)
        map.put("removedAdminMemberJid", revokedAdminMemberJid)
        map.put("removedByMemberJid", revokedByMemberJid)
//        onMemberRemovedAsAdminStreamHandler.onMemberRemovedAsAdmin?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.onMemberRemovedAsAdminChannel,
            map.toString()
        )
    }

    override fun onMemberRemovedFromGroup(
        groupJid: String,
        removedMemberJid: String,
        removedByMemberJid: String
    ) {
        LogMessage.d(
            TAG,
            "onMemberRemovedFromGroup : groupJid $groupJid removedMemberJid $removedMemberJid removedByMemberJid $removedByMemberJid"
        )
        val map = JSONObject()
        map.put("groupJid", groupJid)
        map.put("removedMemberJid", removedMemberJid)
        map.put("removedByMemberJid", removedByMemberJid)
//        onMemberRemovedFromGroupStreamHandler.onMemberRemovedFromGroup?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.onMemberRemovedFromGroupChannel,
            map.toString()
        )
    }

    override fun onNewGroupCreated(groupJid: String) {
        LogMessage.d(TAG, "onNewGroupCreated : $groupJid")
//        onNewGroupCreatedStreamHandler.onNewGroupCreated?.success(groupJid)
        FlyMethodConstants.updateChatSinkValue(
            Constants.onNewGroupCreatedChannel,
            groupJid
        )
    }

    override fun onNewMemberAddedToGroup(
        groupJid: String,
        newMemberJid: String,
        addedByMemberJid: String
    ) {
        LogMessage.d(
            TAG,
            "onNewMemberAddedToGroup : groupJid $groupJid newMemberJid $newMemberJid addedByMemberJid $addedByMemberJid"
        )
        val map = JSONObject()
        map.put("groupJid", groupJid)
        map.put("newMemberJid", newMemberJid)
        map.put("addedByMemberJid", addedByMemberJid)
//        onNewMemberAddedToGroupStreamHandler.onNewMemberAddedToGroup?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.onNewMemberAddedToGroupChannel,
            map.toString()
        )
    }

    override fun blockedThisUser(jid: String) {
        LogMessage.d(TAG, "blockedThisUser : $jid")
        val map = JSONObject()
        map.put("jid", jid)
//        blockedThisUserStreamHandler.blockedThisUser?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.blockedThisUserChannel,
            map.toString()
        )
    }

    override fun myProfileUpdated(isSuccess: Boolean) {
        LogMessage.d(TAG, "myProfileUpdated isSuccess : $isSuccess")
//        myProfileUpdatedStreamHandler.myProfileUpdated?.success(isSuccess)
        FlyMethodConstants.updateChatSinkValue(
            Constants.myProfileUpdatedChannel,
            isSuccess
        )
    }

    override fun onAdminBlockedOtherUser(jid: String, type: String, status: Boolean) {
        LogMessage.d(TAG, "onAdminBlockedOtherUser : $jid type $type status $status")
        val map = JSONObject()
        map.put("jid", jid)
        map.put("type", type)
        map.put("status", status)
//        onAdminBlockedOtherUserStreamHandler.onAdminBlockedOtherUser?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.onAdminBlockedOtherUserChannel,
            map.toString()
        )
    }

    override fun onAdminBlockedUser(jid: String, status: Boolean) {
        LogMessage.d(TAG, "onAdminBlockedUser : $jid status : $status")
        val map = JSONObject()
        map.put("jid", jid)
        map.put("status", status)
//        onAdminBlockedUserStreamHandler.onAdminBlockedUser?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.onAdminBlockedUserChannel,
            map.toString()
        )
    }

    override fun onContactSyncComplete(isSuccess: Boolean) {
        LogMessage.d("onContactSyncComplete", isSuccess.toString())
        FlyCore.getRegisteredUsers(true) { success, _, data ->
//            onContactSyncCompleteStreamHandler.onContactSyncComplete?.success(isSuccess)
            FlyMethodConstants.updateChatSinkValue(
                Constants.onContactSyncCompleteChannel,
                isSuccess
            )
        }
    }

    override fun onLoggedOut() {
        LogMessage.d(TAG, "onLoggedOut")
        Handler(Looper.getMainLooper()).postDelayed(
            Runnable {
                MirrorFlyManager.getActivity()?.runOnUiThread {
                    //            onLoggedOutStreamHandler.onLoggedOut?.success(true)
                    FlyMethodConstants.updateChatSinkValue(
                        Constants.onLoggedOutChannel,
                        true
                    )
                }
            },500
        )
    }

    override fun unblockedThisUser(jid: String) {
        LogMessage.d(TAG, "unblockedThisUser : $jid")
        val map = JSONObject()
        map.put("jid", jid)
//        unblockedThisUserStreamHandler.unblockedThisUser?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.unblockedThisUserChannel,
            map.toString()
        )
    }

    override fun userBlockedMe(jid: String) {
        LogMessage.d(TAG, "userBlockedMe : $jid")
        val map = JSONObject()
        map.put("jid", jid)
//        userBlockedMeStreamHandler.userBlockedMe?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.userBlockedMeChannel,
            map.toString()
        )
    }

    override fun userCameOnline(jid: String) {
        LogMessage.d(TAG, "userCameOnline : $jid")
        val map = JSONObject()
        map.put("jid", jid)
//        userCameOnlineStreamHandler.userCameOnline?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.userCameOnlineChannel,
            map.toString()
        )
    }

    override fun userDeletedHisProfile(jid: String) {
        LogMessage.d(TAG, "userDeletedHisProfile : $jid")
        val map = JSONObject()
        map.put("jid", jid)
//        userDeletedHisProfileStreamHandler.userDeletedHisProfile?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.userDeletedHisProfileChannel,
            map.toString()
        )
    }

    override fun userProfileFetched(jid: String, profileDetails: ProfileDetails) {
        LogMessage.d(
            TAG,
            "userProfileFetched : $jid profileDetails : ${profileDetails.toJsonString()}"
        )
        val map = JSONObject()
        map.put("jid", jid)
        map.put("profileDetails", profileDetails.toJsonString())
//        userProfileFetchedStreamHandler.userProfileFetched?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.userProfileFetchedChannel,
            map.toString()
        )
    }

    override fun userUnBlockedMe(jid: String) {
        LogMessage.d(TAG, "userUnBlockedMe : $jid")
        val map = JSONObject()
        map.put("jid", jid)
//        userUnBlockedMeStreamHandler.userUnBlockedMe?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.userUnBlockedMeChannel,
            map.toString()
        )
    }

    override fun userUpdatedHisProfile(jid: String) {
        LogMessage.d(TAG, "userUpdatedHisProfile : $jid")
        val map = JSONObject()
        map.put("jid", jid)
//        userUpdatedHisProfileStreamHandler.userUpdatedHisProfile?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.userUpdatedHisProfileChannel,
            map.toString()
        )
        FlutterChat.profileListener?.userUpdatedHisProfile(jid)
    }

    override fun userWentOffline(jid: String) {
        LogMessage.d(TAG, "userWentOffline : $jid")
        val map = JSONObject()
        map.put("jid", jid)
//        userWentOfflineStreamHandler.userWentOffline?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.userWentOfflineChannel,
            map.toString()
        )
    }

    override fun usersIBlockedListFetched(jidList: List<String>) {
//        usersIBlockedListFetchedStreamHandler.usersIBlockedListFetched?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.usersIBlockedListFetchedChannel,
            jidList.toJsonString()
        )
    }

    override fun usersProfilesFetched() {
//        usersProfilesFetchedStreamHandler.usersProfilesFetched?.success(true)
        FlyMethodConstants.updateChatSinkValue(
            Constants.usersProfilesFetchedChannel,
            true
        )
    }

    override fun usersWhoBlockedMeListFetched(jidList: List<String>) {
//        usersWhoBlockedMeListFetchedStreamHandler.usersWhoBlockedMeListFetched?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.usersWhoBlockedMeListFetchedChannel,
            jidList.toJsonString()
        )
    }

    override fun onConnected() {
        LogMessage.d(TAG, "Chat Manager connected")
//        onConnectedStreamHandler.onConnected?.success(true)
        FlyMethodConstants.updateChatSinkValue(
            Constants.onConnectedChannel,
            true
        )
    }

    override fun onConnectionFailed(e: FlyException) {
//        onConnectionFailedStreamHandler.onConnectionFailed?.success(e.message)
        FlyMethodConstants.updateChatSinkValue(
            Constants.onConnectionFailedChannel,
            e.message
        )
    }

    override fun onDisconnected() {
        LogMessage.d(TAG, "Chat Manager Disconnected")
//        onDisconnectedStreamHandler.onDisconnected?.success(true)
        FlyMethodConstants.updateChatSinkValue(
            Constants.onDisconnectedChannel,
            true
        )
    }

    override fun onReconnecting() {
        //onReconnecting
        LogMessage.d(TAG, "Chat Manager Reconnecting")
        FlyMethodConstants.updateChatSinkValue(
            Constants.onReconnectingChannel,
            true
        )
    }

    /*override fun onConnectionNotAuthorized() {
    LogMessage.d(TAG, "Chat Manager Not Authorized")
    onConnectionNotAuthorizedStreamHandler.onConnectionNotAuthorized?.success(true)
  }*/

    override fun connectionFailed(message: String) {
        LogMessage.d(TAG, "connectionFailed : $message")
//        connectionFailedStreamHandler.connectionFailed?.success(message)
        FlyMethodConstants.updateChatSinkValue(
            Constants.connectionFailedChannel,
            message
        )
    }

    override fun connectionSuccess() {
        LogMessage.d(TAG, "connection Success")
//        connectionSuccessStreamHandler.connectionSuccess?.success(true)
        FlyMethodConstants.updateChatSinkValue(
            Constants.connectionSuccessChannel,
            true
        )
    }

    /**
     * QR Login Listener - Triggered when logged out at web
     *
     * - onLogoutWeb
     */
    override fun onLogoutWeb(socketId: List<String>?) {
        LogMessage.d(TAG, "onLogoutWeb : socketId $socketId")
        val socketIdJsonArray = JSONArray(socketId)
        val map = JSONObject()
        map.put("socketIdList", socketIdJsonArray)
        FlyMethodConstants.updateChatSinkValue(
            Constants.onWebLogoutChannel,
            map.toString()
        )
    }

    /**
     * MuteEventsListener Listeners
     *
     * - onMuteStatusUpdated
     * - updateMuteSettings
     *
     */
    override fun onMuteStatusUpdated(
        isSuccess: Boolean,
        message: String,
        jidList: List<String>,
        muteStatus: Boolean
    ) {
        LogMessage.d(TAG, "onMuteStatusUpdated : isSuccess $isSuccess, message $message, jidList $jidList, muteStatus $muteStatus")
        val map = JSONObject()
        map.put("isSuccess", isSuccess)
        map.put("message", message)
        val jidListJsonArray = JSONArray(jidList)
        map.put("jidList", jidListJsonArray)
        map.put("muteStatus", muteStatus)

        FlyMethodConstants.updateChatSinkValue(
            Constants.onChatMuteStatusUpdatedChannel,
            map.toString()
        )
    }

    override fun updateMuteSettings(isSuccess: Boolean, message: String, isMuteStatus: Boolean) {
        LogMessage.d(TAG, "updateMuteSettings : isSuccess $isSuccess, message $message, isMuteStatus $isMuteStatus")
        val map = JSONObject()
        map.put("isSuccess", isSuccess)
        map.put("message", message)
        map.put("isMuteStatus", isMuteStatus)

        FlyMethodConstants.updateChatSinkValue(
            Constants.didUpdateMuteSettingsChannel,
            map.toString()
        )
    }

    /**
     * Message Event Listeners
     *
     * - onMuteStatusUpdated
     * - updateMuteSettings
     *
     */

    override fun onAllChatsCleared(){
        LogMessage.d(TAG, "onAllChatsCleared")
        FlyMethodConstants.updateChatSinkValue(
            Constants.onAllChatsClearedChannel,
            true
        )
    }

    override fun onChatCleared(toJid: String, chatClearType: ChatClearType) {
        LogMessage.d(TAG, "onChatCleared : toJid $toJid, chatClearType $chatClearType")
        val map = JSONObject()
        map.put("toJid", toJid)
        when (chatClearType) {
            ChatClearType.DeleteChat -> {
                map.put("chatClearType", "delete")
            }
            ChatClearType.ClearChat -> {
                map.put("chatClearType", "clear")
            }
            else -> {
                LogMessage.d(TAG, "onChatCleared listener received unhandled value")
            }
        }

        FlyMethodConstants.updateChatSinkValue(
            Constants.onChatClearedChannel,
            map.toString()
        )

    }

    override fun onMessageDeleted(
        toJid: String,
        messageIds: ArrayList<String>,
        messageDeleteType: MessageDeleteType
    ) {
        LogMessage.d(TAG, "onMessageDeleted : toJid $toJid, messageIds $messageIds, messageDeleteType $messageDeleteType")
        val map = JSONObject()
        map.put("toJid", toJid)
        val messageIdsJsonArray = JSONArray(messageIds)
        map.put("messageIds", messageIdsJsonArray)

        if (messageDeleteType == MessageDeleteType.DeleteForMe){
            map.put("messageDeleteType", "deleteForMe")
        }else if (messageDeleteType == MessageDeleteType.DeleteForEveryone) {
            map.put("messageDeleteType", "deleteForEveryone")
        }

        FlyMethodConstants.updateChatSinkValue(
            Constants.onMessageDeletedChannel,
            map.toString()
        )

    }

    override fun onUpdateUnStarAllMessages() {
        LogMessage.d(TAG, "onUpdateUnStarAllMessages")
    }

    override fun updateArchiveUnArchiveChats(toUser: String?, archiveStatus: Boolean) {
        LogMessage.d(TAG, "updateArchiveUnArchiveChats : toUser $toUser, archiveStatus $archiveStatus")
        val map = JSONObject()
        map.put("toUser", toUser)
        map.put("archiveStatus", archiveStatus)
        FlyMethodConstants.updateChatSinkValue(
            Constants.updateArchiveUnArchiveChatsChannel,
            map.toString()
        )
    }

    override fun updateArchivedSettings(archivedSettingsStatus: Boolean) {
        LogMessage.d(TAG, "updateArchivedSettings : archivedSettingsStatus $archivedSettingsStatus")
        FlyMethodConstants.updateChatSinkValue(
            Constants.updateArchivedSettingsChannel,
            archivedSettingsStatus
        )
    }

    override fun updateGroupReplyNotificationForArchivedSettingsEnabled(chatMessage: ChatMessage) {
        LogMessage.d(TAG, "updateGroupReplyNotificationForArchivedSettingsEnabled : chatMessage $chatMessage")
    }

    /// Old Delegate method, instead onMessageDeleted added
    override fun onMessagesClearedOrDeleted(messageIds: ArrayList<String>, jid: String) {
        LogMessage.d(TAG, "onMessagesClearedOrDeleted : messageIds $messageIds jid $jid")
        //LogMessage.d("MirrorFly", "onMessagesClearedOrDeleted Status Updated")
    }


    override fun onUpdateBusyStatus(status: Boolean, message: String?) {
        LogMessage.d(TAG, "onUpdateBusyStatus : status $status message $message")
    }

    override fun onMediaStatusUpdated(message: ChatMessage) {
        LogMessage.d(TAG, "onMediaStatusUpdated ${message.toJsonString()}")
//        MediaStatusUpdatedStreamHandler.onMediaStatusUpdated?.success(message.toJsonString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.onMediaStatusUpdatedChannel,
            message.toJsonString()
        )
    }

    override fun onMessageEdited(editedMessage: ChatMessage) {
        FlyMethodConstants.updateChatSinkValue(
            Constants.onMessageEditedChannel,
            editedMessage.toJsonString()
        )
    }

    override fun onMessageReceived(message: ChatMessage) {
        LogMessage.d(TAG, "onMessageReceived ${message.toJsonString()}")
        //called when the new message is received
        //LogMessage.d(TAG, "Message Received ${message.tojsonString()}")
//        MessageReceivedStreamHandler.onMessageReceived?.success(message.toJsonString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.onMessageReceivedChannel,
            message.toJsonString()
        )

    }

    override fun onMessageStatusUpdated(messageId: String, jid: String?) {
        LogMessage.d(TAG, "onMessageStatusUpdated $messageId jid $jid")
        //called when the message status is updated
        //LogMessage.d("Message Ack", "Received")

        //LogMessage.d(TAG, "Message Status Updated ==> $messageId")
        try {
            val message = FlyMessenger.getMessageOfId(messageId)
            if (message != null) {
//            MessageStatusUpdatedStreamHandler.onMessageStatusUpdated?.success(message.toJsonString())
                FlyMethodConstants.updateChatSinkValue(
                    Constants.onMessageStatusUpdatedChannel,
                    message.toJsonString()
                )
            }
        }catch (e: Exception){
            LogMessage.d(TAG, "onMessageStatusUpdated Exception $e")
        }
    }

    override fun showOfflineMessagesNotification(offlineMessagesCount: Int) {
        LogMessage.d(TAG, "showOfflineMessagesNotification: $offlineMessagesCount")
    }

    override fun updateRecentChats(recentChatUserJid: String) {
        LogMessage.d(TAG, "updateRecentChats: $recentChatUserJid")
    }

    override fun updateNewMessagesReceived() {
        LogMessage.d(TAG, "updateNewMessagesReceived")
    }

    override fun onPollVoteNotification(jid: String, voteEvent: PollVoteEvent?) {
        LogMessage.d(TAG, "onPollVoteNotification jid: $jid, voteEvent: $voteEvent")
    }

    override fun onUploadDownloadProgressChanged(
        messageId: String,
        progressPercentage: Int
    ) {
        //called when the media message progress is updated
        //LogMessage.d("MirrorFly", "Upload/Download Status Updated")
        val js = JSONObject()
        js.put("message_id", messageId)
        js.put("progress_percentage", progressPercentage)
//        UploadDownloadProgressChangedStreamHandler.onUploadDownloadProgressChanged?.success(
//            js.toString()
//        )
        FlyMethodConstants.updateChatSinkValue(
            Constants.onUploadDownloadProgressChangedChannel,
            js.toString()
        )
    }

    override fun showOrUpdateOrCancelNotification(jid: String, chatMessage: ChatMessage?) {
        if (chatMessage != null) {
            val chat = chatMessage.toJsonString()
            LogMessage.d(
                TAG,
                "showOrUpdateOrCancelNotification : jid $jid chatMessage ${chat}"
            )
            val json = JSONObject()
            json.put("jid", jid)
            json.put("chatMessage", chat)
//            ShowOrUpdateOrCancelNotificationStreamHandler.showOrUpdateOrCancelNotification?.success(
//                json.toString()
//            )
            FlyMethodConstants.updateChatSinkValue(
                Constants.showUpdateCancelNotificationChannel,
                json.toString()
            )
        } else {
            LogMessage.d(
                TAG,
                "showOrUpdateOrCancelNotification : jid $jid chatMessage ${chatMessage}"
            )
        }
    }



    override fun onWebChatPasswordChanged(isError: Boolean) {
        LogMessage.d(TAG, "web chat password changed error $isError")
        /// Commenting this as this is not used anywhere and not available in iOS
       /* FlyMethodConstants.updateChatSinkValue(
            Constants.onWebChatPasswordChangedChannel,
            isError
        )*/
    }

    override fun setTypingStatus(singleOrGroupJid: String, userId: String, composing: String) {
        /* val map = JSONObject()
         map.put("status", composing)
         if(GroupManager.isValidGroupJid(singleOrGroupJid)){
             map.put("groupJid", if(GroupManager.isValidGroupJid(singleOrGroupJid)) singleOrGroupJid else "")
             map.put("userJid", userId)
             FlyMethodConstants.updateChatSinkValue(
                 Constants.onGroupTypingStatusChannel,
                 map.toString()
             )
         }else {
             map.put("userJid", singleOrGroupJid)
             FlyMethodConstants.updateChatSinkValue(
                 Constants.onChatTypingStatusChannel,
                 map.toString()
             )
         }*/
        val map2 = JSONObject()
        map2.put("singleOrgroupJid", singleOrGroupJid)
        map2.put("userJid", userId)
        map2.put("status", composing)
//        setTypingStatusStreamHandler.setTypingStatus?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.setTypingStatusChannel,
            map2.toString()
        )
    }

    override fun onChatTypingStatus(fromUserJid: String, status: TypingStatus) {
        val map = JSONObject()
//        map.put("fromUserJid", fromUserJid)
//        map.put("status", status)
//        onChatTypingStatusStreamHandler.onChatTypingStatus?.success(map.toString())
//    map.put("singleOrgroupJid", fromUserJid)
        map.put("userJid", fromUserJid)
        map.put("status", getTypingStatus(status))
//        setTypingStatusStreamHandler.setTypingStatus?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.setTypingStatusChannel,
            map.toString()
        )
    }

    override fun onGroupTypingStatus(groupJid: String, groupUserJid: String, status: TypingStatus) {
        val map = JSONObject()
        map.put("groupJid", groupJid)
        map.put("groupUserJid", groupUserJid)
        map.put("status", getTypingStatus(status))
//        setTypingStatusStreamHandler.setTypingStatus?.success(map.toString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.setTypingStatusChannel,
            map.toString()
        )
    }

    private fun getTypingStatus(status: TypingStatus): String {
        return if (status == TypingStatus.COMPOSING) {
            "composing"
        } else {
            "Gone"
        }
    }

    private var fromCallNotification: Boolean = false
    private var mediaClickedJid: String = ""
    private var extras: Bundle? = null
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d(TAG, "onAttachedToActivity")
        MirrorFlyManager.setActivityBinding(binding)
        binding.addActivityResultListener(instance)
        Log.d(TAG, "onAttachedToActivity ${MirrorFlyManager.getActivity()}")
        val mainActivityIntent = binding.activity.intent
        Log.d(TAG, "mainActivityIntent ${mainActivityIntent.extras}")
        instance.extras = mainActivityIntent.extras
        instance.fromCallNotification = false
        instance.mediaClickedJid = ""
        mainActivityIntent.extras?.let {
            Log.d(TAG, "mainActivityIntent ${it.getBoolean("IS_CALL_NOTIFICATION")}")
            if (it.getBoolean(Constants.IS_CALL_NOTIFICATION)) {
                instance.fromCallNotification = true
            } else if (it.getBoolean(Constants.IS_CHAT_NOTIFICATION)) {
                instance.mediaClickedJid = it.getString(Constants.JID, "")
            }
        }
//        if (!launchedActivityFromHistory(mainActivityIntent)) {
        /*if (SELECT_FOREGROUND_NOTIFICATION_ACTION.equals(mainActivityIntent.action)) {
            val notificationResponse: Map<String, Any> =
                extractNotificationResponseMap(mainActivityIntent)
            processForegroundNotificationAction(mainActivityIntent, notificationResponse)
        }*/
//        }
        binding.addOnNewIntentListener(instance)
//        val isRegistered = SharedPreferenceManager.instance.getBoolean("isRegistered")
        ChatManager.setAvailableFeaturesCallback(instance)
//        CallManager.setMissedCallListener(instance)
        /*if (isRegistered) {
            CallLogManager.setCallLogsListener(instance)
            *//*ChatEventsManager.setupMessageEventListener(this)
            ChatEventsManager.attachProfileEventsListener(this)
            ChatEventsManager.attachGroupEventsListener(this)
            ChatEventsManager.attachLoginEventsListener(this)
            ChatEventsManager.attachTypingEventListener(this)*//*
        }*/
        instance.lifecycle = (binding.lifecycle as HiddenLifecycleReference).lifecycle
        instance.lifecycle.addObserver(instance)
    }

    private fun appLaunchedDetails(result: MethodChannel.Result) {
        val json = JSONObject()
        instance.extras?.let {
            Log.d(TAG, "appLaunchedDetails $it")
            if (it.getBoolean(Constants.IS_CALL_NOTIFICATION)) {
                json.put("type", "MissedCall")
                json.put("value", true)
            } else if (it.getBoolean(Constants.IS_CHAT_NOTIFICATION)) {
                json.put("type", "MediaProgress")
                json.put("value", it.getString(Constants.JID, ""))
            } else {
            }
        }
        instance.extras = null
        result.success(json.toString())
    }

    private fun launchedActivityFromHistory(intent: Intent?): Boolean {
        return (intent != null
                && intent.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY
                == Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY)
    }

    override fun onStart(owner: LifecycleOwner) {
        super.onStart(owner)
        // Bind to the service. If the service is in foreground mode, this signals to the service
        // that since this activity is in the foreground, the service can exit foreground mode.
        // for showing call notification
//        CallManager.bindCallService()
        Log.d("#lifecycle", "onStart")
    }

    override fun onStop(owner: LifecycleOwner) {
        // Unbind from the service. This signals to the service that this activity is no longer
        // in the foreground, and the service can respond by promoting itself to a foreground
        // service.
        // for showing call notification
//        CallManager.unbindCallService()
        Log.d("#lifecycle", "onStop")
        super.onStop(owner)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        Log.d(TAG, "onDetachedFromActivityForConfigChanges")
        MirrorFlyManager.setActivityBinding(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Log.d(TAG, "onReattachedToActivityForConfigChanges")
        MirrorFlyManager.setActivityBinding(binding)
        binding.addActivityResultListener(this)
        binding.addOnNewIntentListener(this)
    }

    override fun onDetachedFromActivity() {
        Log.d(TAG, "onDetachedFromActivity")
        MirrorFlyManager.setActivityBinding(null)
        ChatEventsManager.detachProfileEventsListener(this)
        ChatEventsManager.detachGroupEventsListener(this)
        ChatEventsManager.detachLoginEventsListener(this)
        ChatEventsManager.detachTypingEventListener(this)
        ChatConnectionManager.removeChatConnectionListener(this)
        instance.lifecycle.removeObserver(this)
    }

    override fun onNewIntent(intent: Intent): Boolean {
        LogMessage.d("setMediaNotificationIntentAction", "${intent.extras}")
        val res: Boolean = sendNotificationPayloadMessage(intent)
        if (res && MirrorFlyManager.getActivity() != null) {
            MirrorFlyManager.getActivity()!!.intent = intent
        }
        return res
    }

    private fun sendNotificationPayloadMessage(intent: Intent): Boolean {
        Log.d("sendNotificationPayloadMessage", "${intent.extras}")
//        intent.extras?.let {
//            Log.d(TAG, "mainActivityIntent ${it.getString("FROM")}")
//        }
        /*if (SELECT_NOTIFICATION.equals(intent.action)
            || SELECT_FOREGROUND_NOTIFICATION_ACTION.equals(intent.action)
        ) {
            val notificationResponse = extractNotificationResponseMap(intent)
            if (SELECT_FOREGROUND_NOTIFICATION_ACTION.equals(intent.action)) {
                processForegroundNotificationAction(intent, notificationResponse)
            }
            channel.invokeMethod("didReceiveNotificationResponse", notificationResponse)
            return true
        }*/
        return false
    }

    //    var audioFileResult: MethodChannel.Result? = null
    private fun handleAudioVideoIntentFromGalleryMenu(resultCode: Int, intent: Intent?) {
        if (resultCode == Activity.RESULT_CANCELED) {
            MirrorFlyManager.audioFileResult?.error("500", "picker cancelled by user", "")
            MirrorFlyManager.audioFileResult = null
            return
        }
        val uri = intent?.data
        if (uri != null) {
            val uriOfSelectedFile = intent.data!!
            val mimeType =
                MirrorFlyManager.getActivity()?.applicationContext?.contentResolver?.getType(
                    uriOfSelectedFile
                )
            val pathOfSelectedFile = RealPathUtil.getRealPath(
                MirrorFlyManager.getActivity()?.applicationContext!!,
                uriOfSelectedFile
            )
            if (pathOfSelectedFile != null) {
                if (mimeType == null || mimeType.startsWith(com.mirrorflysdk.flycommons.Constants.MSG_TYPE_AUDIO)) {
//                isFileChooser = true
                    MirrorFlyManager.audioFileResult?.success(pathOfSelectedFile)
                    MirrorFlyManager.audioFileResult = null
                } else {
                    MirrorFlyManager.audioFileResult?.error("500", "mime type not found", "")
                    MirrorFlyManager.audioFileResult = null
                }
            } else {
                MirrorFlyManager.audioFileResult?.error("500", "file path null", "")
                MirrorFlyManager.audioFileResult = null
            }
        } else {
            MirrorFlyManager.audioFileResult?.error("500", "file uri not found", "")
            MirrorFlyManager.audioFileResult = null
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        Log.d(TAG, "onActivityResult" + data.toString())
        Log.d(TAG, "onActivityResult mainActivity ${MirrorFlyManager.getActivity()}")
//        setting isActivityStartedForResult to false for xmpp disconnection
        ChatManager.isActivityStartedForResult = false
        when (requestCode) {
            Constants.FROM_GALLERY -> {
                handleAudioVideoIntentFromGalleryMenu(resultCode, data)
            }
        }
        return false
    }

    override fun onUpdateAvailableFeatures(features: Features) {
        LogMessage.d("onAvailableFeaturesUpdated", features.toJsonString())
//        onUpdateAvailableFeaturesStreamHandler.onAvailableFeaturesUpdated?.success(features.toJsonString())
        FlyMethodConstants.updateChatSinkValue(
            Constants.onAvailableFeaturesUpdatedChannel,
            features.toJsonString()
        )
    }

    /*override fun onMissedCall(
        isOneToOneCall: Boolean,
        userJid: String,
        groupId: String?,
        callType: String,
        userList: ArrayList<String>, callMeta: Array<CallMetaData>?
    ) {
        Log.d(
            "onMissedCall",
            "onMissedCall ${MirrorFlyManager.getActivity()} userJid : $userJid, isOneToOne: $isOneToOneCall, groupId: $groupId, callType: $callType, userList: $userList"
        )
        val json = JSONObject()
        json.put("isOneToOneCall", isOneToOneCall)
        json.put("userJid", userJid)
        json.put("groupId", groupId ?: "")
        json.put("callType", callType)
        json.put("userList", userList.joinToString(","))
        *//*

        Instead of doing the string concatenation above, we can try this below

        val json = JSONObject()

        // Convert the array to a JSON array and add it to the JSON object
        val jsonArray = JSONArray(userList)
        json.put("userList", jsonArray)

        OR

        we can pass the array list directly as done in usersIBlockedListFetched

         *//*
        if (MirrorFlyManager.getActivity() != null) {
            MirrorFlyManager.getActivity()?.runOnUiThread {
//                onMissedCallNotificationStreamHandler.onMissedCall?.success(json.toString())
                FlyMethodConstants.updateCallSinkValue(Constants.onMissedCall, json.toString())
            }
        } else {
            FlyMethodConstants.updateCallSinkValue(Constants.onMissedCall, json.toString())
            val notificationContent = getMissedCallNotificationContent(
                isOneToOneCall,
                userJid,
                groupId,
                callType,
                userList
            )
            Log.d("FlyChatPlugin onMissedCall", "else $notificationContent")
            CallNotificationUtils.createNotification(
                instance.mContext,
                notificationContent.first,
                notificationContent.second
            )
        }
    }*/

    /*private fun getMissedCallNotificationContent(
        isOneToOneCall: Boolean, userJid: String, groupId: String?, callType: String,
        userList: ArrayList<String>
    ): Pair<String, String> {
        val messageContent: String
        val missedCallMessage = StringBuilder()
        missedCallMessage.append("You missed ")
        if (isOneToOneCall && groupId.isNullOrEmpty()) {
            if (callType == CallType.AUDIO_CALL) {
                missedCallMessage.append("an ")
            } else {
                missedCallMessage.append("a ")
            }
            missedCallMessage.append(callType).append(" call")
            messageContent = getDisplayName(userJid)
        } else {
            missedCallMessage.append("a group ").append(callType).append(" call")
            messageContent = if (!groupId.isNullOrBlank()) {
                getDisplayName(groupId)
            } else {
                getCallUsersName(userList).toString()
            }
        }
//        if (BuildConfig.HIPAA_COMPLIANCE_ENABLED)
//            messageContent = resources.getString(R.string.new_missed_call)
        return Pair(missedCallMessage.toString(), messageContent)
    }*/

    private fun getCallUsersName(callUsers: java.util.ArrayList<String>): StringBuilder {
        var name = StringBuilder("")
        for (i in callUsers.indices) {
            if (i == 2) {
                name.append(" and (+").append(callUsers.size - i).append(")")
                break
            } else if (i == 1) {
                name.append(", ").append(getDisplayName(callUsers[i]))
            } else {
                name = StringBuilder(getDisplayName(callUsers[i]))
            }
        }
        return name
    }

    private fun getDisplayName(jid: String): String {
        return ContactManager.getProfileDetails(jid)?.name
            ?: ContactManager.getProfileDetails(jid)?.nickName ?: ""
    }

    /*override fun onCallLogsDeleted(isClearAll: Boolean, callIdList: ArrayList<String>) {
        LogMessage.d("deleteCallLog ", "onCallLogsDeleted Called")
        if (!isClearAll) {
            callIdList.forEach { item ->
                FlyMethodConstants.updateCallSinkValue(
                    Constants.onCallLogDeletedChannel,
                    item
                )
            }
        } else {
            FlyMethodConstants.updateCallSinkValue(
                Constants.clearAllCallLogChannel,
                true
            )
        }

    }

    override fun onCallLogsUpdated() {
        LogMessage.d("onCallLogs Updated ", "Updated Called")
//        onCallLogsUpdatedStreamHandler.onCallLogsUpdated?.success(true)
        FlyMethodConstants.updateCallSinkValue(Constants.onCallLogsUpdatedChannel, true)
    }*/

    override fun setMediaNotificationIntentAction(
        notificationCompatBuilder: NotificationCompat.Builder,
        jidList: List<String>
    ) {
        val pendingIntent = getPendingIntent(jidList)
        LogMessage.d(
            "setMediaNotificationIntentAction",
            jidList.joinToString { "," } + " : pendingIntent : ${pendingIntent != null}"
        )
        notificationCompatBuilder.setContentIntent(getPendingIntent(jidList))
    }

    private fun getPendingIntent(toUsers: List<String>): PendingIntent? {
        val notificationIntent =
            instance.mContext.packageManager.getLaunchIntentForPackage(instance.mContext.packageName)
                ?.cloneFilter()
        notificationIntent?.flags =
            (Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        notificationIntent?.putExtra("FROM", "setMediaNotificationIntentAction")
        notificationIntent?.putExtra(Constants.IS_CHAT_NOTIFICATION, true)
        notificationIntent?.putExtra(
            Constants.JID,
            if (toUsers.count() == 1) toUsers.elementAt(0) else Constants.EMPTY_STRING
        )
        val requestID = System.currentTimeMillis().toInt()
        return notificationIntent?.let {
            PendingIntentHelper.getActivity(
                instance.mContext,
                requestID,
                it
            )
        }
    }

    /**
     * This below listener is to listen for the Group Deleted by Super Admin and notify to the Flutter
     */
    override fun onSuperAdminDeleteGroup(groupJid: String, groupName: String) {
        val map = JSONObject()
        map.put("groupJid", groupJid)
        map.put("groupName", groupName)
        FlyMethodConstants.updateChatSinkValue(
            Constants.onSuperAdminDeleteGroupChannel,
            map.toString()
        )
    }

}