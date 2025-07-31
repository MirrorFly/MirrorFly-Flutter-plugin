package com.mirrorfly.mirrorfly_plugin

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.RingtoneManager
import android.media.ThumbnailUtils
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.ContactsContract
import android.provider.MediaStore
import android.util.Base64
import android.webkit.MimeTypeMap
import androidx.core.content.FileProvider
import com.google.gson.Gson
import com.mirrorfly.mirrorfly_plugin.MirrorFlyManager.getActivity
import com.mirrorfly.mirrorfly_plugin.call.FlyCallMethods
import com.mirrorfly.mirrorfly_plugin.call.getDisplayName
import com.mirrorflysdk.ChatSDK
import com.mirrorflysdk.GroupConfig
import com.mirrorflysdk.api.ChatActionListener
import com.mirrorflysdk.api.ChatConnectionListener
import com.mirrorflysdk.api.ChatManager
import com.mirrorflysdk.api.DeleteChatType
import com.mirrorflysdk.api.FlyCore
import com.mirrorflysdk.api.FlyMessenger
import com.mirrorflysdk.api.GroupManager
import com.mirrorflysdk.api.RecentChatListBuilder
import com.mirrorflysdk.api.SendMessageCallback
import com.mirrorflysdk.api.TopicChatListBuilder
import com.mirrorflysdk.api.WebLoginDataManager
import com.mirrorflysdk.api.chat.ContactMessageParams
import com.mirrorflysdk.api.chat.EditMessage
import com.mirrorflysdk.api.chat.FetchMessageListParams
import com.mirrorflysdk.api.chat.FetchMessageListQuery
import com.mirrorflysdk.api.chat.FileMessage
import com.mirrorflysdk.api.chat.FileMessageParams
import com.mirrorflysdk.api.chat.LocationMessageParams
import com.mirrorflysdk.api.chat.MeetMessage
import com.mirrorflysdk.api.chat.TextMessage
import com.mirrorflysdk.api.contacts.ContactManager
import com.mirrorflysdk.api.contacts.ProfileDetails
import com.mirrorflysdk.api.models.BusyStatus
import com.mirrorflysdk.api.models.ChatDataModel
import com.mirrorflysdk.api.models.ChatMessage
import com.mirrorflysdk.api.models.ChatMessageStatusDetail
import com.mirrorflysdk.api.models.MessageStatusDetail
import com.mirrorflysdk.api.models.ProfileStatus
import com.mirrorflysdk.api.models.RecentChat
import com.mirrorflysdk.api.network.FlyNetwork
import com.mirrorflysdk.api.notification.NotificationEventListener
import com.mirrorflysdk.api.notification.PushNotificationManager
import com.mirrorflysdk.api.utils.NameHelper
import com.mirrorflysdk.backup.BackupListener
import com.mirrorflysdk.backup.BackupManager
import com.mirrorflysdk.backup.RestoreListener
import com.mirrorflysdk.backup.RestoreManager
import com.mirrorflysdk.flycall.webrtc.CallType
import com.mirrorflysdk.flycall.webrtc.Logger
import com.mirrorflysdk.flycall.webrtc.api.CallLogManager
import com.mirrorflysdk.flycall.webrtc.api.CallManager
import com.mirrorflysdk.flycommons.ChatType
import com.mirrorflysdk.flycommons.ChatTypeEnum
import com.mirrorflysdk.flycommons.FlyCallback
import com.mirrorflysdk.flycommons.FlyUtils
import com.mirrorflysdk.flycommons.LogMessage
import com.mirrorflysdk.flycommons.MediaCompressQuality
import com.mirrorflysdk.flycommons.Result
import com.mirrorflysdk.flycommons.SharedPreferenceManager
import com.mirrorflysdk.flycommons.TypingStatus
import com.mirrorflysdk.flycommons.exception.FlyException
import com.mirrorflysdk.flycommons.models.MessageMetaData
import com.mirrorflysdk.flycommons.models.MessageType
import com.mirrorflysdk.flycommons.models.MetaData
import com.mirrorflysdk.flycommons.models.MetaDataMessageList
import com.mirrorflysdk.flycommons.models.MetaDataUserList
import com.mirrorflysdk.flynetwork.model.verifyfcm.VerifyFcmResponse
import com.mirrorflysdk.media.MediaUploadHelper
import com.mirrorflysdk.media.newfilecompression.compressfile.MediaCompress
import com.mirrorflysdk.models.MediaAutoDownloadOption
import com.mirrorflysdk.models.RecentChatListParams
import com.mirrorflysdk.models.TopicChatListParams
import com.mirrorflysdk.utils.CompressCallback
import com.mirrorflysdk.utils.MFTextLocalization
import com.mirrorflysdk.utils.StringConstants
import com.mirrorfly.mirrorfly_plugin.FlyTranslations
import com.mirrorflysdk.utils.MediaUtils
import com.mirrorflysdk.utils.ThumbSize
import com.mirrorflysdk.utils.UpDateWebPassword
import com.mirrorflysdk.utils.Utils
import com.mirrorflysdk.utils.VideoRecUtils
import com.mirrorflysdk.xmpp.FlyXMPP
import com.mirrorflysdk.xmpp.chat.models.CreateGroupModel
import com.mirrorflysdk.xmpp.chat.models.Profile
import io.flutter.Log
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import org.json.JSONArray
import org.json.JSONObject
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileWriter
import java.io.IOException
import java.util.Locale

class FlyChatMethods {
    val tag = "#FlyChatMethods"

    fun getAvailableFeatures(call: MethodCall, result: MethodChannel.Result) {
        try {
            val availableFeatures = ChatManager.getAvailableFeatures().toJsonString()
            LogMessage.d("getAvailableFeatures", availableFeatures)
            result.success(availableFeatures)
        } catch (e: Exception) {
            result.error("500", e.message, e)
        }

    }

    fun createTopic(call: MethodCall, result: MethodChannel.Result) {
        val topicName = call.argument<String>("topicName") ?: ""
        val metaData = call.argument<List<Map<String, Any>>>("metaData") ?: arrayListOf()
        LogMessage.d("createTopic", metaData.toString())
        /*if(topicName.isNullOrEmpty()){
            return
        }
        if(metaData.isNullOrEmpty()){
            return
        }*/
        val meta = extractMetaData(metaData)

        ChatManager.createTopic(topicName, meta) { isSuccess, throwable, data ->
            LogMessage.d("createTopic", "$isSuccess : $data")
            if (isSuccess) {
                val topic = data["data"] as JSONObject
                val topicId = topic.get("topicId")
                LogMessage.d("topicId", "$topicId")
                result.success(topicId)
            } else {
                result.error("807", throwable?.message, null)
            }
        }
        //a00251d7-d388-4f47-8672-553f8afc7e11
    }

    fun getTopics(call: MethodCall, result: MethodChannel.Result) {
        val topicIds = call.argument<List<String>>("topicIds")
        LogMessage.d("topicIds", topicIds.toString())
        ChatManager.getTopics(topicIds as ArrayList<String>) { isSuccess, throwable, data ->
            LogMessage.d("getTopics", "$isSuccess : $data")
            //D/getTopics(22473): true : {data={"topics":[{"topicName":"New Topic saravanakumar","topicId":"a00251d7-d388-4f47-8672-553f8afc7e11","metaData":{"key1":"value1"}}]}, http_status_code=200, message=Data retrieved successfully}
            if (isSuccess) {
                val resultData = (data["data"] as JSONObject)
                val topics = resultData.get("topics")
                LogMessage.d("getTopics", topics.toString())
                //handle success
                result.success(topics.toString())
            } else {
                result.error("807", throwable?.message, null)
                // print throwable to find the exception details.
            }
        }
    }

    private fun extractMetaData(data: List<Map<String, Any>>): List<MetaData> {
        val extractedData = ArrayList<MetaData>()
        data.forEach {
            extractedData.add(MetaData(it["key"] as String, it["value"] as String))
        }
        LogMessage.d("extractMetaData", "$data : ${extractedData.toJsonString()}")
        return extractedData
    }

    fun getManifestValue(call: MethodCall, result: MethodChannel.Result) {
        val find = call.argument<String>("key")
        if (find.isNullOrEmpty()) {
            result.error("500", "key must not be null or Empty", "")
        } else {
            val ai: ApplicationInfo =
                MirrorFlyManager.getContext().packageManager //ChatManager.applicationContext.packageManager
                    .getApplicationInfo(
                        MirrorFlyManager.getContext().packageName,
                        PackageManager.GET_META_DATA
                    )//ChatManager.applicationContext.packageName
            val value = ai.metaData[find]//ai.metaData["com.google.android.geo.API_THUMP_KEY"]
//            val key = value
            /*return ("https://maps.googleapis.com/maps/api/staticmap?center=" + latitude + "," + longitude
                + "&zoom=13&size=300x200&markers=color:red|" + latitude + "," + longitude + "&key="
                + key)*/
            if (value != null) {
                result.success(value.toString())
            } else {
//                result.success("")
                result.error("500", "$find key not found in AndoidManifest file", "")
            }
        }
    }

    fun buildChatSDK(call: MethodCall, result: MethodChannel.Result) {
        val domainBaseUrl: String? = call.argument("domainBaseUrl")
        val storageFolderName: String? = call.argument("storageFolderName")
        val licenseKey: String? = call.argument("licenseKey")
        val enableMobileNumberLogin: Boolean? = call.argument("enableMobileNumberLogin")
        val isTrialLicenceKey = call.argument("isTrialLicenceKey") ?: true
        val maximumRecentChatPin: Int? = call.argument("maximumRecentChatPin")
//    val enableGroup : Boolean = call.argument("enableGroup") ?: true
        val groupConfig: HashMap<String, Any?>? = call.argument("groupConfig")
//    val useProfileName : Boolean? = call.argument("useProfileName")
        val ivKey: String? = call.argument("ivKey")
        val enableSDKLog: Boolean = call.argument("enableDebugLog") ?: false
        val chatHistoryEnable: Boolean = call.argument("chatHistoryEnable") ?: false
        val enableAndroidCallKitUI: Boolean = call.argument("enableAndroidCallKitUI") ?: true
        LogMessage.enableDebugLogging(enableSDKLog)
        LogMessage.d("buildChatSDK", call.arguments.toString())
        /*GroupManager.setNameHelper(object  : NameHelper {
            override fun getDisplayName(jid: String): String {
                return if (ContactManager.getProfileDetails(jid) != null) ContactManager.getProfileDetails(jid)!!.name else Constants.EMPTY_STRING
            }
        })*/
        val buildSDK = ChatSDK.Builder()
        CallManager.disableIncomingCallRingtone(!enableAndroidCallKitUI)
        SharedPreferenceManager.instance.storeBoolean(
            MirrorFlyPreferenceUtils.ENABLE_ANDROID_CALL_KIT_UI,
            enableAndroidCallKitUI
        )
//    if(enableGroup){
        val groupConfiguration = GroupConfig.Builder()
            .enableGroupCreation(true)
            .setMaximumMembersInAGroup(200)
            .onlyAdminCanAddOrRemoveMembers(true)
            .build()
        buildSDK.setGroupConfiguration(groupConfiguration)
//    }
        if (groupConfig != null) {
            val groupConfiguration1 = GroupConfig.Builder()
                .enableGroupCreation(groupConfig.get("enableGroup") as Boolean)
                .setMaximumMembersInAGroup(groupConfig.get("maxMembersCount") as Int)
                .onlyAdminCanAddOrRemoveMembers(groupConfig.get("adminOnlyAddRemoveAccess") as Boolean)
                .build()
            buildSDK.setGroupConfiguration(groupConfiguration1)
        }
        LogMessage.d("enable chat history", chatHistoryEnable.toString())
        ChatManager.enableChatHistory(chatHistoryEnable)
        if (storageFolderName != null) {
            ChatManager.setMediaFolderName(storageFolderName)
        }
        if (maximumRecentChatPin != null) {
            buildSDK.setMaximumPinningForRecentChat(maximumRecentChatPin)
        }
        /*if(useProfileName!=null){
      ChatSDK.Builder().useProfileName(useProfileName);
    }*/
        if (ivKey != null) {
            ChatManager.setMessageIVKey(ivKey)
        }

        if (domainBaseUrl != null && licenseKey != null) {
            buildSDK.setDomainBaseUrl(domainBaseUrl)
                .setLicenseKey(licenseKey)
                .setIsTrialLicenceKey(isTrialLicenceKey)
        }
        buildSDK.build()

        /// Do not move this code inside the  buildSDK.build() method. ///

        if (enableMobileNumberLogin != null) {
            ChatManager.enableMobileNumberLogin(enableMobileNumberLogin)
        }

        /// ----- ///

        //Set Name based on the Profile data
        //if not set you will get error on email chat(export) and any group related actions
        GroupManager.setNameHelper(object : NameHelper {
            override fun getDisplayName(jid: String): String {
                return if (ContactManager.getProfileDetails(jid) != null) ContactManager.getProfileDetails(
                    jid
                )!!.getDisplayName() else Constants.EMPTY_STRING
            }
        })
        Logger.enableDebugLogging(enableSDKLog)
        FlyCallMethods().initCall()
    }

    fun buildInitializeSDK(call: MethodCall, result: MethodChannel.Result) {

        val licenseKey: String = call.argument("licenseKey") ?: ""
        val chatHistoryEnable: Boolean = call.argument("chatHistoryEnable") ?: false
        val storageFolderName: String? = call.argument("storageFolderName")
        val enableMobileNumberLogin: Boolean? = call.argument("enableMobileNumberLogin")
        val enableSDKLog: Boolean = call.argument("enableDebugLog") ?: false
        val enablePrivateStorage: Boolean = call.argument("enablePrivateStorage") ?: false
        val enableAndroidCallKitUI: Boolean = call.argument("enableAndroidCallKitUI") ?: true

        if (storageFolderName != null) {
            ChatManager.setMediaFolderName(storageFolderName)
        }
        if (enableMobileNumberLogin != null) {
            ChatManager.enableMobileNumberLogin(enableMobileNumberLogin)
        }

        LogMessage.enableDebugLogging(enableSDKLog)
        Logger.enableDebugLogging(enableSDKLog)
        CallManager.enableDebugLogs(enableSDKLog)
        ChatManager.enableChatHistory(chatHistoryEnable)
        ChatManager.enablePrivateStorage(enablePrivateStorage)
        CallManager.enableCallLogExport(enableSDKLog)
        ChatManager.enableDebugLogging(enableSDKLog)
        CallManager.disableIncomingCallRingtone(!enableAndroidCallKitUI)

        SharedPreferenceManager.instance.storeBoolean(
            MirrorFlyPreferenceUtils.ENABLE_ANDROID_CALL_KIT_UI,
            enableAndroidCallKitUI
        )

        FlyCallMethods().initCall()

        ChatManager.initializeSDK(licenseKey) { isSuccess, throwable, data ->
            if (isSuccess) {
                LogMessage.d(tag, "initializeSDK success")
                result.success(true)
            } else {
                //when internet is not connected the sdk returns false so here we check base url is empty or not so that we return true based on that
                if(ChatManager.getBaseURL()?.isNotEmpty() == true){
                    result.success(true)
                }else {
                    LogMessage.d(tag, "initializeSDK failed with error message " + data["message"])
                    result.error("500", "SDK failed to Initialize", throwable)
                }
            }
        }
    }

    fun privateStorageEnabled(call: MethodCall, result: MethodChannel.Result){
        result.success(ChatManager.isPrivateStorageEnable())
    }

    private var fromCallNotification: Boolean = false
    fun appLaunchedFromMissedCall(call: MethodCall, result: MethodChannel.Result) {
        val fromCall = fromCallNotification
        fromCallNotification = false
        Log.d("appLaunchedFromMissedCall", fromCall.toString())
        result.success(fromCall)
    }

    fun getPlatformVersion(call: MethodCall, result: MethodChannel.Result) {
        result.success("Android ${Build.VERSION.RELEASE}")
    }

    /// Get The Build Flavor config.
    /*private fun getFlavor(result: Result) {
    flutterActivity?.let {
      val pack = it.localClassName.split(".").dropLast(1).joinToString(".")
      val flavor =
        Class.forName(pack.plus(".BuildConfig")).getField("FLAVOR").get(null) as String
      result.success(flavor)
    } ?: run {
      result.success(null)
    }
  }*/

    fun registerUser(call: MethodCall, result: MethodChannel.Result) {
        if (!call.hasArgument("userIdentifier")) {
            result.error("404", "User Mobile Number Required", null)
        } else {
            val userIdentifier: String? = call.argument("userIdentifier")
            val token: String = call.argument("token") ?: ""
            val isForceRegister: Boolean = call.argument("isForceRegister") ?: true
            val userType: String = call.argument("userType") ?: ""
            LogMessage.d("isForceRegister", isForceRegister.toString())
            val metaData = call.argument<List<Map<String, Any>>>("metaData") ?: arrayListOf()
            LogMessage.d("registerUser", call.arguments.toString())
            val metaDataList = extractMetaData(metaData)
            if (userIdentifier != null) {
                if (FlyXMPP.isConnected()) {
                    ChatManager.disconnect()
                }
                FlyCore.registerUser(
                    userIdentifier,
                    token, isForceRegister,
                    userType = userType,
                    metaData = metaDataList
                ) { isSuccess: Boolean, throwable: Throwable?, data: HashMap<String?, Any?> ->
                    if (isSuccess) {

                        val response = JSONObject(data).toString()
                        LogMessage.d("FlyCore.registerUser", data.toJsonString())
                        if (token.isNotEmpty()) {
                            PushNotificationManager.updateFcmToken(
                                token,
                                object : ChatActionListener {
                                    override fun onResponse(
                                        isSuccess: Boolean,
                                        message: String
                                    ) {
                                        if (isSuccess) {
                                            //LogMessage.d( "RESPONSE_CAPTURE","===========================")
                                            //DebugUtilis.v("updateFcmToken", message)
                                            LogMessage.e(tag, "Token updated successfully")
                                        }
                                    }
                                })
                        }
                        CallLogManager.setCallLogsListener(MirrorFlyManager.getFlyChatInstance())
                        /*ChatEventsManager.setupMessageEventListener(instance)
                        ChatEventsManager.attachProfileEventsListener(instance)
                        ChatEventsManager.attachGroupEventsListener(instance)
                        ChatEventsManager.attachLoginEventsListener(instance)
                        ChatEventsManager.attachTypingEventListener(instance)
                        CallLogManager.setCallLogsListener(instance)
                        ChatManager.setAvailableFeaturesCallback(instance)
                        CallManager.setMissedCallListener(instance)*/
                        SharedPreferenceManager.instance.storeBoolean("isRegistered", true)
                        if(FlyXMPP.isConnected()) {
                            LogMessage.d("RegisterUser", "Chat Manager connected and authenticated")
//                            GroupManager.getAllGroups(true) { isSuccess, throwable, data -> }
                            result.success(response)
                        }else{
                            ChatManager.setConnectionListener(object : ChatConnectionListener {
                                override fun onConnected() {
                                    LogMessage.d("RegisterUser", "Chat Manager onConnected")
                                    FlyCore.getBusySettingsStatusFromServer()
                                    FlyCore.getArchivedSettingsStatusFromServer()
                                    FlyCore.getArchivedChatsFromServer()
//                                    GroupManager.getAllGroups(true) { isSuccess, throwable, data ->
//                                    }
//                                    Handler(Looper.getMainLooper()).postDelayed({
                                        result.success(response)
//                                    }, 500)

                                }

                                override fun onConnectionFailed(e: FlyException) {
                                    LogMessage.d("RegisterUser", "Chat Manager onConnectionFailed")
//                                FlutterChatConnection.setListener(null)
                                    result.error(
                                        "500",
                                        e.message,
                                        null
                                    )
                                }

                                override fun onDisconnected() {
                                    LogMessage.d("RegisterUser", "Chat Manager Disconnected")
                                }

                                override fun onReconnecting() {
                                    LogMessage.d("RegisterUser", "Chat Manager onReconnecting")
                                }

                            })
                        }
                    } else {
                        if (data["http_status_code"] == 403) {
                            result.error("403", throwable?.message.toString(), null)
                        } else if (data["http_status_code"] == 405) {
                            result.error("405", data["message"].toString(), null)
                        } else {
                            result.error("500", data["message"].toString(), null)
                        }
                    }
                }
            } else {
                result.error("404", "User Identifier empty", "")
            }
        }
    }

    fun getMetaData(call: MethodCall, result: MethodChannel.Result) {
        ChatManager.getMetaData { isSuccess, throwable, data ->
            if (isSuccess) {
                val metaDataList: ArrayList<MetaData> = data["data"] as ArrayList<MetaData>
                //update the UI
                //[{"key":"key","value":"value"}]
                result.success(metaDataList.toJsonString())
            } else {
                //Fetching metaData value failed print throwable to find the exception details.
                result.error("500", "failed to get user metaData", throwable ?: data)
            }
        }
    }

    fun updateMetaData(call: MethodCall, result: MethodChannel.Result) {
        val metaData = call.argument<List<Map<String, Any>>>("metaData") ?: arrayListOf()
        LogMessage.d("updateMetaData", call.arguments.toString())
        val metaDataList = extractMetaData(metaData)
        ChatManager.updateMetaData(metaDataList) { isSuccess, throwable, data ->
            if (isSuccess) {
                val updatedMetaDataList: ArrayList<MetaData> = data["data"] as ArrayList<MetaData>
                //update the UI
                //[{"key":"key","value":"value"}]
                result.success(updatedMetaDataList.toJsonString())
            } else {
                //Fetching metaData value failed print throwable to find the exception details.
                result.error("500", "failed to get user metaData", throwable ?: data)
            }
        }
    }


    fun setRegionCode(call: MethodCall, result: MethodChannel.Result) {
        val regionCode = call.argument<String?>("regionCode") ?: "IN"
        ChatManager.setUserCountryISOCode(regionCode)
        SharedPreferenceManager.instance.storeString(
            SharedPreferenceManager.COUNTRY_CODE,
            regionCode
        )
        LogMessage.d("regionCode", ChatManager.getUserCountryISOCode())
    }

    fun setDefaultNotificationSound(call: MethodCall, result: MethodChannel.Result) {
        val default = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION).toString()
        setNotificationUri(default)
    }

    fun getJidFromPhoneNumber(call: MethodCall, result: MethodChannel.Result) {
        val mobileNumber = call.argument<String>("mobileNumber") ?: ""
        val countryCode = call.argument<String>("countryCode") ?: ""
        val userJID =
            Utils.getJidFromPhoneNumber(MirrorFlyManager.getContext(), mobileNumber, countryCode)
        result.success(userJID ?: "")
    }

    fun getUnsentMessageOfAJid(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        val data = FlyMessenger.getUnsentMessageOfAJid(jid)
        result.success(data)
    }

    fun getUnsentMessageOf(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        val data = FlyMessenger.getUnsentMessageOf(jid)
        result.success(data.toJsonString())
    }

    fun saveUnsentMessage(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        val texMessage = call.argument<String>("texMessage") ?: ""
        val mentionedUsers = call.argument<List<String>>("mentionedUsers") ?: arrayListOf()
        FlyMessenger.saveUnsentMessage(jid, texMessage, mentionedUsers = mentionedUsers)
    }

    fun setMediaAutoDownload(call: MethodCall, result: MethodChannel.Result) {
        val enable = call.argument<Boolean>("enable") ?: false
        //Auto download settings changed this method is not working so i commented
//    SharedPreferenceManager.instance.storeBoolean(SharedPreferenceManager.MEDIA_AUTO_DOWNLOAD,enable)
        val mediaAutoDownlod = MediaAutoDownloadOption()
        val autoDownloadSettings = FlyMessenger.getMediaAutoDownloadOptions()
        mediaAutoDownlod.autoDownloadEnabled = enable
        mediaAutoDownlod.downloadDocumentsOnMobileData =
            autoDownloadSettings.downloadDocumentsOnMobileData
        mediaAutoDownlod.downloadPhotosOnMobileData =
            autoDownloadSettings.downloadPhotosOnMobileData
        mediaAutoDownlod.downloadVideosOnMobileData =
            autoDownloadSettings.downloadVideosOnMobileData
        mediaAutoDownlod.downloadAudiosOnMobileData =
            autoDownloadSettings.downloadAudiosOnMobileData
        mediaAutoDownlod.downloadDocumentsOnWifiData =
            autoDownloadSettings.downloadDocumentsOnWifiData
        mediaAutoDownlod.downloadPhotosOnWifiData = autoDownloadSettings.downloadPhotosOnWifiData
        mediaAutoDownlod.downloadVideosOnWifiData = autoDownloadSettings.downloadVideosOnWifiData
        mediaAutoDownlod.downloadAudiosOnWifiData = autoDownloadSettings.downloadAudiosOnWifiData
        FlyMessenger.setMediaAutoDownloadOptions(mediaAutoDownlod)
    }

    fun getMediaAutoDownload(call: MethodCall, result: MethodChannel.Result) {
        //Auto download settings changed this method is not working so i commented
//      val enable = SharedPreferenceManager.instance.getBoolean(SharedPreferenceManager.MEDIA_AUTO_DOWNLOAD)
        val enable = FlyMessenger.getMediaAutoDownloadOptions()
        result.success(enable.autoDownloadEnabled)
    }

    fun saveMediaSettings(call: MethodCall, result: MethodChannel.Result) {
        val photos = call.argument<Boolean>("Photos") ?: false
        val videos = call.argument<Boolean>("Videos") ?: false
        val audio = call.argument<Boolean>("Audio") ?: false
        val documents = call.argument<Boolean>("Documents") ?: false
        val networkType = call.argument<Int>("NetworkType") ?: 0
        //Auto download settings changed this method is not working so i commented
        /*val settingsUtil = SettingsUtil()
    val mobileDataSettingsModel = MediaDownloadSettingsModel()
    mobileDataSettingsModel.isShouldAutoDownloadPhotos = Photos
    mobileDataSettingsModel.isShouldAutoDownloadVideos = Videos
    mobileDataSettingsModel.isShouldAutoDownloadAudios = Audio
    mobileDataSettingsModel.isShouldAutoDownloadDocuments = Documents
    mobileDataSettingsModel.dataConnectionNetworkType = NetworkType // 0 is TYPE_MOBILE , 1 is TYPE_WIFI
    println("call ${call.arguments}")
    settingsUtil.saveMediaSettings(mobileDataSettingsModel)*/
        val autoDownloadSettings = FlyMessenger.getMediaAutoDownloadOptions()
        val mediaAutoDownlod = MediaAutoDownloadOption()
        mediaAutoDownlod.autoDownloadEnabled = true
        mediaAutoDownlod.downloadDocumentsOnMobileData =
            if (networkType == 0) documents else autoDownloadSettings.downloadDocumentsOnMobileData
        mediaAutoDownlod.downloadPhotosOnMobileData =
            if (networkType == 0) photos else autoDownloadSettings.downloadPhotosOnMobileData
        mediaAutoDownlod.downloadVideosOnMobileData =
            if (networkType == 0) videos else autoDownloadSettings.downloadVideosOnMobileData
        mediaAutoDownlod.downloadAudiosOnMobileData =
            if (networkType == 0) audio else autoDownloadSettings.downloadAudiosOnMobileData
        mediaAutoDownlod.downloadDocumentsOnWifiData =
            if (networkType == 1) documents else autoDownloadSettings.downloadDocumentsOnWifiData
        mediaAutoDownlod.downloadPhotosOnWifiData =
            if (networkType == 1) photos else autoDownloadSettings.downloadPhotosOnWifiData
        mediaAutoDownlod.downloadVideosOnWifiData =
            if (networkType == 1) videos else autoDownloadSettings.downloadVideosOnWifiData
        mediaAutoDownlod.downloadAudiosOnWifiData =
            if (networkType == 1) audio else autoDownloadSettings.downloadAudiosOnWifiData
        FlyMessenger.setMediaAutoDownloadOptions(mediaAutoDownlod)
    }

    fun downloadMedia(call: MethodCall, result: MethodChannel.Result) {
        val mediaId =
            if (call.argument<String>("mediaMessage_id") == null) "" else call.argument<String?>(
                "mediaMessage_id"
            )
                .toString()
        FlyMessenger.downloadMedia(mediaId)
    }

    fun getMediaSetting(call: MethodCall, result: MethodChannel.Result) {
        val networkType = call.argument<Int>("NetworkType") ?: 0
        val type = call.argument<String>("type") ?: ""
        //Auto download settings changed this method is not working so i commented
        /*val settingsUtil = SettingsUtil()
    val net = if (NetworkType==0) SharedPreferenceManager.CONNECTION_TYPE_MOBILE else SharedPreferenceManager.CONNECTION_TYPE_WIFI
    when(type){
      "Photos" -> result.success(settingsUtil.getMediaSetting(net).isShouldAutoDownloadPhotos)
      "Videos" -> result.success(settingsUtil.getMediaSetting(net).isShouldAutoDownloadVideos)
      "Audio" -> result.success(settingsUtil.getMediaSetting(net).isShouldAutoDownloadAudios)
      "Documents" -> result.success(settingsUtil.getMediaSetting(net).isShouldAutoDownloadDocuments)
      "" -> result.success(false)
    }*/
        val option = FlyMessenger.getMediaAutoDownloadOptions()
        when (type) {
            "Photos" -> result.success(if (networkType == 0) option.downloadPhotosOnMobileData else option.downloadPhotosOnWifiData)
            "Videos" -> result.success(if (networkType == 0) option.downloadVideosOnMobileData else option.downloadVideosOnWifiData)
            "Audio" -> result.success(if (networkType == 0) option.downloadAudiosOnMobileData else option.downloadAudiosOnWifiData)
            "Documents" -> result.success(if (networkType == 0) option.downloadDocumentsOnMobileData else option.downloadDocumentsOnWifiData)
            "" -> result.success(false)
        }

    }

    fun updateMediaDownloadStatus(call: MethodCall, result: MethodChannel.Result) {
        val mediaMessageId = call.argument<String>("mediaMessageId") ?: ""
        val progress = call.argument<Int>("progress") ?: 0
        val downloadStatus = call.argument<Int>("downloadStatus") ?: 0
        val dataTransferred = call.argument<Long>("dataTransferred") ?: 0L
        FlyMessenger.updateMediaDownloadStatus(
            mediaMessageId,
            progress,
            dataTransferred,
            downloadStatus
        )
    }

    fun updateMediaUploadStatus(call: MethodCall, result: MethodChannel.Result) {
        val mediaMessageId = call.argument<String>("mediaMessageId") ?: ""
        val progress = call.argument<Int>("progress") ?: 0
        val uploadStatus = call.argument<Int>("uploadStatus") ?: 0
        val dataTransferred = call.argument<Long>("dataTransferred") ?: 0L
        FlyMessenger.updateMediaUploadStatus(
            mediaMessageId,
            progress,
            dataTransferred,
            uploadStatus
        )
    }

    fun cancelMediaUploadOrDownload(call: MethodCall, result: MethodChannel.Result) {
        val messageId = call.argument<String>("messageId") ?: ""
        FlyMessenger.cancelMediaUploadOrDownload(messageId)
    }

    fun setMediaEncryption(call: MethodCall, result: MethodChannel.Result) {
        val encryption = call.argument<Boolean>("encryption") ?: true
        ChatManager.setMediaEncryption(encryption)
    }

    fun deleteAllMessages(call: MethodCall, result: MethodChannel.Result) {
        FlyMessenger.deleteAllMessages()
    }

    fun getGroupJid(call: MethodCall, result: MethodChannel.Result) {
        val groupID = call.argument<String>("groupId") ?: ""
        result.success(FlyUtils.getGroupJid(groupID))
    }

    fun getProfileDetails(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument("jid") ?: ""
        val profileDetails = ContactManager.getProfileDetails(jid)
        if (profileDetails != null) {
            //LogMessage.d("RESPONSE_CAPTURE", "===========================")
            //DebugUtilis.v("ContactManager.getProfileDetails", profileDetails.tojsonString())
            LogMessage.d("#MF_Profile L: getProfileDetails", profileDetails.toJsonString())
            result.success(profileDetails.toJsonString())
        } else {
            if (GroupManager.isValidGroupJid(jid)){
                LogMessage.d("#MF_Profile#", "getGroupProfile $jid")
                GroupManager.getGroupProfile(jid, true) { isSuccess, throwable, data ->
                    if (isSuccess) {
                        val groupProfileDetails: ProfileDetails = data["data"] as ProfileDetails
                        LogMessage.d("#MF_Profile S: getGroupProfile", groupProfileDetails.toJsonString())
//                        result.success(groupProfileDetails.toJsonString())
                        val profile = ContactManager.getProfileDetails(jid)
                        if (profile != null) {
                            LogMessage.d("#MF_Profile S:I : getGroupProfile", profile.toJsonString())
                            result.success(profile.toJsonString())
                        }else{
                            LogMessage.d("#MF_Profile S:I : getGroupProfile", "Profile is null")
                            result.error("500", "Group Profile fetch failed", "Unable to fetch group profile, after fetching from server")
                        }
                    } else {
                        // Group creation failed print throwable to find the exception details.
                        LogMessage.d("#MF_Profile S: getGroupProfile", throwable.toString())
                        result.error("500", throwable?.message, throwable)
                    }
                }
            }else {
                LogMessage.d("#MF_Profile#", "getUserProfile $jid")
                ContactManager.getUserProfile(jid, true, true, object : FlyCallback {
                    override fun flyResponse(
                        isSuccess: Boolean,
                        throwable: Throwable?,
                        data: HashMap<String, Any>
                    ) {
                        LogMessage.d("#MF_Profile S: getUserProfile", data.toJsonString())
                        val profile = ContactManager.getProfileDetails(jid)
                        if (profile != null) {
                            LogMessage.d("#MF_Profile S:I : getUserProfile", profile.toJsonString())
                            result.success(profile.toJsonString())
                        }else{
                            LogMessage.d("#MF_Profile S:I : getUserProfile", "Profile is null")
                            result.error("500", "Profile fetch failed", "Unable to fetch profile, after fetching from server")
                        }
                    }
                })
            }
        }
    }

    fun createOfflineGroupInOnline(call: MethodCall, result: MethodChannel.Result) {
        val groupId = call.argument<String>("groupId") ?: ""
        GroupManager.createOfflineGroupInOnline(groupId) { isSuccess, throwable, data ->
            if (isSuccess) {
                result.success(isSuccess)
            } else {
                result.error("500", throwable?.message, "")
            }
            /*if (isSuccess) {
          // Group created in server update the UI
      } else {
          // Group creation failed print throwable to find the exception details.
          result.error("500", throwable!!.message, throwable)
      }*/
        }
    }

    fun updateFcmToken(call: MethodCall, result: MethodChannel.Result) {
        val token = call.argument<String>("token") ?: ""
        PushNotificationManager.updateFcmToken(token, object : ChatActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                if (isSuccess) {
                    result.success(isSuccess)
                } else {
                    result.error("500", message, "")
                }
            }
        })
    }

    fun getUnreadMessageCountExceptMutedChat(call: MethodCall, result: MethodChannel.Result) {
        result.success(FlyMessenger.getUnreadMessageCountExceptMutedChat())
    }

    fun handleReceivedMessage(call: MethodCall, result: MethodChannel.Result) {
        val notificationdata = call.argument<Map<String, String>>("notificationdata") ?: mapOf()
        //LogMessage.d("===notificationdata===",notificationdata.toString())
        PushNotificationManager.handleReceivedMessage(notificationdata, object :
            NotificationEventListener {
            override fun onMessageReceived(chatMessage: ChatMessage) {
                LogMessage.d("push onMessageReceived", chatMessage.toJsonString())
                //Here you need to fetch recent unread messages to build up notification content
                //LogMessage.d("notificationdata",chatMessage.tojsonString())
                /*val jsonObject = JSONObject()
                jsonObject.put("groupJid", "")
                jsonObject.put("titleContent", "")
                jsonObject.put("chatMessage", JSONObject(chatMessage.toJson()))
                jsonObject.put("cancel", false)
                result.success(jsonObject.toString())*/
                result.success(chatMessage.toJsonString())
            }

            override fun onGroupNotification(
                groupJid: String,
                titleContent: String,
                chatMessage: ChatMessage
            ) {
                LogMessage.d(
                    "push onGroupNotification",
                    "groupJid $groupJid titleContent $titleContent chatMessage ${chatMessage.toJsonString()}"
                )
                /* Create the notification for group creation with paramter values */
                //LogMessage.d("notificationdata group",chatMessage.tojsonString())
                /*val jsonObject = JSONObject()
                jsonObject.put("groupJid", groupJid)
                jsonObject.put("titleContent", titleContent)
                jsonObject.put("chatMessage", JSONObject(chatMessage.toJson()))
                jsonObject.put("cancel", false)
                result.success(jsonObject.toString())*/
                result.success(chatMessage.toJsonString())
            }

            override fun onCancelNotification() {
                // here you have to cancel notification
                //LogMessage.d("notificationdata","cancel")
                /*val jsonObject = JSONObject()
                jsonObject.put("groupJid", "")
                jsonObject.put("titleContent", "")
                jsonObject.put("chatMessage", "")
                jsonObject.put("cancel", true)
                result.success(jsonObject.toString())*/
            }

        })
    }

    fun prepareChatConversationToExport(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        FlyCore.prepareChatConversationToExport(jid) { isSuccess, throwable, data ->
            if (isSuccess) {
                val json = JSONObject()
                val res: ChatDataModel = data["data"] as ChatDataModel
                val mediaAttachmentUri = JSONArray()
                if (res.mediaAttachmentsUri.isNotEmpty()) {
                    res.mediaAttachmentsUri.forEach { item ->
//            mediaAttachmentUri.put("/storage/emulated/0/"+item.path!!.replace("external/","/storage/emulated/0/"))
                        val file = item.path?.let { File(it) }
                        mediaAttachmentUri.put(file?.let { convertToAbsolutePath(it.path) })//(file.path.toString().replace("external_files/","/storage/emulated/0/"))
                    }
                    json.put("subject", res.subject)
                    json.put("messageContent", res.messageContent)
                    json.put("mediaAttachmentsUrl", mediaAttachmentUri)
                    result.success(json.toString())
                } else {
                    result.success(json.toString())
                }
                // ChatDataModel has the every data to export the chat
            } else {
                //Exporting chat data failed print throwable to find the exception details.
                result.error("500", throwable?.message, throwable)
            }
        }
    }

    fun getCurrentAuthToken(call: MethodCall, result: MethodChannel.Result) {
        result.success(FlyUtils.decodedToken())
    }

    private fun convertToAbsolutePath(relativeFilePath: String): String {
        val externalStorageDirectoryPath = Environment.getExternalStorageDirectory().absolutePath
        return externalStorageDirectoryPath + relativeFilePath.replaceFirst(
            "/external_files".toRegex(),
            ""
        )
    }

    fun getArchivedChatList(call: MethodCall, result: MethodChannel.Result) {
        FlyCore.getArchivedChatList { isSuccess, throwable, data ->
            if (isSuccess) {
                val res: ArrayList<RecentChat> = data["data"] as ArrayList<RecentChat>
                result.success(data.toJsonString())
            } else {
                //Getting users blocked me list failed print throwable to find the exception details.
                result.error("500", throwable?.message, throwable)
            }
        }
    }

    fun updateChatMuteStatus(call: MethodCall, result: MethodChannel.Result) {
        LogMessage.d("updateChatMuteStatus", call.arguments.toString())
        val jid = call.argument<String>("jid") ?: ""
        val mute_status = call.argument<Boolean>("mute_status") ?: false
        if (GroupManager.isValidGroupJid(jid)) {
            GroupManager.updateGroupMuteStatus(jid, mute_status)
        } else {
            FlyCore.updateChatMuteStatus(jid, mute_status)
        }
        LogMessage.d("updateChatMuteStatus", "isMuted" + ChatManager.isMuted(jid))
    }

    fun updateChatMuteStatusList(call: MethodCall, result: MethodChannel.Result) {
        val jidList = call.argument<List<String>>("jidList") ?: arrayListOf()
        val muteStatus = call.argument<Boolean>("mute_status") ?: false
        try {
            ChatManager.updateChatMuteStatus(jidList, muteStatus)
        } catch (e : Exception) {
            val map = JSONObject()
            map.put("isSuccess", false)
            map.put("message", e.message)
            val jidListJsonArray = JSONArray(jidList)
            map.put("jidList", jidListJsonArray)
            map.put("muteStatus", muteStatus)
            FlyMethodConstants.updateChatSinkValue(
                Constants.onChatMuteStatusUpdatedChannel,
                map.toString()
            )
        }
    }

    fun sendTypingStatus(call: MethodCall, result: MethodChannel.Result) {
        val tojid = call.argument<String>("to_jid") ?: ""
        val type = call.argument<String>("chattype") ?: ""
        val chattype = getChatEnum(type)
        ChatManager.sendTypingStatus(tojid, chattype)
    }

    fun sendTypingGoneStatus(call: MethodCall, result: MethodChannel.Result) {
        val tojid = call.argument<String>("to_jid") ?: ""
        val type = call.argument<String>("chattype") ?: ""
        val chattype = getChatEnum(type)
        ChatManager.sendTypingGoneStatus(tojid, chattype)
    }

    fun enableDisableArchivedSettings(call: MethodCall, result: MethodChannel.Result) {
        val enable = call.argument<Boolean>("enable") ?: false
        FlyCore.enableDisableArchivedSettings(enable) { isSuccess, throwable, data ->
            if (isSuccess) {
                result.success(isSuccess)
            } else {
                result.error("500", throwable?.message, "")
            }
        }
    }

    fun updateArchiveUnArchiveChat(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        val enabled = call.argument<Boolean>("isArchived") ?: false
        FlyCore.updateArchiveUnArchiveChat(jid, enabled) { isSuccess, throwable, data ->
            if (isSuccess) {
                result.success(isSuccess)
            } else {
                result.error("500", throwable?.message, "")
            }
        }
    }

    fun deleteRecentChats(call: MethodCall, result: MethodChannel.Result) {
        val jidlist = call.argument<List<String>>("jidlist") ?: arrayListOf()
        ChatManager.deleteRecentChats(jidlist, object : ChatActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                if (isSuccess) {
                    result.success(isSuccess)
                } else {
                    result.error("500", message, "")
                }
            }

        })
    }

    fun markConversationAsRead(call: MethodCall, result: MethodChannel.Result) {
        val jidlist = call.argument<List<String>>("jidlist") ?: arrayListOf()
        FlyCore.markConversationAsRead(jidlist)
    }

    fun deleteUnreadMessageSeparatorOfAConversation(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        val JID: String = call.argument("jid") ?: ""
        FlyMessenger.deleteUnreadMessageSeparatorOfAConversation(JID)
        result.success(true)
    }

    fun getRecalledMessagesOfAConversation(call: MethodCall, result: MethodChannel.Result) {
        val JID: String = call.argument("jid") ?: ""
        val recalledMessages: List<ChatMessage> =
            FlyMessenger.getRecalledMessagesOfAConversation(JID)
        result.success(recalledMessages.toJsonString())
    }

    fun uploadMedia(call: MethodCall, result: MethodChannel.Result) {
        val messageid: String = call.argument("messageid") ?: ""
        FlyMessenger.uploadMedia(messageid)
        result.success(true)
    }

    fun markConversationAsUnread(call: MethodCall, result: MethodChannel.Result) {
        val jidlist = call.argument<List<String>>("jidlist") ?: arrayListOf()
        FlyCore.markConversationAsUnread(jidlist)
    }

    fun clearAllConversation(call: MethodCall, result: MethodChannel.Result) {
        ChatManager.clearAllConversation(object : ChatActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                if (isSuccess) {
                    result.success(isSuccess)
                } else {
                    result.error("500", message, "")
                }
            }

        })
    }

    fun insertBusyStatus(call: MethodCall, result: MethodChannel.Result) {
        val busyStatus = call.argument<String>("busy_status") ?: ""
        FlyCore.insertMyBusyStatus(busyStatus)
        FlyCore.setMyBusyStatus(
            busyStatus
        ) { isSuccess, throwable, p2 ->
            if (isSuccess) {
                result.success(isSuccess)
            } else {
                result.error("500", throwable?.message.toString(), throwable)
            }
        }
    }

    fun getDocsMessages(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        val docMessages = ChatManager.getDocsMessages(jid)
        //LogMessage.d("RESPONSE_CAPTURE", "===========================")
        //DebugUtilis.v("ChatManager.getDocsMessages", docMessages.tojsonString())
        result.success(docMessages.toJsonString())
    }

    fun getLinkMessages(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        val linkMessage = ChatManager.getLinkMessages(jid)
        //LogMessage.d("RESPONSE_CAPTURE", "===========================")
        //DebugUtilis.v("ChatManager.getLinkMessages", linkMessage.tojsonString())
        result.success(linkMessage.toJsonString())
    }

    fun isAdmin(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        val groupJid = call.argument<String>("group_jid") ?: ""
        val isAdmin =
            GroupManager.isAdmin(groupJid, jid)
        //DebugUtilis.v("GroupManager.isAdmin", isAdmin.toString())
        result.success(isAdmin)
    }

    fun getGroupProfile(call: MethodCall, result: MethodChannel.Result) {
        val groupJid = call.argument<String>("groupJid") ?: ""
        val server = call.argument<Boolean>("server") ?: false
        GroupManager.getGroupProfile(groupJid, server) { isSuccess, throwable, data ->
            if (isSuccess) {
                val groupProfileDetails: ProfileDetails = data["data"] as ProfileDetails
                result.success(groupProfileDetails.toJsonString())
            } else {
                // Group creation failed print throwable to find the exception details.
                result.error("500", throwable?.message, throwable)
            }
        }
    }

    fun getGroupMessageDeliveredToList(call: MethodCall, result: MethodChannel.Result) {
        val messageId = call.argument<String>("messageId") ?: ""
        GroupManager.getGroupMessageDeliveredToList(messageId) { isSuccess, throwable, data ->
            if (isSuccess) {
                val messageStatusList: List<MessageStatusDetail> =
                    data["data"] as List<MessageStatusDetail>
                val groupMessageDeliveredJsonObject = JSONObject()
                groupMessageDeliveredJsonObject.put(
                    "count",
                    messageStatusList.size.toString()
                )
                groupMessageDeliveredJsonObject.put(
                    "totalParticipantCount",
                    FlyMessenger.getGroupMessageStatusCount(messageId)
                )
                val jsArray = JSONArray(messageStatusList.toJson())
                groupMessageDeliveredJsonObject.put("participantList", jsArray)
                LogMessage.d("getGroupMessageDeliveredToList", data["data"]?.toJsonString())
                result.success(groupMessageDeliveredJsonObject.toString())
            } else {
                result.error("500", throwable?.message, throwable)
            }
        }
    }

    fun getGroupMessageReadByList(call: MethodCall, result: MethodChannel.Result) {
        val messageId = call.argument<String>("messageId") ?: ""
        GroupManager.getGroupMessageReadByList(messageId) { isSuccess, throwable, data ->
            if (isSuccess) {
                val messageStatusList: List<MessageStatusDetail> =
                    data["data"] as List<MessageStatusDetail>

                val groupMessageReadJsonObject = JSONObject()
                groupMessageReadJsonObject.put("count", messageStatusList.size.toString())
                groupMessageReadJsonObject.put(
                    "totalParticipantCount",
                    FlyMessenger.getGroupMessageStatusCount(messageId)
                )
                val jsArray = JSONArray(messageStatusList.toJson())
                groupMessageReadJsonObject.put("participantList", jsArray)
                LogMessage.d("getGroupMessageReadByList", data["data"]?.toJsonString())
                result.success(groupMessageReadJsonObject.toString())
            } else {
                result.error("500", throwable?.message, throwable)
            }
        }
    }

    private fun contactSyncState(call: MethodCall, result: MethodChannel.Result) {
        /*FlyCore.contactSyncState.observe(mContext) {
      when (it) {
        is com.contus.flycommons.Result.Error -> {
          result.error("500", it.exception.message, it.exception)
        }
        is com.contus.flycommons.Result.InProgress -> {
          result.success("InProgress")
        }
        is com.contus.flycommons.Result.Success -> {
          result.success("Success")
        }
      }

    };*/
    }

    fun revokeContactSync(call: MethodCall, result: MethodChannel.Result) {
        FlyCore.revokeContactSync { isSuccess, throwable, data ->
            if (isSuccess) {
                result.success(isSuccess)//(data.toJsonString())
            } else {
                result.error("500", throwable?.message, throwable)
            }
        }
    }

    fun getUsersWhoBlockedMe(call: MethodCall, result: MethodChannel.Result) {
        val server = call.argument<Boolean>("server") ?: false
        FlyCore.getUsersWhoBlockedMe(server) { isSuccess, throwable, data ->
            if (isSuccess) {
                val profilesList = data["data"] as ArrayList<ProfileDetails>
                result.success(profilesList.toJsonString())
            } else {
                result.error("500", throwable?.message, throwable)
            }
        }
    }

    fun getUnKnownUserProfiles(call: MethodCall, result: MethodChannel.Result) {
        val unknownProfilesList: List<ProfileDetails> = FlyCore.getUnKnownUserProfiles()
        result.success(unknownProfilesList.toJsonString())
    }

    fun getMyProfileStatus(call: MethodCall, result: MethodChannel.Result) {
        val myUserStatus: ProfileStatus = FlyCore.getMyProfileStatus()!!
        result.success(myUserStatus.toJsonString())
    }

    fun getMyBusyStatus(call: MethodCall, result: MethodChannel.Result) {
        val myBusyStatus: BusyStatus? = FlyCore.getMyBusyStatus()
        if (myBusyStatus != null) {
            LogMessage.d("myBusyStatus", myBusyStatus.toJsonString())
            result.success(myBusyStatus.toJsonString())
        } else {
            if (FlyCore.getBusyStatusList().isEmpty()) {
                val defaultStatus = arrayListOf<String>(
                    "Driving car. Text you later",
                    "Please call me if anything important",
                    "Sleeping",
                    "In meeting"
                )
                for (statusValue in defaultStatus) {
                    FlyCore.insertMyBusyStatus(statusValue)
                }
            }
            if (FlyCore.getMyBusyStatus() == null || FlyCore.getMyBusyStatus()!!.status.isEmpty()) {
                FlyCore.setMyBusyStatus("I am busy") { isSuccess, throwable, p2 -> }
            }
            result.success(FlyCore.getMyBusyStatus()!!.toJsonString())
        }
    }

    fun setMyBusyStatus(call: MethodCall, result: MethodChannel.Result) {
        val busyStatus = call.argument<String>("status") ?: ""
        FlyCore.setMyBusyStatus(
            busyStatus
        ) { isSuccess, throwable, p2 ->
            if (isSuccess) {
                result.success(isSuccess)
            } else {
                result.error("500", throwable?.message.toString(), throwable)
            }
        }
    }

    fun enableDisableBusyStatus(call: MethodCall, result: MethodChannel.Result) {
        val busyStatusEnable = call.argument<Boolean>("enable") ?: false
        FlyCore.enableDisableBusyStatus(
            busyStatusEnable
        ) { isSuccess, throwable, p2 ->
            if (isSuccess) {
                result.success(isSuccess)
            } else {
                result.error("500", throwable?.message.toString(), throwable)
            }
        }
    }

    fun getBusyStatusList(call: MethodCall, result: MethodChannel.Result) {
        val myBusyStatusList: List<BusyStatus> = FlyCore.getBusyStatusList()
        result.success(myBusyStatusList.toJsonString())
    }

    fun deleteProfileStatus(call: MethodCall, result: MethodChannel.Result) {
        val id = call.argument<String>("id") ?: "0"
        val status = call.argument<String>("status") ?: ""
        val isCurrentStatus = call.argument<Boolean>("isCurrentStatus") ?: false
        val profileStatus = ProfileStatus(id.toLong(), status, isCurrentStatus)
        FlyCore.deleteProfileStatus(profileStatus)
        result.success(true)
    }

    fun deleteBusyStatus(call: MethodCall, result: MethodChannel.Result) {
        val id = call.argument<String>("id") ?: "0"
        val status = call.argument<String>("status") ?: ""
        val isCurrentStatus = call.argument<Boolean>("isCurrentStatus") ?: false
        val profileStatus = BusyStatus(id.toLong(), status, isCurrentStatus)
        FlyCore.deleteBusyStatus(profileStatus)
        result.success(true)
    }

    fun isHideLastSeenEnabled(call: MethodCall, result: MethodChannel.Result) {
        result.success(FlyCore.isHideLastSeenEnabled())
    }

    fun enableDisableHideLastSeen(call: MethodCall, result: MethodChannel.Result) {
        val enable = call.argument<Boolean>("enable") ?: false
        FlyCore.enableDisableHideLastSeen(enable) { isSuccess, throwable, data ->
            if (isSuccess) {
                result.success(isSuccess)
            } else {
                result.error("500", throwable?.message, "")
            }
            /*if (isSuccess) {
      } else {
          result.error("500", throwable!!.message, throwable)
      }*/
        }
    }

    fun deleteMessagesForMe(call: MethodCall, result: MethodChannel.Result) {
        val userJID = call.argument<String>("jid")
        val chatType = call.argument<String>("chat_type")
        val isMediaDelete = call.argument<Boolean>("isMediaDelete") ?: false
        val messageIDList = call.argument<List<String>>("message_ids")
        if (userJID != null && messageIDList != null && chatType != null) {
            ChatManager.deleteMessagesForMe(
                userJID,
                messageIDList,
                getDeleteChatEnum(chatType),
                isMediaDelete,
                object : ChatActionListener {
                    override fun onResponse(isSuccess: Boolean, message: String) {
                        if (isSuccess) {
                            result.success(isSuccess)
                        } else {
                            result.error("500", message, "")
                        }
                    }

                })
        }
    }

    fun deleteMessagesForEveryone(call: MethodCall, result: MethodChannel.Result) {
        val userJID = call.argument<String>("jid")
        val chatType = call.argument<String>("chat_type")
        val isMediaDelete = call.argument<Boolean>("isMediaDelete") ?: false
        val messageIDList = call.argument<List<String>>("message_ids")
        if (userJID != null && messageIDList != null && chatType != null) {
            ChatManager.deleteMessagesForEveryone(
                userJID,
                messageIDList,
                getDeleteChatEnum(chatType),
                isMediaDelete,
                object : ChatActionListener {
                    override fun onResponse(isSuccess: Boolean, message: String) {
                        if (isSuccess) {
                            result.success(isSuccess)
                        } else {
                            result.error("500", message, "")
                        }
                    }
                })
        }
    }

    fun markAsRead(call: MethodCall, result: MethodChannel.Result) {
        val JID: String = call.argument("jid") ?: ""
        ChatManager.markAsRead(JID)
        result.success(true)
    }

    fun getAllGroups(call: MethodCall, result: MethodChannel.Result) {
        val server = call.argument<Boolean>("server") ?: false
        GroupManager.getAllGroups(server) { isSuccess, throwable, data ->
            if (isSuccess) {
                val profilesList = data["data"] as ArrayList<ProfileDetails>
                profilesList.let {
                    it.sortedBy { profileDetails -> profileDetails.name?.lowercase() }
                }
                //DebugUtilis.v("GroupManager.getAllGroups", data.tojsonString())
                result.success(profilesList.toJsonString())
            } else {
                result.error("500", throwable?.message, throwable)
            }
        }
    }

    fun getFavouriteMessages(call: MethodCall, result: MethodChannel.Result) {
        val favouriteMessages: List<ChatMessage> = FlyMessenger.getFavouriteMessages()
        //LogMessage.d("RESPONSE_CAPTURE", "===========================")
        //DebugUtilis.v("FlyMessenger.getFavouriteMessages", favouriteMessages.tojsonString())
        result.success(favouriteMessages.toJsonString())
    }


    fun unFavouriteAllFavouriteMessages(call: MethodCall, result: MethodChannel.Result) {
        ChatManager.unFavouriteAllFavouriteMessages(object : ChatActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                if (isSuccess) {
                    result.success(isSuccess)
                } else {
                    result.error("500", message, "")
                }
            }
        })

    }


    fun deleteAccount(call: MethodCall, result: MethodChannel.Result) {
        val deleteReason = call.argument("delete_reason") ?: ""
        val deleteFeedback = call.argument("delete_feedback") ?: ""
        FlyCore.deleteAccount(deleteReason, deleteFeedback) { isSuccess, throwable, data ->
            if (isSuccess) {
                //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                //DebugUtilis.v("FlyCore.deleteAccount", data.tojsonString())
//                result.success(data.toJsonString())
                result.success(true)
            } else {
                result.error("500", throwable?.message, throwable)
            }

        }
    }

    fun forwardMessagesToMultipleUsers(call: MethodCall, result: MethodChannel.Result) {

        val messageIDList = call.argument<List<String>>("message_ids")
        val userList = call.argument<List<String>>("userList")

        if (messageIDList != null && userList != null) {
            ChatManager.forwardMessagesToMultipleUsers(
                messageIDList,
                userList,
                object : ChatActionListener {
                    override fun onResponse(isSuccess: Boolean, message: String) {
                        if (isSuccess) {
                            //LogMessage.d("ChatManager.forwardMessagesToMultipleUsers", message)
                            result.success(true)
                        } else {
                            result.error("500", message, message)
                        }

                    }
                })
        }
    }

    fun forwardMessages(call: MethodCall, result: MethodChannel.Result) {
        val messageIDList = call.argument<List<String>>("message_ids")
        val tojid = call.argument<String>("to_jid")
        val type = call.argument<String>("chat_type")

        if (messageIDList != null && tojid != null && type != null) {
            val chatType = getChatEnum(type)
            ChatManager.forwardMessages(
                messageIDList,
                tojid,
                chatType,
                object : ChatActionListener {
                    override fun onResponse(isSuccess: Boolean, message: String) {
                        result.success(isSuccess)
                    }
                })
        }
    }

    fun updateFavouriteStatus(call: MethodCall, result: MethodChannel.Result) {
        val messageID = call.argument<String>("messageID")
        val chatUserJID = call.argument<String>("chatUserJID")
        val isFavourite = call.argument<Boolean>("isFavourite")

        if (messageID != null && chatUserJID != null && isFavourite != null) {
            ChatManager.updateFavouriteStatus(
                messageID,
                chatUserJID,
                isFavourite,
                object : ChatActionListener {
                    override fun onResponse(isSuccess: Boolean, message: String) {
                        if (isSuccess) {
                            //LogMessage.d("ChatManager.updateFavouriteStatus", message)
                            result.success(true)
                        } else {
                            result.error("500", "Unable to Favourite the Message", message)
                        }
                    }
                })
        }
    }

    fun getMessageStatusOfASingleChatMessage(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        val messageID = call.argument<String>("messageID")
        val messageStatus: ChatMessageStatusDetail? = messageID?.let {
            FlyMessenger.getMessageStatusOfASingleChatMessage(
                it
            )
        }
        if (messageStatus != null) {
            val messageStatusDetail = ChatMessageStatusDetail(
                messageStatus.messageId,
                messageStatus.sentTime.checkNullOrEmpty(),
                messageStatus.deliveredTime.checkNullOrEmpty(),
                messageStatus.seenTime.checkNullOrEmpty()
            )
            //LogMessage.d("RESPONSE_CAPTURE", "===========================")
            LogMessage.d(
                "FlyMessenger.getMessageStatusOfASingleChatMessage",
                messageStatus.toJsonString()
            )
            result.success(messageStatusDetail.toJsonString())
        } else {
            //LogMessage.d(TAG, "Message Info Error")
        }
    }

    fun deleteMessages(call: MethodCall, result: MethodChannel.Result) {

        val isDeleteForEveryOne = call.argument<Boolean>("is_delete_for_everyone")
        val userJID = call.argument<String>("jid")
        val chatType = call.argument<String>("chat_type")
        val messageIDList = call.argument<List<String>>("message_ids")
        if (userJID != null && messageIDList != null && chatType != null) {
            if (isDeleteForEveryOne!!) {
                //LogMessage.d(TAG, "Delete For EveryOne")
                ChatManager.deleteMessagesForEveryone(
                    userJID,
                    messageIDList,
                    getDeleteChatEnum(chatType),
                    false,
                    object : ChatActionListener {
                        override fun onResponse(isSuccess: Boolean, message: String) {
                            if (isSuccess) {
                                //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                                //DebugUtilis.v("ChatManager.deleteMessagesForEveryone", message)
                                result.success(message)
                            } else {
                                result.error("500", "Unable to Delete the Chat", message)
                            }
                        }

                    })
            } else {

                //LogMessage.d(TAG, "Delete For Me")
                ChatManager.deleteMessagesForMe(
                    userJID,
                    messageIDList,
                    getDeleteChatEnum(chatType),
                    false,
                    object : ChatActionListener {
                        override fun onResponse(isSuccess: Boolean, message: String) {
                            if (isSuccess) {
                                //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                                //DebugUtilis.v("ChatManager.deleteMessagesForMe", message)
                                result.success(message)
                            } else {
                                result.error("500", "Unable to Delete the Chat", message)
                            }
                        }

                    })
            }
        }
    }

    fun getMessagesUsingIds(call: MethodCall, result: MethodChannel.Result) {
        val messageIDList = call.argument<List<String>>("MessageIds") ?: arrayListOf()
        val messages = FlyMessenger.getMessagesUsingIds(messageIDList)
        result.success(messages.toJsonString())
    }

    fun reportUserOrMessages(call: MethodCall, result: MethodChannel.Result) {
        val userJID = call.argument<String>("jid")
        val chatType = call.argument<String>("chat_type")
        val selectedMessageID = call.argument<String>("selectedMessageID") ?: ""
        if (chatType != null && userJID != null) {
            FlyCore.reportUserOrMessages(
                userJID,
                chatType,
                selectedMessageID
            ) { isSuccess, throwable, data ->
                if (isSuccess) {
                    //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                    //DebugUtilis.v("FlyCore.reportUserOrMessages", data.tojsonString())
                    result.success(isSuccess)
                } else {
                    result.error("500", "Unable to report the User/Chat", throwable?.message)
                }
            }
        } else {
            result.error("500", "Parameters Missing", null)
        }
    }

    fun clearChat(call: MethodCall, result: MethodChannel.Result) {
        val userJID = call.argument<String>("jid")
        val chatType = call.argument<String>("chat_type")
        val clearExceptStarred = call.argument<Boolean>("clear_except_starred")
        if (userJID != null && chatType != null && clearExceptStarred != null) {
            ChatManager.clearChat(
                userJID,
                getChatEnum(chatType),
                clearExceptStarred,
                object : ChatActionListener {
                    override fun onResponse(isSuccess: Boolean, message: String) {
                        if (isSuccess) {
                            result.success(isSuccess)
                        } else {
                            result.error("500", message, "")
                        }
                    }
                })
        } else {
            result.error("500", "Parameters Missing", null)
        }
    }

    private fun getChatEnum(chatType: String): ChatTypeEnum {
        return when (chatType) {
            ChatType.TYPE_CHAT -> ChatTypeEnum.chat
            ChatType.TYPE_GROUP_CHAT -> ChatTypeEnum.groupchat
            else -> ChatTypeEnum.broadcast
        }
    }

    private fun getDeleteChatEnum(chatType: String): DeleteChatType {
        return when (chatType) {
            ChatType.TYPE_CHAT -> DeleteChatType.chat
            ChatType.TYPE_GROUP_CHAT -> DeleteChatType.groupchat
            else -> DeleteChatType.chat
        }
    }

    fun sendAudioMessage(call: MethodCall, result: MethodChannel.Result) {
        val userJID = call.argument<String>("jid")
        val audiofileUrl = call.argument<String>("audiofileUrl") ?: ""
        val filePath = call.argument<String>("filePath") ?: ""
        val audioFile = File(filePath)
        val replyMessageID = call.argument<String>("replyMessageId") ?: ""
        val isRecorded = call.argument<Boolean>("isRecorded")
        val duration = call.argument<String>("duration")?.toLong()
        val topicId = call.argument("topicId") ?: ""
        LogMessage.d("isRecorded", isRecorded.toString())
        val listener = object : SendMessageCallback {
            override fun onResponse(
                isSuccess: Boolean,
                error: Throwable?,
                chatMessage: ChatMessage?
            ) {
                if (chatMessage != null) {
                    //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                    //DebugUtilis.v("FlyMessenger.sendAudioMessage", chatMessage.tojsonString())
                    result.success(chatMessage.toJsonString())
                } else {
                    result.error("500", error?.message, error)
                }
            }
        }
        if (audioFile.exists()) {
            if (userJID != null && duration != null && isRecorded != null) {
                if (audiofileUrl.isNotEmpty()) {
                    val sendMessageParams = FileMessage().apply {
                        toId = userJID
                        this.topicId = topicId
                        messageType =
                            if (isRecorded) MessageType.AUDIO_RECORDED else MessageType.AUDIO
                        replyMessageId = replyMessageID //Optional
                        fileMessage = FileMessageParams().apply {
                            fileUrl = audiofileUrl
                            fileName = audioFile.name
                            this.duration = duration
                            this.localFilePath = filePath
                            this.fileSize = audioFile.length()
                        }
                    }
                    FlyMessenger.sendFileMessage(sendMessageParams, listener = listener)
                    /*FlyMessenger.sendAudioMessage(
                        userJID,
                        MediaData(
                            audioFile.name,
                            audioFile.length(),
                            audiofileUrl,
                            filePath,
                            duration = duration
                        ),
                        isRecorded,
                        replyMessageID,
                        listener
                    )*/
                    /*FlyMessenger.sendAudioMessage(
              userJID, audioFile.length(), audiofileUrl, filePath, duration, isRecorded,
              replyMessageID, listener
          )*/
                } else {
                    val sendMessageParams = FileMessage().apply {
                        toId = userJID
                        this.topicId = topicId
                        messageType =
                            if (isRecorded) MessageType.AUDIO_RECORDED else MessageType.AUDIO
                        this.replyMessageId = replyMessageID
                        fileMessage = FileMessageParams().apply {
                            file = audioFile
                        }
                    }
                    FlyMessenger.sendFileMessage(sendMessageParams, listener = listener)
                    /*FlyMessenger.sendAudioMessage(
                        userJID,
                        audioFile,
                        duration,
                        isRecorded,
                        replyMessageID,
                        listener
                    )*/
                }
            } else {
                result.error("500", "File Not Exists", "")
            }
        } else {
            result.error("500", "File Not Exists", "")
        }
    }

    fun sendContactMessage(call: MethodCall, result: MethodChannel.Result) {
        val contactList = call.argument<List<String>>("contact_list")
        val userJID = call.argument<String>("jid")
        val contactName = call.argument<String>("contact_name")
        val replyMessageID = call.argument<String>("replyMessageId") ?: ""
        val topicId = call.argument("topicId") ?: ""
        if (userJID != null && contactList != null && contactName != null) {
            val sendMessageParams = FileMessage().apply {
                toId = userJID
                this.topicId = topicId
                messageType = MessageType.CONTACT
                replyMessageId = replyMessageID //Optional
                contactMessage = ContactMessageParams().apply {
                    this.name = contactName
                    this.numbers = contactList
                }
            }
            FlyMessenger.sendFileMessage(
                sendMessageParams,
                listener = object : SendMessageCallback {
                    override fun onResponse(
                        isSuccess: Boolean,
                        error: Throwable?,
                        chatMessage: ChatMessage?
                    ) {
                        if (isSuccess && chatMessage != null) {
                            //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                            //DebugUtilis.v("FlyMessenger.sendContactMessage",chatMessage.tojsonString())
                            result.success(chatMessage.toJsonString())
                        } else {
                            result.error("500", error?.message, error)
                        }
                    }

                })
            /* FlyMessenger.sendContactMessage(
                 userJID,
                 contactName,
                 contactList,
                 replyMessageID,
                 object : SendMessageListener {
                     override fun onResponse(isSuccess: Boolean, chatMessage: ChatMessage?) {
                         if (chatMessage != null) {
                             //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                             //DebugUtilis.v("FlyMessenger.sendContactMessage",chatMessage.tojsonString())
                             result.success(chatMessage.toJsonString())
                         } else {
                             result.error("500", "Unable to Send Contact Message", null)
                         }
                     }

                 })*/
        }
    }

    fun sendVideoMessage(call: MethodCall, result: MethodChannel.Result) {
        val userJid = call.argument<String>("jid") ?: ""
        val localFilePath = call.argument<String>("filePath") ?: ""
        val topicId = call.argument("topicId") ?: ""
        val videoFile = File(localFilePath)

        val videoCaption = call.argument<String>("caption") ?: ""
        val replyMessageID = call.argument<String>("replyMessageId") ?: ""
        val videoFileUrl = call.argument<String>("videoFileUrl") ?: ""
        val videoDuration = call.argument<Long>("videoDuration") ?: 0L
        val thumbImageBase64 = call.argument<String>("thumbImageBase64") ?: ""

        val listener = object : SendMessageCallback {
            override fun onResponse(
                isSuccess: Boolean,
                error: Throwable?,
                chatMessage: ChatMessage?
            ) {
                if (chatMessage != null) {
                    //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                    //DebugUtilis.v("FlyMessenger.sendVideoMessage", chatMessage.tojsonString())
                    result.success(chatMessage.toJsonString())
                } else {
                    result.error("500", error?.message, error)
                }
            }
        }
        if (videoFile.exists()) {
            if (videoFileUrl.isNotEmpty() && thumbImageBase64.isNotEmpty() && videoDuration != 0L) {
                val sendMessageParams = FileMessage().apply {
                    toId = userJid
                    this.topicId = topicId
                    messageType = MessageType.VIDEO
                    replyMessageId = replyMessageID //Optional
                    fileMessage = FileMessageParams().apply {
                        fileUrl = videoFileUrl
                        fileName = videoFile.name
                        this.duration = videoDuration
                        this.localFilePath = localFilePath
                        this.fileSize = videoFile.length()
                        this.caption = videoCaption
                        this.thumbImage = thumbImageBase64
                    }
                }
                FlyMessenger.sendFileMessage(sendMessageParams, listener = listener)
                /*FlyMessenger.sendVideoMessage(
                    toJid = userJid,
                    MediaData(
                        fileName = videoFile.name,
                        fileSize = videoFile.length(),
                        fileUrl = videoFileUrl,
                        base64Thumbnail = thumbImageBase64,
                        fileLocalPath = localFilePath,
                        caption = videoCaption,
                        duration = videoDuration
                    ), isRecorded = false, replyMessageID, listener
                )*/
                /*FlyMessenger.sendVideoMessage(
            toJid = userJid,
            videoFile.name,
            videoFileUrl,
            videoFile.length(),
            videoDuration,
            thumbImageBase64,
            localFilePath,
            videoCaption,
            replyMessageID,
            listener
        )*/
            } else {
                val sendMessageParams = FileMessage().apply {
                    toId = userJid
                    this.topicId = topicId
                    messageType = MessageType.VIDEO
                    replyMessageId = replyMessageID //Optional
                    fileMessage = FileMessageParams().apply {
                        file = videoFile
                        this.caption = videoCaption
                    }
                }
                FlyMessenger.sendFileMessage(sendMessageParams, listener = listener)
                /*FlyMessenger.sendVideoMessage(
                    toJid = userJid,
                    file = videoFile,
                    caption = videoCaption,
                    replyMessageId = replyMessageID,
                    listener = listener
                )*/
            }
        } else {
            result.error("500", "File Not Exists", "")
        }
    }

    fun sendMediaFileMessage(call: MethodCall, result: MethodChannel.Result) {
        val messageParams = call.arguments<HashMap<String, Any>>()
        LogMessage.d("sendMediaFileMessage", messageParams.toString())
        val fileMessage = buildFileMessage(messageParams)
        LogMessage.d("fileMessage", fileMessage.toJsonString())
        sendMediaFileMessage(fileMessage, result)
    }

    fun sendMessage(call: MethodCall, result: MethodChannel.Result) {
        val messageParams = call.arguments<HashMap<String, Any>>()
        LogMessage.d("sendMessage", messageParams.toString())
        val userJid = messageParams?.getOrDefault("toJid", "") as String


        /// When a user logs in and sends a message without loading Recent Chats or Groups,
        /// the message won't be sent if the profile details for the particular JID do not exist in the local database.
        /// To handle this, we first try to fetch the profile details locally.
        /// If the profile response is nil, we fetch the profile details from the server, which will store them in the database.
        /// Once the profile details are retrieved and stored, the message can be sent without any issue.

        val profileDetails : ProfileDetails? = ContactManager.getProfileDetails(userJid)

        if (profileDetails != null) {
            processAndSendMessage(messageParams, result)
        } else {
           if (GroupManager.isValidGroupJid(userJid)){
               GroupManager.getGroupProfile(userJid, true) { isSuccess, throwable, data ->
                   if (isSuccess) {

                       GroupManager.getGroupMembersList(true, userJid) { groupMemberListIsSuccess, groupMemberListThrowable, _ ->
                           if (groupMemberListIsSuccess) {
                               processAndSendMessage(messageParams, result)
                           } else {
                               result.error("500", "Group Member Not found", groupMemberListThrowable.toString())
                           }
                       }
                   } else {
                          result.error("500", throwable?.message, throwable)
                   }
               }
           }else{
               ContactManager.getUserProfile(userJid, fetchFromServer = true, saveAsFriend = true) { _, throwable, _ ->
                   val profile = ContactManager.getProfileDetails(userJid)
                   if (profile != null) {
                       processAndSendMessage(messageParams, result)
                   } else {
                       result.error("500", "User not found", throwable)
                   }
               }
           }
        }
    }

    private fun processAndSendMessage(messageParams: HashMap<String, Any>?, result: MethodChannel.Result) {
        val messageType = messageParams?.get("messageType") as String?
        val mediaCompressionType = messageParams?.get("mediaCompressionType") as Int?
        messageType?.let {
            if (MessageType.valueOf(messageType) == MessageType.TEXT) {
                val textMessage = buildTextMessage(messageParams)
                textMessage?.let {
                    LogMessage.d("textMessage", textMessage.toJsonString())
                    sendTextMessage(textMessage, result)
                }
            }else if(MessageType.valueOf(messageType) == MessageType.MEET){
                val meetMessage = buildMeetMessage(messageParams)
                LogMessage.d("meetMessage", meetMessage?.toJsonString())
                meetMessage.let {
                    LogMessage.d("meetMessage", meetMessage?.toJsonString())
                    sendMeetMessage(meetMessage, result)
                }
            } else if ((MessageType.valueOf(messageType) == MessageType.IMAGE || MessageType.valueOf(messageType) == MessageType.VIDEO)) {
                compressAndSendImageOrVideoFiles(messageParams, result)
            } else {
                val fileMessage = buildFileMessage(messageParams)
                LogMessage.d("fileMessage", fileMessage.toJsonString())
                sendMediaFileMessage(fileMessage, result)
            }
        }
    }

    private fun sendTextMessage(textMessage: TextMessage?, result: MethodChannel.Result) {
        if (textMessage == null) {
            result.error("500", "TextMessage params not be null for MessageType TEXT", null)
            return
        }
        FlyMessenger.sendTextMessage(textMessage, object : SendMessageCallback {
            override fun onResponse(
                isSuccess: Boolean,
                error: Throwable?,
                chatMessage: ChatMessage?
            ) {
                if (isSuccess) {
                    if (chatMessage != null) {
                        result.success(chatMessage.toJsonString())
                    } else {
                        result.error("500", "message not available", error)
                    }
                } else {
                    result.error("500", error?.message ?: "", error)
                }
            }
        })
    }

    private fun sendMeetMessage(meetMessage: MeetMessage?, result: MethodChannel.Result) {
        if (meetMessage == null) {
            result.error("500", "MeetMessage params not be null for MessageType TEXT", null)
            return
        }
        LogMessage.d("meetMessage send", meetMessage.toJsonString())
        FlyMessenger.sendMeetMessage(meetMessage, object : SendMessageCallback {
            override fun onResponse(
                isSuccess: Boolean,
                error: Throwable?,
                chatMessage: ChatMessage?
            ) {
                if (isSuccess) {
                    if (chatMessage != null) {
                        result.success(chatMessage.toJsonString())
                    } else {
                        result.error("500", "message not available", error)
                    }
                } else {
                    result.error("500", error?.message ?: "", error)
                }
            }
        })
    }

    private fun sendMediaFileMessage(fileMessage: FileMessage?, result: MethodChannel.Result) {
        if (fileMessage == null) {
            result.error("500", "fileMessage params not be null for Media Messages", null)
            return
        }
        FlyMessenger.sendMediaFileMessage(fileMessage, object : SendMessageCallback {
            override fun onResponse(
                isSuccess: Boolean,
                error: Throwable?,
                chatMessage: ChatMessage?
            ) {
                if (isSuccess) {
                    if (chatMessage != null) {
                        result.success(chatMessage.toJsonString())
                    } else {
                        result.error("500", "message not available", error)
                    }
                } else {
                    result.error("500", error?.message ?: "", error)
                }
            }

        })
    }

    private fun compressAndSendImageOrVideoFiles(messageParams: HashMap<String, Any>?, result: MethodChannel.Result) {
        val messageType = messageParams?.get("messageType") as String?
        val mediaCompressionType = messageParams?.get("mediaCompressionType") as Int?

        val fileMessage: FileMessageParams? = if (messageParams?.get("fileMessage") != null) {
            (messageParams["fileMessage"] as? HashMap<*, *>)?.let { fileMap ->
                FileMessageParams().apply {
                    this.file = (fileMap["file"] as? String)?.let { File(it) }
                    this.duration = (fileMap["duration"] as? Int)?.toLong()
                    this.thumbImage = fileMap["thumbImage"] as? String
                    this.fileName = fileMap["fileName"] as? String
                    this.fileSize = (fileMap["fileSize"] as? Int)?.toLong()
                    this.caption = (fileMap["caption"] as? String).toString()
                }
            }
        } else null

        messageType?.let {
            if (fileMessage?.file == null) {
                result.error("400", "File is missing", null)
                return
            }

            val quality = getCompressionQuality(mediaCompressionType)
            when (MessageType.valueOf(messageType)) {
                MessageType.IMAGE -> {
                    val fileMessage = buildFileMessage(messageParams)
                    compressImage(fileMessage, quality, MirrorFlyManager.getContext(), result)
                }
                MessageType.VIDEO -> {
                    val fileMessage = buildFileMessage(messageParams)
                    compressVideo(fileMessage, quality, MirrorFlyManager.getContext(), result)
                }
                else -> {
                    result.error("400", "Media file should be only image or video", null)
                }
            }
        }
    }

    private fun getCompressionQuality(qualityAsString: Int?): MediaCompressQuality {
        return when (qualityAsString) {
            0 -> MediaCompressQuality.uncompressed
            1 -> MediaCompressQuality.low
            2 -> MediaCompressQuality.medium
            3 -> MediaCompressQuality.high
            else -> MediaCompressQuality.uncompressed
        }
    }

    private fun  compressImage(fileMessage:FileMessage,compressQuality:MediaCompressQuality,context: Context,result: MethodChannel.Result) {
        val contextWrapper = ContextWrapper(context)
        MediaUtils.compressImageFile(fileMessage.fileMessage?.file?.absolutePath, compressQuality, contextWrapper
        ) { isSuccess, compressedFilePath, errorMessage ->
            if (isSuccess) {
                fileMessage.fileMessage?.file = File(compressedFilePath!!)
                sendMediaMessage(fileMessage, result)
            } else {
                result.error("402", "Error while compressing the image", null)
            }
        }
    }

    private fun compressVideo(fileMessage: FileMessage,compressQuality:MediaCompressQuality,context: Context,result: MethodChannel.Result) {
        val contextWrapper = ContextWrapper(context)
        MediaUtils.compressVideoFile(fileMessage.fileMessage?.file?.absolutePath, compressQuality,contextWrapper) { isSuccess, compressedFilePath, errorMessage ->
            if (isSuccess) {
                fileMessage.fileMessage?.file = File(compressedFilePath!!)
                sendMediaMessage(fileMessage, result)
            } else {
                result.error("402", "Error while compressing the video", null)
            }
        }
    }

    private fun sendMediaMessage(fileMessage: FileMessage?, result: MethodChannel.Result) {
        if (fileMessage == null) {
            result.error("500", "fileMessage params not be null for Media Messages", null)
            return
        }

        FlyMessenger.sendMediaMessage(fileMessage
        ) { isSuccess, error, chatMessage ->
            if (isSuccess) {
                LogMessage.d("MediaCompression Manual","sendMediaMessage message: ${chatMessage.toString()}")
                if (chatMessage != null) {
                    result.success(chatMessage.toJsonString())
                } else {
                    result.error("500", "message not available", error)
                }
            } else {
                result.error("500", error?.message ?: "", error)
            }
        }
    }

    private fun buildTextMessage(map: HashMap<String, Any>?): TextMessage? {
        val textMessage = TextMessage()

        if (map != null) {
            if (map["textMessage"] != null) {
                textMessage.apply {
                    this.toId = map.getOrDefault("toJid", "") as String
                    this.replyMessageId = map["replyMessageId"] as String?
                    this.topicId = map.getOrDefault("topicId", "") as String
                    this.metaData =
                        if (map["metaData"] != null) extractMessageMetaData(map["metaData"] as List<Map<String, Any>>) else emptyList()
                    this.mentionedUsersIds =
                        if (map["mentionedUsersIds"] != null) map["mentionedUsersIds"] as List<String> else null
                    val textMessageText = map["textMessage"] as HashMap<*, *>
                    this.messageText = textMessageText.getOrDefault("messageText", "") as String
                }
            } else {
                return null
            }
        }
        return textMessage
    }

    private fun buildMeetMessage(map: HashMap<String, Any>?): MeetMessage? {
        val meetMessage = MeetMessage()
        if(map  != null && map["meetMessage"] != null){
            LogMessage.d("meetMessage par -", map.toString());
       meetMessage.apply {
            this.toId = map.getOrDefault("toJid", "") as String
           this.replyMessageId = map["replyMessageId"] as String?
           this.topicId = map.getOrDefault("topicId", "") as String
           this.metaData =
               if (map["metaData"] != null) extractMessageMetaData(map["metaData"] as List<Map<String, Any>>) else emptyList()
           val meetMessageMap = map["meetMessage"] as? Map<String, Any> // Safe cast to Map<String, Any>

           this.title = meetMessageMap?.get("title") as? String
           this.scheduledDateTime = meetMessageMap?.get("scheduledDateTime") as? Long
           this.link = meetMessageMap?.get("link") as? String

           this.mentionedUsersIds= if (map["mentionedUsersIds"] != null) map["mentionedUsersIds"] as List<String> else null
       }
        }else {
            return null
        }
        return meetMessage
    }

    private fun buildFileMessage(map: HashMap<String, Any>?): FileMessage {
        val fileMessage = FileMessage()
        if (map != null) {
            fileMessage.apply {
//                val metaData = call.argument<List<Map<String, Any>>>("metaData") ?: arrayListOf()
                this.toId = map.getOrDefault("toJid", "") as String
                this.replyMessageId = map["replyMessageId"] as String?
                this.topicId = map.getOrDefault("topicId", "") as String
                this.metaData =
                    if (map["metaData"] != null) extractMessageMetaData(map["metaData"] as List<Map<String, Any>>) else emptyList()
                this.messageType = (map["messageType"] as String?)?.let { MessageType.valueOf(it) }
                this.mentionedUsersIds =
                    if (map["mentionedUsersIds"] != null) map["mentionedUsersIds"] as List<String> else null
                this.locationMessage =
                    if (map["locationMessage"] != null) LocationMessageParams().apply {
                        val location = map["locationMessage"] as HashMap<*, *>
                        this.latitude = location["latitude"] as Double?
                        this.longitude = location["longitude"] as Double?
                    } else null
                this.contactMessage =
                    if (map["contactMessage"] != null) ContactMessageParams().apply {
                        val contact = map["contactMessage"] as HashMap<*, *>
                        this.name = contact.getOrDefault("name", "") as String?
                        this.numbers = contact["numbers"] as List<String>?
                    } else null
                this.fileMessage = if (map["fileMessage"] != null) FileMessageParams().apply {
                    val file_Message = map["fileMessage"] as HashMap<*, *>
                    this.file = (file_Message["file"] as String?)?.let { File(it) }
                    this.duration = (file_Message["duration"] as Int?)?.toLong()
                    this.thumbImage = file_Message["thumbImage"] as String?
                    this.fileName = file_Message["fileName"] as String?
                    this.fileSize = (file_Message["fileSize"] as Int?)?.toLong()
                    this.caption = file_Message["caption"] as String
                } else null

            }
        }
        return fileMessage
    }

    private fun extractMessageMetaData(data: List<Map<String, Any>>): List<MessageMetaData> {
        val extractedData = ArrayList<MessageMetaData>()
        data.forEach {
            extractedData.add(MessageMetaData(it["key"] as String, it["value"] as String))
        }
        LogMessage.d("extractMessageMetaData", "$data : ${extractedData.toJsonString()}")
        return extractedData
    }

    fun logoutOfChatSDK(call: MethodCall, result: MethodChannel.Result) {

        try {
            FlyCore.logoutOfChatSDK { isSuccess, throwable, _ ->
                if (isSuccess) {
//                    SharedPreferenceManager.instance.clearAllPreference()
                    result.success(true)
                } else {
                    result.error("400", throwable?.message.toString(), "")
                }
            }
        } catch (e: Exception) {
            //LogMessage.d(TAG, e.message.toString())
            result.error("400", e.message.toString(), "")
        }

    }

    fun getMessageOfId(call: MethodCall, result: MethodChannel.Result) {
        val mid = call.argument<String>("mid") ?: ""
        val data = FlyMessenger.getMessageOfId(mid)
        if (data != null) {
            //LogMessage.d("RESPONSE_CAPTURE", "===========================")
            //DebugUtilis.v("FlyMessenger.getMessageOfId", data.tojsonString())
            result.success(data.toJsonString())
        }
    }

//    private fun getUserMedia(call: MethodCall, result: MethodChannel.Result) {
//        val messageID: String? = call.argument("message_id")
//        val message = FlyMessenger.getMessageOfId(messageID!!)
//        if (message != null) {
//            //LogMessage.d("RESPONSE_CAPTURE", "===========================")
//            //DebugUtilis.v("FlyMessenger.getMessageOfId", message.tojsonString())
//            result.success(message.tojsonString())
//        } else {
//            result.error("500", "Media Details Not Found", null)
//        }
//
//    }

    private var messageListQuery: FetchMessageListQuery? = null
    fun initializeMessageListParams(call: MethodCall, result: MethodChannel.Result) {
        val chatJid: String = call.argument("userJid") ?: ""
        val messageId: String = call.argument("messageId") ?: ""
        val messageTime: String = call.argument("messageTime") ?: ""
        val inclusive: Boolean = call.argument("exclude") ?: false
        val ascendingOrder: Boolean = call.argument("ascendingOrder") ?: true
        val limit: Int = call.argument("limit") ?: 50
        val topicId: String = call.argument("topicId") ?: ""
        val metaData = call.argument<Map<String, Any>>("metaMessageList") ?: HashMap<String, Any>()
        var extractedData = MetaDataMessageList()
        if (metaData.containsKey("key") && metaData.containsKey("value")) {
            extractedData = MetaDataMessageList(
                key = metaData["key"] as String? ?: "",
                value = (metaData["value"] as List<String>?) as ArrayList<String>? ?: arrayListOf()
            )
        }
        LogMessage.d("initializeMessageList", "${call.arguments}")
        if (ContactManager.isValidJid(chatJid)) {
            val messageListParams = FetchMessageListParams()
            messageListParams.chatJid = chatJid
            if (messageId.isNotEmpty()) messageListParams.messageId = messageId
            if (messageTime.isNotEmpty()) messageListParams.messageTime = messageTime
            messageListParams.inclusive =
                !inclusive// for iOS using exclude , so we using NOT to match the Android and iOS
            messageListParams.ascendingOrder = ascendingOrder
            messageListParams.topicId = topicId
            messageListParams.limit = limit
//            messageListParams.metaData = extractedData
//            messageListParams.chatType = if(ContactManager.getProfileDetails(chatJid)!!.isGroupProfile)  "groupchat" else "singlechat" // groupchat or singlechat
//            messageListParams.direction = "backward" // forward or backward
            messageListQuery = FetchMessageListQuery(messageListParams)
            result.success(true)
        } else {
            result.error("500", "jid is not Valid", "")
        }
    }

    fun loadMessages(call: MethodCall, result: MethodChannel.Result) {
        if (messageListQuery == null) {
            result.error("500", "Message List not Initialized", "")
            return
        }
        if (messageListQuery!!.isFetchingInProgress()) {
            result.error("500", "Already Message Fetching is In Progress", "")
            return
        }
        messageListQuery!!.loadMessages { isSuccess, throwable, data ->
            if (isSuccess) {
                val messageList = data["data"] as ArrayList<ChatMessage>
                result.success(messageList.toJsonString())
                LogMessage.d("loadMessages", "$isSuccess : ${messageList.toJsonString()}")
            } else {
                LogMessage.d("loadMessages", "$isSuccess : $throwable")
                // Fetch messages failed print throwable to find the exception details.
                result.error("500", "Failed to Load Initial Messages ", "$throwable")
            }
        }
    }

    fun hasPreviousMessages(call: MethodCall, result: MethodChannel.Result) {
        if (messageListQuery != null) {
            result.success(messageListQuery?.hasPreviousMessages())
        } else {
            result.error(
                "500",
                "Message List not Initialized. Initialize using  initializeMessageList() method",
                null
            )
        }
    }

    fun hasNextMessages(call: MethodCall, result: MethodChannel.Result) {
        if (messageListQuery != null) {
            result.success(messageListQuery?.hasNextMessages())
        } else {
            result.error(
                "500",
                "Message List not Initialized. Initialize using  initializeMessageList() method",
                null
            )
        }
    }

    fun loadPreviousMessages(call: MethodCall, result: MethodChannel.Result) {
        if (messageListQuery == null) {
            result.error("500", "Message List not Initialized", "")
            return
        }
        /*if (!messageListQuery!!.hasPreviousMessages()) {
            result.success(arrayListOf<ChatMessage>().toJsonString())
//            result.error("500", "There is no Previous Messages", "")
            return
        }*/
        if (messageListQuery!!.isFetchingInProgress()) {
            result.error("500", "Already Message Fetching is In Progress", "")
            return
        }
        messageListQuery!!.loadPreviousMessages { isSuccess, throwable, data ->
            if (isSuccess) {
                val messages = data["data"] as ArrayList<ChatMessage>
                result.success(messages.toJsonString())
                LogMessage.d("loadPreviousMessages", "$isSuccess : ${data["data"]}")
            } else {
                LogMessage.d("loadPreviousMessages", "$isSuccess : $throwable")
                // Fetch messages failed print throwable to find the exception details.
                result.error("500", "Failed to Load Previous Messages ", "$throwable")
            }
        }
    }

    fun loadNextMessages(call: MethodCall, result: MethodChannel.Result) {
        if (messageListQuery == null) {
            result.error("500", "Message List not Initialized", "")
            return
        }
        /*if (!messageListQuery!!.hasNextMessages()) {
            result.success(arrayListOf<ChatMessage>().toJsonString())
//            result.error("500", "There is no Next Messages", "")
            return
        }*/
        if (messageListQuery!!.isFetchingInProgress()) {
            result.error("500", "Already Message Fetching is In Progress", "")
            return
        }
        messageListQuery!!.loadNextMessages { isSuccess, throwable, data ->
            if (isSuccess) {
                val messages = data["data"] as ArrayList<ChatMessage>
                result.success(messages.toJsonString())
                LogMessage.d("loadNextMessages", "$isSuccess : ${data["data"]}")
            } else {
                LogMessage.d("loadNextMessages", "$isSuccess : $throwable")
                // Fetch messages failed print throwable to find the exception details.
                result.error("500", "Failed to Load Next Messages ", "$throwable")
            }
        }
    }

    fun getMessagesOfJid(call: MethodCall, result: MethodChannel.Result) {
        //if (AppUtils.isNetConnected(mContext)) {
        if (!call.hasArgument("JID")) {
            result.error("404", "User JID Required", null)
        } else {
            val userJID: String? = call.argument("JID")
            if (userJID != null && userJID.isNotEmpty()) {
                val messages: List<ChatMessage> = FlyMessenger.getMessagesOfJid(userJID)
                //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                //DebugUtilis.v("FlyMessenger.getMessagesOfJid", messages.tojsonString())

                result.success(messages.toJsonString())
            } else {
                result.error("500", "User JID is Empty", null)
            }
        }

        //}
    }

    fun updateRecentChatPinStatus(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        val pin_status = call.argument<Boolean>("pin_recent_chat") ?: false
        FlyCore.updateRecentChatPinStatus(jid, pin_status)
    }

    fun deleteRecentChat(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
//                FlyCore.deleteRecentChat(jid)// this method only deletes from local DB
        ChatManager.deleteRecentChats(arrayListOf(jid), object : ChatActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                if (isSuccess) {
                    result.success(isSuccess)
                } else {
                    result.error("500", message, "")
                }
            }

        })
    }

    fun recentChatPinnedCount(call: MethodCall, result: MethodChannel.Result) {
        result.success(FlyCore.recentChatPinnedCount())
    }

    fun getUserList(call: MethodCall, result: MethodChannel.Result) {
        //if (AppUtils.isNetConnected(mContext)) {
        val page = call.argument("page") ?: 1
        val perPageResultSize = call.argument("perPageResultSize") ?: 20
        val search = call.argument("search") ?: ""
        val metaData = call.argument<Map<String, Any>>("metaDataUserList") ?: HashMap<String, Any>()
        var extractedData = MetaDataUserList()
        if (metaData.containsKey("key") && metaData.containsKey("value")) {
            extractedData = MetaDataUserList(
                key = metaData["key"] as String? ?: "",
                value = (metaData["value"] as List<String>?) as ArrayList<String>? ?: arrayListOf()
            )
        }
        LogMessage.d("getUserList", call.arguments.toString())
        FlyCore.getUserList(
            page,
            perPageResultSize,
            search,
            extractedData
        ) { isSuccess, throwable, data ->
            data["status"] = isSuccess
            LogMessage.d("registered", "$isSuccess : $data : $throwable")
            if (isSuccess) {
                //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                //DebugUtilis.v("getUserList", data.tojsonString())
                result.success(data.toJsonString())
            } else {
                println("getUserList error : " + throwable.toString())
                result.error("400", throwable?.message.toString(), "")
            }

        }
        //} else {
        /*Toast.makeText(mContext, "Please Check Your Internet connection", Toast.LENGTH_SHORT)
            .show()*/
        //}
    }

    fun getJid(call: MethodCall, result: MethodChannel.Result) {
        if (!call.hasArgument("username")) {
            result.error("404", "User Name Required", null)
        } else {
            val userName: String? = call.argument("username")
            if (userName != null) {
                result.success(FlyUtils.getJid(userName))
            } else {
                result.error("500", "User Name is Empty", null)
            }
        }

    }

    fun getImagePath(call: MethodCall, result: MethodChannel.Result) {
        val imageUrl = call.argument<String>("image")
        val path = Uri.parse(MediaUploadHelper.UPLOAD_ENDPOINT).buildUpon()
            .appendPath(Uri.parse(imageUrl).lastPathSegment).build().toString()
        LogMessage.d("path : ", path)
        result.success(path)
    }

    fun updateMyProfile(call: MethodCall, result: MethodChannel.Result) {
        val name = call.argument("name") ?: ""
        val nickName = call.argument("nickName") ?: ""
        val mobile = call.argument("mobile") ?: ""
        val email = call.argument("email") ?: ""
        val image = call.argument("image") ?: ""
        val status = call.argument("status") ?: ""
//        if (name.isNotEmpty() && mobile.isNotEmpty() && email.isNotEmpty()) {
        val profileObj = Profile()
        profileObj.name = name
        profileObj.nickName = name
        profileObj.mobileNumber = mobile
        profileObj.email = email
        profileObj.status = status
        profileObj.image = image
        ContactManager.updateMyProfile(profileObj) { isSuccess, throwable, data ->
            //LogMessage.d("RESPONSE_CAPTURE", "===========================")
            //DebugUtilis.v("ContactManager.updateMyProfile", data.tojsonString())
            if (isSuccess) {
                data["status"] = isSuccess
                result.success(data.toJsonString())
            } else {
                result.error("500", throwable?.message, throwable)
            }
        }
//        } else {
//            result.error(
//                "400",
//                "Fill All details",
//                null
//            )
//        }
    }

    fun getMediaEndPoint(call: MethodCall, result: MethodChannel.Result) {
        result.success(MediaUploadHelper.UPLOAD_ENDPOINT)
    }

    fun updateMyProfileImage(call: MethodCall, result: MethodChannel.Result) {
        if (call.hasArgument("image")) {
            val image = call.argument<String>("image")
            if (image != null) {
                val imagefile = File(image)
                if (imagefile.exists()) {
                    ContactManager.updateMyProfileImage(
                        imagefile,
                        flyCallback = { isSuccess, _, data ->
                            //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                            //DebugUtilis.v("ContactManager.updateMyProfileImage", data.tojsonString())
                            if (isSuccess) {
                                data["status"] = isSuccess
                                result.success(data.toJsonString())
                            } else {
                                result.error("500", "update profile image failure", null)
                            }
                        })
                } else {
                    ContactManager.updateMyProfileImage(
                        flyCallback = { isSuccess, _, data ->
                            //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                            //DebugUtilis.v("ContactManager.updateMyProfileImage", data.tojsonString())
                            if (isSuccess) {
                                data["status"] = isSuccess
                                result.success(data.toJsonString())
                            } else {
                                result.error("500", "update profile image failure", null)
                            }
                        }, imageUrl = image
                    )
                }
            } else {
                result.error("500", "Image not available to update profile", null)
                return
            }
        } else {
            result.error("500", "Select Image file", null)
            return
        }
    }

    fun isUserUnArchived(call: MethodCall, result: MethodChannel.Result) {
        result.success(FlyCore.isUserUnArchived(call.argument<String>("jid") ?: ""))
    }

    fun removeProfileImage(call: MethodCall, result: MethodChannel.Result) {
        ContactManager.removeProfileImage { isSuccess, error, data ->
            LogMessage.d("removeProfileImage", "==$error data: $data")
            if (isSuccess) {
                //DebugUtilis.v("ContactManager.removeProfileImage", data.tojsonString())
//                data["status"] = isSuccess
                val details = ContactManager.getMyProfileData()
                val profile = Profile().apply {
                    name = details.name
                    nickName = details.nickName
                    image = Constants.EMPTY_STRING
                    mobileNumber = details.mobileNumber
                    email = details.email
                    status = details.status
                }
                LogMessage.d("updateMyProfile", profile.toJsonString())
                ContactManager.updateMyProfile(profile) { isSucces, throwable, dat ->
                    if (isSucces) {
                        result.success(isSucces)
                    } else {
                        result.error("500", throwable?.toString(), dat.toString())
                    }
                }
            } else {
                result.error("500", error?.toString(), data.toString())
            }
        }
    }

    fun isArchivedSettingsEnabled(call: MethodCall, result: MethodChannel.Result) {
        result.success(FlyCore.isArchivedSettingsEnabled())
    }

    fun setMyProfileStatus(call: MethodCall, result: MethodChannel.Result) {
        val status = call.argument<String>("status") ?: ""
        if (status.isNotEmpty()) {
            FlyCore.setMyProfileStatus(status) { isSuccess, error, data ->
                data["status"] = isSuccess
                if (isSuccess) {
                    result.success(data.toJsonString())
//                    result.success(true)
                } else {
                    result.error("500", error?.message.toString(), error)
                }

            }
        }
    }

    fun getMediaMessages(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        val mediaMessage = ChatManager.getMediaMessages(jid)
        //LogMessage.d("RESPONSE_CAPTURE", "===========================")
        //DebugUtilis.v("ChatManager.getMediaMessages", mediaMessage.tojsonString())
        result.success(mediaMessage.toJsonString())
    }

    fun isMemberOfGroup(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        val userjid = call.argument<String>("userjid")
            ?: SharedPreferenceManager.instance.currentUserJid
        val isMemberGroup = GroupManager.isMemberOfGroup(jid, userjid)
        //DebugUtilis.v("GroupManager.isMemberOfGroup", isMemberGroup.toString())
        result.success(isMemberGroup)
    }

    fun insertNewProfileStatus(call: MethodCall, result: MethodChannel.Result) {

        // Same Function as "setMyProfileStatus", writing as separate new function inorder to match the iOS Functionality
        val status = call.argument<String>("status") ?: ""
        if (status.isNotEmpty()) {
            FlyCore.setMyProfileStatus(status) { isSuccess, error, data ->
                data["status"] = isSuccess

                if (isSuccess) {
//                    result.success(data.toJsonString())
                    result.success(true)
                } else {
                    result.error("500", error?.message.toString(), error)
                }
            }
        }

    }

    fun isTrailLicence(call: MethodCall, result: MethodChannel.Result) {
        result.success(ChatManager.isTrialLicense())//(BuildConfig.IS_TRIAL_LICENSE)
    }

    fun syncContacts(call: MethodCall, result: MethodChannel.Result) {
        val isFirsttime = call.argument<Boolean>("is_first_time") ?: false
        FlyCore.syncContacts(isFirsttime) { b, _, data ->
            LogMessage.d(tag, "Contacts Sync contactSyncSuccess:$b and data: ${data}")
            result.success(true)
        }
    }

    fun contactSyncStateValue(call: MethodCall, result: MethodChannel.Result) {
        val contactSyncStateResult: Result<Boolean>? = FlyCore.contactSyncState.value
        val res = (contactSyncStateResult == Result.InProgress)
        result.success(res)
    }

    fun getUserProfile(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument("jid") ?: ""
        val server = call.argument<Boolean>("server") ?: false
        val saveasfriend = call.argument<Boolean>("saveasfriend") ?: false
        LogMessage.d(tag, "JID==> $jid")
        ContactManager.getUserProfile(
            jid, server, saveasfriend
        ) { isSuccess, throwable, data ->
            if (isSuccess) {
                //ContactManager.shared.getUserProfileDetails
                //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                //DebugUtilis.v("getUserProfile", data.tojsonString())
                data["status"] = isSuccess
                LogMessage.d(tag, "getProfile => " + data.toJsonString())
                result.success(data.toJsonString())
            } else {
                result.error("500", throwable?.message, data)
            }
        }
    }

    fun sendTextMessage(call: MethodCall, result: MethodChannel.Result) {
        if (!call.hasArgument("message") && !call.hasArgument("JID")) {
            result.error("404", "Message/JID Required", null)
        } else {
            val topicId = call.argument("topicId") ?: ""
            val txtMessage: String? = call.argument("message")
            val receiverJID: String? = call.argument("JID")
            val replyMessageID = call.argument("replyMessageId") ?: ""
            if (txtMessage != null && receiverJID != null) {
                val textMessage = TextMessage()
                textMessage.toId = receiverJID
                textMessage.messageText = txtMessage
                textMessage.replyMessageId = replyMessageID // Optional
//                textMessage.metaData = META_DATA //Optional
                textMessage.topicId = topicId //Optional
                FlyMessenger.sendTextMessage(textMessage,
                    listener = object : SendMessageCallback {
                        override fun onResponse(
                            isSuccess: Boolean,
                            error: Throwable?,
                            chatMessage: ChatMessage?
                        ) {
                            // you will get the message sent success response
                            if (isSuccess) {
                                LogMessage.d("sendTextMessage", chatMessage?.toJsonString())
                                if (chatMessage != null) {
                                    result.success(chatMessage.toJsonString())
                                }
                            } else {
                                //LogMessage.d(TAG, "Message sent Failed")
                                LogMessage.e("sendTextMessage", error)
                                result.error("500", error?.message, error)
                            }
                        }
                    })

            } else {
                result.error("500", "User Name is Empty", null)
            }
        }

    }

    fun markAsReadDeleteUnreadSeparator(call: MethodCall, result: MethodChannel.Result) {
        if (!call.hasArgument("jid")) {
            result.error("404", "JID Required", null)
        } else {
            val receiverJID: String? = call.argument("jid")
            if (receiverJID != null) {
                LogMessage.d(tag, "Read Receipt of JID $receiverJID")
                //Notify the message is read by user
                ChatManager.markAsRead(receiverJID)
                //To Remove the Unread Notification Separator in Chat List
                FlyMessenger.deleteUnreadMessageSeparatorOfAConversation(receiverJID)
                result.success(true)
            } else {
                result.error("500", "JID is Empty", null)
            }
        }

    }

    fun sendDocumentMessage(call: MethodCall, result: MethodChannel.Result) {
        if (!call.hasArgument("message") && !call.hasArgument("jid")) {
            result.error("404", "Message/JID Required", null)
        } else {
            val replyMessageId: String = call.argument("replyMessageId") ?: ""
            val receiverJID: String = call.argument("jid") ?: ""
            val file: String = call.argument("file") ?: ""
            val fileUrl: String = call.argument("file_url") ?: ""
            val topicId = call.argument("topicId") ?: ""
            val listener = object : SendMessageCallback {
                override fun onResponse(
                    isSuccess: Boolean, error: Throwable?, chatMessage: ChatMessage?
                ) {
                    // you will get the message sent success response
                    if (isSuccess && chatMessage != null) {
                        //DebugUtilis.v( "FlyMessenger.sendDocumentMessage",chatMessage.tojsonString())
                        LogMessage.d(tag, chatMessage.toJsonString())
                        result.success(chatMessage.toJsonString())
                    } else {
                        //LogMessage.d(TAG, "File Message sent Failed")
                        result.error("500", "File Message sent Failed", null)
                    }
                }
            }
            if (File(file).exists()) {
                if (fileUrl.isNotEmpty()) {
                    val sendMessageParams = FileMessage().apply {
                        toId = receiverJID
                        this.topicId = topicId
                        messageType = MessageType.DOCUMENT
                        this.replyMessageId = replyMessageId //Optional
                        fileMessage = FileMessageParams().apply {
                            this.fileUrl = fileUrl
                            fileName = File(file).name
                            this.localFilePath = file
                            this.fileSize = File(file).length()
                        }
                    }
                    FlyMessenger.sendFileMessage(sendMessageParams, listener = listener)
                    /*FlyMessenger.sendDocumentMessage(
                        receiverJID,
                        File(file).name,
                        File(file).length(),
                        fileUrl,
                        file,
                        replyMessageId,
                        listener
                    )*/
                } else {
                    val sendMessageParams = FileMessage().apply {
                        toId = receiverJID
                        this.topicId = topicId
                        messageType = MessageType.DOCUMENT
                        this.replyMessageId = replyMessageId //Optional
                        fileMessage = FileMessageParams().apply {
                            this.file = File(file)
                        }
                    }
                    FlyMessenger.sendFileMessage(sendMessageParams, listener = listener)
                    /*FlyMessenger.sendDocumentMessage(
                        receiverJID,
                        File(file),
                        File(file).name,
                        replyMessageId,
                        listener
                    )*/
                }
            } else {
                result.error("500", "File not Exists", "")
            }
        }

    }

    fun sendLocationMessage(call: MethodCall, result: MethodChannel.Result) {
        val userJid = call.argument<String>("jid") ?: ""
        val latitude = call.argument<Double>("latitude") ?: 00.0
        val longitude = call.argument<Double>("longitude") ?: 00.0
        val replyMessageId: String? = call.argument("replyMessageId")
        val topicId = call.argument("topicId") ?: ""
        if (userJid.isNotEmpty() && latitude != 00.0 && longitude != 00.0 && replyMessageId != null) {
            val sendMessageParams = FileMessage().apply {
                toId = userJid
                this.topicId = topicId
                messageType = MessageType.LOCATION
                this.replyMessageId = replyMessageId //Optional
                locationMessage = LocationMessageParams().apply {
                    this.latitude = latitude
                    this.longitude = longitude
                }
            }
            FlyMessenger.sendFileMessage(
                sendMessageParams,
                listener = object : SendMessageCallback {
                    override fun onResponse(
                        isSuccess: Boolean,
                        error: Throwable?,
                        chatMessage: ChatMessage?
                    ) {
                        if (isSuccess && chatMessage != null) {
                            //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                            //DebugUtilis.v("sendLocationMessage", chatMessage.tojsonString())
                            result.success(chatMessage.toJsonString())
                        } else {
                            result.error("500", error?.message, error)
                        }
                    }
                })
            /*FlyMessenger.sendLocationMessage(
                userJid,
                latitude,
                longitude,
                replyMessageId,
                object : SendMessageListener {
                    override fun onResponse(isSuccess: Boolean, chatMessage: ChatMessage?) {
                        if (chatMessage != null) {
                            //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                            //DebugUtilis.v("sendLocationMessage", chatMessage.tojsonString())
                            result.success(chatMessage.toJsonString())
                        } else {
                            result.error("500", error?.message, error)
                        }
                    }
                })*/
        } else {
            if (userJid.isEmpty())
                result.error("500", "User Jid is Empty", null)
            else if (latitude != 00.0 || longitude != 00.0)
                result.error("500", "Location is Empty", null)
        }
    }

    fun sendImageMessage(call: MethodCall, result: MethodChannel.Result) {
        val userJid = call.argument<String>("jid") ?: ""
        val filePath = call.argument<String>("filePath") ?: ""
        //createDotNoMediaFile()

        val imageFile = File(filePath)

        val caption = call.argument<String>("caption") ?: ""
        val replyMessageID = call.argument<String>("replyMessageId") ?: ""
        val imageFileUrl = call.argument<String>("imageFileUrl") ?: ""
        val topicId = call.argument("topicId") ?: ""

        val thumbnailBase64 = getImageThumbImage(filePath)

        //LogMessage.d("FILEPATH", filePath)
        LogMessage.d(tag, filePath)
        LogMessage.d(tag, thumbnailBase64)
        val listener = object : SendMessageCallback {
            override fun onResponse(
                isSuccess: Boolean,
                error: Throwable?,
                chatMessage: ChatMessage?
            ) {
                if (isSuccess && chatMessage != null) {
                    //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                    //DebugUtilis.v("FlyMessenger.sendImageMessage", chatMessage.tojsonString())
                    result.success(Gson().toJson(chatMessage))
                } else {
                    result.error("500", error?.message, error)
                }
            }
        }
        if (imageFileUrl.isNotEmpty()) {
            val sendMessageParams = FileMessage().apply {
                toId = userJid
                this.topicId = topicId
                messageType = MessageType.IMAGE
                replyMessageId = replyMessageID //Optional
                fileMessage = FileMessageParams().apply {
                    fileUrl = imageFileUrl
                    fileName = imageFile.name
                    this.localFilePath = filePath
                    this.fileSize = imageFile.length()
                    this.caption = caption
                    this.thumbImage = thumbnailBase64
                }
            }
            FlyMessenger.sendFileMessage(sendMessageParams, listener = listener)
            /*FlyMessenger.sendImageMessage(
                toJid = userJid,
                MediaData(
                    fileName = imageFile.name,
                    fileSize = imageFile.length(),
                    fileUrl = imageFileUrl,
                    fileLocalPath = filePath,
                    base64Thumbnail = thumbnailBase64,
                    caption
                ), replyMessageID, listener
            )*/
            /*FlyMessenger.sendImageMessage(
          userJid,
          imageFile.name,
          imageFile.length().toString(),
          imageFileUrl,
          filePath,
          thumbnailBase64,
          caption,
          replyMessageID,
          listener
      )*/
        } else {
            val sendMessageParams = FileMessage().apply {
                toId = userJid
                this.topicId = topicId
                messageType = MessageType.IMAGE
                replyMessageId = replyMessageID //Optional
                fileMessage = FileMessageParams().apply {
                    file = imageFile
                    this.caption = caption
                }
            }
            FlyMessenger.sendFileMessage(sendMessageParams, listener = listener)
            /*FlyMessenger.sendImageMessage(
                userJid,
                imageFile,
                thumbnailBase64,
                caption,
                replyMessageID,
                listener
            )*/
        }
    }

    fun getRecentChatList(call: MethodCall, result: MethodChannel.Result) {
        println("recent here")
        //if (AppUtils.isNetConnected(mContext)) {
        //progress.show()
        FlyCore.getRecentChatList { isSuccess, throwable, data ->
            //progress.dismiss()
            if (isSuccess) {
                //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                //DebugUtilis.v("FlyCore.getRecentChatList", data.tojsonString())
                result.success(Gson().toJson(data).toString())
            } else {
                result.error("500", throwable?.message, null)
            }
            LogMessage.d("Recent ==>", data.toString())
        }
        /*} else {
        //Toast.makeText(this, "Please Check Your Internet connection", Toast.LENGTH_SHORT).show()
        result.error("500", "Please Check Your Internet connection", null)
    }*/
    }

    fun getRecentChatListHistoryByTopic(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        val firstSet = call.argument<Boolean>("firstSet") ?: true
        val limit = call.argument("limit") ?: 15
        val topicId = call.argument("topicId") ?: ""
        LogMessage.d("topic chat history firstSet", firstSet.toString())
        val topicChatListParams = TopicChatListParams().apply {
            this.topicId = topicId
            this.limit = limit
        }
        val topicChatListBuilder = TopicChatListBuilder(topicChatListParams)
        runBlocking {
            launch {
                if (firstSet) {
                    LogMessage.d(
                        "topic chat history ",
                        "first page ${topicChatListParams.topicId} ${topicChatListParams.limit}"
                    )
                    topicChatListBuilder.loadTopicBasedChatList { isSuccess, throwable, data ->
                        if (isSuccess) {
                            val recentChatList = data["data"] as ArrayList<RecentChat>
                            LogMessage.d(
                                "topic chat history item count",
                                recentChatList.size.toString()
                            )
                            result.success(data.toJsonString())
                        } else {
                            result.error("500", throwable?.message, null)
                        }

                    }
                } else {
                    topicChatListBuilder.nextSetOfTopicBasedChatList { isSuccess, throwable, data ->
                        if (isSuccess) {
                            val recentChatList = data["data"] as ArrayList<RecentChat>
                            LogMessage.d(
                                "topic chat history item count",
                                recentChatList.size.toString()
                            )
                            result.success(data.toJsonString())
                        } else {
                            result.error("500", throwable?.message, null)
                        }

                    }
                }
            }
        }
    }

    fun getRecentChatListHistory(call: MethodCall, result: MethodChannel.Result) {

        val firstSet = call.argument<Boolean>("firstSet") ?: true
        val limit = call.argument("limit") ?: 15
        LogMessage.d("chat history firstSet", firstSet.toString())

        val recentChatListParams = RecentChatListParams().apply { this.limit = limit }
        val recentChatListBuilder = RecentChatListBuilder(recentChatListParams)
        runBlocking {
            launch {
                if (firstSet) {
                    LogMessage.d("chat history ", "first page")
                    recentChatListBuilder.loadRecentChatList { isSuccess, throwable, data ->
                        if (isSuccess) {
                            val recentChatList = data["data"] as ArrayList<RecentChat>
                            LogMessage.d("chat history item count", data.toString())
                            result.success(data.toJsonString())
                        } else {
                            result.error("500", throwable?.message, null)
                        }

                    }
                } else {
                    LogMessage.d("chat history next set data", "firstSet $firstSet")
                    recentChatListBuilder.nextSetOfData { isSuccess, throwable, data ->
                        if (isSuccess) {
                            //                    val recentChatList = data["data"] as ArrayList<RecentChat>
                            result.success(data.toJsonString())
                        } else {
                            // Fetch recent chat list failed print throwable to find the exception details.
                            result.error("500", throwable?.message, null)
                        }
                    }
                }
            }
        }
    }

    private fun getImageThumbImage(imagePath: String?): String {
        return if (imagePath != null) {
            val thumb = ThumbnailUtils.extractThumbnail(
                BitmapFactory.decodeFile(imagePath),
                ThumbSize.THUMB_100,
                ThumbSize.THUMB_100
            )
            if (thumb != null) {
                val byteArray = getCompressedBitmapData(thumb)
                LogMessage.v(
                    "getVideoThumbImage",
                    "final video thumbnail size: " + byteArray.size
                )
                thumb.recycle()
                Base64.encodeToString(byteArray, 0)
            } else ""
        } else ""
    }

    private fun getCompressedBitmapData(
        bitmap: Bitmap
    ): ByteArray {
        val resizedBitmap: Bitmap =
            if (bitmap.width > 48 || bitmap.height > 48) {
                getResizedBitmap(bitmap)
            } else {
                bitmap
            }
        var bitmapData = getByteArray(resizedBitmap)
        while (bitmapData.size > 2048) {
            bitmapData = getByteArray(resizedBitmap)
        }
        return bitmapData
    }

    private fun getResizedBitmap(image: Bitmap): Bitmap {
        var width = image.width
        var height = image.height
        val bitmapRatio = width.toFloat() / height.toFloat()
        if (bitmapRatio > 1) {
            width = 48
            height = (width / bitmapRatio).toInt()
        } else {
            height = 48
            width = (height * bitmapRatio).toInt()
        }
        return Bitmap.createScaledBitmap(image, width, height, true)
    }

    private fun getByteArray(bitmap: Bitmap): ByteArray {
        val bos = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.JPEG, 50, bos)
        return bos.toByteArray()
    }

    fun getProfileStatusList(call: MethodCall, result: MethodChannel.Result) {
        val status =
            FlyCore.getProfileStatusList()//[{"id":1,"isCurrentStatus":true,"status":"I am in Mirror Fly"}]
        result.success(status.toJsonString())
    }

    fun insertDefaultStatus(call: MethodCall, result: MethodChannel.Result?) {
        val status = call.argument<String>("status") ?: ""
        if (status.isNotEmpty()) {
            FlyCore.insertDefaultStatus(status)
            result?.success(true)
        }
    }

    @SuppressLint("IntentReset")
    fun openMediaFile(call: MethodCall, result: MethodChannel.Result) {

        val filePath = call.argument<String>("filePath")

        try {
            val file = filePath?.let { File(it) }
            val extension = MimeTypeMap.getFileExtensionFromUrl(filePath)
            val mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension)
            val intent = Intent(Intent.ACTION_VIEW)
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            val fileUri = file?.let {
                FileProvider.getUriForFile(
                    MirrorFlyManager.getContext(), ChatManager.fileProviderAuthority,
                    it
                )
            }
            intent.setDataAndType(fileUri, mimeType)
            val mediaListIntent = Intent(Intent.ACTION_VIEW, fileUri)
            mediaListIntent.type = mimeType
            val mediaViewerApps: List<ResolveInfo> =
                MirrorFlyManager.getContext().packageManager.queryIntentActivities(
                    mediaListIntent,
                    0
                )
            try {
                when {
                    intent.resolveActivity(MirrorFlyManager.getContext().packageManager) != null -> MirrorFlyManager.getContext()
                        .startActivity(
                            intent
                        )

                    mediaViewerApps.isNotEmpty() -> MirrorFlyManager.getContext()
                        .startActivity(intent)

                    else -> result.error("500", "Unable to Open the File", null)
//                Toast.makeText(context, R.string.content_not_found, Toast.LENGTH_LONG).show()
                }
            } catch (e: Exception) {
                result.error("500", "Unable to Open the File", null)
            }
        } catch (e: Exception) {
            result.error("500", "File Not Found", null)
        }
    }

    private fun createDotNoMediaFile() {
//        FilePathUtils.getExternalStorage()

        val mediaPath =
            VideoRecUtils.getSentParentPath(com.mirrorflysdk.flycommons.Constants.MSG_TYPE_IMAGE)

        //LogMessage.d("FIle Upload root path", mediaPath)

        val sentMedia = File(mediaPath)
        if (!sentMedia.exists()) {
            //LogMessage.d(TAG, "sent Media Not exists")
            sentMedia.mkdirs()
        } else {
            //LogMessage.d(TAG, "Sent Media Already Exists")
        }
        val noMediaFile = File(sentMedia, ".nomedia")
        if (!noMediaFile.exists()) {
            //LogMessage.d(TAG, "NoMediaFile not exists")
            try {
                FileWriter(noMediaFile).use { writer ->
                    LogMessage.d(
                        tag,
                        "createNoMedia: $writer"
                    )
                }
            } catch (e: IOException) {
                //LogMessage.d("File Upload Exception", e.message.toString())
                LogMessage.e(e)
            }
        } else {
            //LogMessage.d("File Upload", "No Media Already Exists")
        }
    }


    fun getRecentChatListIncludingArchived(call: MethodCall, result: MethodChannel.Result) {

        val recentChatListWithArchived = FlyCore.getRecentChatListIncludingArchived()
        //LogMessage.d("RESPONSE_CAPTURE", "===========================")
        //DebugUtilis.v( "FlyCore.getRecentChatListIncludingArchived",recentChatListWithArchived.tojsonString())
        result.success(recentChatListWithArchived.toJsonString())

    }

    fun getRecentChatOf(call: MethodCall, result: MethodChannel.Result) {
        val userJID = call.argument<String>("jid") ?: ""
        val recent = FlyCore.getRecentChatOf(userJID)
        if (recent != null) {
            //LogMessage.d("RESPONSE_CAPTURE", "===========================")
            //DebugUtilis.v("FlyCore.getRecentChatOf", recent.tojsonString())
            result.success(recent.toJsonString())
        }else{
            result.success(null)
        }
    }

    fun searchConversation(call: MethodCall, result: MethodChannel.Result) {
        val searchKey = call.argument<String>("searchKey") ?: ""
        val jidForSearch = call.argument<String>("jidForSearch") ?: ""
        val globalSearch = call.argument<Boolean>("globalSearch") ?: true
        FlyCore.searchConversation(
            searchKey,
            jidForSearch,
            globalSearch
        ) { isSuccess, _, data ->
            if (isSuccess) {
                //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                //DebugUtilis.v("FlyCore.searchConversation", data.tojsonString())
                val filterMessageList = data["data"] as MutableList<*>
                LogMessage.d("searchConversation", filterMessageList.toJsonString())
                result.success(filterMessageList.toJsonString())
            }
        }
    }

    fun getRegisteredUsers(call: MethodCall, result: MethodChannel.Result) {
        val server = call.argument<Boolean>("server") ?: false
        FlyCore.getRegisteredUsers(server) { isSuccess, throwable, data ->
            if (isSuccess) {
                val profileDetails = data["data"] as MutableList<ProfileDetails>
                LogMessage.d("profileDetails", profileDetails.toString())
                //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                //DebugUtilis.v("FlyCore.getRegisteredUsers", data.tojsonString())
                result.success(data.toJsonString())
            } else {
                result.error("400", throwable?.message.toString(), "")
            }
        }
    }

    fun refreshAndGetAuthToken(call: MethodCall, result: MethodChannel.Result) {
        FlyCore.refreshAndGetAuthToken { isSuccess, _, data ->
            if (isSuccess) {
                //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                //DebugUtilis.v("FlyCore.refreshAndGetAuthToken", data.tojsonString())
                LogMessage.d(tag, "Token Refresh success: ${data["data"]}")
                result.success(data["data"].toString())
            } else {
                LogMessage.d(tag, "Token Refresh failure")
                result.success(FlyUtils.decodedToken().trim())
            }
        }
    }

    fun blockUser(call: MethodCall, result: MethodChannel.Result) {
        val userJid = call.argument<String>("userJID") ?: ""
        FlyCore.blockUser(userJid) { isSuccess, throwable, data ->
            if (isSuccess) {
                //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                //DebugUtilis.v("FlyCore.blockUser", data.tojsonString())
//                result.success(data.toJsonString())
                result.success(true)
            } else {
                result.error("500", "Unable to Block User", throwable?.toJsonString())
            }

        }
    }

    fun unblockUser(call: MethodCall, result: MethodChannel.Result) {
        val userJid = call.argument<String>("userJID") ?: ""

        FlyCore.unblockUser(userJid) { isSuccess, throwable, data ->
            if (isSuccess) {
                //DebugUtilis.v("FlyCore.unblockUser", data.tojsonString())
                result.success(true)
            } else {
                result.error("500", "Unable to Unblock User", throwable?.toJsonString())

            }

        }
    }

    fun createGroup(call: MethodCall, result: MethodChannel.Result) {
        val groupName = call.argument<String>("group_name") ?: ""
        val members = call.argument<List<String>>("members") ?: arrayListOf()
        val fileTemp = call.argument<String>("file") ?: ""
        val file = if (fileTemp.trim().isNotEmpty()) File(fileTemp) else null
        GroupManager.createGroup(groupName, members,
            file, { isSuccess, throwable, hashmap ->
                if (isSuccess) {
                    //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                    //DebugUtilis.v("GroupManager.createGroup", hashmap.tojsonString())
                    val groupData = hashmap["data"] as CreateGroupModel
                    result.success(groupData.toJsonString())
//                    result.success(true)
                } else {
                    result.error("500", "Unable to Create Group", throwable.toString())
                }
            })
    }

    fun updateGroupProfileImage(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        val fileTemp = call.argument<String>("file") ?: ""
        if (fileTemp.isNotEmpty()) {
            GroupManager.updateGroupProfileImage(jid, File(fileTemp), object : ChatActionListener {
                override fun onResponse(isSuccess: Boolean, message: String) {
                    if (isSuccess) {
                        result.success(isSuccess)
                    } else {
                        result.error("500", message, "")
                    }
                }

            })
        }

    }

    fun addUsersToGroup(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        val members = call.argument<List<String>>("members") ?: arrayListOf()
        GroupManager.addUsersToGroup(jid, members) { isSuccess, throwable, _ ->
            if (isSuccess) {
                result.success(isSuccess)
            } else {
                result.error("500", throwable?.message, "")
            }
        }
    }

    fun makeAdmin(call: MethodCall, result: MethodChannel.Result) {
        val groupjid = call.argument<String>("jid") ?: ""
        val userjid = call.argument<String>("userjid") ?: ""
        GroupManager.makeAdmin(groupjid, userjid, object :
            ChatActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                //LogMessage.d("GroupManager.makeAdmin", message)
                if (isSuccess) {
                    result.success(isSuccess)
                } else {
                    result.error("500", message, "")
                }
            }
        })
    }

    fun removeMemberFromGroup(call: MethodCall, result: MethodChannel.Result) {
        val groupjid = call.argument<String>("jid") ?: ""
        val userjid = call.argument<String>("userjid") ?: ""
        GroupManager.removeMemberFromGroup(groupjid, userjid) { isSuccess, throwable, _ ->
            if (isSuccess) {
                result.success(isSuccess)
            } else {
                result.error("500", throwable?.message, "")
            }
        }
    }

    fun isMuted(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        result.success(ChatManager.isMuted(jid))
    }

    fun exportChatConversationToEmail(call: MethodCall, result: MethodChannel.Result) {
//        val jid = call.argument<String?>("jid") ?: ""
//        FlyCore.exportChatConversationToEmail(jid, emptyList())
        prepareChatConversationToExport(call, result)
    }

    fun verifyToken(call: MethodCall, results: MethodChannel.Result) {
        try {
            val userName = call.argument<String>("userName") ?: ""
            val googleToken = call.argument<String>("googleToken") ?: ""
            FlyNetwork.verifyToken(userName, googleToken) { isSuccess, throwable, data ->
                LogMessage.d(tag, data["data"].toString())
                if (isSuccess) {
                    //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                    //DebugUtilis.v("FlyNetwork.verifyToken", data.tojsonString())
                    val fcmData = data["data"] as VerifyFcmResponse
                    results.success(fcmData.data!!.deviceToken.toString())
                } else {
                    results.error("400", throwable?.message, "")
                }
            }
        } catch (e: Exception) {
            LogMessage.d("verifyToken", e.toString())
            results.error("400", "Server Error, Please try After sometime", "")
        }
    }

    fun getGroupMembersList(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        var fromServer = call.argument<Boolean>("server")
            ?: GroupManager.doesFetchingMembersListFromServedRequired(jid)
        val fetFromServerRequired = GroupManager.doesFetchingMembersListFromServedRequired(jid)
        if (!fromServer && fetFromServerRequired){
            fromServer = true
        }
        LogMessage.d("#getGroupMembersList ", fromServer.toString())
        LogMessage.d("#fetFromServerRequired ", fetFromServerRequired.toString())
        GroupManager.getGroupMembersList(fromServer, jid) { isSuccess, throwable, data ->
            if (isSuccess) {
                //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                //DebugUtilis.v("GroupManager.getGroupMembersList", data.tojsonString())
                val groupMembers: MutableList<ProfileDetails> =
                    data["data"] as ArrayList<ProfileDetails>
                /*val myProfileIndex =
                    groupMembers.indexOfFirst { pd -> pd.jid == SharedPreferenceManager.instance.currentUserJid }
                if (myProfileIndex >= 0) {
                    val myProfile = groupMembers[myProfileIndex]
                    groupMembers.removeAt(myProfileIndex)
                    myProfile.nickName = com.mirrorflysdk.flycommons.Constants.YOU
                    myProfile.name = com.mirrorflysdk.flycommons.Constants.YOU
                    groupMembers.add(myProfile)
                }*/
                result.success(groupMembers.toJsonString())
            } else {
                result.error("404", "fetching group members", throwable.toString())
            }
        }
    }

//    private fun reportUserOrMessages(call: MethodCall, result: MethodChannel.Result) {
//        val jid = call.argument<String>("jid") ?: ""
//        val type = call.argument<String>("type") ?: ChatType.TYPE_CHAT
//        FlyCore.reportUserOrMessages(jid, type) { isSuccess, _, _ ->
//            if (isSuccess) {
//                result.success(true)
//            } else {
//                result.success(false)
//            }
//        }
//    }

    fun leaveFromGroup(call: MethodCall, result: MethodChannel.Result) {
        val groupJid = call.argument<String>("groupJid") ?: ""
        val userJid = call.argument<String>("userJid") ?: ""
        LogMessage.d("leaveGroup", call.arguments.toString())
        GroupManager.leaveFromGroup(groupJid, userJid) { isSuccess, throwable, _ ->
            if (isSuccess) {
                result.success(true)
            } else {
                result.error("500", throwable?.message.toString(), "")
            }
        }
    }

    fun deleteGroup(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        GroupManager.deleteGroup(jid) { isSuccess, throwable, _ ->
            if (isSuccess) {
                result.success(true)
            } else {
                result.error("500", throwable?.message.toString(), "")
            }
        }
    }

    fun removeGroupProfileImage(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        GroupManager.removeGroupProfileImage(jid, object : ChatActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                if (isSuccess) {
                    result.success(true)
                } else {
                    result.error("500", message, "")
                }
            }
        })
    }

    fun updateGroupName(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        val name = call.argument<String>("name") ?: ""
        GroupManager.updateGroupName(jid, name, object : ChatActionListener {
            override fun onResponse(isSuccess: Boolean, message: String) {
                if (isSuccess) {
                    result.success(isSuccess)
                } else {
                    result.error("500", message, "")
                }
            }
        })
    }

    fun getUserLastSeenTime(call: MethodCall, result: MethodChannel.Result) {
        val jid = call.argument<String>("jid") ?: ""
        ContactManager.getRegisteredUserLastSeenTime(jid, object : ContactManager.LastSeenListener {
            override fun onFailure(message: String) {
                /* No Implementation Needed */
                result.error("500", message, "")
            }

            override fun onSuccess(lastSeenTime: String) {
                //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                //DebugUtilis.v("ContactManager.getUserLastSeenTime", lastSeenTime)
                result.success(lastSeenTime)
            }
        })
    }

    fun sendContactUsInfo(call: MethodCall, result: MethodChannel.Result) {
        val title = call.argument<String>("title") ?: ""
        val description = call.argument<String>("description") ?: ""
        ContactManager.sendContactUsInfo(title, description) { isSuccess, throwable, _ ->
            if (isSuccess) {
                result.success(isSuccess)
            } else {
                result.error("500", throwable?.message, "")
            }
        }
    }

    fun getUsersIBlocked(call: MethodCall, result: MethodChannel.Result) {
        val serverCall = call.argument<Boolean>("serverCall") ?: false
        FlyCore.getUsersIBlocked(serverCall) { isSuccess: Boolean, throwable: Throwable?, data: HashMap<String, Any> ->
            if (isSuccess) {
                //LogMessage.d("RESPONSE_CAPTURE", "===========================")
                //DebugUtilis.v("FlyCore.getUsersIBlocked", data.tojsonString())
                val profilesList = data["data"] as ArrayList<ProfileDetails>
                result.success(profilesList.toJsonString())
            } else {
                result.error("500", throwable?.message.toString(), "")
            }
        }
    }

    fun loginWebChatViaQRCode(call: MethodCall, result: MethodChannel.Result) {
        val barcode = call.argument<String>("barcode") ?: ""
        try {
            FlyCore.loginWebChatViaQRCode(barcode) { isSuccess, throwable, _ ->
                if (isSuccess) {
                    result.success(isSuccess)
                    /*val vibrator =
                        MirrorFlyManager.getContext()
                            .getSystemService(FlutterActivity.VIBRATOR_SERVICE) as Vibrator
                    if (vibrator.hasVibrator()) {
                        vibrator.vibrate(50)
                    }*/
                } else {
                    result.error("500", throwable?.message.toString(), "")
                }
            }
        } catch (e: java.lang.Exception) {
            //LogMessage.d("qr", e.toString())
        }
    }

    fun getWebLoginDetails(call: MethodCall, result: MethodChannel.Result) {
        val details = WebLoginDataManager.getWebLoginDetails()
        result.success(details.toJsonString())
    }

    /*fun webLoginDetailsCleared(call: MethodCall, result: MethodChannel.Result) {
        WebLoginDataManager.webLoginDetailsCleared()
        result.success(true)
    }*/

    fun logoutWebUser(call: MethodCall, result: MethodChannel.Result) {
        WebLoginDataManager.logOutWebSessions{isSuccess, throwable, data ->
            if (isSuccess) {
                // Logout from the web session was successful.
                result.success(true)
            } else {
                // Handle the failure of logging out from the web session.
                result.error("500", throwable?.message.toString(), "")
            }

        }
    }

    private lateinit var ringToneResult: MethodChannel.Result
    private var existingCustomTone = "None"
    fun showCustomTones(call: MethodCall, result: MethodChannel.Result) {
        ringToneResult = result
//        existingCustomTone = call.argument<String>("ringtone_uri") ?: "None"
        val existingCustomTone =
            Uri.parse(SharedPreferenceManager.instance.getString("notification_uri"))
        val customToneUri = existingCustomTone.toString()
        val intent = Intent(RingtoneManager.ACTION_RINGTONE_PICKER)
        intent.putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, RingtoneManager.TYPE_NOTIFICATION)
        intent.putExtra(RingtoneManager.EXTRA_RINGTONE_TITLE, "Notification")
        if (customToneUri != "None")
            intent.putExtra(RingtoneManager.EXTRA_RINGTONE_EXISTING_URI, existingCustomTone)
        getActivity()?.startActivityForResult(
            intent,
            com.mirrorflysdk.flycommons.Constants.ACTIVITY_REQ_CODE
        )
        /* setting isActivityStartedForResult to true to avoid xmpp disconnection */
        ChatManager.isActivityStartedForResult = true
    }

    /*override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) : Boolean{
        *//* setting isActivityStartedForResult to false for xmpp disconnection *//*
        Log.d("onActivityResult", "onActivity Result")
        ChatManager.isActivityStartedForResult = false
        //try {
            if(resultCode == Activity.RESULT_OK && requestCode == Constants.FROM_GALLERY) {
                data?.let { handleAudioVideoIntentFromGalleryMenu(data) }
            }else if(resultCode == Activity.RESULT_CANCELED && requestCode == Constants.FROM_GALLERY){
                audioFileResult?.error("500","audio file picker cancelled","")
            }else {
                if (resultCode == Activity.RESULT_OK && requestCode == com.mirrorflysdk.flycommons.Constants.ACTIVITY_REQ_CODE &&
                    data?.parcelable<Parcelable>(RingtoneManager.EXTRA_RINGTONE_PICKED_URI) != null
                ) {


                    val selectedToneUri =
                        (data.parcelable<Parcelable>(RingtoneManager.EXTRA_RINGTONE_PICKED_URI)
                            .toString())
                    LogMessage.d("Android Notification", selectedToneUri)
                    //SharedPreferenceManager.instance.storeString(com.contusfly.utils.Constants.NOTIFICATION_URI, data.getParcelableExtra<Parcelable>(RingtoneManager.EXTRA_RINGTONE_PICKED_URI).toString())
                    //binding.notificationToneLabel.setText(getRingtoneName(SharedPreferenceManager.instance.getString(com.contusfly.utils.Constants.NOTIFICATION_URI)))
                    setNotificationUri(selectedToneUri)
                    ringToneResult.success(selectedToneUri)
                    return true
                }

                if (data == null) {
                    LogMessage.d("Android Notification", "data is null")
                    setNotificationUri(existingCustomTone)
                    ringToneResult.success(existingCustomTone)

                    //SharedPreferenceManager.instance.storeString(com.contusfly.utils.Constants.NOTIFICATION_URI, SharedPreferenceManager.instance.getString(com.contusfly.utils.Constants.NOTIFICATION_URI))
                    //binding.notificationToneLabel.setText(getRingtoneName(SharedPreferenceManager.instance.getString(com.contusfly.utils.Constants.NOTIFICATION_URI)))
                    return false
                } else if (data.parcelable<Parcelable>(RingtoneManager.EXTRA_RINGTONE_PICKED_URI) == null) {
                    LogMessage.d("Android Notification", "ringtone is null")
                    setNotificationUri(null)
                    ringToneResult.success("None")

                    //SharedPreferenceManager.instance.storeString(com.contusfly.utils.Constants.NOTIFICATION_URI, "None")
                    //binding.notificationToneLabel.setText(getRingtoneName(SharedPreferenceManager.instance.getString(com.contusfly.utils.Constants.NOTIFICATION_URI)))
                    return true
                }
            }
            return false
//        } catch (exception: Exception) {
//            LogMessage.e(exception)
//            return false
//        }

    }*/

    fun getRingtoneName(call: MethodCall, result: MethodChannel.Result) {
//        val default = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION).toString()
        val storedNotification = SharedPreferenceManager.instance.getString("notification_uri")
        LogMessage.d("stored notification", storedNotification)

        val ringtoneJSONObject = JSONObject()

        if (storedNotification == "") {
            ringtoneJSONObject.put(
                "name",
                SharedPreferenceManager.instance.getString("notification_uri")
            )
            ringtoneJSONObject.put(
                "tone_uri",
                SharedPreferenceManager.instance.getString("notification_uri")
            )
            result.success(ringtoneJSONObject.toString())
        }
//        if(storedNotification == ""){
//            return RingtoneManager.getRingtone(mContext, Uri.parse(default)).getTitle(mContext)
//        }
        val ringtone = RingtoneManager.getRingtone(
            MirrorFlyManager.getContext(),
            Uri.parse(storedNotification)
        )
        ringtoneJSONObject.put("name", ringtone.getTitle(MirrorFlyManager.getContext()))
        ringtoneJSONObject.put("tone_uri", storedNotification)

        result.success(ringtoneJSONObject.toString())

    }

    fun setOnGoingChatUser(call: MethodCall, result: MethodChannel.Result) {
        val userJID =
            if (call.argument<String>("jid") == null) "" else call.argument<String?>("jid")
                .toString()
        LogMessage.d("setOnGoingChatUser", userJID)
        ChatManager.setOnGoingChatUser(userJID)
    }

    private fun getTypingStatus(status: TypingStatus): String {
        return if (status == TypingStatus.COMPOSING) {
            "composing"
        } else {
            "Gone"
        }
    }

    fun getDefaultNotificationUri(call: MethodCall, result: MethodChannel.Result) {
        val default = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION).toString()
        setNotificationUri(default)
        result.success(default)
    }

    private fun setNotificationUri(uri: String?) {
        LogMessage.d("Android Notification set", uri.toString())
        SharedPreferenceManager.instance.storeString(SharedPreferenceManager.NOTIFICATION_URI, uri)
    }

    /*private fun setNotificationUri(call: MethodCall, result: MethodChannel.Result){
      val uri = call.argument<String>("uri") ?: ""
      SharedPreferenceManager.instance.storeString("notification_uri",uri)
  }*/
    fun setNotificationSound(call: MethodCall, result: MethodChannel.Result) {
        val enable = call.argument("enable") ?: false
        SharedPreferenceManager.instance.storeBoolean(
            SharedPreferenceManager.NOTIFICATION_SOUND,
            enable
        )
    }

    fun isBusyStatusEnabled(call: MethodCall, result: MethodChannel.Result) {
        result.success(FlyCore.isBusyStatusEnabled())
    }

    fun getNotificationSound(call: MethodCall, result: MethodChannel.Result) {
        result.success(SharedPreferenceManager.instance.getBoolean(SharedPreferenceManager.NOTIFICATION_SOUND))
    }

    fun setMuteNotification(call: MethodCall, result: MethodChannel.Result) {
        val enable = call.argument("enable") ?: false
        SharedPreferenceManager.instance.storeBoolean(
            SharedPreferenceManager.MUTE_NOTIFICATION,
            enable
        )
    }

    fun setNotificationVibration(call: MethodCall, result: MethodChannel.Result) {
        val enable = call.argument("enable") ?: false
        SharedPreferenceManager.instance.storeBoolean(SharedPreferenceManager.VIBRATION, enable)
    }

    fun cancelNotifications(call: MethodCall, result: MethodChannel.Result) {
        //AppNotificationManager.cancelNotifications(mContext)
    }

    fun openCreateContact(call: MethodCall, result: MethodChannel.Result) {
        val phone = call.argument("number") ?: ""
        // Create a new Intent to open the Contacts app with a pre-filled contact form
        val intent = Intent(Intent.ACTION_INSERT)
        intent.type = ContactsContract.Contacts.CONTENT_TYPE

        // Set the contact fields using the data provided by the Flutter app
        intent.putExtra(ContactsContract.Intents.Insert.PHONE, phone)

        // Launch the Contacts app with the pre-filled contact form
        getActivity()?.startActivity(intent)
    }

    private fun launchedActivityFromHistory(intent: Intent?): Boolean {
        return (intent != null
                && intent.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY
                == Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY)
    }

    private fun getCallNotificationAppLaunchDetails(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        /*val notificationAppLaunchDetails: MutableMap<String, Any> = HashMap()
        var notificationLaunchedApp = false
        if (mainActivity != null) {
            val launchIntent: Intent = mainActivity!!.intent
            notificationLaunchedApp =
                (launchIntent != null && (SELECT_NOTIFICATION.equals(launchIntent.action)
                        || SELECT_FOREGROUND_NOTIFICATION_ACTION.equals(launchIntent.action))
                        && !launchedActivityFromHistory(launchIntent))
            if (notificationLaunchedApp) {
                notificationAppLaunchDetails["notificationResponse"] =
                    extractNotificationResponseMap(launchIntent)
            }
        }
//        notificationAppLaunchDetails[NOTIFICATION_LAUNCHED_APP] = notificationLaunchedApp
        result.success(notificationAppLaunchDetails)*/
        val appLaunchDetail = JSONObject()
        var notificationLaunchedApp = false
        if (getActivity() != null) {
            val launchIntent = getActivity()!!.intent
            notificationLaunchedApp =
                (launchIntent != null /*&& (SELECT_NOTIFICATION.equals(launchIntent.action)
                        || SELECT_FOREGROUND_NOTIFICATION_ACTION.equals(launchIntent.action))*/
                        && !launchedActivityFromHistory(launchIntent))
            if (notificationLaunchedApp) {
                appLaunchDetail.put("action", launchIntent.action)
                appLaunchDetail.put("data", extractNotificationResponseMap(launchIntent))
            }
        }
        result.success(appLaunchDetail.toString())
    }

    fun extractNotificationResponseMap(intent: Intent): Map<String, Any?>? {
//        val notificationId = intent.getIntExtra(NOTIFICATION_ID, 0)
//        val notificationResponseMap: MutableMap<String, Any?> = HashMap()
        /*notificationResponseMap[NOTIFICATION_ID] =
            notificationId
        notificationResponseMap[ACTION_ID] = intent.getStringExtra(ACTION_ID)
        notificationResponseMap[FlutterLocalNotificationsPlugin.PAYLOAD] =
            intent.getStringExtra(FlutterLocalNotificationsPlugin.PAYLOAD)
        val remoteInput: Bundle = RemoteInput.getResultsFromIntent(intent)
        if (remoteInput != null) {
            notificationResponseMap[INPUT] = remoteInput.getString(INPUT_RESULT)
        }
        if (SELECT_NOTIFICATION.equals(intent.action)) {
            notificationResponseMap[NOTIFICATION_RESPONSE_TYPE] = 0
        }
        if (SELECT_FOREGROUND_NOTIFICATION_ACTION.equals(intent.action)) {
            notificationResponseMap[NOTIFICATION_RESPONSE_TYPE] = 1
        }*/
        return HashMap()
    }

    private fun sendNotificationPayloadMessage(intent: Intent): Boolean {
        Log.d("sendNotificationPayloadMessage", "${intent.extras}")
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

    //    var isFileChooser = false
//    var audioFileResult: MethodChannel.Result? = null
    private var activityBinding: ActivityPluginBinding? = null
    fun selectAudioFileFromStorage(call: MethodCall, result: MethodChannel.Result) {
        Log.d("FlyChat", "selectAudioFileFromStorage ${getActivity()}")
//        isFileChooser = true
        MirrorFlyManager.setMethodResult(result)
        val manufacturer = Build.MANUFACTURER.uppercase(Locale.getDefault())
        val intent = Intent(Intent.ACTION_PICK, MediaStore.Audio.Media.EXTERNAL_CONTENT_URI)
        val audioListIntent = Intent(Intent.ACTION_GET_CONTENT)
        audioListIntent.type = Constants.AUDIO_FILE
        val audioPickerApps: List<ResolveInfo> =
            MirrorFlyManager.getContext().packageManager.queryIntentActivities(audioListIntent, 0)
        when {
            manufacturer.contains("HMD GLOBAL") -> {
                openCustomOSAudioSelection()
            }

            manufacturer.contains("VIVO") -> {
                openCustomOSAudioSelection()
            }

            manufacturer.contains("REALME") -> {
                openCustomOSAudioSelection()
            }

            manufacturer.contains("SAMSUNG") -> {
                val intent2 = Intent("com.sec.android.app.myfiles.PICK_DATA")
                intent2.putExtra("CONTENT_TYPE", audioListIntent.type)
                intent2.addCategory(Intent.CATEGORY_DEFAULT)
                getActivity()?.startActivityForResult(intent2, Constants.FROM_GALLERY)
                /* setting isActivityStartedForResult to true to avoid xmpp disconnection*/
                ChatManager.isActivityStartedForResult = true
            }

            intent.resolveActivity(MirrorFlyManager.getContext().packageManager) != null -> {
                getActivity()?.startActivityForResult(intent, Constants.FROM_GALLERY)
                /* setting isActivityStartedForResult to true to avoid xmpp disconnection*/
                ChatManager.isActivityStartedForResult = true
            }

            audioPickerApps.isNotEmpty() -> {
                try {
                    val audioIntent = Intent(Intent.ACTION_GET_CONTENT)
                    audioIntent.setDataAndType(
                        MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                        Constants.AUDIO_FILE
                    )
                    getActivity()?.startActivityForResult(audioIntent, Constants.FROM_GALLERY)
                } catch (e: Exception) {
                    MirrorFlyManager.audioFileResult?.error("500", e.message, e)
                    LogMessage.e(tag, e.stackTraceToString())
                } catch (e: SecurityException) {
                    MirrorFlyManager.audioFileResult?.error("500", e.message, e)
                    LogMessage.e(tag, e.stackTraceToString())
                }

            }

            else -> noAudioFound()
        }
    }

    private fun noAudioFound() {
//        isFileChooser = false
        MirrorFlyManager.audioFileResult?.error("500", "No suitable app found!", "")
//        showToast("No suitable app found!")
    }

    private fun openCustomOSAudioSelection() {
        val intent = Intent(Intent.ACTION_GET_CONTENT)
        intent.type = Constants.AUDIO_FILE
        if (intent.resolveActivity(MirrorFlyManager.getContext().packageManager) != null) {
            getActivity()?.startActivityForResult(intent, Constants.FROM_GALLERY)
            /* setting isActivityStartedForResult to true to avoid xmpp disconnection*/
            ChatManager.isActivityStartedForResult = true
        }
    }

    private fun handleAudioVideoIntentFromGalleryMenu(resultCode: Int, intent: Intent?) {
        if (resultCode == Activity.RESULT_CANCELED) {
            MirrorFlyManager.audioFileResult?.error("500", "picker cancelled by user", "")
            MirrorFlyManager.audioFileResult = null
            return
        }
        val uri = intent?.data
        if (uri != null) {
            val uriOfSelectedFile = intent.data!!
            val mimeType = getActivity()?.applicationContext?.contentResolver?.getType(
                uriOfSelectedFile
            )
            val pathOfSelectedFile = RealPathUtil.getRealPath(
                getActivity()?.applicationContext!!,
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

    private fun getMissedCallNotificationContent(
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
    }

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

    fun editTextMessage(call: MethodCall, result: MethodChannel.Result) {
        val message_id = call.argument<String>("messageId") ?: ""
        val edited_text_content = call.argument<String>("editedTextContent") ?: ""
        val mentioned_users_Ids = call.argument<List<String>>("mentionedUsersIds") ?: arrayListOf()

        val editMessage = EditMessage().apply {
            messageId = message_id
            editedTextContent = edited_text_content
            mentionedUsersIds = mentioned_users_Ids
        }

        FlyMessenger.editTextMessage(editMessage, object : SendMessageCallback {
            override fun onResponse(
                isSuccess: Boolean,
                error: Throwable?,
                chatMessage: ChatMessage?
            ) {
                if (isSuccess) {
                    if (chatMessage != null) {
                        result.success(chatMessage.toJsonString())
                    } else {
                        result.error("500", "Error while editing message", error)
                    }
                } else {
                    result.error("500", error?.message, error)
                }
            }
        })
    }

    fun editMediaCaption(call: MethodCall, result: MethodChannel.Result) {
        val message_id = call.argument<String>("messageId") ?: ""
        val edited_text_content = call.argument<String>("editedTextContent") ?: ""
        val mentioned_users_Ids = call.argument<List<String>>("mentionedUsersIds") ?: arrayListOf()

        val editMessage = EditMessage().apply {
            messageId = message_id
            editedTextContent = edited_text_content
            mentionedUsersIds = mentioned_users_Ids
        }

        FlyMessenger.editMediaCaption(editMessage, object : SendMessageCallback {
            override fun onResponse(
                isSuccess: Boolean,
                error: Throwable?,
                chatMessage: ChatMessage?
            ) {
                if (isSuccess) {
                    if (chatMessage != null) {
                        result.success(chatMessage.toJsonString())
                    } else {
                        result.error("500", "Error while editing caption text", error)
                    }
                } else {
                    result.error("500", error?.message, error)
                }
            }
        })
    }

    fun startBackup(call: MethodCall, result: MethodChannel.Result){
        val enableEncryption = call.argument<Boolean>("enableEncryption") ?: true
        BackupManager.startBackup(
            isEncrypt = enableEncryption, backupListener = object : BackupListener {
                override fun onFailure(reason: String) {
                    MirrorFlyManager.getActivity()?.runOnUiThread {
                        FlyMethodConstants.updateChatSinkValue(
                            Constants.onBackupFailureChannel,
                            reason
                        )
                    }
                }

                override fun onProgressChanged(percentage: Int) {
                    MirrorFlyManager.getActivity()?.runOnUiThread {
                        FlyMethodConstants.updateChatSinkValue(
                            Constants.onBackupProgressChangedChannel,
                            percentage
                        )
                    }
                }

                override fun onSuccess(backUpFilePath: String) {
                    MirrorFlyManager.getActivity()?.runOnUiThread {
                        FlyMethodConstants.updateChatSinkValue(
                            Constants.onBackupSuccessChannel,
                            backUpFilePath
                        )
                    }
                }
            }
        )
    }
    fun restoreBackup(call: MethodCall, result: MethodChannel.Result){
        val filepath = call.argument<String>("backupPath") ?: ""
        val file = File(filepath)
        if (file.exists()) {
            RestoreManager.restoreData(file, object : RestoreListener {
                override fun onFailure(reason: String) {
//                                onFailureStreamHandler.onFailure?.success(reason)
                    MirrorFlyManager.getActivity()?.runOnUiThread {
                        FlyMethodConstants.updateChatSinkValue(
                            Constants.onRestoreFailureChannel,
                            reason
                        )
                    }
                }

                override fun onProgressChanged(percentage: Int) {
//                                onProgressChangedStreamHandler.onProgressChanged?.success(percentage)
                    MirrorFlyManager.getActivity()?.runOnUiThread {
                        FlyMethodConstants.updateChatSinkValue(
                            Constants.onRestoreProgressChangedChannel,
                            percentage
                        )
                    }
                }

                override fun onSuccess() {
//                                onSuccessStreamHandler.onSuccess?.success("")
                    MirrorFlyManager.getActivity()?.runOnUiThread {
                    FlyMethodConstants.updateChatSinkValue(
                            Constants.onRestoreSuccessChannel,
                            true
                    )
                        }
                }
            })
        }
    }
    fun cancelBackup(call: MethodCall, result: MethodChannel.Result){
        BackupManager.cancelBackup()
        result.success(true)
    }
    fun cancelRestore(call: MethodCall, result: MethodChannel.Result){
        RestoreManager.cancelRestore()
        result.success(true)
    }

    fun setTranslations(call: MethodCall, result: MethodChannel.Result) {
        val receivedMap = call.argument<Map<String, String>>("stringSet")
        val stringSet = HashMap<String, String>()
        if (receivedMap != null) {
            for ((key, value) in receivedMap) {
                val stringConstKey = FlyTranslations.constantMap[key]
                if (stringConstKey != null) {
                    if (value.contains("{%s}")) {
                        stringSet[stringConstKey] = value.replace("{%s}", "%s")
                    } else {
                        stringSet[stringConstKey] = value
                    }
                } else {
                    Log.d("FlyTranslations", "Unknown key: $key")
                }
            }
            MFTextLocalization.setStringSet(stringSet)
            result.success(true)
        } else {
            result.error(MirrorFlyErrorCodes.TRANSLATION_STRING_SET_NOT_FOUND, "setTranslations stringSet is null", null)
        }
    }
}