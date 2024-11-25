import 'package:flutter/services.dart';
import 'package:mirrorfly_plugin/edit_message_params.dart';
import 'package:mirrorfly_plugin/mirrorfly.dart';

import 'fly_chat_platform_interface.dart';

/// The main class for the MirrorFly Flutter plugin.
/// This class provides static methods to interact with the MirrorFly platform.
/// It serves as the entry point for the plugin and provides methods to initialize the SDK,
/// send messages, and perform other operations.
/// The class is implemented as a singleton, and its methods are accessed through static calls.
/// To use the plugin, import the `mirrorfly_plugin` package and call the methods on the `Mirrorfly` class.
class Mirrorfly {
  Mirrorfly._();

  /// isTrialLicence to check the trial or live licence
  @Deprecated(
      'This method is deprecated. Please refrain from using it, as the functionality has been internally managed within the plugin')
  static var isTrialLicence = true;

  /// isChatHistoryEnabled to check the chat history is enabled or not
  static var isChatHistoryEnabled = false;

  /// isPrivateStorageEnabled to check the private storage is enabled or not
  static var isPrivateStorageEnabled = false;

  ///Used as a initChat class for [Mirrorfly]
  ///
  /// * @param [baseUrl] provides the base url for making api calls
  /// * @param [licenseKey] provides the License Key
  /// @param [iOSContainerID] provides the App Group of the iOS Project
  /// @param [chatHistoryEnable] set true to enable chat History.
  /// @param [isTrialLicenceKey] to provide trial/live register and contact sync
  /// @param [storageFolderName] provides the Local Storage Folder Name
  /// @param [enableDebugLog] provides the Debug Log.
  @Deprecated('Instead of use Mirrorfly.initializeSDK()')
  static init(
      {required String baseUrl,
      required String licenseKey,
      required String iOSContainerID,
      String? storageFolderName,
      bool enableMobileNumberLogin = true,
      bool isTrialLicenceKey = true,
      bool chatHistoryEnable = false,
      // int? maximumRecentChatPin,
      // GroupConfig? groupConfig,
      // String? ivKey,
      bool enableDebugLog = false}) {
    var builder = ChatBuilder(
        domainBaseUrl: baseUrl,
        iOSContainerID: iOSContainerID,
        licenseKey: licenseKey,
        storageFolderName: storageFolderName,
        enableMobileNumberLogin: enableMobileNumberLogin,
        isTrialLicenceKey: isTrialLicenceKey,
        chatHistoryEnable: chatHistoryEnable,
        // maximumRecentChatPin: maximumRecentChatPin,
        // groupConfig: groupConfig,
        // ivKey: ivKey,
        enableDebugLog: enableDebugLog);
    isTrialLicence = isTrialLicenceKey;
    isChatHistoryEnabled = chatHistoryEnable;
    FlyChatFlutterPlatform.instance.init(builder);
  }

  /// Initializes the SDK with the provided configuration parameters.
  ///
  /// This method initializes the Mirrorfly SDK with the specified configuration parameters.
  /// It is an asynchronous operation that returns a [Future] that completes with [void] once the initialization is complete.
  ///
  /// Parameters:
  ///   - [licenseKey] : The license key used for SDK initialization. Must not be null.
  ///   - [iOSContainerID] : The iOSContainerID represents App Group ID for iOS app sharing data between app extensions and containing apps. Must not be null for iOS.
  ///   - [storageFolderName] : The name of the storage folder to be used by the SDK. Defaults to "Mirrorfly".
  ///   - [chatHistoryEnable] : Flag indicating whether chat history should be enabled. Defaults to false.
  ///   - [enableMobileNumberLogin] : Flag indicating whether mobile number login should be enabled. Defaults to true.
  ///   - [enableDebugLog] : Flag indicating whether debug logs should be enabled. Defaults to false.
  ///   - [enablePrivateStorage] : Flag indicating whether private storage should be enable. Defaults to false.
  ///   - [flyCallback] : A callback function to handle the response from the SDK initialization. Must not be null.
  ///
  /// Returns:
  ///   A [Future] that completes with [void] once the initialization is complete.
  ///
  /// Throws:
  ///   - [PlatformException] if any of the required parameters are null or other exceptions.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.initializeSDK(
  ///   licenseKey: "your_license_key",
  ///   iOSAppGroupID: "your_app_group_id",
  ///   flyCallback: (response) {
  ///     if (response.isSuccess) {
  ///       print('SDK initialization successful');
  ///     } else {
  ///       print('SDK initialization failed: ${response.errorMessage}');
  ///     }
  ///
  ///     runApp(const MyApp());
  ///
  ///   },
  /// );
  /// ```
  static Future<void> initializeSDK(
      {required String licenseKey,
      required String iOSContainerID,
      String? storageFolderName = "Mirrorfly",
      bool chatHistoryEnable = false,
      bool enableMobileNumberLogin = true,
      bool enableDebugLog = false,
      bool enablePrivateStorage = false,
      required Function(FlyResponse response) flyCallback}) {
    var builder = InitializeSDKBuilder(
        iOSContainerID: iOSContainerID,
        licenseKey: licenseKey,
        storageFolderName: storageFolderName,
        chatHistoryEnable: chatHistoryEnable,
        enableMobileNumberLogin: enableMobileNumberLogin,
        enableDebugLog: enableDebugLog,
        enablePrivateStorage: enablePrivateStorage);
    isChatHistoryEnabled = chatHistoryEnable;
    isPrivateStorageEnabled = enablePrivateStorage;
    return FlyChatFlutterPlatform.instance.initializeSDK(builder, flyCallback);
  }

  /// Provides functionality to register the user to the Mirrorfly platform.
  @Deprecated('Instead of use Mirrorfly.login()')
  static Future<void> registerUser(
      {required String userIdentifier,
      String fcmToken = "",
      bool isForceRegister = true,
      required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.registerUser(userIdentifier,
        fcmToken: fcmToken,
        isForceRegister: isForceRegister,
        callback: flyCallback);
  }

  /// Provides functionality to log in a user to the Mirrorfly platform.
  ///
  /// This static method initiates the login process for a user with the specified [userIdentifier] to the Mirrorfly platform.
  /// Optionally, you can provide the [fcmToken] for Firebase Cloud Messaging (FCM) integration,
  /// and specify whether to forcefully register the user if not already registered with [isForceRegister].to specify the app user type use [userType].
  ///
  /// The [flyCallback] function is called upon completion of the login operation,
  /// providing a [FlyResponse] object containing information about the operation's success or failure.
  /// The [identifierMetaData] parameter is optional and represents additional metadata associated with the User.
  ///
  /// Throws an error if the [userIdentifier] is not provided.
  ///
  /// Example usage:
  /// ```dart
  ///   await Mirrorfly.login(
  ///     userIdentifier: 'example_user_id',
  ///     fcmToken: 'example_fcm_token',
  ///     userType: 'd'
  ///     isForceRegister: true,
  ///     flyCallback: (FlyResponse response) {
  ///       if (response.success) {
  ///         print('User logged in successfully.');
  ///       } else {
  ///         print('Login failed: ${response.errorMessage}');
  ///       }
  ///     },
  ///   );
  /// ```
  ///
  /// Note: This method is a static member of the [Mirrorfly] class.
  static Future<void> login(
      {required String userIdentifier,
      String fcmToken = "",
      String userType = "d",
      bool isForceRegister = true,
      List<IdentifierMetaData>? identifierMetaData,
      required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.registerUser(userIdentifier,
        fcmToken: fcmToken,
        userType: userType,
        isForceRegister: isForceRegister,
        identifierMetaData: identifierMetaData,
        callback: flyCallback);
  }

  /// Logs the user out of the Mirrorfly chat SDK.
  ///
  /// This static method sends a request to the Mirrorfly chat SDK to logout
  /// the current user. It returns a [Future] that completes with a [bool] value,
  /// indicating whether the logout operation was successful (`true`) or not (`false`).
  ///
  /// Returns:
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  /// Example:
  /// ```dart
  /// Mirrorfly.logoutOfChatSDK(flyCallBack: (response){
  ///   if(response.isSuccess){
  ///     print('User logged out of Mirrorfly chat SDK.');
  ///   }else{
  ///     print('Failed to logout of Mirrorfly chat SDK.');
  ///   }
  /// });
  /// ```
  static Future<void> logoutOfChatSDK(
      {required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.logoutOfChatSDK(flyCallBack);
  }

  /// isPrivateStorageEnabledOrNot to check the private storage is enabled or not
  static Future<bool> isPrivateStorageEnabledOrNot() {
    return FlyChatFlutterPlatform.instance.isPrivateStorageEnabledOrNot();
  }

  /*static Future<String?> getPlatformVersion() {
    return FlyChatFlutterPlatform.instance.getPlatformVersion();
  }*/
  /*static init(ChatBuilder builder){
    return FlyChatFlutterPlatform.instance.init(builder);
  }*/

  /// Asynchronously synchronizes contacts with the Mirrorfly platform.
  ///
  /// This method triggers the synchronization process with the Mirrorfly platform
  /// to update the local contact list. It takes a boolean parameter, [isFirstTime],
  /// indicating whether this is the first synchronization attempt. The return value
  /// is a Future<bool?>, representing the success of the synchronization operation.
  /// If the synchronization is successful, it returns true; otherwise, it returns false
  /// or null in case of any errors or exceptions.
  ///
  /// Parameters:
  ///   - isFirstTime: A required boolean parameter indicating whether this is the
  ///     first synchronization attempt.
  ///
  /// Returns:
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  ///
  /// Example usage:
  /// ```dart
  /// Mirrorfly.syncContacts(isFirstTime: true,flyCallBack: (response){
  /// });
  /// ```
  static Future<void> syncContacts(
      {required bool isFirstTime,
      required Function(FlyResponse response) flyCallBack}) async {
    return FlyChatFlutterPlatform.instance
        .syncContacts(isFirstTime, flyCallBack);
  }

  /// Checks the current state of contact synchronization.
  ///
  /// This method queries the current state of contact synchronization with the Mirrorfly platform.
  /// It returns a [Future<bool>] indicating the synchronization state.
  ///
  /// Returns:
  /// - `true` if contacts are currently being synchronized.
  /// - `false` if contacts are not currently being synchronized.
  static Future<bool> contactSyncStateValue() {
    return FlyChatFlutterPlatform.instance.contactSyncStateValue();
  }

  /*static Future<dynamic> contactSyncState() {
    return FlyChatFlutterPlatform.instance.contactSyncState();
  }*/

  /// Revokes the contact synchronization process.
  ///
  /// This method is used to revoke or cancel the ongoing contact synchronization process with the Mirrorfly platform.
  /// It can be useful in scenarios where the app needs to stop the synchronization process due to user action or any other condition.
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  /// Throws:
  ///   - [PlatformException] if there is an issue with revoking the contact sync process.

  static Future<void> revokeContactSync(
      {required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.revokeContactSync(flyCallBack);
  }

  /// Retrieves a list of users who have blocked the current user.
  ///
  /// This method retrieves a list of users who have blocked the current user
  /// from accessing their profiles or interacting with them. The list may be
  /// fetched either from local DB or from the server, depending on the value
  /// of the [fetchFromServer] parameter.
  ///
  /// If [fetchFromServer] is set to `true`, the method will fetch the list of
  /// blocked users from the server, ensuring that the most up-to-date data is
  /// obtained. If set to `false`, the method will attempt to retrieve the data
  /// from the local DB, if available, which may result in faster response
  /// times but potentially outdated data.
  ///
  /// Note: This method is a static member of the [UserUtils] class.
  ///
  /// Parameters:
  ///   - [fetchFromServer]: A boolean flag indicating whether to fetch the list
  ///     of blocked users from the server (`true`) or from the local DB
  ///     (`false`). Defaults to `false`.
  ///
  /// Returns:
  ///   A [Future] that completes with the list of users who have blocked the
  ///   current user. The type of the list may vary depending on the implementation,
  ///   so it is returned as `String`.
  static Future<void> getUsersWhoBlockedMe(
      {bool fetchFromServer = false,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .getUsersWhoBlockedMe(fetchFromServer, flyCallBack);
  }

  /*static Future<dynamic> getUnKnownUserProfiles() {
    return FlyChatFlutterPlatform.instance.getUnKnownUserProfiles();
  }*/

  /*static Future<dynamic> getMyProfileStatus() {
    return FlyChatFlutterPlatform.instance.getMyProfileStatus();
  }*/

  /// Retrieves the busy status of the current user asynchronously.
  ///
  /// This method sends a request to the Mirrorfly platform to retrieve the busy status of the current user.
  /// The busy status indicates whether the user is currently engaged or busy with some activity.
  ///
  /// Returns a [Future] that completes with a [String] representing
  /// the busy status of the user.
  ///
  /// Example usage:
  /// ```dart
  /// Mirrorfly.getMyBusyStatus().then((value) {
  ///   var userBusyStatus = json.decode(value);
  /// }
  /// ```
  static Future<String> getMyBusyStatus() {
    return FlyChatFlutterPlatform.instance.getMyBusyStatus();
  }

  /// Retrieves the list of busy statuses asynchronously.
  ///
  /// This static function asynchronously retrieves the list of busy statuses from the platform
  /// using [getBusyStatusList]. The returned value is a Future that completes with a
  /// String representing the busy status list.
  ///
  /// Example:
  /// ```dart
  /// Mirrorfly.getBusyStatusList().then((value) {
  //       if (value != null) {
  //         busyStatusList(statusDataFromJson(value));
  //         busyStatusList.refresh();
  //       }
  //     }).catchError((onError) {
  //
  //     });
  /// ```
  static Future<String?> getBusyStatusList() {
    return FlyChatFlutterPlatform.instance.getBusyStatusList();
  }

  /*static Future<String?> getRecalledMessagesOfAConversation({required String jid}) {
    return FlyChatFlutterPlatform.instance.getRecalledMessagesOfAConversation(jid);
  }*/

  /// Sets the busy status of the current user.
  ///
  /// This method asynchronously sets the busy status of the current user to the specified [busyStatus].
  /// The [busyStatus] parameter is a required string indicating the user's current status, such as "I'm busy" or "Driving".
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  ///
  ///Example:
  /// ```dart
  /// Mirrorfly.setMyBusyStatus(busyStatus: "I'm busy",flyCallBack: (response){
  /// });
  /// ```
  static Future<void> setMyBusyStatus(
      {required String busyStatus,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .setMyBusyStatus(busyStatus, flyCallBack);
  }

  /// Enables or disables the busy status feature.
  ///
  /// This method allows the application to enable or disable the busy status feature.
  /// When the feature is enabled, it indicates that the user is busy and may not be
  /// available to respond to messages. When disabled, the user is considered available
  /// for communication.
  ///
  /// The [enable] parameter specifies whether to enable or disable the busy status:
  /// - If `true`, the busy status feature will be enabled.
  /// - If `false`, the busy status feature will be disabled.
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  ///
  /// Example usage:
  /// ```dart
  /// Mirrorfly.enableDisableBusyStatus(enable: true,flyCallBack: (response){
  ///
  /// });
  /// ```
  static Future<void> enableDisableBusyStatus(
      {required bool enable,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .enableDisableBusyStatus(enable, flyCallBack);
  }

  /// Retrieves the last seen status of the current user.
  @Deprecated('Instead of use Mirrorfly.setLastSeenVisibility()')
  static Future<bool?> enableDisableHideLastSeen(bool enable) async {
    return FlyChatFlutterPlatform.instance.enableDisableHideLastSeen(enable);
  }

  /// Sets the visibility of the last seen status.
  ///
  /// This method allows the user to enable or disable the visibility of the last seen status
  /// in the chat application.
  ///
  /// The [enable] parameter specifies whether to enable (`true`) or disable (`false`) the
  /// visibility of the last seen status.
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  ///
  /// Example usage:
  /// ```dart
  /// Mirrorfly.setLastSeenVisibility(enable: true,flyCallBack: (response){
  ///
  /// });
  /// ```
  static Future<void> setLastSeenVisibility(
      {required bool enable,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .setLastSeenVisibility(enable, flyCallBack);
  }

  /// Checks whether the busy status feature is enabled for the current user.
  ///
  /// Returns a [Future] that resolves to a boolean value indicating whether
  /// the busy status feature is enabled. If the feature is enabled, the future
  /// completes with `true`; otherwise, it completes with `false`.
  ///
  /// Usage:
  /// ```dart
  /// bool isEnabled = await Mirrorfly.isBusyStatusEnabled();
  /// if (isEnabled != null) {
  ///   print('Busy status feature is ${isEnabled ? 'enabled' : 'disabled'}');
  /// } else {
  ///   print('Unable to determine busy status feature status.');
  /// }
  /// ```
  ///
  static Future<bool> isBusyStatusEnabled() {
    return FlyChatFlutterPlatform.instance.isBusyStatusEnabled();
  }

  /// Deletes a profile status.
  ///
  /// This method asynchronously deletes a profile status identified by [id], [status], and [isCurrentStatus].
  /// Parameters:
  /// The [id] parameter specifies the unique identifier of the status to be deleted.
  /// The [status] parameter specifies the status message to be deleted.
  /// The [isCurrentStatus] parameter indicates whether the status to be deleted is the current status.
  ///
  /// Returns:
  ///   A [Future<bool?>] that completes with `true` if the deletion was successful, `false` if unsuccessful, or `null` if an error occurred.
  ///
  /// Example usage:
  /// ```dart
  /// bool? isDeleted = await Mirrorfly.deleteProfileStatus(
  ///   id: "statusId",
  ///   status: "Busy",
  ///   isCurrentStatus: true,
  /// );
  /// if (isDeleted == true) {
  ///   print("Status deleted successfully");
  /// } else {
  ///   print("Failed to delete status");
  /// }
  /// ```
  static Future<bool?> deleteProfileStatus(
      {required String id,
      required String status,
      required bool isCurrentStatus}) {
    return FlyChatFlutterPlatform.instance
        .deleteProfileStatus(id, status, isCurrentStatus);
  }

  /// Deletes a busy status.
  ///
  /// This method asynchronously deletes a busy status identified by [id], [status], and [isCurrentStatus].
  /// Parameters:
  /// The [id] parameter specifies the unique identifier of the busy status to be deleted.
  /// The [status] parameter specifies the busy status message to be deleted.
  /// The [isCurrentStatus] parameter indicates whether the busy status to be deleted is the current status.
  ///
  /// Returns:
  ///   A [Future<bool?>] that completes with `true` if the deletion was successful, `false` if unsuccessful, or `null` if an error occurred.
  ///
  /// Example usage:
  /// ```dart
  /// bool? isDeleted = await Mirrorfly.deleteBusyStatus(
  ///   id: "busyStatusId",
  ///   status: "In a meeting",
  ///   isCurrentStatus: true,
  ///   );
  ///   if (isDeleted == true) {
  ///   print("Busy status deleted successfully");
  ///   } else {
  ///   print("Failed to delete busy status");
  ///   }
  ///   ```
  ///
  static Future<bool?> deleteBusyStatus(
      {required String id,
      required String status,
      required bool isCurrentStatus}) {
    return FlyChatFlutterPlatform.instance
        .deleteBusyStatus(id, status, isCurrentStatus);
  }

  /// Retrieves the media endpoint URL from the Mirrorfly platform.
  ///
  /// The media endpoint URL is used to get Media end point for displaying profile images
  ///
  /// Returns a [Future] containing the media endpoint URL as a [String], or `null`
  /// if the operation fails.
  static Future<String?> mediaEndPoint() {
    return FlyChatFlutterPlatform.instance.mediaEndPoint();
  }

  /// Unfavorites all the favorite messages.
  ///
  /// This static method calls the corresponding [unFavouriteAllFavouriteMessages] method
  /// to unfavorite all favorite messages.
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  ///
  /// Returns:
  /// - A [Future] that resolves to a [bool] value.
  static Future<void> unFavouriteAllFavouriteMessages(
      {required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .unFavouriteAllFavouriteMessages(flyCallBack);
  }

  /// Marks a message as read on the Mirrorfly chat platform.
  ///
  /// This static method asynchronously marks a message as read with the specified [jid],
  /// which represents the unique identifier of the chat.
  ///
  /// Returns a Future<bool?> that completes with a boolean value indicating whether
  /// the operation was successful.
  ///
  static Future<bool?> markAsRead({required String jid}) {
    return FlyChatFlutterPlatform.instance.markAsRead(jid);
  }

  /// Uploads media associated with a message to the Mirrorfly chat platform.
  ///
  /// The [messageId] parameter specifies the unique identifier of the message
  /// for which the media is start upload.
  ///
  /// Returns a [Future] that completes with a `true` value if the media upload
  /// is starts.
  ///
  /// Throws an [ArgumentError] if the [messageId] parameter is not provided.
  static Future<bool?> uploadMedia({required String messageId}) {
    return FlyChatFlutterPlatform.instance.uploadMedia(messageId);
  }

  /// Deletes the unread message separator of a conversation.
  ///
  /// This method deletes the unread message separator for the specified conversation
  /// identified by the JID.
  ///
  /// The [jid] parameter specifies the JID of the conversation from which to delete
  /// the unread message(Notification message type)separator.
  ///
  /// Returns a [Future] that completes with a boolean value indicating whether the
  /// operation was successful.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.deleteUnreadMessageSeparatorOfAConversation(jid: 'conversation_jid');
  /// ```
  static Future<bool?> deleteUnreadMessageSeparatorOfAConversation(
      {required String jid}) {
    return FlyChatFlutterPlatform.instance
        .deleteUnreadMessageSeparatorOfAConversation(jid);
  }

  /*static Future<int?> getMembersCountOfGroup({required String groupJid}) {
    return FlyChatFlutterPlatform.instance.getMembersCountOfGroup(groupJid);
  }*/

  /*static Future<bool?> doesFetchingMembersListFromServedRequired({required String groupJid}) {
    return FlyChatFlutterPlatform.instance.doesFetchingMembersListFromServedRequired(groupJid);
  }*/

  /// Checks whether the last seen status is hidden from other users.
  @Deprecated('Instead of use Mirrorfly.isLastSeenVisible()')
  static Future<bool?> isHideLastSeenEnabled() {
    return FlyChatFlutterPlatform.instance.isHideLastSeenEnabled();
  }

  /// Checks whether the last seen status is visible to other users.
  ///
  /// This static method asynchronously queries the platform to determine
  /// whether the last seen status is visible to other users.
  ///
  /// Returns a [Future] that completes with a [bool] value:
  /// - `true` if the last seen status is visible.
  /// - `false` if the last seen status is hidden.
  /// - `null` if the visibility status cannot be determined.
  static Future<bool?> isLastSeenVisible() {
    return FlyChatFlutterPlatform.instance.isHideLastSeenEnabled();
  }

  /*static deleteOfflineGroup({required String groupJid}) {
    return FlyChatFlutterPlatform.instance.deleteOfflineGroup(groupJid);
  }*/

  /// Sends the typing status to the specified recipient.
  ///
  /// This static method is used to send the typing status to a recipient with the given [toJid]
  /// and [chatType].
  ///
  /// The [toJid] parameter specifies the JID of the recipient chat.
  /// The [chatType] parameter specifies the type of chat, such as "chat" for one-to-one chat
  /// or "groupchat" for group chat.
  ///
  ///  Returns a `Future<void>` that completes when the typing status is sent successfully.
  ///
  /// Throws an exception if the required parameters are not provided.
  /// Example:
  /// ```dart
  /// await Mirrorfly.sendTypingStatus(toJid: 'example@domain.com', chatType: 'single');
  /// ```
  static sendTypingStatus({required String toJid, required String chatType}) {
    return FlyChatFlutterPlatform.instance.sendTypingStatus(toJid, chatType);
  }

  /// Sends a typing-gone status to the specified recipient.
  ///
  /// This method is used to indicate that the user has stopped typing in a chat conversation.
  ///
  /// The [toJid] parameter specifies the JID of the recipient.
  ///
  /// The [chatType] parameter specifies the type of chat, such as "chat" for one-to-one chat
  /// or "groupchat" for group chat.
  ///
  /// Returns a `Future<void>` that completes when the typing-gone status is sent successfully.
  ///
  /// Example:
  /// ```dart
  /// await Mirrorfly.sendTypingGoneStatus(toJid: 'example@domain.com', chatType: 'single');
  /// ```
  static sendTypingGoneStatus(
      {required String toJid, required String chatType}) {
    return FlyChatFlutterPlatform.instance
        .sendTypingGoneStatus(toJid, chatType);
  }

  /// Updates the mute status of a chat identified by its JID.
  ///
  /// This method is used to update the mute status of a chat identified by its JID.
  ///
  /// The [jid] parameter specifies the JID of the chat to be updated.
  ///
  /// The [muteStatus] parameter indicates whether the chat should be muted or unmuted.
  /// If set to `true`, the chat will be muted. If set to `false`, the chat will be unmuted.
  ///
  /// Returns a `Future<void>` that completes when the mute status update is performed successfully.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// await Mirrorfly.updateChatMuteStatus(jid: 'example@domain.com', muteStatus: true);
  /// ```
  static updateChatMuteStatus({required String jid, required bool muteStatus}) {
    return FlyChatFlutterPlatform.instance
        .updateChatMuteStatus(jid, muteStatus);
  }

  /// Updates the pin status of a recent chat.
  ///
  /// This static method is used to update the pin status of a recent chat
  /// identified by its unique JID.
  ///
  /// Parameters:
  ///   - [jid]: The unique identifier (JID) of the chat.
  ///   - [pinStatus]: The new pin status to be set for the chat.
  ///
  ///
  /// Returns a `Future<void>` representing the completion of the update operation.
  ///
  /// Example:
  /// ```dart
  /// await Mirrorfly.updateRecentChatPinStatus(jid: 'example@domain.com', pinStatus: true);
  /// ```
  static updateRecentChatPinStatus(
      {required String jid, required bool pinStatus}) {
    return FlyChatFlutterPlatform.instance
        .updateRecentChatPinStatus(jid, pinStatus);
  }

  /// Deletes recent chats for the specified JID.
  @Deprecated('Instead of use Mirrorfly.deleteRecentChats()')
  static deleteRecentChat(String jid) {
    return FlyChatFlutterPlatform.instance.deleteRecentChat(jid, null);
  }

  /*static setTypingStatusListener() {
    return FlyChatFlutterPlatform.instance.setTypingStatusListener();
  }*/

  /// Checks if a chat is unarchived based on their JID.
  @Deprecated('Instead of use Mirrorfly.isChatUnArchived(jid: ' ')')
  static Future<bool?> isUserUnArchived(String jid) {
    return FlyChatFlutterPlatform.instance.isUserUnArchived(jid);
  }

  /// Checks if a chat is unarchived based on their JID.
  ///
  /// This method sends a request to the Mirrorfly platform to determine
  /// whether a user with the specified JID is unarchived.
  ///
  /// The [jid] parameter is the JID of the chat to check.
  ///
  /// Returns a [Future] that completes with a [bool] value:
  /// - `true` if the user is unarchived.
  /// - `false` if the user is archived or if an error occurs during the request.
  static Future<bool?> isChatUnArchived({required String jid}) {
    return FlyChatFlutterPlatform.instance.isUserUnArchived(jid);
  }

  /*static Future<bool?> getIsProfileBlockedByAdmin() {
    return FlyChatFlutterPlatform.instance.getIsProfileBlockedByAdmin();
  }*/

  /// Deletes recent chats for the specified list of JIDs.
  ///
  /// This method allows you to delete recent chats for the specified list
  /// of JIDs from the Mirrorfly platform.
  ///
  /// The [jidList] parameter is a required list of strings containing the
  /// JIDs of the chats to be deleted.
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  ///
  /// Example:
  /// ```dart
  /// Mirrorfly.deleteRecentChats(jidList: ['user1@example.com', 'user2@example.com'],flyCallBack: (response){
  /// });
  /// ```
  ///
  static Future<void> deleteRecentChats(
      {required List<String> jidList,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .deleteRecentChats(jidList, flyCallBack);
  }

  /// Marks the conversations with the specified JIDs as read.
  ///
  /// This method communicates with the Mirrorfly chat platform to mark
  /// the conversations associated with the provided JIDs as read.
  ///
  /// The [jidList] parameter is a list of JIDs (Jabber IDs) identifying
  /// the conversations to be marked as read.
  ///
  /// Example:
  /// ```dart
  /// Mirrorfly.markConversationAsRead(jidList: ['user1@example.com', 'user2@example.com']);
  /// ```
  ///
  /// Throws a [PlatformException] if an error occurs during the process.
  static markConversationAsRead({required List<String> jidList}) {
    return FlyChatFlutterPlatform.instance.markConversationAsRead(jidList);
  }

  /// Marks the conversations with the specified JIDs as Unread.
  ///
  /// This method communicates with the Mirrorfly chat platform to mark
  /// the conversations associated with the provided JIDs as read.
  ///
  /// The [jidList] parameter is a list of JIDs (Jabber IDs) identifying
  /// the conversations to be marked as Unread.
  ///
  /// Example:
  /// ```dart
  /// Mirrorfly.markConversationAsUnread(jidList: ['user1@example.com', 'user2@example.com']);
  /// ```
  ///
  /// Throws a [PlatformException] if an error occurs during the process.
  static markConversationAsUnread({required List<String> jidList}) {
    return FlyChatFlutterPlatform.instance.markConversationAsUnread(jidList);
  }

  /*static getArchivedChatsFromServer() {
    return FlyChatFlutterPlatform.instance.getArchivedChatsFromServer();
  }*/

  /*static setCustomValue({required String messageId, required String key, required String value}) {
    return FlyChatFlutterPlatform.instance.setCustomValue(messageId, key, value);
  }

  static removeCustomValue({required String messageId, required String key}) {
    return FlyChatFlutterPlatform.instance.removeCustomValue(messageId, key);
  }*/

  /*static inviteUserViaSMS({required String mobileNo, required String message}) {
    return FlyChatFlutterPlatform.instance.inviteUserViaSMS(mobileNo, message);
  }*/

  /*static cancelBackup() {
    return FlyChatFlutterPlatform.instance.cancelBackup();
  }

  static startBackup() {
    return FlyChatFlutterPlatform.instance.startBackup();
  }

  static cancelRestore() {
    return FlyChatFlutterPlatform.instance.cancelRestore();
  }

  static clearAllSDKData() {
    return FlyChatFlutterPlatform.instance.clearAllSDKData();
  }

  static getRoster() {
    return FlyChatFlutterPlatform.instance.getRoster();
  }

  static Future<String?> getCustomValue({required String messageId, required String key}) {
    return FlyChatFlutterPlatform.instance.getCustomValue(messageId, key);
  }*/

  /// Clears all conversations from the Mirrorfly chat platform.
  ///
  /// This method asynchronously clears all conversations from the Mirrorfly chat platform.
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  ///
  static Future<void> clearAllConversation(
      {required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.clearAllConversation(flyCallBack);
  }

  /// Updates the Firebase Cloud Messaging (FCM) token for the Mirrorfly SDK.
  ///
  /// This method sends the provided [firebaseToken] to the Mirrorfly platform
  /// to update the FCM token used for push notifications.
  ///
  /// The [firebaseToken] parameter is the FCM token obtained from Firebase Cloud Messaging.
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  ///
  static Future<void> updateFcmToken(
      {required String firebaseToken,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .updateFcmToken(firebaseToken, flyCallBack);
  }

  /// Checks if a chat is muted for the given JID.
  @Deprecated('Instead of use Mirrorfly.isChatMuted()')
  static Future<bool?> isMuted(String jid) {
    return FlyChatFlutterPlatform.instance.isMuted(jid);
  }

  /// Checks if a chat is muted for the given JID.
  ///
  /// Returns a [Future] that completes with a boolean value indicating whether the chat is muted.
  ///
  /// The [jid] parameter specifies the JID of the chat to check.
  /// It must not be null.
  ///
  /// Example:
  /// ```dart
  /// bool? muted = await Mirrorfly.isChatMuted(jid: 'example@domain.com');
  /// if (muted == true) {
  ///   print('The chat is muted.');
  /// } else if (muted == false) {
  ///   print('The chat is not muted.');
  /// }
  /// ```
  static Future<bool?> isChatMuted({required String jid}) {
    return FlyChatFlutterPlatform.instance.isMuted(jid);
  }

  ///This [handleReceivedMessage] Handles an incoming FCM message received by the Mirrorfly SDK for only [Android]
  ///for [iOS] Need to add Notification Extension Service
  ///add this line in your Notification Extension service MirrorFlyNotification().handleNotification(notificationRequest: request, contentHandler: contentHandler, containerID: "xxx", licenseKey: "xxxx")
  ///
  /// This method is responsible for processing the received FCM message
  /// and passing it to the Mirrorfly SDK for further handling.
  ///
  /// The [notificationData] parameter is a required [Map] containing the `remoteMessage.data`
  /// received in the FCM message notification [RemoteMessage].
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  ///to Show Notification using FCM 'remoteMessage.data' as [notificationData]
  ///for iOS Need to add Notification Extension Service
  ///add this line in your extension service MirrorFlyNotification().handleNotification(notificationRequest: request, contentHandler: contentHandler, containerID: "xxx", licenseKey: "xxxx")
  static Future<void> handleReceivedMessage(
      {required Map notificationData,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .handleReceivedMessage(notificationData, flyCallBack);
  }

  /*static Future<String?> getLastNUnreadMessages({required int messagesCount}) {
    return FlyChatFlutterPlatform.instance.getLastNUnreadMessages(messagesCount);
  }*/

  /*static Future<dynamic> getNUnreadMessagesOfEachUsers(int messagesCount) {
    return FlyChatFlutterPlatform.instance.getNUnreadMessagesOfEachUsers(messagesCount);
  }*/

  /// Checks whether the archived settings feature is enabled in the Mirrorfly platform.
  ///
  /// This method asynchronously queries the Mirrorfly platform to determine
  /// whether the archived settings feature is enabled.
  ///
  /// Returns a [Future] containing a [bool] value indicating whether the archived settings feature is enabled.
  ///
  /// If the archived settings feature is enabled, the Future resolves to `true`.
  /// If the archived settings feature is disabled, the Future resolves to `false`.
  static Future<bool?> isArchivedSettingsEnabled() {
    return FlyChatFlutterPlatform.instance.isArchivedSettingsEnabled();
  }

  // Enables or disables archived settings in the Mirrorfly SDK.
  ///
  /// This method enables or disables the archived settings feature in the Mirrorfly SDK,
  /// based on the value of the [enable] parameter.
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  ///
  static Future<void> enableDisableArchivedSettings(
      {required bool enable,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .enableDisableArchivedSettings(enable, flyCallBack);
  }

  /// Provides functionality to set the archived status of a chat.
  @Deprecated('Instead of use Mirrorfly.setChatArchived()')
  static Future<bool?> updateArchiveUnArchiveChat(
      String jid, bool isArchived) async {
    return FlyChatFlutterPlatform.instance
        .updateArchiveUnArchiveChat(jid, isArchived);
  }

  /// Provides functionality to set the archived status of a chat.
  ///
  /// This method allows the user to update the archived status of a chat identified
  /// by the unique identifier [jid]. If [isArchived] is `true`, the chat will be
  /// archived; if `false`, it will be unarchived.
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  /// Example usage:
  /// ```dart
  /// Mirrorfly.setChatArchived(jid: 'unique_chat_jid', isArchived: true,flyCallBack:(response){
  /// bool isChatArchived = response.isSuccess;
  /// });
  /// print('Chat archived status: $isChatArchived');
  /// ```
  static Future<void> setChatArchived(
      {required String jid,
      required bool isArchived,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .setChatArchived(jid, isArchived, flyCallBack);
  }

  /*static Future<int?> getGroupMessageStatusCount({required String messageId}) {
    return FlyChatFlutterPlatform.instance.getGroupMessageStatusCount(messageId);
  }*/

  /// Retrieves the count of unread messages in all active chats, excluding muted chats.
  ///
  /// Returns a [Future] that completes with the count of unread messages,
  /// or `null` if an error occurs during the operation.
  ///
  /// Usage:
  /// ```dart
  /// int? unreadCount = await Mirrorfly.getUnreadMessageCountExceptMutedChat();
  /// print('Unread message count: $unreadCount');
  /// ```
  static Future<int?> getUnreadMessageCountExceptMutedChat() {
    return FlyChatFlutterPlatform.instance
        .getUnreadMessageCountExceptMutedChat();
  }

  /// Retrieves the count of recent chats that are pinned.
  @Deprecated('Instead of use Mirrorfly.getRecentChatPinnedCount()')
  static Future<int?> recentChatPinnedCount() {
    return FlyChatFlutterPlatform.instance.recentChatPinnedCount();
  }

  /// Retrieves the count of recent chats that are pinned.
  ///
  /// Returns a [Future] that completes with an [int] representing the count of recent chats that are pinned.
  ///
  /// Throws an exception if the operation fails.
  static Future<int?> getRecentChatPinnedCount() {
    return FlyChatFlutterPlatform.instance.recentChatPinnedCount();
  }

  /// Retrieves the count of unread messages asynchronously.
  ///
  /// This static method asynchronously retrieves the count of unread messages
  /// from the Mirrorfly chat.
  ///
  /// Returns a [Future] that completes with an [int] representing the count of unread messages,
  /// or `null` if an error occurs during the operation.
  ///
  /// Example usage:
  /// ```dart
  /// int? unreadCount = await Mirrorfly.getUnreadMessagesCount();
  /// print('Unread message count: $unreadCount');
  /// ```
  static Future<int?> getUnreadMessagesCount() {
    return FlyChatFlutterPlatform.instance.getUnreadMessagesCount();
  }

  /// Retrieves the Typed unsent message of a given JID.
  ///
  /// This static method asynchronously fetches the unsent message for a
  /// specific JID from the Mirrorfly chat.
  ///
  /// [jid] is for which to retrieve the unsent message.
  ///
  /// Returns a Future that completes with the unsent message as a String,
  /// or null if no unsent message is found.
  static Future<String?> getUnsentMessageOfAJid({required String jid}) {
    return FlyChatFlutterPlatform.instance.getUnsentMessageOfAJid(jid);
  }

  /*static Future<String?> getUsersListToAddMembersInOldGroup(String groupJid) {
    return FlyChatFlutterPlatform.instance.getUsersListToAddMembersInOldGroup(groupJid);
  }*/

  /*static Future<dynamic> prepareChatConversationToExport(String jid) {
    return FlyChatFlutterPlatform.instance.prepareChatConversationToExport(jid);
  }*/

  /// Provides a list of archived chats.
  ///
  /// Retrieves a list of archived chats from the Mirrorfly platform.
  /// Each chat in the list represents a conversation that has been archived.
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  static Future<void> getArchivedChatList(
      {required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.getArchivedChatList(flyCallBack);
  }

  /*static Future<dynamic> getMessageActions(List<String> messageidlist) {
    return FlyChatFlutterPlatform.instance.getMessageActions(messageidlist);
  }*/

  /*static Future<String?> getUsersListToAddMembersInNewGroup() {
    return FlyChatFlutterPlatform.instance.getUsersListToAddMembersInNewGroup();
  }*/

  /*static Future<bool?> createOfflineGroupInOnline({required String groupId}) {
    return FlyChatFlutterPlatform.instance.createOfflineGroupInOnline(groupId);
  }*/

  //cross checked with Android and iOS SDK both response is from different model

  /// Retrieves the profile of a group.
  ///
  /// This method fetches the profile information of a group identified by the given [groupJid].
  /// The profile can be fetched either from the server or from the local cache, based on the value of [fetchFromServer].
  ///
  /// Parameters:
  ///   - [groupJid]: The unique identifier of the group whose profile is to be retrieved. This parameter is required.
  ///   - [fetchFromServer]: A boolean flag indicating whether to fetch the profile from the server (`true`) or from the local cache (`false`). Defaults to `false`.
  ///   - [flyCallBack]: A callback function that will be called upon completion of the operation. It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  /// Returns:
  ///   A [Future] that completes when the profile retrieval operation is finished.
  ///
  /// Example usage:
  /// ```dart
  /// Mirrorfly.getGroupProfile(
  ///   groupJid: 'group_jid',
  ///   fetchFromServer: true,
  ///   flyCallBack: (response) {
  ///     if (response.isSuccess) {
  ///       print('Group profile retrieved successfully');
  ///     } else {
  ///       print('Failed to retrieve group profile: ${response.errorMessage}');
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> getGroupProfile(
      {required String groupJid,
      bool fetchFromServer = false,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .getGroupProfile(groupJid, fetchFromServer, flyCallBack);
  }

  /*static updateMediaDownloadStatus({required String mediaMessageId,
    required int progress,
    required int downloadStatus,
    required num dataTransferred}) {
    return FlyChatFlutterPlatform.instance
        .updateMediaDownloadStatus(mediaMessageId, progress, downloadStatus, dataTransferred);
  }

  static updateMediaUploadStatus({required String mediaMessageId,
    required int progress,
    required int uploadStatus,
    required num dataTransferred}) {
    return FlyChatFlutterPlatform.instance
        .updateMediaUploadStatus(mediaMessageId, progress, uploadStatus, dataTransferred);
  }*/

  /// Cancels a media upload or download operation.
  ///
  /// The [messageId] parameter specifies the unique identifier of the message
  /// for which the media upload or download operation should be canceled.
  ///
  /// Throws an exception if the operation fails or if the message ID is invalid.
  ///
  /// Example:
  /// ```dart
  ///   await Mirrorfly.cancelMediaUploadOrDownload(messageId: 'unique_message_id');
  /// ```
  static cancelMediaUploadOrDownload({required String messageId}) async {
    return FlyChatFlutterPlatform.instance
        .cancelMediaUploadOrDownload(messageId);
  }

  /// Sets the media encryption status for the Mirrorfly chat platform.
  ///
  /// The [enable] parameter specifies whether media encryption should be enabled or disabled.
  /// If [enable] is true, media encryption will be enabled. If false, media encryption will be disabled.
  ///
  /// Example usage:
  /// ```dart
  /// Mirrorfly.setMediaEncryption(enable: true);
  /// ```
  static setMediaEncryption({required bool enable}) {
    return FlyChatFlutterPlatform.instance.setMediaEncryption(enable);
  }

  /*static deleteAllMessages() {
    return FlyChatFlutterPlatform.instance.deleteAllMessages();
  }*/

  /// Retrieves the group JID associated with a given group ID.
  ///
  /// This static method asynchronously retrieves the group JID
  /// associated with the specified [groupId]. The group JID uniquely identifies
  /// the group in the Mirrorfly chat platform.
  ///
  /// If the operation is successful, the method returns a [String] representing
  /// the group JID. If the operation fails, `null` is returned.
  ///
  /// Throws an error if [groupId] is null.
  ///
  /// Example usage:
  /// ```dart
  /// String? groupJid = await Mirrorfly.getGroupJid(groupId: 'your_group_id');
  /// if (groupJid != null) {
  ///   print('Group JID: $groupJid');
  /// } else {
  ///   print('Failed to retrieve group JID');
  /// }
  /// ```
  static Future<String?> getGroupJid({required String groupId}) {
    return FlyChatFlutterPlatform.instance.getGroupJid(groupId);
  }

  /// Retrieves the last seen time of a user identified by their JID.
  ///
  /// This method asynchronously fetches and returns the last seen time of the user
  /// associated with the provided JID. The JID uniquely identifies a user within
  /// the Mirrorfly chat platform.
  ///
  /// The [jid] parameter is required and represents the JID of the user whose last
  /// seen time is to be retrieved.
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  /// Returns a [data] that completes with a [String] representing the last seen
  /// time in [DateTime.fromMillisecondsSinceEpoch] of the user, or `null` if the last seen time is not available or an error
  /// occurs during the retrieval process.
  ///
  /// Example:
  /// ```dart
  /// Mirrorfly.getUserLastSeenTime(jid: 'user123@domain.com',flyCallBack: (response){
  ///   if(response.isSuccess){
  ///     String lastSeenTime = response.data;
  ///     if (lastSeenTime.isNotEmpty) {
  ///       DateTime lastSeen = DateTime.fromMillisecondsSinceEpoch(int.parse(seconds), isUtc: false);
  ///       print('Last seen time: $lastSeen');
  ///     } else {
  ///       print('Last seen time is not available.');
  ///     }
  ///   }
  /// });
  /// ```
  static Future<void> getUserLastSeenTime(
      {required String jid,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .getUserLastSeenTime(jid, flyCallBack);
  }

  @Deprecated('Instead of use refreshAndGetAuthToken')

  /// This [authToken] is used to get refreshed Auth Token.
  static Future<String?> authToken() {
    return FlyChatFlutterPlatform.instance.authToken();
  }

  /// This method is used to refresh the Auth Token.
  @Deprecated('This method is deprecated. Please refrain from using it')
  static Future<String?> verifyToken(String userName, String token) {
    return FlyChatFlutterPlatform.instance.verifyToken(userName, token);
  }

  /// Retrieves the JID associated with the given [username].
  ///
  /// The [username] parameter is the unique identifier of the user.
  /// Returns a [Future] that completes with the JID as a [String] on success,
  /// or `null` if there's an error or the JID is not found.
  ///
  /// Throws an [ArgumentError] if [username] is `null`.
  ///
  /// Example usage:
  /// ```dart
  /// String? jid = await Mirrorfly.getJid(username: 'xxxxxx');
  /// if (jid != null) {
  ///   print('JID retrieved successfully: $jid');
  /// } else {
  ///   print('Failed to retrieve JID for username: $username');
  /// }
  /// ```
  static Future<String?> getJid({required String username}) {
    return FlyChatFlutterPlatform.instance.getJid(username);
  }

  /// Sends a text message to a specified JID.
  ///
  /// This method sends a text message to the user or group identified by the [jid].
  /// The [message] parameter contains the text of the message to be sent.
  /// The [replyMessageId] parameter is optional and specifies the ID of the message being replied to, if any.
  ///
  /// Parameters:
  ///   - [jid]: The JID of the recipient.
  ///   - [message]: The text message to send.
  ///   - [replyMessageId]: The ID of the message being replied to (optional).
  ///
  /// Returns a [Future<String>] containing the ID of the sent message.
  ///
  /// Throws an [ArgumentError] if [jid] or [message] is null.
  @Deprecated(
      'Instead of use Mirrorfly.sendMessage(messageParams: MessageParams.text())')
  static Future<String> sendTextMessage(
      String message, String jid, String replyMessageId,
      {String? topicId}) {
    return FlyChatFlutterPlatform.instance
        .sendTextMessage(message, jid, replyMessageId, topicId: topicId);
  }

  /// Sends a location message to a specified JID.
  ///
  /// This method sends a location message, including latitude and longitude, to the user or group identified by the [jid].
  /// The [latitude] and [longitude] parameters specify the location's coordinates.
  /// The [replyMessageId] parameter is optional and specifies the ID of the message being replied to, if any.
  ///
  /// Parameters:
  ///   - [jid]: The JID of the recipient.
  ///   - [latitude]: The latitude of the location.
  ///   - [longitude]: The longitude of the location.
  ///   - [replyMessageId]: The ID of the message being replied to (optional).
  ///
  /// Returns a [Future<String>] containing the ID of the sent message.
  ///
  /// Throws an [ArgumentError] if [jid], [latitude], or [longitude] is null.
  @Deprecated(
      'Instead of use Mirrorfly.sendMessage(messageParams: MessageParams.location())')
  static Future<String> sendLocationMessage(
      String jid, double latitude, double longitude, String replyMessageId,
      {String? topicId}) {
    return FlyChatFlutterPlatform.instance.sendLocationMessage(
        jid, latitude, longitude, replyMessageId,
        topicId: topicId);
  }

  /// Sends an image message to a specified JID.
  ///
  /// This method sends an image message to the user or group identified by the [jid].
  /// The [imagePath] parameter specifies the local path of the image to be sent.
  /// The [replyMessageId] parameter is optional and specifies the ID of the message being replied to, if any.
  ///
  /// Parameters:
  ///   - [jid]: The JID of the recipient.
  ///   - [imagePath]: The local path of the image.
  ///   - [replyMessageId]: The ID of the message being replied to (optional).
  ///
  /// Returns a [Future<String>] containing the ID of the sent message.
  ///
  /// Throws an [ArgumentError] if [jid] or [imagePath] is null.
  @Deprecated(
      'Instead of use Mirrorfly.sendMessage(messageParams: MessageParams.image())')
  static Future<String> sendImageMessage(
      String jid, String filePath, String? caption, String? replyMessageID,
      {String? imageFileUrl, String? topicId}) {
    return FlyChatFlutterPlatform.instance.sendImageMessage(
        jid, filePath, caption, replyMessageID,
        imageFileUrl: imageFileUrl, topicId: topicId);
  }

  /// Sends a video message to a specified JID.
  ///
  /// This method allows you to send a video message to a user or group identified by the [jid].
  /// The [filePath] parameter specifies the local path of the video file to be sent.
  /// The [caption] parameter allows you to add a text caption to the video message (optional).
  /// The [replyMessageID] parameter is used if the message is a reply to a previous message (optional).
  /// Additional parameters such as [imageFileUrl] and [topicId] can be used for further customization (optional).
  @Deprecated(
      'Instead of use Mirrorfly.sendMessage(messageParams: MessageParams.video())')
  static Future<String> sendVideoMessage(
      String jid, String filePath, String? caption, String? replyMessageID,
      {String? videoFileUrl,
      num? videoDuration,
      String? thumbImageBase64,
      String? topicId}) {
    return FlyChatFlutterPlatform.instance.sendVideoMessage(
        jid, filePath, caption, replyMessageID,
        videoFileUrl: videoFileUrl,
        videoDuration: videoDuration,
        thumbImageBase64: thumbImageBase64,
        topicId: topicId);
  }

  /// Sends a document message to a specified JID.
  ///
  /// This method allows you to send a document message to a user or group identified by the [jid].
  /// The [documentPath] parameter specifies the local path of the document to be sent.
  /// The [replyMessageId] parameter is used if the message is a reply to a previous message (optional).
  /// Additional parameters such as [documentName] and [mimeType] can be used for further customization (optional).
  ///
  @Deprecated(
      'Instead of use Mirrorfly.sendMessage(messageParams: MessageParams.document())')
  static Future<String> sendDocumentMessage(
      String jid, String documentPath, String replyMessageId,
      {String? fileUrl, String? topicId}) {
    return FlyChatFlutterPlatform.instance.sendDocumentMessage(
        jid, documentPath, replyMessageId,
        fileUrl: fileUrl, topicId: topicId);
  }

  /// Sends an audio message to a specified JID.
  ///
  /// This method allows you to send an audio message to a user or group identified by the [jid].
  /// The [filePath] parameter specifies the local path of the audio file to be sent.
  /// The [isRecorded] parameter indicates whether the audio message is a recorded message (true) or not (false).
  /// The [duration] parameter specifies the duration of the audio message in seconds.
  /// The [replyMessageId] parameter is used if the message is a reply to a previous message (optional).
  /// Additional parameters such as [audioFileUrl] and [topicId] can be used for further customization (optional).
  @Deprecated(
      'Instead of use Mirrorfly.sendMessage(messageParams: MessageParams.audio())')
  static Future<String> sendAudioMessage(String jid, String filePath,
      bool isRecorded, String duration, String replyMessageId,
      {String? audioFileUrl, String? topicId}) {
    return FlyChatFlutterPlatform.instance.sendAudioMessage(
        jid, filePath, isRecorded, duration, replyMessageId,
        audioFileUrl: audioFileUrl, topicId: topicId);
  }

  /// Sends a contact message to a specified JID.
  ///
  /// This method allows you to send a contact message to a user or group identified by the [jid].
  /// The [contactList] parameter is a list of strings, each representing a contact's unique identifier.
  /// The [contactName] parameter specifies the name of the contact being sent.
  /// The [replyMessageId] parameter is used if the message is a reply to a previous message (optional).
  /// Additional parameters such as [contactFileUrl] and [topicId] can be used for further customization (optional).
  ///
  @Deprecated(
      'Instead of use Mirrorfly.sendMessage(messageParams: MessageParams.contact())')
  static Future<String> sendContactMessage(List<String> contactList, String jid,
      String contactName, String replyMessageId,
      {String? topicId}) {
    return FlyChatFlutterPlatform.instance.sendContactMessage(
        contactList, jid, contactName, replyMessageId,
        topicId: topicId);
  }

  /*static Future<void> sendMediaFileMessage(
      {required FileMessage messageParams, required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.sendMediaFileMessage(messageParams: messageParams, flyCallback: flyCallback);
  }*/

  /// Sends a message using the Mirrorfly messaging platform.
  ///
  /// This method sends a message using the provided [messageParams] and
  /// asynchronously invokes the [flyCallback] function with the result.
  ///
  /// The [messageParams] parameter contains the details of the message to be sent,
  /// using [MessageParams] class.
  ///
  /// The [flyCallback] parameter is a function that will be called with a [FlyResponse]
  /// object containing information about the success or failure of the message sending operation.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.sendMessage(
  ///   messageParams: messageParams,
  ///   flyCallback: (FlyResponse response) {
  ///     if (response.isSuccess) {
  ///       print('Message sent successfully');
  ///     } else {
  ///       print('Failed to send message: ${response.errorMessage}');
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> sendMessage(
      {required MessageParams messageParams,
      required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance
        .sendMessage(messageParams: messageParams, callback: flyCallback);
  }

  /// A method used to edit a text message sent previously.
  ///
  /// Parameters:
  ///
  /// The [editMessageParams] : An object containing parameters required for editing the message.
  /// The [flyCallback] : A callback function to handle the response from the [editTextMessage].
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.editTextMessage(
  ///   editMessageParams: editMessageParams,
  ///   flyCallback: (FlyResponse response) {
  ///     if (response.isSuccess) {
  ///       print('Message Edited successfully');
  ///     } else {
  ///       print('Failed to edit message: ${response.errorMessage}');
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> editTextMessage(
      {required EditMessageParams editMessageParams,
      required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.editTextMessage(
        editMessageParams: editMessageParams, callback: flyCallback);
  }

  /// A method used to edit a Caption Text message sent previously.
  ///
  /// Parameters:
  ///
  /// The [editMessageParams] : An object containing parameters required for editing the message.
  /// The [flyCallback] : A callback function to handle the response from the [editTextMessage].
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.editMediaCaption(
  ///   editMessageParams: editMessageParams,
  ///   flyCallback: (FlyResponse response) {
  ///     if (response.isSuccess) {
  ///       print('Message Edited successfully');
  ///     } else {
  ///       print('Failed to edit message: ${response.errorMessage}');
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> editMediaCaption(
      {required EditMessageParams editMessageParams,
      required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.editMediaCaption(
        editMessageParams: editMessageParams, callback: flyCallback);
  }

  /// A method used to get the list of registered users from the Mirrorfly platform.
  @Deprecated('Instead of use Mirrorfly.getRegisteredUsers()')
  static Future<String?> getRegisteredUserList(
      {required bool fetchFromServer}) {
    return FlyChatFlutterPlatform.instance
        .getRegisteredUserList(server: fetchFromServer);
  }

  /// Retrieves a list of users from the Mirrorfly platform.
  ///
  /// Retrieves a paginated list of users based on the specified [page] number and optional search [query].
  /// The [page] parameter specifies the page number to retrieve.
  /// The optional [search] parameter allows filtering users based on a search query.
  /// The [perPageResultSize] parameter specifies the number of users to retrieve per page (default is 20).
  /// The [flyCallback] parameter is a callback function that handles the response from the platform.
  /// The [metaDataUserList] parameter is optional and represents additional metadata associated with the User.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.getUserList(
  ///   page: 1,
  ///   search: "John Doe",
  ///   perPageResultSize: 10,
  ///   flyCallback: (response) {
  ///     // Handle the response from the Mirrorfly platform
  ///     if(response.isSuccess){
  ///       if (response.hasData) {
  ///         var list = userListFromJson(response.data);
  ///       }
  ///     }
  ///   }
  /// );
  /// ```
  ///
  /// Throws a [PlatformException] if an error occurs during the API call.
  static Future<void> getUserList(
      {int page = 1,
      String search = "",
      int perPageResultSize = 20,
      MetaDataUserList? metaDataUserList,
      required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.getUserList(
        page, search, metaDataUserList, flyCallback,
        perPageResultSize: perPageResultSize);
  }

  /// Provides access to call logs list from the platform.
  ///
  /// Retrieves a list of call logs from the platform asynchronously.
  ///
  /// [currentPage]: The current page number to retrieve the call logs list from.
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  /// Example usage:
  /// ```dart
  /// Mirrorfly.getCallLogsList(currentPage: 1,flyCallBack: (response){
  //     if (response.isSuccess) {
  //       var list = callLogListFromJson(response.data);
  //     }
  /// });
  /// ```
  static Future<void> getCallLogsList(
      {required int currentPage,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .getCallLogsList(currentPage, flyCallBack);
  }

  /// Provides access to call logs list from the platform.
  ///
  /// Retrieves a list of call logs from the Local DB asynchronously.
  ///
  /// Returns a Future<String?> representing the call logs list.
  /// Returns `null` if an error occurs during the retrieval process.
  /// Example usage:
  /// ```dart
  /// Mirrorfly.getLocalCallLogs().then((value) {
  //          if (value != null) {
  //            var list = callLogListFromJson(value);
  //          }
  //      }
  /// );
  /// ```
  static Future<String> getLocalCallLogs() {
    return FlyChatFlutterPlatform.instance.getLocalCallLogs();
  }

  /// Deletes call logs from the Mirrorfly chat platform.
  ///
  /// Deletes call logs for the specified list of JIDs [jidList].
  /// If [isClearAll] is set to `true`, all call logs will be deleted.
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  static Future<void> deleteCallLog(
      {required List<String> jidList,
      required bool isClearAll,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .deleteCallLog(jidList, isClearAll, flyCallBack);
  }

  /// A stream that emits events when a message is received.
  ///
  /// This stream listens for incoming messages from the Mirrorfly platform. Each event
  /// contains the data of the received message. Use this stream to update your UI or
  /// perform actions upon receiving a new message.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onMessageReceived.listen((messageData) {
  ///   // Handle the received message
  ///   print("New message received: $messageData");
  /// });
  /// ```
  static Stream<dynamic> get onMessageReceived =>
      FlyChatFlutterPlatform.instance.onMessageReceived;

  /// A stream that emits events when the status of a message is updated.
  ///
  /// This stream listens for updates to the status of messages, such as when a message
  /// is read or delivered. Each event contains the updated status information. Use this
  /// stream to update message status indicators in your UI.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onMessageStatusUpdated.listen((statusUpdate) {
  ///   // Handle the message status update
  ///   print("Message status updated: $statusUpdate");
  /// });
  /// ```
  static Stream<dynamic> get onMessageStatusUpdated =>
      FlyChatFlutterPlatform.instance.onMessageStatusUpdated;

  /// A stream that emits events when the status of a media message is updated.
  ///
  /// This stream listens for updates related to media messages, such as when a media
  /// message is successfully uploaded, downloaded, or fails to transfer. Each event
  /// contains the updated status information of the media message. Use this stream
  /// to update your UI or perform actions upon receiving a media status update.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onMediaStatusUpdated.listen((mediaStatusUpdate) {
  ///   // Handle the media status update
  ///   print("Media status updated: $mediaStatusUpdate");
  /// });
  /// ```
  static Stream<dynamic> get onMediaStatusUpdated =>
      FlyChatFlutterPlatform.instance.onMediaStatusUpdated;

  /// A stream that emits events when there is a change in upload or download progress
  /// of a media file.
  ///
  /// This stream provides updates on the progress of media file uploads or downloads.
  /// Each event contains information about the current progress, including the percentage
  /// completed. This can be used to display progress indicators in your UI.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onUploadDownloadProgressChanged.listen((progressUpdate) {
  ///   // Update progress indicator
  ///   print("Upload/Download progress: $progressUpdate");
  /// });
  /// ```
  static Stream<dynamic> get onUploadDownloadProgressChanged =>
      FlyChatFlutterPlatform.instance.onUploadDownloadProgressChanged;

  /// A stream that emits events when a group profile is fetched.
  ///
  /// This stream listens for events indicating that a group profile has been successfully
  /// fetched from the server. Each event contains the data of the fetched group profile.
  /// Use this stream to update your UI or perform actions upon receiving a group profile.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onGroupProfileFetched.listen((groupProfileData) {
  ///   // Handle the fetched group profile
  ///   print("Group profile fetched: $groupProfileData");
  /// });
  /// ```
  static Stream<dynamic> get onGroupProfileFetched =>
      FlyChatFlutterPlatform.instance.onGroupProfileFetched;

  /// A stream that emits events when a new group is created.
  ///
  /// This stream listens for events indicating that a new group has been successfully
  /// created on the Mirrorfly platform. Each event contains the data of the newly created
  /// group. Use this stream to update your UI or perform actions upon the creation of a new group.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onNewGroupCreated.listen((newGroupData) {
  ///   // Handle the new group creation
  ///   print("New group created: $newGroupData");
  /// });
  /// ```
  static Stream<dynamic> get onNewGroupCreated =>
      FlyChatFlutterPlatform.instance.onNewGroupCreated;

  /// A stream that emits events when a group profile is updated.
  ///
  /// This stream listens for events indicating that a group profile has been updated
  /// on the Mirrorfly platform. Each event contains the updated data of the group profile.
  /// Use this stream to refresh group profile information in your UI or perform other actions
  /// when a group profile is updated.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onGroupProfileUpdated.listen((updatedGroupProfile) {
  ///   // Handle the group profile update
  ///   print("Group profile updated: $updatedGroupProfile");
  /// });
  /// ```
  static Stream<dynamic> get onGroupProfileUpdated =>
      FlyChatFlutterPlatform.instance.onGroupProfileUpdated;

  /// A stream that emits events when a new member is added to a group.
  ///
  /// This stream listens for events indicating that a new member has been added to a group
  /// on the Mirrorfly platform. Each event contains information about the group and the new member.
  /// Use this stream to update your UI or perform actions upon the addition of a new member to a group.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onNewMemberAddedToGroup.listen((newMemberData) {
  ///   // Handle the addition of a new member to the group
  ///   print("New member added to group: $newMemberData");
  /// });
  static Stream<dynamic> get onNewMemberAddedToGroup =>
      FlyChatFlutterPlatform.instance.onNewMemberAddedToGroup;

  /// A stream that emits events when a member is removed from a group.
  ///
  /// This stream listens for events indicating that a member has been removed from a group
  /// on the Mirrorfly platform. Each event contains information about the group and the member
  /// who was removed. Use this stream to update your UI or perform actions upon the removal
  /// of a member from a group.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onMemberRemovedFromGroup.listen((memberRemovedData) {
  ///   // Handle the removal of a member from the group
  ///   print("Member removed from group: $memberRemovedData");
  /// });
  /// ```
  static Stream<dynamic> get onMemberRemovedFromGroup =>
      FlyChatFlutterPlatform.instance.onMemberRemovedFromGroup;

  /// A stream that emits events when the fetching of group members is completed.
  ///
  /// This stream listens for events indicating that the process of fetching group members
  /// from the server has been completed. Each event contains information about the group
  /// and its members. Use this stream to update your UI or perform actions upon the completion
  /// of fetching group members.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onFetchingGroupMembersCompleted.listen((groupMembersData) {
  ///   // Handle the completion of fetching group members
  ///   print("Fetching group members completed: $groupMembersData");
  /// });
  /// ```
  static Stream<dynamic> get onFetchingGroupMembersCompleted =>
      FlyChatFlutterPlatform.instance.onFetchingGroupMembersCompleted;

  // static Stream<dynamic> get onDeleteGroup => FlyChatFlutterPlatform.instance.onDeleteGroup;
  //
  // static Stream<dynamic> get onFetchingGroupListCompleted =>
  //     FlyChatFlutterPlatform.instance.onFetchingGroupListCompleted;

  /// A stream that emits events when a member is made as an admin of a group.
  ///
  /// This stream listens for events indicating that a member has been granted admin privileges
  /// in a group on the Mirrorfly platform. Each event contains information about the group and the member
  /// who was made an admin. Use this stream to update your UI or perform actions upon the change in group admin status.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onMemberMadeAsAdmin.listen((adminData) {
  ///   // Handle the event when a member is made an admin
  ///   print("Member made as admin: $adminData");
  /// });
  /// ```
  static Stream<dynamic> get onMemberMadeAsAdmin =>
      FlyChatFlutterPlatform.instance.onMemberMadeAsAdmin;

  /// A stream that emits events when a member is removed as an admin from a group.
  ///
  /// This stream listens for events indicating that a member's admin privileges have been revoked
  /// in a group on the Mirrorfly platform. Each event contains information about the group and the member
  /// who was removed as an admin. Use this stream to update your UI or perform actions upon the change in group admin status.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onMemberRemovedAsAdmin.listen((adminData) {
  ///   // Handle the event when a member is removed as an admin
  ///   print("Member removed as admin: $adminData");
  /// });
  /// ```
  static Stream<dynamic> get onMemberRemovedAsAdmin =>
      FlyChatFlutterPlatform.instance.onMemberRemovedAsAdmin;

  /// A stream that emits events when a member leaves a group.
  ///
  /// This stream listens for events indicating that a member has left a group on the Mirrorfly platform.
  /// Each event contains information about the group and the member who left. Use this stream to update your UI
  /// or perform actions upon the departure of a member from a group.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onLeftFromGroup.listen((leftData) {
  ///   // Handle the event when a member leaves a group
  ///   print("Member left from group: $leftData");
  /// });
  /// ```
  static Stream<dynamic> get onLeftFromGroup =>
      FlyChatFlutterPlatform.instance.onLeftFromGroup;

  /// A stream that emits events related to group notifications.
  ///
  /// This stream listens for group notification messages on the Mirrorfly platform. Each event
  /// contains the data of the group notification message. Use this stream to update your UI or perform
  /// actions upon receiving a group notification message.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onGroupNotificationMessage.listen((notificationData) {
  ///   // Handle group notification messages
  ///   print("Group notification message: $notificationData");
  /// });
  /// ```
  static Stream<dynamic> get onGroupNotificationMessage =>
      FlyChatFlutterPlatform.instance.onGroupNotificationMessage;

  /// A stream that emits events for showing, updating, or canceling notifications.
  ///
  /// This stream provides updates related to the operation of showing, updating, or canceling
  /// notifications on the Mirrorfly platform. Each event contains information about the notification
  /// operation. Use this stream to manage notifications in your UI.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.showOrUpdateOrCancelNotification.listen((notificationOperation) {
  ///   // Handle notification operations
  ///   print("Notification operation: $notificationOperation");
  /// });
  /// ```
  static Stream<dynamic> get showOrUpdateOrCancelNotification =>
      FlyChatFlutterPlatform.instance.showOrUpdateOrCancelNotification;

  /// A stream that emits events when a group is deleted locally.
  ///
  /// This stream listens for events indicating that a group has been deleted locally
  /// on the Mirrorfly platform. Use this stream to update your UI or perform actions
  /// upon the local deletion of a group.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onGroupDeletedLocally.listen((groupData) {
  ///   // Handle the local deletion of a group
  ///   print("Group deleted locally: $groupData");
  /// });
  /// ```
  static Stream<dynamic> get onGroupDeletedLocally =>
      FlyChatFlutterPlatform.instance.onGroupDeletedLocally;

  /// A stream that emits events when a user is blocked.
  ///
  /// This stream listens for events indicating that a user has been blocked
  /// on the Mirrorfly platform. Each event contains information about the user
  /// who was blocked. Use this stream to update your UI or perform actions upon
  /// blocking a user.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.blockedThisUser.listen((userData) {
  ///   // Handle the event of blocking a user
  ///   print("User blocked: $userData");
  /// });
  /// ```
  static Stream<dynamic> get blockedThisUser =>
      FlyChatFlutterPlatform.instance.blockedThisUser;

  /// A stream that emits events when the user's profile is updated.
  ///
  /// This stream listens for events indicating that the user's profile has been updated
  /// on the Mirrorfly platform. Each event contains the updated data of the user's profile.
  /// Use this stream to refresh user profile information in your UI or perform other actions
  /// when a user's profile is updated.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.myProfileUpdated.listen((profileData) {
  ///   // Handle the user profile update
  ///   print("My profile updated: $profileData");
  /// });
  /// ```
  static Stream<dynamic> get myProfileUpdated =>
      FlyChatFlutterPlatform.instance.myProfileUpdated;

  /// A stream that emits events when an admin blocks another user.
  ///
  /// This stream listens for events indicating that an admin has blocked another user on the platform.
  /// Each event contains information about the admin and the user who was blocked. Use this stream
  /// to update your UI or perform actions upon the blocking of a user by an admin.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onAdminBlockedOtherUser.listen((blockEventData) {
  ///   // Handle the event when an admin blocks another user
  ///   print("Admin blocked another user: $blockEventData");
  /// });
  /// ```
  static Stream<dynamic> get onAdminBlockedOtherUser =>
      FlyChatFlutterPlatform.instance.onAdminBlockedOtherUser;

  /// A stream that emits events when a user is blocked by an admin.
  ///
  /// This stream listens for events indicating that an admin has blocked a user on the platform.
  /// Each event contains information about the user who was blocked. Use this stream
  /// to update your UI or perform actions upon the blocking of a user by an admin.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onAdminBlockedUser.listen((blockEventData) {
  ///   // Handle the event when a user is blocked by an admin
  ///   print("User blocked by admin: $blockEventData");
  /// });
  /// ```
  static Stream<dynamic> get onAdminBlockedUser =>
      FlyChatFlutterPlatform.instance.onAdminBlockedUser;

  /// A stream that emits events when contact synchronization is complete.
  ///
  /// This stream listens for events indicating that the contact synchronization process has completed on the platform.
  /// Use this stream to update your UI or perform actions upon the completion of contact synchronization.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onContactSyncComplete.listen((syncEventData) {
  ///   // Handle the event when contact synchronization is complete
  ///   print("Contact sync complete: $syncEventData");
  /// });
  /// ```
  static Stream<dynamic> get onContactSyncComplete =>
      FlyChatFlutterPlatform.instance.onContactSyncComplete;

  /// A stream that emits events when a user is logged out.
  ///
  /// This stream listens for events indicating that a user has logged out from the SDK.
  /// Each event contains information about the logout event. Use this stream
  /// to update your UI or perform actions upon user logout.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onLoggedOut.listen((logoutEventData) {
  ///   // Handle the event when a user logs out
  ///   print("User logged out: $logoutEventData");
  /// });
  /// ```
  static Stream<dynamic> get onLoggedOut =>
      FlyChatFlutterPlatform.instance.onLoggedOut;

  /// A stream that emits events when a user is unblocked.
  ///
  /// This stream listens for events indicating that a user has been unblocked on the platform.
  /// Each event contains information about the user who was unblocked. Use this stream
  /// to update your UI or perform actions upon user unblocking.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.unblockedThisUser.listen((unblockEventData) {
  ///   // Handle the event when a user is unblocked
  ///   print("User unblocked: $unblockEventData");
  /// });
  /// ```
  static Stream<dynamic> get unblockedThisUser =>
      FlyChatFlutterPlatform.instance.unblockedThisUser;

  /// A stream that emits events when a user blocks the current user.
  ///
  /// This stream listens for events indicating that a user has blocked the current user on the platform.
  /// Each event contains information about the user who blocked the current user. Use this stream
  /// to update your UI or perform actions upon being blocked by a user.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.userBlockedMe.listen((blockEventData) {
  ///   // Handle the event when a user blocks the current user
  ///   print("User blocked me: $blockEventData");
  /// });
  /// ```
  static Stream<dynamic> get userBlockedMe =>
      FlyChatFlutterPlatform.instance.userBlockedMe;

  /// A stream that emits events when a user comes online.
  ///
  /// This stream listens for events indicating that a user has come online on the platform.
  /// Each event contains information about the user who came online. Use this stream
  /// to update your UI or perform actions upon user coming online.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.userCameOnline.listen((onlineEventData) {
  ///   // Handle the event when a user comes online
  ///   print("User came online: $onlineEventData");
  /// });
  /// ```
  static Stream<dynamic> get userCameOnline =>
      FlyChatFlutterPlatform.instance.userCameOnline;

  /// A stream that emits events when a user deletes his profile.
  ///
  /// This stream listens for events indicating that a user has deleted their profile on the platform.
  /// Each event contains information about the user who deleted their profile. Use this stream
  /// to update your UI or perform actions upon user profile deletion.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.userDeletedHisProfile.listen((deleteEventData) {
  ///   // Handle the event when a user deletes their profile
  ///   print("User deleted their profile: $deleteEventData");
  /// });
  /// ```
  static Stream<dynamic> get userDeletedHisProfile =>
      FlyChatFlutterPlatform.instance.userDeletedHisProfile;

  /// A stream that emits events when multiple user profiles are fetched.
  ///
  /// This stream listens for events indicating that multiple user profiles have been fetched on the platform.
  /// Each event contains information about the fetched user profiles. Use this stream
  /// to update your UI or perform actions upon fetching multiple user profiles.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.usersProfilesFetched.listen((profilesEventData) {
  ///   // Handle the event when multiple user profiles are fetched
  ///   print("User profiles fetched: $profilesEventData");
  /// });
  /// ```
  static Stream<dynamic> get usersProfilesFetched =>
      FlyChatFlutterPlatform.instance.usersProfilesFetched;

  /// A stream that emits events when a single user profile is fetched.
  ///
  /// This stream listens for events indicating that a single user profile has been fetched on the platform.
  /// Each event contains information about the fetched user profile. Use this stream
  /// to update your UI or perform actions upon fetching a user profile.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.userProfileFetched.listen((profileEventData) {
  ///   // Handle the event when a user profile is fetched
  ///   print("User profile fetched: $profileEventData");
  /// });
  /// ```
  static Stream<dynamic> get userProfileFetched =>
      FlyChatFlutterPlatform.instance.userProfileFetched;

  /// A stream that emits events when a user unblocks the current user.
  ///
  /// This stream listens for events indicating that a user has unblocked the current user on the platform.
  /// Each event contains information about the user who unblocked the current user. Use this stream
  /// to update your UI or perform actions upon being unblocked by a user.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.userUnBlockedMe.listen((unblockEventData) {
  ///   // Handle the event when a user unblocks the current user
  ///   print("User unblocked me: $unblockEventData");
  /// });
  /// ```
  static Stream<dynamic> get userUnBlockedMe =>
      FlyChatFlutterPlatform.instance.userUnBlockedMe;

  /// A stream that emits events when a user updates his profile.
  ///
  /// This stream listens for events indicating that a user has updated his profile on the platform.
  /// Each event contains information about the updated user profile. Use this stream
  /// to update your UI or perform actions upon user profile update.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.userUpdatedHisProfile.listen((updateEventData) {
  ///   // Handle the event when a user updates their profile
  ///   print("User updated their profile: $updateEventData");
  /// });
  /// ```
  static Stream<dynamic> get userUpdatedHisProfile =>
      FlyChatFlutterPlatform.instance.userUpdatedHisProfile;

  /// A stream that emits events when a user goes offline.
  ///
  /// This stream listens for events indicating that a user has gone offline on the platform.
  /// Each event contains information about the user who went offline. Use this stream
  /// to update your UI or perform actions upon user going offline.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.userWentOffline.listen((offlineEventData) {
  ///   // Handle the event when a user goes offline
  ///   print("User went offline: $offlineEventData");
  /// });
  /// ```
  static Stream<dynamic> get userWentOffline =>
      FlyChatFlutterPlatform.instance.userWentOffline;

  /// A stream that emits events when the list of users the current user has blocked is fetched.
  ///
  /// This stream listens for events indicating that the list of users blocked by the current user has been fetched on the platform.
  /// Each event contains information about the blocked users list. Use this stream
  /// to update your UI or perform actions upon fetching the blocked users list.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.usersIBlockedListFetched.listen((blockedListEventData) {
  ///   // Handle the event when the blocked users list is fetched
  ///   print("Blocked users list fetched: $blockedListEventData");
  /// });
  /// ```
  static Stream<dynamic> get usersIBlockedListFetched =>
      FlyChatFlutterPlatform.instance.usersIBlockedListFetched;

  /// A stream that emits events when the list of users who blocked the current user is fetched.
  ///
  /// This stream listens for events indicating that the list of users who blocked the current user has been fetched on the platform.
  /// Each event contains information about the users who blocked the current user. Use this stream
  /// to update your UI or perform actions upon fetching the list of users who blocked the current user.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.usersWhoBlockedMeListFetched.listen((blockedMeListEventData) {
  ///   // Handle the event when the list of users who blocked the current user is fetched
  ///   print("Users who blocked me list fetched: $blockedMeListEventData");
  /// });
  /// ```
  static Stream<dynamic> get usersWhoBlockedMeListFetched =>
      FlyChatFlutterPlatform.instance.usersWhoBlockedMeListFetched;

  /// A stream that emits events when the chat service is connected.
  ///
  /// This stream listens for events indicating that the chat service has established a connection.
  /// Each event contains information about the connection state. Use this stream
  /// to update your UI or perform actions upon chat service connection.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onConnected.listen((connectedEventData) {
  ///   // Handle the event when the platform is connected
  ///   print("Platform connected: $connectedEventData");
  /// });
  /// ```
  static Stream<dynamic> get onConnected =>
      FlyChatFlutterPlatform.instance.onConnected;

  /// A stream that emits events when the chat service is disconnected.
  ///
  /// This stream listens for events indicating that the chat service has lost connection.
  /// Each event contains information about the disconnection state. Use this stream
  /// to update your UI or perform actions upon chat service disconnection.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onDisconnected.listen((disconnectedEventData) {
  ///   // Handle the event when the platform is disconnected
  ///   print("Platform disconnected: $disconnectedEventData");
  /// });
  /// ```
  static Stream<dynamic> get onDisconnected =>
      FlyChatFlutterPlatform.instance.onDisconnected;

  /*static Stream<dynamic> get onConnectionNotAuthorized =>
      FlyChatFlutterPlatform.instance.onConnectionNotAuthorized;*/

  /// A stream that emits events when the chat service connection fails.
  ///
  /// This stream listens for events indicating that the chat service has failed to establish a connection.
  /// Each event contains information about the connection failure. Use this stream
  /// to update your UI or perform actions upon connection failure.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onConnectionFailed.listen((failureEventData) {
  ///   // Handle the event when the platform connection fails
  ///   print("Platform connection failed: $failureEventData");
  /// });
  /// ```
  static Stream<dynamic> get onConnectionFailed =>
      FlyChatFlutterPlatform.instance.onConnectionFailed;

  // static Stream<dynamic> get connectionFailed => FlyChatFlutterPlatform.instance.connectionFailed;

  // static Stream<dynamic> get connectionSuccess => FlyChatFlutterPlatform.instance.connectionSuccess;

  // static Stream<dynamic> get onWebChatPasswordChanged =>
  //     FlyChatFlutterPlatform.instance.onWebChatPasswordChanged;

  /// A stream that emits events when a message is edited.
  ///
  /// This stream listens for events indicating that a message has been edited.
  /// Each event contains information about the edited message. Use this stream
  /// to update your UI or perform actions upon message editing.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onMessageEdited.listen((editedMessageData) {
  ///   // Handle the event when a message is edited
  ///   print("Message edited: $editedMessageData");
  /// });
  /// ```
  static Stream<dynamic> get onMessageEdited =>
      FlyChatFlutterPlatform.instance.onMessageEdited;

  /// A stream to set the typing status of a user.
  ///
  /// This stream allows setting the typing status of a user. Note that this is deprecated
  /// and it is recommended to use `Mirrorfly.typingStatus` instead.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.setTypingStatus.listen((typingStatusData) {
  ///   // Handle the event to set the typing status
  ///   print("Set typing status: $typingStatusData");
  /// });
  /// ```
  @Deprecated('Instead of use Mirrorfly.typingStatus')
  static Stream<dynamic> get setTypingStatus =>
      FlyChatFlutterPlatform.instance.setTypingStatus;

  /// A stream that emits typing status events.
  ///
  /// This stream listens for typing status events on the platform. Each event contains information
  /// about the typing status of a user. Use this stream to update your UI based on typing status.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.typingStatus.listen((typingStatusData) {
  ///   // Handle the event for typing status
  ///   print("Typing status: $typingStatusData");
  /// });
  /// ```
  static Stream<dynamic> get typingStatus =>
      FlyChatFlutterPlatform.instance.setTypingStatus;

  /// A stream that emits chat typing status events.
  ///
  /// This stream listens for chat typing status events. Note that this is deprecated
  /// and it is recommended to use `Mirrorfly.typingStatus` instead.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onChatTypingStatus.listen((chatTypingStatusData) {
  ///   // Handle the event for chat typing status
  ///   print("Chat typing status: $chatTypingStatusData");
  /// });
  /// ```
  @Deprecated('Instead of use Mirrorfly.typingStatus')
  static Stream<dynamic> get onChatTypingStatus =>
      FlyChatFlutterPlatform.instance.onChatTypingStatus;

  /// A stream that emits group typing status events.
  ///
  /// This stream listens for group typing status events. Note that this is deprecated
  /// and it is recommended to use `Mirrorfly.typingStatus` instead.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onGroupTypingStatus.listen((groupTypingStatusData) {
  ///   // Handle the event for group typing status
  ///   print("Group typing status: $groupTypingStatusData");
  /// });
  /// ```
  @Deprecated('Instead of use Mirrorfly.typingStatus')
  static Stream<dynamic> get onGroupTypingStatus =>
      FlyChatFlutterPlatform.instance.onGroupTypingStatus;

  // static Stream<dynamic> get onFailure => FlyChatFlutterPlatform.instance.onFailure;

  // static Stream<dynamic> get onProgressChanged => FlyChatFlutterPlatform.instance.onProgressChanged;
  //
  // static Stream<dynamic> get onSuccess => FlyChatFlutterPlatform.instance.onSuccess;

  // static Stream<dynamic> get onCallReceiving =>
  //     FlyChatFlutterPlatform.instance.onCallReceiving;

  /// A stream that emits events when a local video track is added.
  ///
  /// This stream listens for events indicating that a local video track has been added to the Mirrorfly View
  /// Each event contains information about the added video track. Use this stream
  /// to update your UI or perform actions upon local video track addition.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onLocalVideoTrackAdded.listen((videoTrackData) {
  ///   // Handle the event when a local video track is added
  ///   print("Local video track added: $videoTrackData");
  /// });
  /// ```
  static Stream<dynamic> get onLocalVideoTrackAdded =>
      FlyChatFlutterPlatform.instance.onLocalVideoTrackAdded;

  /// A stream that emits events when a remote video track is added.
  ///
  /// This stream listens for events indicating that a remote video track has been added to the Mirrorfly View
  /// Each event contains information about the added video track. Use this stream
  /// to update your UI or perform actions upon remote video track addition.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onRemoteVideoTrackAdded.listen((videoTrackData) {
  ///   // Handle the event when a remote video track is added
  ///   print("Remote video track added: $videoTrackData");
  /// });
  /// ```
  static Stream<dynamic> get onRemoteVideoTrackAdded =>
      FlyChatFlutterPlatform.instance.onRemoteVideoTrackAdded;

  /// A stream that emits events when any track is added.
  ///
  /// This stream listens for events indicating that any track (audio or video) has been added.
  /// Each event contains information about the added track. Use this stream
  /// to update your UI or perform actions upon track addition.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onTrackAdded.listen((trackData) {
  ///   // Handle the event when any track is added
  ///   print("Track added: $trackData");
  /// });
  /// ```
  static Stream<dynamic> get onTrackAdded =>
      FlyChatFlutterPlatform.instance.onTrackAdded;

  /// A stream that emits events when call status is updated.
  ///
  /// This stream listens for events indicating that the status of a call has been updated.
  /// Each event contains information about the updated call status. Use this stream
  /// to update your UI or perform actions upon call status update.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onCallStatusUpdated.listen((callStatusData) {
  ///   // Handle the event when call status is updated
  ///   print("Call status updated: $callStatusData");
  /// });
  /// ```
  static Stream<dynamic> get onCallStatusUpdated =>
      FlyChatFlutterPlatform.instance.onCallStatusUpdated;

  /// A stream that emits events for call actions.
  ///
  /// This stream listens for events indicating various call actions.
  /// Each event contains information about the call action. Use this stream
  /// to update your UI or perform actions upon call actions.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onCallAction.listen((callActionData) {
  ///   // Handle the event for call actions
  ///   print("Call action: $callActionData");
  /// });
  /// ```
  static Stream<dynamic> get onCallAction =>
      FlyChatFlutterPlatform.instance.onCallAction;

  /// A stream that emits events when mute status is updated.
  ///
  /// This stream listens for events indicating that the mute status of a user has been updated.
  /// Each event contains information about the updated mute status. Use this stream
  /// to update your UI or perform actions upon mute status update.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onMuteStatusUpdated.listen((muteStatusData) {
  ///   // Handle the event when mute status is updated
  ///   print("Mute status updated: $muteStatusData");
  /// });
  /// ```
  static Stream<dynamic> get onMuteStatusUpdated =>
      FlyChatFlutterPlatform.instance.onMuteStatusUpdated;

  /// A stream that emits events when a user starts speaking.
  ///
  /// This stream listens for events indicating that a user has started speaking.
  /// Each event contains information about the user who started speaking. Use this stream
  /// to update your UI or perform actions upon user speaking.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onUserSpeaking.listen((userSpeakingData) {
  ///   // Handle the event when a user starts speaking
  ///   print("User started speaking: $userSpeakingData");
  /// });
  /// ```
  static Stream<dynamic> get onUserSpeaking =>
      FlyChatFlutterPlatform.instance.onUserSpeaking;

  /// A stream that emits events when a user stops speaking.
  ///
  /// This stream listens for events indicating that a user has stopped speaking.
  /// Each event contains information about the user who stopped speaking. Use this stream
  /// to update your UI or perform actions upon user stopping speaking.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onUserStoppedSpeaking.listen((userStoppedSpeakingData) {
  ///   // Handle the event when a user stops speaking
  ///   print("User stopped speaking: $userStoppedSpeakingData");
  /// });
  /// ```
  static Stream<dynamic> get onUserStoppedSpeaking =>
      FlyChatFlutterPlatform.instance.onUserStoppedSpeaking;

  /// A stream that emits events for missed calls.
  ///
  /// This stream listens for events indicating that a call was missed.
  /// Each event contains information about the missed call. Use this stream
  /// to update your UI or perform actions upon missed calls.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onMissedCall.listen((missedCallData) {
  ///   // Handle the event for missed calls
  ///   print("Missed call: $missedCallData");
  /// });
  /// ```
  static Stream<dynamic> get onMissedCall =>
      FlyChatFlutterPlatform.instance.onMissedCall;

  /// A stream that emits events when available features are updated.
  ///
  /// This stream listens for events indicating that the available features have been updated.
  /// Each event contains information about the updated features. Use this stream
  /// to update your UI or perform actions upon feature updates.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onAvailableFeaturesUpdated.listen((featuresData) {
  ///   // Handle the event when available features are updated
  ///   print("Available features updated: $featuresData");
  /// });
  /// ```
  static Stream<dynamic> get onAvailableFeaturesUpdated =>
      FlyChatFlutterPlatform.instance.onAvailableFeaturesUpdated;

  /// A stream that emits events when call logs are updated.
  ///
  /// This stream listens for events indicating that the call logs have been updated.
  /// Each event contains information about the updated call logs. Use this stream
  /// to update your UI or perform actions upon call log updates.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onCallLogsUpdated.listen((callLogsData) {
  ///   // Handle the event when call logs are updated
  ///   print("Call logs updated: $callLogsData");
  /// });
  /// ```
  static Stream<dynamic> get onCallLogsUpdated =>
      FlyChatFlutterPlatform.instance.onCallLogsUpdated;

  /// A stream that emits events when a call log is deleted.
  ///
  /// This stream listens for events indicating that a call log has been deleted.
  /// Each event contains information about the deleted call log. Use this stream
  /// to update your UI or perform actions upon call log deletion.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onCallLogDeleted.listen((callLogDeletedData) {
  ///   // Handle the event when a call log is deleted
  ///   print("Call log deleted: $callLogDeletedData");
  /// });
  /// ```
  static Stream<dynamic> get onCallLogDeleted =>
      FlyChatFlutterPlatform.instance.onCallLogDeleted;

  /// A stream that emits events when all call logs are cleared.
  ///
  /// This stream listens for events indicating that all call logs have been cleared.
  /// Each event contains information about the cleared call logs. Use this stream
  /// to update your UI or perform actions upon clearing all call logs.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.onCallLogsCleared.listen((callLogsClearedData) {
  ///   // Handle the event when all call logs are cleared
  ///   print("All call logs cleared: $callLogsClearedData");
  /// });
  /// ```
  static Stream<dynamic> get onCallLogsCleared =>
      FlyChatFlutterPlatform.instance.onClearAllCallLog;

  /*static Future<String?> imagePath({required String imgUrl}) {
    return FlyChatFlutterPlatform.instance.imagePath(imgUrl);
  }*/

  /*static Future<dynamic> saveProfile(String name, String email) {
    return FlyChatFlutterPlatform.instance.saveProfile(name, email);
  }*/

  /*static Future<String?> sentFileMessage({required String jid, String? file}) {
    return FlyChatFlutterPlatform.instance.sentFileMessage(file, jid);
  }*/

  /// Retrieves the recent chat list from the Mirrorfly chat platform.
  ///
  /// This static method asynchronously fetches the list of recent chats
  /// from the Mirrorfly chat platform by calling the corresponding method
  /// on the [FlyChatFlutterPlatform] instance.
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// await Mirrorfly.getRecentChatList(flyCallback: (response) {
  ///     // Handle the response here
  ///     if (response.isSuccess && response.hasData) {
  //         var data = recentChatFromJson(response.data);
  //      }
  ///   }
  /// );
  /// ```
  static Future<void> getRecentChatList(
      {required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.getRecentChatList(flyCallBack);
  }

  /// Retrieves the recent chat list history asynchronously.
  ///
  /// This method fetches the recent chat list history from the Mirrorfly platform.
  /// You can specify whether it's the first set of data to fetch using [firstSet].
  /// The maximum number of chat items to retrieve is specified by [limit],
  /// with a default value of 15 if not provided.
  /// The result is returned asynchronously through the [flyCallback] function,
  /// which accepts a [FlyResponse] object as a parameter.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// await Mirrorfly.getRecentChatListHistory(
  ///   firstSet: true,
  ///   limit: 20,
  ///   flyCallback: (response) {
  ///     // Handle the response here
  ///     if (response.isSuccess && response.hasData) {
  //         var data = recentChatFromJson(response.data);
  //      }
  ///   }
  /// );
  /// ```
  static Future<void> getRecentChatListHistory(
      {required bool firstSet,
      int limit = 15,
      required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.getRecentChatListHistory(
        firstSet: firstSet, limit: limit, callback: flyCallback);
  }

  /// This method is used to initialize the Single/Group Chat User History to set the message filters.
  /// * @param [userJid] - Chat user JID (Single/Group)
  /// * @param [messageId] - Message id of the starting point (Optional)
  /// * @param [messageTime] - Message time of the starting point (Optional)
  /// * @param [exclude] - If true message of the Message ID given will be excluded in message list default true
  /// * @param [topicId] - use to get messages by topic id
  /// * @param [limit] - No of messages will be fetched for each request default 25
  /// * @param [ascendingOrder] - If true message list will be returned ascendingOrder by message time default false
  static Future<bool> initializeMessageList(
      {required String userJid,
      String? messageId,
      double? messageTime,
      bool exclude = true,
      bool ascendingOrder = false,
      String? topicId,
      @Deprecated("Meta data is no longer supported in this version")
      MetaDataMessageList? metaDataMessageList,
      int limit = 25}) {
    return FlyChatFlutterPlatform.instance.initializeMessageList(
        userJid: userJid,
        messageId: messageId,
        messageTime: messageTime,
        exclude: exclude,
        ascendingOrder: ascendingOrder,
        topicId: topicId,
        metaDataMessageList: metaDataMessageList,
        limit: limit);
  }

  /// This [loadMessages] is used to Fetch initial conversations between you and a single chat user or group.
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  /// This method should be called only after the initializeMessageList Method.
  static Future<void> loadMessages(
      {required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.loadMessages(flyCallback);
  }

  /// This [hasPreviousMessages] is used to find it has any Previous messages
  static Future<bool> hasPreviousMessages() {
    return FlyChatFlutterPlatform.instance.hasPreviousMessages();
  }

  /// This [loadPreviousMessages] is used to fetch previous set of conversations between you and a single chat user or group.
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  /// This set contains the limit/length set in initializeMessageList method
  static Future<void> loadPreviousMessages(
      {required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.loadPreviousMessages(flyCallback);
  }

  /// This [hasNextMessages] is used to find it has any Previous messages
  static Future<bool> hasNextMessages() {
    return FlyChatFlutterPlatform.instance.hasNextMessages();
  }

  /// This [loadNextMessages] is used to fetch next set of conversations between you and a single chat user or group.
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  /// This set contains the limit/length set in initializeMessageList method
  static Future<void> loadNextMessages(
      {required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.loadNextMessages(flyCallback);
  }

  /// Retrieves a list of profile statuses.
  ///
  /// This method asynchronously fetches a list of profile statuses from the Mirrorfly platform.
  /// It returns a [Future<String?>] that resolves to a JSON string representing the list of statuses,
  /// or `null` if an error occurs during the fetch operation.
  ///
  /// Returns:
  ///   A [Future<String?>] containing the JSON string of profile statuses or `null` in case of an error.
  ///
  /// Example usage:
  /// ```dart
  /// String? profileStatusList = await Mirrorfly.getProfileStatusList();
  /// if (profileStatusList != null) {
  ///   print("Profile Status List: $profileStatusList");
  /// } else {
  ///   print("Failed to fetch profile status list");
  /// }
  /// ```
  static Future<String?> getProfileStatusList() {
    return FlyChatFlutterPlatform.instance.getProfileStatusList();
  }

  /// Inserts a default status.
  ///
  /// This method asynchronously inserts a default status into the Mirrorfly platform.
  /// The [status] parameter is required and specifies the status message to be inserted.
  ///
  /// Returns:
  ///   A [Future<bool?>] that completes with `true` if the insertion was successful,
  ///   `false` if unsuccessful, or `null` if an error occurred during the operation.
  ///
  /// Example usage:
  /// ```dart
  /// bool? isInserted = await Mirrorfly.insertDefaultStatus(status: "Available");
  /// if (isInserted == true) {
  ///   print("Default status inserted successfully");
  /// } else {
  ///   print("Failed to insert default status");
  /// }
  static Future<bool?> insertDefaultStatus({required String status}) {
    return FlyChatFlutterPlatform.instance.insertDefaultStatus(status);
  }

  /// Updates the user's profile information asynchronously.
  ///
  /// This method updates the user's profile with the provided [name], [email], [mobile],
  /// [status], and [image] details. The [name] parameter is required, while the others are optional.
  ///
  /// The [flyCallback] parameter is a callback function that will be invoked with a [FlyResponse] object
  /// when the operation completes. The [FlyResponse] object contains information about the success or failure
  /// of the update operation.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.updateMyProfile(
  ///   name: 'John Doe',
  ///   email: 'john@example.com',
  ///   mobile: '1234567890',
  ///   status: 'Available',
  ///   image: 'profile_image_url',
  ///   flyCallback: (response) {
  ///     if (response.isSuccess) {
  ///     var data = profileUpdateFromJson(response.data);
  ///       // Profile update was successful
  ///     } else {
  ///       // Profile update failed
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> updateMyProfile(
      {required String name,
      String? email,
      String? mobile,
      String? status,
      String? image,
      required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance
        .updateMyProfile(name, email, mobile, status, image, flyCallback);
  }

  /// Retrieves the user profile from the Mirrorfly server.
  ///
  /// Retrieves the user profile associated with the provided [jid].
  /// Optionally, the profile can be fetched from the server if [fetchFromServer] is set to true.
  /// If [fetchFromServer] is false, the profile is retrieved from the local DB.
  ///
  /// The [flyCallback] function is invoked with a [FlyResponse] object as a parameter,
  /// providing information about the success or failure of the operation.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.getUserProfile(
  ///   jid: 'user123',
  ///   fetchFromServer: true,
  ///   flyCallback: (response) {
  ///     if (response.isSuccess) {
  ///      var data = profileDataFromJson(response.data);
  ///       print('User profile retrieved successfully: ${response.data}');
  ///     } else {
  ///       print('Failed to retrieve user profile: ${response.errorMessage}');
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> getUserProfile({
    required String jid,
    bool fetchFromServer = false,
    bool saveAsFriend = false,
    required Function(FlyResponse response) flyCallback,
  }) {
    return FlyChatFlutterPlatform.instance
        .getUserProfile(jid, flyCallback, fetchFromServer, saveAsFriend);
  }

  /// Retrieves profile details for a given user.
  ///
  /// This static method fetches profile details for the user identified by [jid]
  /// from the Mirrorfly chat platform. It returns a [Future] that resolves to a [String]
  /// containing the profile details if the operation is successful. If an error occurs,
  /// `null` is returned.
  ///
  /// The [jid] parameter specifies the JID of the user whose
  /// profile details are to be retrieved.
  ///
  /// Example usage:
  /// ```dart
  /// String? profileDetails = await Mirrorfly.getProfileDetails(jid: 'user123@example.com');
  /// if (profileDetails != null) {
  ///   print('Profile details: $profileDetails');
  ///   var details = profiledata(profileDetails)
  /// } else {
  ///   print('Failed to retrieve profile details.');
  /// }
  /// ```
  static Future<String?> getProfileDetails({required String jid}) {
    return FlyChatFlutterPlatform.instance.getProfileDetails(jid);
  }

  /*static Future<dynamic> getProfileLocal(String jid, bool fetchFromServer) {
    return FlyChatFlutterPlatform.instance.getProfileLocal(jid, fetchFromServer);
  }*/

  /// Sets the user's profile status.
  /// Parameters:
  ///   [status] - The new status message to set.
  ///   [statusId] - The ID of the status to be updated.
  ///   [flyCallBack] - A callback function that is called with a [FlyResponse] object upon completion.
  ///
  /// Returns:
  ///   A [Future<void>] that completes when the operation is finished.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.setMyProfileStatus(
  ///   status: "Available",
  ///   statusId: "status123",
  ///   flyCallBack: (response) {
  ///     if (response.isSuccess) {
  ///       print("Profile status updated successfully");
  ///     } else {
  ///       print("Failed to update profile status");
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> setMyProfileStatus(
      {required String status,
      required String statusId,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .setMyProfileStatus(status, statusId, flyCallBack);
  }

  /// Inserts a new profile status.
  ///
  /// This method adds a new status message to the user's profile on the Mirrorfly platform.
  ///
  /// Parameters:
  ///   [status] - The status message to add.
  ///
  /// Returns:
  ///   A [Future<bool?>] that completes with `true` if the insertion was successful,
  ///   `false` if unsuccessful, or `null` if an error occurred during the operation.
  ///
  /// Example usage:
  /// ```dart
  /// bool? isInserted = await Mirrorfly.insertNewProfileStatus(status: "Busy");
  /// if (isInserted == true) {
  ///   print("New profile status inserted successfully");
  /// } else {
  ///   print("Failed to insert new profile status");
  /// }
  /// ```
  static Future<bool?> insertNewProfileStatus({required String status}) {
    return FlyChatFlutterPlatform.instance.insertNewProfileStatus(status);
  }

  ///[image] can be File path String or Url of the image
  static Future<void> updateMyProfileImage(
      {required String image,
      required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance
        .updateMyProfileImage(image, flyCallback);
  }

  /// Removes the profile image of the current user.
  ///
  /// This method asynchronously removes the profile image of the current user on the Mirrorfly platform.
  /// Upon completion, the provided callback function [flyCallBack] is invoked with a [FlyResponse] object,
  /// which contains information about the success or failure of the operation.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.removeProfileImage(flyCallBack: (response) {
  ///   if (response.isSuccess) {
  ///     print("Profile image removed successfully");
  ///   } else {
  ///     print("Failed to remove profile image");
  ///   }
  /// });
  /// ```
  static Future<void> removeProfileImage(
      {required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.removeProfileImage(flyCallBack);
  }

  /// Removes the profile image of a group.
  ///
  /// This method asynchronously removes the profile image of a specified group on the Mirrorfly platform.
  /// The [jid] parameter specifies the unique identifier of the group whose profile image is to be removed.
  /// Upon completion, the provided callback function [flyCallBack] is invoked with a [FlyResponse] object,
  /// which contains information about the success or failure of the operation.
  ///
  /// Parameters:
  ///   [jid] - The JID of the group whose profile image is to be removed.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.removeGroupProfileImage(
  ///   jid: "group jid",
  ///   flyCallBack: (response) {
  ///     if (response.isSuccess) {
  ///       print("Group profile image removed successfully");
  ///     } else {
  ///       print("Failed to remove group profile image");
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> removeGroupProfileImage(
      {required String jid,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .removeGroupProfileImage(jid, flyCallBack);
  }

  /// This [refreshAndGetAuthToken] is used to get refreshed Auth Token.
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  static Future<void> refreshAndGetAuthToken(
      {required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.refreshAndGetAuthToken(flyCallBack);
  }

  /// Retrieves the current authentication token asynchronously.
  ///
  /// This method returns a Future<String> representing the current authentication token.
  /// The authentication token is required for displaying profile images in tha app.
  ///
  /// Returns:
  /// - A Future<String> containing the current authentication token.
  ///
  /// Throws:
  /// - If the authentication token cannot be retrieved, the method may throw an exception.
  static Future<String> getCurrentAuthToken() {
    return FlyChatFlutterPlatform.instance.getCurrentAuthToken();
  }

  /// Provides a method to fetch messages for a specific JID.
  ///
  /// This static method is used to retrieve messages associated with the provided JID.
  ///
  /// Throws an exception if [jid] is null.
  ///
  /// Returns a [Future] that resolves to a [String] representing the messages for the specified JID.
  ///
  /// Example usage:
  /// ```dart
  /// Mirrorfly.getMessagesOfJid(profile.jid.checkNull()).then((value) {
  ///   print('Messages: value');
  ///    List<ChatMessageModel> chatMessageModel = chatMessageModelFromJson(value);
  /// }).catchError((e) {
  ///   print('Failed to fetch messages: $e');
  /// });
  /// ```
  static Future<String?> getMessagesOfJid({required String jid}) {
    return FlyChatFlutterPlatform.instance.getMessagesOfJid(jid);
  }

  /*static Future<dynamic> listenMessageEvents() {
    return FlyChatFlutterPlatform.instance.listenMessageEvents();
  }

  static Future<dynamic> listenGroupChatEvents() {
    return FlyChatFlutterPlatform.instance.listenGroupChatEvents();
  }*/

  /*static Future<dynamic> getMedia({required String mid}) {
    return FlyChatFlutterPlatform.instance.getMedia(mid);
  }*/

  /// This method is used to mark all messages as read up to the most recent message received in a chat identified by [jid].
  /// It also removes the unread message separator that visually distinguishes unread messages from read messages in the chat interface.
  ///
  /// Parameters:
  ///   [jid] - The JID (Jabber ID) of the chat for which messages should be marked as read and the unread separator deleted.
  ///
  /// Returns:
  ///   A [Future<bool?>] that completes with `true` if the operation was successful,
  ///   `false` if unsuccessful, or `null` if an error occurred during the operation.
  ///
  /// Example usage:
  /// ```dart
  /// bool? isSuccess = await Mirrorfly.markAsReadDeleteUnreadSeparator(jid: "user123@example.com");
  /// if (isSuccess == true) {
  ///   print("Messages marked as read and unread separator deleted successfully");
  /// } else {
  ///   print("Failed to mark messages as read or delete unread separator");
  /// }
  /// ```
  static Future<bool?> markAsReadDeleteUnreadSeparator({required String jid}) {
    return FlyChatFlutterPlatform.instance.markAsReadDeleteUnreadSeparator(jid);
  }

  /// Sets the ongoing chat user for the current session.
  ///
  /// This method sets the ongoing chat user for the current session by
  /// providing the unique identifier (JID) of the user.
  ///
  /// The [jid] parameter is the unique identifier of the chat user. or set Empty String to no user in ongoing chat page
  ///
  static setOnGoingChatUser({required String jid}) {
    return FlyChatFlutterPlatform.instance.setOnGoingChatUser(jid);
  }

  /// Download media associated with a message to the Mirrorfly chat platform.
  ///
  /// The [messageId] parameter specifies the unique identifier of the message
  /// for which the media is start Download.
  ///
  /// Returns a [Future] that completes with a `true` value if the media Download
  /// is starts.
  ///
  /// Throws an [ArgumentError] if the [messageId] parameter is not provided.
  static downloadMedia({required String messageId}) {
    return FlyChatFlutterPlatform.instance.downloadMedia(messageId);
  }

  /*static Future<dynamic> openFile(String filePath) {
    return FlyChatFlutterPlatform.instance.openFile(filePath);
  }*/

  /// Retrieves a list of recent chats including archived ones.
  ///
  /// This method fetches a list of recent chats, including those that have been archived.
  ///
  /// Returns:
  ///   A [Future<String>] that completes with a JSON string representing the list of recent chats, including archived ones.
  ///
  /// Example usage:
  /// ```dart
  /// String recentChats = await Mirrorfly.getRecentChatListIncludingArchived();
  /// print("Recent chats including archived: $recentChats");
  /// ```
  static Future<String> getRecentChatListIncludingArchived() {
    return FlyChatFlutterPlatform.instance.getRecentChatListIncludingArchived();
  }

  ///
  /// This method searches for conversations that match the given [searchKey].
  ///
  /// Parameters:
  ///   [searchKey] - The key used for searching conversations.
  ///   [jidForSearch] - The JID (Jabber ID) of the user to limit the search to. If null, the search is not limited to a specific user.
  ///   [globalSearch] - A boolean value that determines the scope of the search. If true, the search is global across all conversations. If false, the search is limited to the current conversation. Defaults to true.
  ///
  /// Returns:
  ///   A [Future<void>] that completes when the search operation is finished.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.searchConversation(
  ///   searchKey: "query",
  ///   jidForSearch: "user123@example.com",
  ///   globalSearch: true,
  ///   flyCallBack: (response) {
  ///     if (response.isSuccess) {
  ///       print("Search successful: ${response.data}");
  ///     } else {
  ///       print("Search failed: ${response.errorMessage}");
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> searchConversation(
      {required String searchKey,
      String? jidForSearch,
      bool globalSearch = true,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .searchConversation(searchKey, jidForSearch, globalSearch, flyCallBack);
  }

  /// This method fetches the list of users registered on the Mirrorfly platform under the license key.
  ///
  /// Parameters:
  ///   [fetchFromServer] - A boolean value that determines the source of the user list.
  ///   If `true`, the list is fetched from the server. If `false`, the list is fetched from the local.
  /// Returns:
  ///   A [Future<void>] that completes when the operation is finished.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.getRegisteredUsers(
  ///   fetchFromServer: true,
  ///   flyCallback: (response) {
  ///     if (response.isSuccess) {
  ///       print("Successfully fetched registered users: ${response.data}");
  ///     } else {
  ///       print("Failed to fetch registered users: ${response.errorMessage}");
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> getRegisteredUsers(
      {required bool fetchFromServer,
      required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance
        .getRegisteredUsers(fetchFromServer, flyCallback);
  }

  /// This method fetches the details of a message identified by its unique [messageId].
  /// It returns a [Future<String?>] that completes with the message details as a JSON string,
  /// or `null` if the message cannot be found or an error occurs.
  ///
  /// Parameters:
  ///   [messageId] - The unique identifier of the message whose details are to be retrieved.
  ///
  /// Returns:
  ///   A [Future<String?>] that completes with the message details as a JSON string or `null`.
  ///
  /// Example usage:
  /// ```dart
  /// String? messageDetails = await Mirrorfly.getMessageOfId(messageId: "message_id");
  /// if (messageDetails != null) {
  ///   print("Message details: $messageDetails");
  /// } else {
  ///   print("Message not found or error occurred");
  /// }
  /// ```
  static Future<String?> getMessageOfId({required String messageId}) {
    return FlyChatFlutterPlatform.instance.getMessageOfId(messageId);
  }

  /// This method fetches the details of the most recent chat for a user or group identified by [jid].
  ///
  /// Parameters:
  ///   [jid] - The JID (Jabber ID) of the user or group whose most recent chat details are to be retrieved.
  ///
  /// Returns:
  ///   A [Future<String>] that completes with the most recent chat details as a JSON string.
  ///
  /// Example usage:
  /// ```dart
  /// String recentChatDetails = await Mirrorfly.getRecentChatOf(jid: "user_or_group_jid");
  /// print("Recent chat details: $recentChatDetails");
  /// ```
  static Future<String> getRecentChatOf({required String jid}) {
    return FlyChatFlutterPlatform.instance.getRecentChatOf(jid);
  }

  /// This method clears the chat history for the chat identified by [jid] and [chatType].
  /// It can optionally preserve starred messages if [clearExceptStarred] is set to true.
  ///
  /// Parameters:
  ///   [jid] - The JID (Jabber ID) of the user or group whose chat history is to be cleared.
  ///   [chatType] - The type of chat (e.g., "single", "group") to specify which chat's history to clear.
  ///   [clearExceptStarred] - A boolean value indicating whether to clear all messages except starred ones.
  ///
  /// Returns:
  ///   A [Future<void>] that completes when the operation is finished.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.clearChat(
  ///   jid: "user123@example.com",
  ///   chatType: "groupchat" or "chat",
  ///   clearExceptStarred: false,
  ///   flyCallBack: (response) {
  ///     if (response.isSuccess) {
  ///       print("Chat cleared successfully");
  ///     } else {
  ///       print("Failed to clear chat: ${response.errorMessage}");
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> clearChat(
      {required String jid,
      required String chatType,
      required bool clearExceptStarred,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .clearChat(jid, chatType, clearExceptStarred, flyCallBack);
  }

  /*static Future<dynamic> reportChatOrUser({required String jid, required String chatType, String? messageId}) {
    return FlyChatFlutterPlatform.instance.reportChatOrUser(jid, chatType, messageId);
  }*/

  /// This method fetches messages based on a list of message IDs provided. It returns a [Future<String?>]
  /// that completes with the message details as a JSON string, or `null` if an error occurs.
  ///
  /// Parameters:
  ///   [messageIds] - A list of message IDs for which the details are to be retrieved.
  ///
  /// Returns:
  ///   A [Future<String?>] that completes with the message details as a JSON string or `null`.
  ///
  /// Example usage:
  /// ```dart
  /// String? messages = await Mirrorfly.getMessagesUsingIds(messageIds: ["id1", "id2", "id3"]);
  /// if (messages != null) {
  ///   print("Messages: $messages");
  /// } else {
  ///   print("Failed to fetch messages or error occurred");
  /// }
  /// ```
  static Future<String?> getMessagesUsingIds(
      {required List<String> messageIds}) {
    return FlyChatFlutterPlatform.instance.getMessagesUsingIds(messageIds);
  }

  /// This method deletes specified messages for the current user but not for other users in the chat.
  /// It can optionally delete associated media files if [isMediaDelete] is set to true.
  ///
  /// Parameters:
  ///   [jid] - The JID (Jabber ID) of the user or group from which messages are to be deleted.
  ///   [chatType] - The type of chat (e.g., "groupchat" or "chat") to specify which chat's messages to delete.
  ///   [messageIds] - A list of message IDs to be deleted.
  ///   [isMediaDelete] - A boolean value indicating whether to delete associated media files.
  ///
  /// Returns:
  ///   [flyCallBack] - A callback function that is called with a [FlyResponse] object upon completion.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.deleteMessagesForMe(
  ///   jid: "user123@example.com",
  ///   chatType: "groupchat" or "chat",
  ///   messageIds: ["messageId1", "messageId2"],
  ///   isMediaDelete: true,
  ///   flyCallBack: (response) {
  ///     if (response.isSuccess) {
  ///       print("Messages deleted successfully");
  ///     } else {
  ///       print("Failed to delete messages: ${response.errorMessage}");
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> deleteMessagesForMe(
      {required String jid,
      required String chatType,
      required List<String> messageIds,
      bool? isMediaDelete,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.deleteMessagesForMe(
        jid, chatType, messageIds, isMediaDelete, flyCallBack);
  }

  /// This method deletes specified messages for all users in a chat, optionally including associated media files.
  /// Upon completion, [flyCallBack] is invoked with a [FlyResponse] object containing the result of the operation.
  ///
  /// Parameters:
  ///   [jid] - The JID (Jabber ID) of the user or group from which messages are to be deleted.
  ///   [chatType] - The type of chat (e.g., "groupchat" or "chat") to specify which chat's messages to delete.
  ///   [messageIds] - A list of message IDs to be deleted.
  ///   [isMediaDelete] - A boolean value indicating whether to delete associated media files.
  ///
  /// Returns:
  ///   [flyCallBack] - A callback function that is called with a [FlyResponse] object upon completion.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.deleteMessagesForEveryone(
  ///   jid: "user123@example.com",
  ///   chatType: "groupchat",
  ///   messageIds: ["messageId1", "messageId2"],
  ///   isMediaDelete: true,
  ///   flyCallBack: (response) {
  ///     if (response.isSuccess) {
  ///       print("Messages deleted for everyone successfully");
  ///     } else {
  ///       print("Failed to delete messages for everyone: ${response.errorMessage}");
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> deleteMessagesForEveryone(
      {required String jid,
      required String chatType,
      required List<String> messageIds,
      bool? isMediaDelete,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.deleteMessagesForEveryone(
        jid, chatType, messageIds, isMediaDelete, flyCallBack);
  }

  /*static Future<dynamic> deleteMessages(
      {required String jid, required List<String> messageIds, required bool isDeleteForEveryOne}) {
    return FlyChatFlutterPlatform.instance.deleteMessages(jid, messageIds, isDeleteForEveryOne);
  }*/

  /// This method fetches the list of recipients who have received the specified group message.
  /// Note that this method is deprecated and it is recommended to use
  /// `Mirrorfly.getGroupMessageDeliveredRecipients()` instead.
  ///
  /// Params:
  /// - [messageId]: The ID of the message.
  /// - [jid]: The JID of the group.
  ///
  /// Returns:
  /// - A `Future<String>` that completes with the list of recipients.
  ///
  /// Usage example:
  /// ```dart
  /// String messageId = "your_message_id";
  /// String jid = "your_jid";
  /// Mirrorfly.getGroupMessageDeliveredToList(messageId, jid).then((recipientsList) {
  ///   // Handle the list of recipients to whom the group message was delivered
  ///   print("Group message delivered to: $recipientsList");
  /// });
  /// ```
  @Deprecated('Instead of use Mirrorfly.getGroupMessageDeliveredRecipients()')
  static Future<String> getGroupMessageDeliveredToList(
      String messageId, String jid) async {
    return FlyChatFlutterPlatform.instance
        .getGroupMessageDeliveredToList(messageId, jid);
  }

  /// Get Delivered Recipients of a Group message to the Mirrorfly chat platform.
  ///
  /// The [messageId] parameter specifies the unique identifier of the message
  /// for which the message you have to get Delivered recipients
  ///
  /// Returns:
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  /// [FlyResponse.data] is Json Encoded value of the message Status Details ([MessageStatusDetail])
  ///
  static Future<void> getGroupMessageDeliveredRecipients(
      {required String messageId,
      required String groupJid,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .getGroupMessageDeliveredRecipients(messageId, groupJid, flyCallBack);
  }

  /// This method fetches the list of recipients who have received the specified group message.
  /// Note that this method is deprecated and it is recommended to use
  /// `Mirrorfly.getGroupMessageDeliveredRecipients()` instead.
  ///
  /// Usage example:
  /// ```dart
  /// String messageId = "your_message_id";
  /// String jid = "your_jid";
  /// Mirrorfly.getGroupMessageDeliveredToList(messageId, jid).then((recipientsList) {
  ///   // Handle the list of recipients to whom the group message was delivered
  ///   print("Group message delivered to: $recipientsList");
  /// });
  /// ```
  ///
  /// Params:
  /// - [messageId]: The ID of the message.
  /// - [jid]: The JID of the group.
  ///
  /// Returns:
  /// - A `Future<String>` that completes with the list of recipients.
  ///
  /// Deprecated:
  /// - Use `Mirrorfly.getGroupMessageDeliveredRecipients()` instead.
  @Deprecated('Instead of use Mirrorfly.getGroupMessageSeenRecipients()')
  static Future<String> getGroupMessageReadByList(
      String messageId, String jid) async {
    return FlyChatFlutterPlatform.instance
        .getGroupMessageReadByList(messageId, jid);
  }

  /// Get Seen Recipients of a Group message to the Mirrorfly chat platform.
  ///
  /// The [messageId] parameter specifies the unique identifier of the message
  /// for which the message you have to get seen recipients
  ///
  /// Returns:
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  /// [FlyResponse.data] is Json Encoded value of the message Status Details ([MessageStatusDetail])
  ///
  static Future<void> getGroupMessageSeenRecipients(
      {required String messageId,
      required String groupJid,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .getGroupMessageSeenRecipients(messageId, groupJid, flyCallBack);
  }

  /// This method fetches the status of the specified single chat message.
  /// Note that this method is deprecated and it is recommended to use
  /// `Mirrorfly.getMessageStatusOf()` instead.
  ///
  /// Params:
  /// - [messageID]: The ID of the message.
  ///
  /// Returns:
  /// - A `Future<String>` that completes with the status of the message.
  ///
  /// Usage example:
  /// ```dart
  /// String messageID = "your_message_id";
  /// Mirrorfly.getMessageStatusOfASingleChatMessage(messageID).then((messageStatus) {
  ///   // Handle the status of the single chat message
  ///   print("Message status: $messageStatus");
  /// });
  /// ```
  @Deprecated('Instead of use Mirrorfly.getMessageStatusOf()')
  static Future<String> getMessageStatusOfASingleChatMessage(String messageID) {
    return FlyChatFlutterPlatform.instance
        .getMessageStatusOfASingleChatMessage(messageID);
  }

  /// Get Status of a message to the Mirrorfly chat platform.
  ///
  /// The [messageId] parameter specifies the unique identifier of the message
  /// for which the message you have to get
  ///
  /// Returns a [String] that completes with a Json Encoded value of the message Status Details ([ChatMessageStatusDetail])
  ///
  /// Throws an [PlatformException] if any error occurred.
  static Future<String> getMessageStatusOf({required String messageId}) {
    return FlyChatFlutterPlatform.instance
        .getMessageStatusOfASingleChatMessage(messageId);
  }

  /// This method sends a request to block a user identified by [userJid]. Upon completion,
  /// the [flyCallBack] function is invoked with a [FlyResponse] object, which contains
  /// information about the success or failure of the operation.
  ///
  /// Parameters:
  ///   [userJid] - The JID (Jabber ID) of the user to be blocked.
  ///
  /// Returns:
  ///   [flyCallBack] - A callback function that is called with a [FlyResponse] object upon completion.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.blockUser(
  ///   userJid: "user123@example.com",
  ///   flyCallBack: (response) {
  ///     if (response.isSuccess) {
  ///       print("User blocked successfully");
  ///     } else {
  ///       print("Failed to block user: ${response.errorMessage}");
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> blockUser(
      {required String userJid,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.blockUser(userJid, flyCallBack);
  }

  /// This method sends a request to unblock a user identified by [userJid]. Upon completion,
  /// the [flyCallBack] function is invoked with a [FlyResponse] object, which contains
  /// information about the success or failure of the operation.
  ///
  /// Parameters:
  ///   [userJid] - The JID (Jabber ID) of the user to be unblocked.
  ///
  /// Returns:

  ///   [flyCallBack] - A callback function that is called with a [FlyResponse] object upon completion.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.unblockUser(
  ///   userJid: "user123@example.com",
  ///   flyCallBack: (response) {
  ///     if (response.isSuccess) {
  ///       print("User unblocked successfully");
  ///     } else {
  ///       print("Failed to unblock user: ${response.errorMessage}");
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> unblockUser(
      {required String userJid,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.unblockUser(userJid, flyCallBack);
  }

  /*static Future<String?> showCustomTones() {
    return FlyChatFlutterPlatform.instance.showCustomTones();
  }

  static Future<String?> getRingtoneName() {
    return FlyChatFlutterPlatform.instance.getRingtoneName();
  }*/

  /*static Future<bool?> loginWebChatViaQRCode({required String barcode}) {
    return FlyChatFlutterPlatform.instance.loginWebChatViaQRCode(barcode);
  }

  static Future<bool?> webLoginDetailsCleared() {
    return FlyChatFlutterPlatform.instance.webLoginDetailsCleared();
  }

  static Future<bool?> logoutWebUser({required List<String> logins}) {
    return FlyChatFlutterPlatform.instance.logoutWebUser(logins);
  }*/

  //not used
  /*static Future<bool?> iOSFileExist({required String filePath}) {
    return FlyChatFlutterPlatform.instance.iOSFileExist(filePath);
  }*/

  /*static Future<dynamic> getWebLoginDetails() {
    return FlyChatFlutterPlatform.instance.getWebLoginDetails();
  }*/

  /// This method updates the favourite status of a specific message for a chat user. The favourite status
  /// can be set to true or false. Upon completion, the [flyCallBack] function is invoked with a [FlyResponse]
  /// object, which contains information about the success or failure of the operation.
  ///
  /// Parameters:
  ///   [messageId] - The unique identifier of the message whose favourite status is to be updated.
  ///   [chatUserJid] - The JID (Jabber ID) of the chat user for whom the message's favourite status is updated.
  ///   [isFavourite] - A boolean value indicating the new favourite status of the message.
  ///   [chatType] - The type of chat (e.g., "groupchat" or "chat") to specify in which chat's context the operation is performed.

  ///
  /// Returns:
  ///   [flyCallBack] - A callback function that is called with a [FlyResponse] object upon completion.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.updateFavouriteStatus(
  ///   messageId: "messageId123",
  ///   chatUserJid: "user123@example.com",
  ///   isFavourite: true,
  ///   chatType: "chat",
  ///   flyCallBack: (response) {
  ///     if (response.isSuccess) {
  ///       print("Message favourite status updated successfully");
  ///     } else {
  ///       print("Failed to update message favourite status: ${response.errorMessage}");
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> updateFavouriteStatus(
      {required String messageId,
      required String chatUserJid,
      required bool isFavourite,
      required String chatType,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.updateFavouriteStatus(
        messageId, chatUserJid, isFavourite, chatType, flyCallBack);
  }

  /// This method forwards a list of messages to multiple users. Upon completion, the [flyCallBack] function
  /// is invoked with a [FlyResponse] object, which contains information about the success or failure of the operation.
  ///
  /// Parameters:
  ///   [messageIds] - A list of message IDs that are to be forwarded.
  ///   [userList] - A list of JIDs (Jabber IDs) of the users to whom the messages are to be forwarded.
  ///
  /// Returns:
  ///   [flyCallBack] - A callback function that is called with a [FlyResponse] object upon completion.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.forwardMessagesToMultipleUsers(
  ///   messageIds: ["messageId1", "messageId2"],
  ///   userList: ["user123@example.com", "user456@example.com"],
  ///   flyCallBack: (response) {
  ///     if (response.isSuccess) {
  ///       print("Messages forwarded successfully");
  ///     } else {
  ///       print("Failed to forward messages: ${response.errorMessage}");
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> forwardMessagesToMultipleUsers(
      {required List<String> messageIds,
      required List<String> userList,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .forwardMessagesToMultipleUsers(messageIds, userList, flyCallBack);
  }

  /*static Future<dynamic> forwardMessages(List<String> messageIds, String tojid, String chattype) {
    return FlyChatFlutterPlatform.instance.forwardMessages(messageIds, tojid, chattype);
  }*/

  /// This method creates a new group with the specified name, user list, and group image. Upon completion,
  /// the [flyCallBack] function is invoked with a [FlyResponse] object, which contains
  /// information about the success or failure of the operation.
  ///
  /// Parameters:
  ///   [groupName] - The name of the group to be created.
  ///   [userList] - A list of JIDs of the users to be added to the group.
  ///   [image] - A file path or URL of the image to be used as the group's profile picture.
  ///
  /// Returns:
  ///   [flyCallBack] - A callback function that is called with a [FlyResponse] object upon completion.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.createGroup(
  ///   groupName: "My Group",
  ///   userList: ["user123@example.com", "user456@example.com"],
  ///   image: "path/to/image.png",
  ///   flyCallBack: (response) {
  ///     if (response.isSuccess) {
  ///       print("Group created successfully");
  ///     } else {
  ///       print("Failed to create group: ${response.errorMessage}");
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> createGroup(
      {required String groupName,
      required List<String> userList,
      required String image,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .createGroup(groupName, userList, image, flyCallBack);
  }

  /// Adds users to a group.
  ///
  /// This method adds the specified users to a group.
  ///
  /// Params:
  /// - [jid] : The JID of the group.
  /// - [userList] : A list of user JIDs to be added to the group.
  ///
  /// Returns:
  ///
  /// - [flyCallBack] : A callback function that is called with a [FlyResponse] object upon completion.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.addUsersToGroup(
  ///   jid: "group_jid",
  ///   userList: ["user1_jid", "user2_jid"],
  ///   flyCallBack: (response) {
  ///     // Handle the response
  ///     print("Users added to group: $response");
  ///   },
  /// );
  /// ```
  static Future<void> addUsersToGroup(
      {required String jid,
      required List<String> userList,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .addUsersToGroup(jid, userList, flyCallBack);
  }

  /// Retrieves the list of group members.
  ///
  /// This method fetches the list of members in the specified group.
  ///
  /// Params:
  /// - [jid] : The JID of the group.
  /// - [fetchFromServer] : Whether to fetch the list from the server. Defaults to `false`.
  ///
  /// Returns:
  /// - [flyCallBack] : A callback function that is called with a [FlyResponse] object upon completion.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.getGroupMembersList(
  ///   jid: "group_jid",
  ///   fetchFromServer: true,
  ///   flyCallBack: (response) {
  ///     // Handle the response
  ///     print("Group members list: $response");
  ///   },
  /// );
  /// ```
  static Future<void> getGroupMembersList(
      {required String jid,
      bool? fetchFromServer,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .getGroupMembersList(jid, fetchFromServer, flyCallBack);
  }

  /// Retrieves the list of users blocked by the current user.
  ///
  /// This method fetches the list of users that the current user has blocked.
  ///
  /// Params:
  /// - [fetchFromServer] : Whether to fetch the list from the server. Defaults to `false`.
  ///
  /// Returns:
  /// - [flyCallBack] : A callback function that is called with a [FlyResponse] object upon completion.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.getUsersIBlocked(
  ///   fetchFromServer: true,
  ///   flyCallBack: (response) {
  ///     // Handle the response
  ///     print("Blocked users list: $response");
  ///   },
  /// );
  /// ```
  static Future<void> getUsersIBlocked(
      {bool fetchFromServer = false,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .getUsersIBlocked(fetchFromServer, flyCallBack);
  }

  /// Retrieves media messages for a specific JID.
  ///
  /// This method fetches media messages (e.g., images, videos) for the specified JID.
  ///
  /// Params:
  /// - [jid] : The JID to fetch media messages for.
  ///
  /// Returns:
  /// - A `Future<String?>` that completes with the media messages.
  ///
  /// Usage example:
  /// ```dart
  /// String jid = "user_jid";
  /// Mirrorfly.getMediaMessages(jid: jid).then((mediaMessages) {
  ///   // Handle the media messages
  ///   print("Media messages: $mediaMessages");
  /// });
  /// ```
  static Future<String?> getMediaMessages({required String jid}) {
    return FlyChatFlutterPlatform.instance.getMediaMessages(jid);
  }

  /// Retrieves document messages for a specific JID.
  ///
  /// This method fetches document messages (e.g., PDFs, DOCs) for the specified JID.
  ///
  /// Params:
  /// - [jid] : The JID to fetch document messages for.
  ///
  /// Returns:
  /// - A `Future<String?>` that completes with the document messages.
  ///
  /// Usage example:
  /// ```dart
  /// String jid = "user_jid";
  /// Mirrorfly.getDocsMessages(jid: jid).then((docsMessages) {
  ///   // Handle the document messages
  ///   print("Document messages: $docsMessages");
  /// });
  /// ```
  static Future<String?> getDocsMessages({required String jid}) {
    return FlyChatFlutterPlatform.instance.getDocsMessages(jid);
  }

  /// Retrieves link messages for a specific JID.
  ///
  /// This method fetches link messages (e.g., URLs) for the specified JID.
  ///
  /// Params:
  /// - [jid] : The JID to fetch link messages for.
  ///
  /// Returns:
  /// - A `Future<String?>` that completes with the link messages.
  ///
  /// Usage example:
  /// ```dart
  /// String jid = "user_jid";
  /// Mirrorfly.getLinkMessages(jid: jid).then((linkMessages) {
  ///   // Handle the link messages
  ///   print("Link messages: $linkMessages");
  /// });
  /// ```
  static Future<String?> getLinkMessages({required String jid}) {
    return FlyChatFlutterPlatform.instance.getLinkMessages(jid);
  }

  /// Exports chat conversation to email.
  ///
  /// This method exports the chat conversation of the specified JID to email.
  ///
  /// Params:
  /// - [jid] : The JID of the chat to be exported.
  ///
  /// Returns:
  /// - [flyCallBack] : A callback function that is called with the response.
  ///
  /// Usage example:
  /// ```dart
  /// String jid = "user_jid";
  /// Mirrorfly.exportChatConversationToEmail(
  ///   jid: jid,
  ///   flyCallBack: (response) {
  ///     // Handle the response
  ///     print("Chat exported to email: $response");
  ///   },
  /// );
  /// ```
  static Future<void> exportChatConversationToEmail(
      {required String jid,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .exportChatConversationToEmail(jid, flyCallBack);
  }

  /// Reports a user or messages.
  ///
  /// This method reports a user or specific messages of the specified JID.
  ///
  /// Params:
  /// - [jid] : The JID of the user or messages to be reported.
  /// - [type] : The type of report (e.g., user, message).
  /// - [messageId] : The ID of the message to be reported (optional).
  ///
  /// Returns:
  /// - [flyCallBack] : A callback function that is called with the response.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.reportUserOrMessages(
  ///   jid: jid,
  ///   type: type,
  ///   messageId: messageId,
  ///   flyCallBack: (response) {
  ///     // Handle the response
  ///     print("User or messages reported: $response");
  ///   },
  /// );
  /// ```
  static Future<void> reportUserOrMessages(
      {required String jid,
      required String type,
      String messageId = "",
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .reportUserOrMessages(jid, type, messageId, flyCallBack);
  }

  /// Makes a user an admin of a group.
  ///
  /// This method promotes a user to be an admin of the specified group.
  ///
  /// Params:
  /// - [groupJid] : The JID of the group.
  /// - [userJid] : The JID of the user to be made admin.
  ///
  /// Returns:
  /// - [flyCallBack] : A callback function that is called with the response.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.makeAdmin(
  ///   groupJid: groupJid,
  ///   userJid: userJid,
  ///   flyCallBack: (response) {
  ///     // Handle the response
  ///     print("User made admin: $response");
  ///   },
  /// );
  /// ```
  static Future<void> makeAdmin(
      {required String groupJid,
      required String userJid,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .makeAdmin(groupJid, userJid, flyCallBack);
  }

  /// Removes a member from a group.
  ///
  /// This method removes the specified user from the specified group.
  ///
  /// Params:
  /// - [groupJid] : The JID of the group.
  /// - [userJid] : The JID of the user to be removed.
  ///
  /// Returns:
  /// - [flyCallBack] : A callback function that is called with the response.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.removeMemberFromGroup(
  ///   groupJid: groupJid,
  ///   userJid: userJid,
  ///   flyCallBack: (response) {
  ///     // Handle the response
  ///     print("User removed from group: $response");
  ///   },
  /// );
  /// ```
  static Future<void> removeMemberFromGroup(
      {required String groupJid,
      required String userJid,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .removeMemberFromGroup(groupJid, userJid, flyCallBack);
  }

  /// User Leaves from a group.
  ///
  /// This method allows the specified user to leave the specified group.
  ///
  /// Params:
  /// - [userJid] : The JID of the user leaving the group.
  /// - [groupJid] : The JID of the group.
  ///
  /// Returns:
  /// - [flyCallBack] : A callback function that is called with the response.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.leaveFromGroup(
  ///   userJid: userJid,
  ///   groupJid: groupJid,
  ///   flyCallBack: (response) {
  ///     // Handle the response
  ///     print("User left group: $response");
  ///   },
  /// );
  /// ```
  static Future<void> leaveFromGroup(
      {required String userJid,
      required String groupJid,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .leaveFromGroup(userJid, groupJid, flyCallBack);
  }

  /// Deletes a group.
  ///
  /// This method deletes the specified group.
  ///
  /// Params:
  /// - [jid] : The JID of the group to be deleted.
  ///
  /// Returns:
  /// - [flyCallBack] : A callback function that is called with the response.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.deleteGroup(
  ///   jid: jid,
  ///   flyCallBack: (response) {
  ///     // Handle the response
  ///     print("Group deleted: $response");
  ///   },
  /// );
  /// ```
  static Future<void> deleteGroup(
      {required String jid,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.deleteGroup(jid, flyCallBack);
  }

  /// Checks if a user is an admin of a group.
  ///
  /// This method checks whether the specified user is an admin of the specified group.
  /// Note that this method is deprecated and it is recommended to use
  /// `Mirrorfly.isGroupAdmin()` instead.
  ///
  /// Params:
  /// - [userJid] : The JID of the user to check.
  /// - [groupJID] : The JID of the group.
  ///
  /// Returns:
  /// - A `Future<bool?>` that completes with `true` if the user is an admin, `false` otherwise.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.isAdmin(userJid, groupJID).then((isAdmin) {
  ///   // Handle the result
  ///   if (isAdmin == true) {
  ///     print("User is an admin of the group");
  ///   } else {
  ///     print("User is not an admin of the group");
  ///   }
  /// });
  /// ```
  @Deprecated('Instead of use Mirrorfly.isGroupAdmin()')
  static Future<bool?> isAdmin(String userJid, String groupJID) {
    return FlyChatFlutterPlatform.instance.isAdmin(userJid, groupJID);
  }

  /// Checks if a user is an admin of a group.
  ///
  /// This method checks whether the specified user is an admin of the specified group.
  ///
  /// Params:
  /// - [userJid] : The JID of the user to check.
  /// - [groupJid] : The JID of the group.
  ///
  /// Returns:
  /// - A `Future<bool?>` that completes with `true` if the user is an admin, `false` otherwise.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.isGroupAdmin(userJid: userJid, groupJid: groupJid).then((isAdmin) {
  ///   // Handle the result
  ///   if (isAdmin == true) {
  ///     print("User is an admin of the group");
  ///   } else {
  ///     print("User is not an admin of the group");
  ///   }
  /// });
  /// ```
  static Future<bool?> isGroupAdmin(
      {required String userJid, required String groupJid}) {
    return FlyChatFlutterPlatform.instance.isAdmin(userJid, groupJid);
  }

  /// Updates the profile image of a group.
  ///
  /// This method updates the profile image of the specified group.
  ///
  /// Params:
  /// - [jid] : The JID of the group.
  /// - [file] : The file path of the new profile image.

  ///
  /// Returns:
  /// - [flyCallBack] : A callback function that is called with with a [FlyResponse].
  ///
  /// Usage example:
  /// ```dart
  /// String jid = "group_jid";
  /// String file = "path/to/image.jpg";
  /// Mirrorfly.updateGroupProfileImage(
  ///   jid: jid,
  ///   file: file,
  ///   flyCallBack: (response) {
  ///     // Handle the response
  ///     print("Group profile image updated: $response");
  ///   },
  /// );
  /// ```
  static Future<void> updateGroupProfileImage(
      {required String jid,
      required String file,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .updateGroupProfileImage(jid, file, flyCallBack);
  }

  /// Updates the name of a group.
  ///
  /// This method updates the name of the specified group.
  ///
  /// Params:
  /// - [jid] : The JID of the group.
  /// - [name] : The new name for the group.
  ///
  /// Returns:
  /// - [flyCallBack] : A callback function that is called with with a [FlyResponse].
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.updateGroupName(
  ///   jid: jid,
  ///   name: name,
  ///   flyCallBack: (response) {
  ///     // Handle the response
  ///     print("Group name updated: $response");
  ///   },
  /// );
  /// ```
  static Future<void> updateGroupName(
      {required String jid,
      required String name,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .updateGroupName(jid, name, flyCallBack);
  }

  /// Checks if a user is a member of a group.
  ///
  /// This method checks whether the specified user is a member of the specified group.
  ///
  /// Params:
  /// - [userJid] : The JID of the user to check.
  /// - [groupJid] : The JID of the group.
  ///
  /// Returns:
  /// - A `Future<bool?>` that completes with `true` if the user is a member, `false` otherwise.
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.isMemberOfGroup(userJid: userJid, groupJid: groupJid).then((isMember) {
  ///   // Handle the result
  ///   if (isMember == true) {
  ///     print("User is a member of the group");
  ///   } else {
  ///     print("User is not a member of the group");
  ///   }
  /// });
  /// ```
  static Future<bool?> isMemberOfGroup(
      {required String userJid, required String groupJid}) {
    return FlyChatFlutterPlatform.instance.isMemberOfGroup(groupJid, userJid);
  }

  /// Sends contact us information.
  ///
  /// This method sends contact us information with the specified title and description.
  ///
  /// Params:
  /// - [title] : The title of the contact us information.
  /// - [description] : The description of the contact us information.
  ///
  /// Returns:
  /// - [flyCallBack] : A callback function that is called with with a [FlyResponse].
  ///
  /// Usage example:
  /// ```dart
  /// Mirrorfly.sendContactUsInfo(
  ///   title: title,
  ///   description: description,
  ///   flyCallBack: (response) {
  ///     // Handle the response
  ///     print("Contact us info sent: $response");
  ///   },
  /// );
  /// ```
  static Future<void> sendContactUsInfo(
      {required String title,
      required String description,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .sendContactUsInfo(title, description, flyCallBack);
  }

  /*static copyTextMessages({required List<String> messageIds}) {
    return FlyChatFlutterPlatform.instance.copyTextMessages(messageIds);
  }*/

  /// Saves an unsent message for a specific user or group.
  ///
  /// This method stores a message that could not be sent at the moment. It can be used to save messages
  /// temporarily until they can be sent. The message is associated with the JID of the user or group.
  ///
  /// Parameters:
  ///   [jid] - The JID (Jabber ID) of the user or group to which the message was intended.
  ///   [message] - The message text that was not sent.
  ///
  /// Returns:
  ///   A [Future] that completes when the operation is finished.
  ///
  /// Example usage:
  /// ```dart
  /// await Mirrorfly.saveUnsentMessage(
  ///   jid: "user123@example.com",
  ///   message: "Hello, this message couldn't be sent earlier!",
  /// );
  /// ```
  static saveUnsentMessage({required String jid, required String message}) {
    return FlyChatFlutterPlatform.instance.saveUnsentMessage(jid, message);
  }

  /// Deletes the user account from the Mirrorfly platform.
  ///
  /// This method initiates the process of deleting the user account from the
  /// Mirrorfly platform. It requires a [reason] parameter specifying the reason
  /// for deleting the account. Optionally, you can provide a [feedback] message
  /// to provide additional details or feedback regarding the deletion.
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  static Future<void> deleteAccount(
      {required String reason,
      String? feedback,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .deleteAccount(reason, feedback, flyCallBack);
  }

  /// Retrieves the user's favorite messages from the Mirrorfly chat platform.
  ///
  /// This static method asynchronously retrieves the user's favorite messages
  /// from the Mirrorfly chat platform using the underlying platform implementation.
  ///
  /// Returns a [Future] that completes with a [String] representing the user's
  /// favorite([ChatMessageModel]) messages.
  ///
  ///Example:
  ///Mirrorfly.getFavouriteMessages().then((value) {
  //    List<ChatMessageModel> chatMessageModel = chatMessageModelFromJson(value);
  //}).catchError((e){
  // });
  static Future<String> getFavouriteMessages() {
    return FlyChatFlutterPlatform.instance.getFavouriteMessages();
  }

  /// Retrieves all groups.
  ///
  /// Fetches all groups from the local DB by default. If [fetchFromServer] is set to `true`,
  /// it fetches groups from the server instead.
  ///
  /// Returns a [Future] that completes with a [String] representing the retrieved groups ([ProfileDetails]),
  /// or `null` if an error occurs.
  ///
  ///Example
  ///Mirrorfly.getAllGroups(flyCallBack: (response){
  //    if (response.isSuccess && response.hasData) {
  //      List<ProfileDetails> list = profileFromJson(value);
  //    }
  ///});
  static Future<void> getAllGroups(
      {bool fetchFromServer = false,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .getAllGroups(fetchFromServer, flyCallBack);
  }

  /*static Future<String?> getDefaultNotificationUri() {
    return FlyChatFlutterPlatform.instance.getDefaultNotificationUri();
  }

  static Future setDefaultNotificationSound() {
    return FlyChatFlutterPlatform.instance.setDefaultNotificationSound();
  }

  static setNotificationUri({required String uri}) {
    return FlyChatFlutterPlatform.instance.setNotificationUri(uri);
  }

  static setNotificationSound({required bool enable}) {
    return FlyChatFlutterPlatform.instance.setNotificationSound(enable);
  }

  static setMuteNotification({required bool enable}) {
    return FlyChatFlutterPlatform.instance.setMuteNotification(enable);
  }

  static setNotificationVibration({required bool enable}) {
    return FlyChatFlutterPlatform.instance.setNotificationVibration(enable);
  }

  static cancelNotifications() {
    return FlyChatFlutterPlatform.instance.cancelNotifications();
  }*/

  /// Saves media settings for the user.
  ///
  /// This static method is used to save the user's media download settings while using Mobile Network and WIFI, such as
  /// preferences for photos, videos, audio, and documents, as well as the
  /// preferred network type for media downloads.
  ///
  /// Parameters:
  /// - [photos]: A boolean indicating whether the user allows photo downloads.
  /// - [videos]: A boolean indicating whether the user allows video downloads.
  /// - [audio]: A boolean indicating whether the user allows audio downloads.
  /// - [documents]: A boolean indicating whether the user allows document downloads.
  /// - [networkType]: An integer representing the type of network. This could
  ///   be values such as 0 for cellular data, 1 for Wi-Fi, etc.
  ///
  /// Returns:
  /// A future that completes with a boolean value indicating whether the media settings
  /// were successfully saved.
  static saveMediaSettings(
      {required bool photos,
      required bool videos,
      required bool audios,
      required bool documents,
      required int networkType}) async {
    return FlyChatFlutterPlatform.instance
        .saveMediaSettings(photos, videos, audios, documents, networkType);
  }

  // Retrieves media settings from the Mirrorfly chat platform.
  ///
  /// This static method queries the Mirrorfly chat platform to retrieve media
  /// settings based on the specified [networkType] and [type].
  ///
  /// - [networkType]: An integer representing the type of network. This could
  ///   be values such as 0 for cellular data, 1 for Wi-Fi, etc.
  ///
  /// - [type]: A string specifying the type of media setting to retrieve.
  ///   Examples include 'Photos', 'Videos', 'Audio', 'Documents'.
  ///
  /// Returns a [Future] that completes with a boolean value indicating
  /// whether the media setting retrieval was successful.
  static Future<bool?> getMediaSetting(
      {required int networkType, required String type}) async {
    return FlyChatFlutterPlatform.instance.getMediaSetting(networkType, type);
  }

  /// Retrieves the media auto-download setting.
  ///
  /// This static method asynchronously retrieves the current setting for media auto-download.
  /// It delegates the task to the FlyChatFlutterPlatform instance and returns a Future<bool?>
  /// representing the current state of media auto-download.
  ///
  /// Returns:
  /// - `true` if media auto-download is enabled.
  /// - `false` if media auto-download is disabled.
  /// - `null` if the media auto-download setting cannot be retrieved or is not available.
  static Future<bool?> getMediaAutoDownload() async {
    return FlyChatFlutterPlatform.instance.getMediaAutoDownload();
  }

  /// Sets whether media files should be automatically downloaded.
  ///
  /// This static method sets whether media files (e.g., images, videos) received
  /// through the Mirrorfly SDK should be automatically downloaded to the device.
  ///
  /// [enable] specifies whether media auto-download should be enabled or disabled.
  /// If set to `true`, media auto-download will be enabled. If set to `false`, it
  /// will be disabled.
  ///
  /// Returns a `Future<void>` that completes once the operation is complete.
  ///
  static setMediaAutoDownload({required bool enable}) async {
    return FlyChatFlutterPlatform.instance.setMediaAutoDownload(enable);
  }

  /// Retrieves the JID associated with a given phone number.
  ///
  /// This method queries the Mirrorfly to find the JID associated with the specified
  /// mobile number and country code. It is useful for converting a user's phone number into
  /// their JID, which is required for various operations within the Mirrorfly platform.
  ///
  /// Parameters:
  ///   [mobileNumber] - The mobile number of the user whose JID is to be retrieved.
  ///   [countryCode] - The country code of the user's mobile number.
  ///
  /// Returns:
  ///   A [Future<String?>] that completes with the JID associated with the given phone number
  ///   or `null` if the JID cannot be found or an error occurs.
  ///
  /// Example usage:
  /// ```dart
  /// String? jid = await Mirrorfly.getJidFromPhoneNumber(
  ///   mobileNumber: "1234567890",
  ///   countryCode: "+1",
  /// );
  /// if (jid != null) {
  ///   print("JID: $jid");
  /// } else {
  ///   print("JID not found or error occurred");
  /// }
  /// ```
  static Future<String?> getJidFromPhoneNumber(
      {required String mobileNumber, required String countryCode}) async {
    return FlyChatFlutterPlatform.instance
        .getJidFromPhoneNumber(mobileNumber, countryCode);
  }

  /*static Future<bool?> getNotificationSound() async {
    return FlyChatFlutterPlatform.instance.getNotificationSound();
  }*/

  /// Inserts the busy status for the current user.
  ///
  /// This static method sends the provided [busyStatus] to the Mirrorfly chat platform
  /// to update the user's busy status.
  ///
  /// Returns a [Future] that completes with a [bool] value indicating whether
  /// the insertion operation was successful. Returns `true` if successful, `false` otherwise.
  ///
  /// Throws an error if [busyStatus] is null.
  static Future<bool?> insertBusyStatus({required String busyStatus}) async {
    return FlyChatFlutterPlatform.instance.insertBusyStatus(busyStatus);
  }

  /// This method is used to check if the user is a trail user or not.
  @Deprecated(
      'This method is deprecated. Please refrain from using it, as the functionality has been internally managed within the plugin')
  static Future<bool?> isTrailLicence() async {
    return FlyChatFlutterPlatform.instance.isTrailLicence();
  }

  /*static Future<String?> getNonChatUsers() async {
    return FlyChatFlutterPlatform.instance.getNonChatUsers();
  }*/

  /// This method adds a contact with the specified phone number and name to the user's contact list.
  /// It is an asynchronous operation that returns a [Future<bool?>] indicating the success or failure of the contact addition.
  ///
  /// Parameters:
  ///   [number] - The phone number of the contact to be added.
  ///   [name] - The name of the contact to be added.
  ///
  /// Returns:
  ///   A [Future<bool?>] that completes with `true` if the contact was successfully added,
  ///   `false` if the operation failed, or `null` if an error occurred.
  ///
  /// Example usage:
  /// ```dart
  /// bool? isSuccess = await Mirrorfly.addContact(
  ///   number: "1234567890",
  ///   name: "John Doe",
  /// );
  /// if (isSuccess == true) {
  ///   print("Contact added successfully");
  /// } else {
  ///   print("Failed to add contact");
  /// }
  /// ```
  static Future<bool?> addContact(
      {required String number, required String name}) async {
    return FlyChatFlutterPlatform.instance.addContact(number, name);
  }

  /// Sets the region code for the User.
  ///
  /// The [regionCode] parameter specifies the region code to set.
  /// This method is used to configure the region for the Mirrorfly.
  /// This method is used when [enableMobileNumberLogin] enabled in [initializeSDK]
  ///
  /// Example usage:
  /// ```dart
  ///
  /// await Mirrorfly.setRegionCode(regionCode: 'US');
  ///
  /// ```
  static Future<void> setRegionCode({required String regionCode}) async {
    return FlyChatFlutterPlatform.instance.setRegionCode(regionCode);
  }

  /// Utility method to retrieve a value from either the AndroidManifest.xml (for Android)
  /// or the Info.plist (for iOS) based on the provided keys.
  ///
  /// This method is asynchronous and returns a [Future] that completes with a [String]
  /// representing the retrieved value. The value is obtained using the platform-specific
  /// implementation provided by [Mirrorfly].
  ///
  /// Provide the [androidManifestKey] to specify the key for the value in the AndroidManifest.xml.
  /// Provide the [iOSPlistKey] to specify the key for the value in the Info.plist.
  ///
  static Future<String> getValueFromManifestOrInfoPlist(
      {String? androidManifestKey, String? iOSPlistKey}) async {
    return FlyChatFlutterPlatform.instance.getValueFromManifestOrInfoPlist(
        androidManifestKey: androidManifestKey, iOSPlistKey: iOSPlistKey);
  }

  /// Creates a new topic with the specified name and optional metadata.
  ///
  /// Parameters:
  /// - The [topicName] parameter is required and represents the name of the topic to be created.
  ///
  /// - The [metaData] parameter is optional and represents additional metadata associated with the topic.
  ///
  /// Returns a [Future] that completes with a [String] representing the unique identifier of the created topic.
  ///
  /// Throws an error if the creation of the topic fails.
  static Future<void> createTopic(
      {required String topicName,
      List<TopicMetaData> metaData = const [],
      required Function(FlyResponse response) flyCallBack}) async {
    return FlyChatFlutterPlatform.instance.createTopic(
        topicName: topicName, metaData: metaData, callback: flyCallBack);
  }

  /// Retrieves topics from the Mirrorfly platform.
  ///
  /// This method asynchronously retrieves topics from the Mirrorfly platform
  /// based on the provided list of [topicIds].
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  /// Example:
  /// await Mirrorfly.getTopics(topicIds: ["c47cdeec-32a0-4abb-a318-ab60048df577"],flyCallBack: (response){
  ///   if(response.isSuccess && response.hasData){
  ///     var topics = topicsFromJson(response.data);
  ///   }
  /// });
  static Future<void> getTopics(
      {required List<String> topicIds,
      required Function(FlyResponse response) flyCallBack}) async {
    return FlyChatFlutterPlatform.instance
        .getTopics(topicIds: topicIds, callback: flyCallBack);
  }

  /// Retrieves the recent chat list history by Topic asynchronously.
  ///
  /// This method fetches the recent chat list history from the Mirrorfly platform.
  /// You can specify whether it's the first set of data to fetch using [firstSet].
  /// The maximum number of chat items to retrieve is specified by [limit],
  /// with a default value of 15 if not provided.
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// await Mirrorfly.getRecentChatListHistoryByTopic(
  ///   topicId: '',
  ///   firstSet: true,
  ///   limit: 20,
  ///   flyCallback: (response) {
  ///     // Handle the response here
  ///     if (response.isSuccess && response.hasData) {
  //         var data = recentChatFromJson(response.data);
  //      }
  ///   }
  /// );
  /// ```
  static Future<void> getRecentChatListHistoryByTopic(
      {required String topicId,
      required bool firstSet,
      int limit = 15,
      required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.getRecentChatListHistoryByTopic(
        topicId: topicId,
        firstSet: firstSet,
        limit: limit,
        callback: flyCallback);
  }

  /// Initiates a video call with the specified user.
  ///
  /// The [userJid] parameter is the JID of the user with whom
  /// the video call will be initiated.
  ///
  /// Before initiating the video call, this method checks for permissions to access
  /// the [camera] and [microphone].
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  static Future<void> makeVideoCall(
      {required String toUserJid,
      required Function(FlyResponse response) flyCallBack}) async {
    return FlyChatFlutterPlatform.instance
        .makeVideoCall(toUserJid, flyCallBack);
  }

  /// Makes a voice call to the specified user.
  ///
  /// The [userJid] parameter is the JID of the user with whom
  /// the voice call will be initiated.
  ///
  /// Before initiating the voice call, this method checks for permissions to access
  /// the [microphone].
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  static Future<void> makeVoiceCall(
      {required String toUserJid,
      required Function(FlyResponse response) flyCallBack}) async {
    return FlyChatFlutterPlatform.instance
        .makeVoiceCall(toUserJid, flyCallBack);
  }

  /// Initiates a group voice call using Mirrorfly.
  ///
  /// Calls multiple users simultaneously by creating a group call.
  ///
  /// [groupJid] The unique identifier for the group where the call will be made.
  /// [jidList] A list of unique identifiers for individual users to be called in the group.
  ///
  /// Before initiating the voice call, this method checks for permissions to access
  /// the [microphone].
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  /// Returns a Future<bool> indicating whether the call initiation was successful.
  /// If successful, returns true; otherwise, throws an Exception.
  ///
  static Future<void> makeGroupVoiceCall(
      {String groupJid = "",
      List<String> toUserJidList = const [],
      required Function(FlyResponse response) flyCallBack}) async {
    return FlyChatFlutterPlatform.instance
        .makeGroupVoiceCall(groupJid, toUserJidList, flyCallBack);
  }

  /// Initiates a group video call using Mirrorfly.
  ///
  /// Calls multiple users simultaneously by creating a group call.
  ///
  /// [groupJid] The unique identifier for the group where the call will be made.
  /// [jidList] A list of unique identifiers for individual users to be called in the group.
  ///
  /// Before initiating the video call, this method checks for permissions to access
  /// the [camera] and [microphone].
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  /// Returns a Future<bool> indicating whether the call initiation was successful.
  /// If successful, returns true; otherwise, throws an Exception.
  ///
  static Future<void> makeGroupVideoCall(
      {String groupJid = "",
      List<String> toUserJidList = const [],
      required Function(FlyResponse response) flyCallBack}) async {
    return FlyChatFlutterPlatform.instance
        .makeGroupVideoCall(groupJid, toUserJidList, flyCallBack);
  }

  /// Retrieves a list of users in the current call.
  ///
  /// This method asynchronously requests a list of users in the current calls
  ///
  /// Returns a [Future] that completes with the result of users list in the call with their call status.
  ///
  static Future<String> getCallUsersList() async {
    return FlyChatFlutterPlatform.instance.getCallUsersList();
  }

  /// Retrieves the type of ongoing call from the Mirrorfly platform.
  ///
  /// Returns a [Future] that completes with a [String] representing
  /// the type of call, which could be "audio", "video"
  /// Throws an error if there's an issue retrieving the call type.
  static Future<String> getCallType() async {
    return FlyChatFlutterPlatform.instance.getCallType();
  }

  /// Retrieves the group JID for video call purposes.
  ///
  /// This static method asynchronously fetches the group JID used for current ongoing/incoming
  /// call. The group JID uniquely identifies the group conversation
  /// where the audio or video call will be conducted.
  ///
  /// Returns a [Future] that completes with the group JID string upon success.
  ///
  /// Throws an error if there's any issue with retrieving the group JID.
  static Future<String> getCallGroupJid() async {
    return FlyChatFlutterPlatform.instance.getCallGroupJid();
  }

  /// Retrieves the call direction from the Mirrorfly platform.
  ///
  /// This static method asynchronously fetches the call direction from the
  /// underlying Mirrorfly implementation. It returns a [Future] that
  /// resolves to a [String] representing the call direction.such as `incoming` or `outgoing`
  ///
  /// Returns:
  ///   A [Future] that resolves to a [String] representing the call direction.
  ///   such as `Incoming` or `Outgoing`.
  ///
  static Future<String> getCallDirection() async {
    return FlyChatFlutterPlatform.instance.getCallDirection();
  }

  /// Retrieves a list of all available audio input devices.
  ///
  /// Returns a [Future] that completes with a [String] representing
  /// the list of available audio input devices.
  ///
  /// The returned string may contain a JSON-encoded list of available
  /// audio input device identifiers.
  ///
  /// Throws an exception if there is an error retrieving the list
  /// of available audio input devices.
  static Future<String> getAllAvailableAudioInput() async {
    return FlyChatFlutterPlatform.instance.getAllAvailableAudioInput();
  }

  /// Switches the camera used for video call.
  ///
  /// This static method asynchronously switches the camera being used for video call.
  /// switch the camera rear or front
  ///
  static switchCamera() async {
    return FlyChatFlutterPlatform.instance.switchCamera();
  }

  ///Used as a [declineCall] class for [Mirrorfly]
  ///used to decline the Call an out-going call
  static Future<bool?> declineCall() async {
    return FlyChatFlutterPlatform.instance.declineCall();
  }

  /// Mutes or unmutes audio during a call.
  ///
  /// This static method allows the user to mute or unmute audio during a call.
  /// It takes a boolean [status] parameter indicating whether to mute or unmute audio.
  /// If [status] is true, audio will be muted; if false, audio will be unmuted.
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  static Future<void> muteAudio(
      {required bool status,
      required Function(FlyResponse response) flyCallBack}) async {
    return FlyChatFlutterPlatform.instance.muteAudio(status, flyCallBack);
  }

  /// Mutes or unmutes the video during an ongoing call.
  ///
  /// This method allows the user to mute or unmute the video during an ongoing call in the Mirrorfly SDK.
  ///
  /// The [status] parameter indicates whether the video should be muted (`true`) or unmuted (`false`).
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  static Future<void> muteVideo(
      {required bool status,
      required Function(FlyResponse response) flyCallBack}) async {
    return FlyChatFlutterPlatform.instance.muteVideo(status, flyCallBack);
  }

  /// Routes audio to the specified destination.
  ///
  /// This static method routes audio to the destination specified by [routeType].
  ///
  /// The [routeType] parameter specifies the type of destination where the audio
  /// should be routed. It must not be null. you will get Available audio device types from [getAllAvailableAudioInput].
  ///
  /// Returns a [Future] that completes with a [bool] value indicating whether
  /// the audio routing was successful.
  ///
  /// Throws an [ArgumentError] if the [routeType] is null.
  static Future<bool?> routeAudioTo({required String routeType}) async {
    return FlyChatFlutterPlatform.instance.routeAudioTo(routeType: routeType);
  }

  /// Checks whether there is an ongoing call.
  ///
  /// This method asynchronously queries the platform to determine if there
  /// is an ongoing call in the Mirrorfly SDK.
  ///
  /// Returns a [Future] that completes with a [bool] value:
  /// - `true` if there is an ongoing call.
  /// - `false` if there is no ongoing call or if the call status cannot be determined.
  ///
  static Future<bool?> isOnGoingCall() async {
    return FlyChatFlutterPlatform.instance.isOnGoingCall();
  }

  /// Provides functionality to disconnect a call in the Mirrorfly platform.
  ///
  /// This static method invokes the [disconnectCall] method from the
  /// `FlyChatFlutterPlatform` instance to disconnect the ongoing call.
  ///
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  static Future<void> disconnectCall(
      {required Function(FlyResponse response) flyCallBack}) async {
    return FlyChatFlutterPlatform.instance.disconnectCall(flyCallBack);
  }

  /// Returns the selected audio device during a call.
  ///
  /// This static method asynchronously retrieves the selected audio device
  /// during an ongoing call from the Mirrorfly platform.
  ///
  /// Returns a [Future] that resolves to a [String] representing the Type of
  /// the selected audio device.you will get available audio device types from [getAllAvailableAudioInput]
  static Future<String?> selectedAudioDevice() async {
    return FlyChatFlutterPlatform.instance.selectedAudioDevice();
  }

  /// Checks if the user's audio is muted during a call.
  ///
  /// This method asynchronously queries the platform to determine if the audio
  /// of the user identified by [userJid] is muted during an ongoing call.
  ///
  /// Returns a [Future] that completes with a [bool] value indicating whether
  /// the user's audio is muted (`true`) or not (`false`).
  ///
  /// If [userJid] is provided, the method checks the audio mute status for
  /// the specified user. If [userJid] is `null`, it checks the audio mute status
  /// for the current user.
  ///
  static Future<bool?> isUserAudioMuted({String? userJid}) async {
    return FlyChatFlutterPlatform.instance.isUserAudioMuted(userJid);
  }

  /// Checks if the user's video is muted during a call.
  ///
  /// This method asynchronously queries the platform to determine if the video
  /// of the user identified by [userJid] is muted during an ongoing call.
  ///
  /// Returns a [Future] that completes with a [bool] value indicating whether
  /// the user's video is muted (`true`) or not (`false`).
  ///
  /// If [userJid] is provided, the method checks the video mute status for
  /// the specified user. If [userJid] is `null`, it checks the video mute status
  /// for the current user.
  ///
  static Future<bool?> isUserVideoMuted({String? userJid}) async {
    return FlyChatFlutterPlatform.instance.isUserVideoMuted(userJid);
  }

  /// Retrieves the number of unread missed calls.
  ///
  /// Returns a [Future] that completes with the number of unread missed calls.
  ///
  /// Throws an exception if there is an error while retrieving the count.
  ///
  static Future<int?> getUnreadMissedCallCount() async {
    return FlyChatFlutterPlatform.instance.getUnreadMissedCallCount();
  }

  /// Checks if the app was launched from a missed call notification.
  ///
  /// This static method asynchronously checks if the app was launched from a
  /// missed call notification. It delegates the task to the underlying platform
  /// implementation.
  ///
  /// Returns a [Future] that completes with a [bool] value indicating whether
  /// the app was launched from a missed call notification:
  ///
  /// - `true` if the app was launched from a missed call notification.
  /// - `false` if the app was not launched from a missed call notification.
  ///
  static Future<bool?> appLaunchedFromMissedCall() async {
    return FlyChatFlutterPlatform.instance.appLaunchedFromMissedCall();
  }

  /// Checks if the app was launched from a Mirrorfly notification.
  ///
  /// This static method asynchronously checks if the app was launched from a
  /// mirrorfly notification. It delegates the task to the underlying platform
  /// implementation.
  ///
  /// Returns a [Future] that completes with a [MirrorflyNotificationAppLaunchDetails] value of
  /// the app was launched from a mirrorfly notification:
  ///
  ///
  static Future<MirrorflyNotificationAppLaunchDetails?>
      getAppLaunchedDetails() async {
    return FlyChatFlutterPlatform.instance.getAppLaunchedDetails();
  }

  /// Opens the audio file picker to select an audio file for [[Platform].isAndroid].
  ///
  /// Returns a [Future] that completes with a [String] representing the path
  /// of the selected audio file, or `null` if no file is selected.
  ///
  /// Throws an error if there is any issue opening the audio file picker.
  static Future<String?> openAudioFilePicker() async {
    return FlyChatFlutterPlatform.instance.openAudioFilePicker();
  }

  /// Retrieves the available features provided by the Mirrorfly SDK.
  ///the features based on MirrorFly Plan from your license key
  ///You can Call this to show/hide features based on the availability
  ///If the feature is not available, then SDK methods wil throw 403 Exception.
  static Future<String> getAvailableFeatures() async {
    return FlyChatFlutterPlatform.instance.getAvailableFeatures();
  }

  ///Used to [requestVideoCallSwitch] from Audio to Video Call
  /// You can switch the Audio Call to Video Call on requesting the Remote User
  /// If the remote User Accepts, Audio Call will be changed to Video Call.
  static Future<bool> requestVideoCallSwitch() async {
    return FlyChatFlutterPlatform.instance.requestVideoCallSwitch();
  }

  /// Cancels the video call switch operation.
  ///
  /// This method sends a request to the Mirrorfly platform to cancel the
  /// ongoing video call switch operation. It returns a Future that completes
  /// with the result of the operation.
  ///
  /// [cancelVideoCallSwitch] Used to Cancel the Video Call Request from Audio to Video Call
  /// You can use this cancelVideoCallSwitch to deny the request and also call this method When the Request Timeouts
  static Future<bool> cancelVideoCallSwitch() async {
    return FlyChatFlutterPlatform.instance.cancelVideoCallSwitch();
  }

  /// Accepts a request to switch to a video call during an ongoing voice call.
  ///
  /// Used to Accept the Video Call Request from Audio to Video Call
  ///
  /// This static method initiates the process of switching from a voice call to a video call
  /// in the Mirrorfly platform. It calls the underlying platform-specific method
  /// provided by [Mirrorfly] to handle the request.
  ///
  /// The method returns a [Future] that completes with the result of the operation.
  /// If the operation is successful, the future completes with the result from the platform-specific method.
  /// If an error occurs during the operation, the future completes with an error.
  ///
  static Future<bool> acceptVideoCallSwitchRequest() async {
    return FlyChatFlutterPlatform.instance.acceptVideoCallSwitchRequest();
  }

  /// Declines a request to switch from a voice call to video call from other Remote user in the call.
  ///
  /// This method sends a request to the Mirrorfly platform to decline a
  /// request to switch from a voice call to video call.
  ///
  /// Returns a [Future] that completes with the result of the operation.
  ///
  static Future<bool> declineVideoCallSwitchRequest() async {
    return FlyChatFlutterPlatform.instance.declineVideoCallSwitchRequest();
  }

  //// Retrieves the maximum number of users allowed in a call.
  ///
  /// This static method asynchronously calls the platform-specific implementation
  /// to obtain the maximum number of users allowed in a call.
  ///
  /// Returns a [Future] containing the maximum number of users allowed in a call,
  ///
  static Future<int?> getMaxCallUsersCount() async {
    return FlyChatFlutterPlatform.instance.getMaxCallUsersCount();
  }

  /// Invites users to an ongoing call.
  ///
  /// This static method sends an invitation to join an ongoing call to the users specified by their JIDs.
  /// The [jidList] parameter is a list of JIDs of the users to be invited.
  ///
  /// Returns:
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  static Future<void> inviteUsersToOngoingCall(
      {required List<String> jidList,
      required Function(FlyResponse response) flyCallback}) async {
    return FlyChatFlutterPlatform.instance
        .inviteUsersToOngoingCall(jidList, flyCallback);
  }

  /// Retrieves a list of invited users from the Mirrorfly platform asynchronously.
  ///
  /// This static method calls the underlying platform-specific implementation to
  /// retrieve the list of invited users asynchronously.
  ///
  /// Returns a [Future] that completes with a list of strings representing the
  /// invited users(JIDs) when the operation is successful.
  ///
  static Future<List<String>> getInvitedUsersList() async {
    return FlyChatFlutterPlatform.instance.getInvitedUsersList();
  }

  /// Marks all unread missed calls as read.
  ///
  /// This static method asynchronously marks all unread missed calls as read.
  /// It delegates the task to the platform-specific implementation provided by Mirrorfly.
  ///
  /// Returns a Future<bool?> indicating whether the operation was successful.
  /// If the operation succeeds, the future completes with `true`.
  /// If the operation fails or encounters an error, the future completes with `false`
  static Future<bool?> markAllUnreadMissedCallsAsRead() async {
    return FlyChatFlutterPlatform.instance.markAllUnreadMissedCallsAsRead();
  }

  /// Provides information about the availability of call conversion requests.
  ///
  /// This method asynchronously checks whether call conversion requests are available.
  ///
  /// Returns a [Future] that completes with a [bool] value indicating whether call
  /// conversion requests are available.
  ///
  static Future<bool?> isCallConversionRequestAvailable() async {
    return FlyChatFlutterPlatform.instance.isCallConversionRequestAvailable();
  }

  /// Synchronizes call logs with the Mirrorfly platform.
  ///
  /// This method asynchronously triggers the synchronization of call logs from server to local DB.
  /// with the Mirrorfly platform using the `syncCallLogs` method of the
  /// [Mirrorfly] instance.
  ///
  /// Returns a [Future] that completes with a [bool] value indicating whether
  /// the synchronization operation was successful.
  ///
  /// If the operation is successful, the returned value is `true`.
  /// If the operation fails or encounters an error, the returned value is `false`.
  ///
  static Future<bool?> syncCallLogs() async {
    return FlyChatFlutterPlatform.instance.syncCallLogs();
  }

  /// Sets the message event listener.
  ///
  /// Registers a listener for message events. This listener will be notified of various message-related events.
  ///
  /// Parameters:
  ///   [messageEventListeners] - The listener to be registered for message events.
  ///
  static setMessageEventListener(MessageEventListeners messageEventListeners) {
    return FlyChatFlutterPlatform.instance
        .setMessageEventListener(messageEventListeners);
  }

  /// Sets the connection event listener.
  ///
  /// Registers a listener for connection events. This listener will be notified of changes in the connection status,
  /// such as when the connection is established, lost, or when reconnection attempts are made.
  ///
  /// Parameters:
  ///   [connectionEventListeners] - The listener to be registered for connection events.
  static setConnectionEventListener(
      ConnectionEventListeners connectionEventListeners) {
    return FlyChatFlutterPlatform.instance
        .setConnectionEventListener(connectionEventListeners);
  }

  /// Sets the profile event listener.
  ///
  /// Registers a listener for profile events. This listener will be notified of changes to user profiles,
  /// such as profile updates.
  ///
  /// Parameters:
  ///   [profileEventListeners] - The listener to be registered for profile events.
  ///
  static setProfileEventListener(ProfileEventListeners profileEventListeners) {
    return FlyChatFlutterPlatform.instance
        .setProfileEventsListener(profileEventListeners);
  }

  /// Sets the group event listener.
  ///
  /// Registers a listener for group events. This listener will be notified of various group-related events.
  ///
  /// Parameters:
  ///   [groupEventListeners] - The listener to be registered for group events.
  ///
  static setGroupEventListener(GroupEventListeners groupEventListeners) {
    return FlyChatFlutterPlatform.instance
        .setGroupEventsListener(groupEventListeners);
  }

  /// Sets the call event listener.
  ///
  /// Registers a listener for call events. This listener will be notified of call-related events.
  ///
  /// Parameters:
  ///   [callEventListeners] - The listener to be registered for call events.
  static setCallEventListener(CallEventListeners callEventListeners) {
    return FlyChatFlutterPlatform.instance
        .setCallEventListener(callEventListeners);
  }

/* /// [changeCallType] Used to Change the Call Type
  /// audio for Switching to Audio Call
  /// video for Switching to Video Call
  static Future<dynamic> changeCallType({required String switchType}) async {
    return FlyChatFlutterPlatform.instance.changeCallType(switchType: switchType);
  }

  /// [reRouteAudio] Used to Re-Route the Audio Output in Call
  /// It will Re-Route the audio to available device
  static Future reRouteAudio() async {
    return FlyChatFlutterPlatform.instance.reRouteAudio();
  }*/

  /// Provides information about the metadata of logged in with metadata .
  ///
  /// This method fetches the [IdentifierMetaData] from the Mirrorfly platform.
  /// from current logged in user.
  static getMetaData({required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.getMetaData(flyCallback);
  }

  /// Provides information about the metadata of logged in with metadata .
  ///
  /// This method update the [IdentifierMetaData] from the Mirrorfly platform.
  /// to current logged in user
  static updateMetaData(
      {required List<IdentifierMetaData> identifierMetaDataList,
      Function(FlyResponse response)? flyCallback}) {
    return FlyChatFlutterPlatform.instance
        .updateMetaData(identifierMetaDataList, flyCallback);
  }

  /// This listener is set to listen the call link events.
  static void setCallLinkEventListener(
      CallLinkEventListeners callLinkEventsListener) {
    return FlyChatFlutterPlatform.instance
        .setCallLinkEventListener(callLinkEventsListener);
  }

  /// Creates a meeting link.
  ///
  /// This method initiates the creation of a meeting link. Upon completion,
  /// the provided callback function [flyCallback] is invoked with a [FlyResponse] object,
  /// which contains information about the success or failure of the operation.
  ///
  /// Returns:
  ///   [flyCallback] - A function that is called upon completion of the operation.
  static Future<void> createMeetLink(
      {required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.createMeetLink(flyCallback);
  }

  /// Retrieves the call link.
  ///
  /// This method fetches the call link that can be used to join a meeting.
  ///
  /// Returns:
  ///   A [Future<String>] that completes with the call link.
  static Future<String> getCallLink() {
    return FlyChatFlutterPlatform.instance.getCallLink();
  }

  /// Initializes a meeting with the specified call link and user name.
  ///
  /// This method sets up a meeting using the provided call link and user name. Upon completion,
  /// the provided callback function [flyCallback] is invoked with a [FlyResponse] object,
  /// which contains information about the success or failure of the operation.
  ///
  /// Parameters:
  ///   [callLinkId] - The call link id for the meeting.
  ///   [userName] - The user name to be used in the meeting.
  ///
  /// Returns:
  ///   [flyCallback] - A function that is called upon completion of the operation.
  static Future<void> initializeMeet(
      {required String callLinkId,
      required String userName,
      required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance
        .initializeMeet(callLinkId, userName, flyCallback);
  }

  /// Disposes of the meeting preview.
  ///
  /// This method cleans up resources used for the meeting preview. It should be called
  /// when the preview is no longer needed.
  ///
  /// Returns:
  ///   A [Future<void>] that completes when the operation is finished.
  static Future<void> disposePreview() {
    return FlyChatFlutterPlatform.instance.disposePreview();
  }

  /// Joins a call.
  ///
  /// This method initiates the process of joining a call. Upon completion,
  /// the provided callback function [flyCallback] is invoked with a [FlyResponse] object,
  /// which contains information about the success or failure of the operation.
  ///
  /// Returns:
  ///   [flyCallback] - A function that is called upon completion of the operation.
  static Future<void> joinCall(
      {required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.joinCall(flyCallback);
  }

  /// Start Video Capture in joined via link call.
  ///
  /// This method starts the video capture process for a call that has been joined via a link.
  /// It is useful for enabling video transmission after joining a call in audio-only mode or
  /// when video capture needs to be started at a specific point during the call.
  ///
  /// The method takes a callback function [flyCallback] as a parameter. This callback is invoked
  /// upon the completion of the operation, providing a [FlyResponse] object that contains
  /// information about the success or failure of the operation.
  ///
  /// Parameters:
  ///   [flyCallback] - A function that is called upon completion of the operation.
  /// Example usage:
  /// ```dart
  /// Mirrorfly.startVideoCapture(flyCallback: (response) {
  ///   if (response.isSuccess) {
  ///     print("Video capture started successfully");
  ///   } else {
  ///     print("Failed to start video capture: ${response.errorMessage}");
  ///   }
  /// });
  static Future<void> startVideoCapture(
      {required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.startVideoCapture(flyCallback);
  }

  /// Retrieves the meeting username for a given user JID.
  ///
  /// This method fetches the username used in meetings for the specified user JID.
  ///
  /// Parameters:
  ///   [userJid] - The JID (Jabber ID) of the user whose meeting username is to be retrieved.
  ///
  /// Returns:
  ///   A [Future<String>] that completes with the meeting username.
  static Future<String> getMeetUsername({required String userJid}) {
    return FlyChatFlutterPlatform.instance.getMeetUsername(userJid);
  }

  /// Stream that emits events when the call link subscribed success.
  static Stream<dynamic> get onSubscribeSuccess =>
      FlyChatFlutterPlatform.instance.onSubscribeSuccess;

  /// Stream that emits events when the call link subscribe error
  static Stream<dynamic> get onError => FlyChatFlutterPlatform.instance.onError;

  /// Stream that emits events when the call link users are updated
  static Stream<dynamic> get onUsersUpdated =>
      FlyChatFlutterPlatform.instance.onUsersUpdated;

  /// Validates a group JID (Jabber ID) for a group.
  ///
  /// This method checks if the provided [groupJid] is a valid group JID. A valid group JID must:
  /// - Contain the substring "@mix".
  /// - Contain exactly one '@' character.
  /// - Have a non-empty local part (the part before the '@').
  /// - Have a non-empty domain part (the part after the '@') that contains "mix".
  ///
  /// Parameters:
  ///   - [groupJid]: The group JID to be validated. This parameter is required.
  ///
  /// Returns:
  ///   - `true` if the [groupJid] is valid.
  ///   - `false` if the [groupJid] is invalid.
  ///
  /// The method logs debug messages using [LogMessage.d] to indicate the reason for invalidity.
  ///
  /// Example usage:
  /// ```dart
  /// bool isValid = isValidGroupJid('group@mix.example.com');
  /// if (isValid) {
  ///   print('The group JID is valid.');
  /// } else {
  ///   print('The group JID is invalid.');
  /// }
  /// ```
  static bool isValidGroupJid(String groupJid) {
    // Check if the JID contains "@mix" and follows basic JID validation
    if (groupJid.isNotEmpty && groupJid.contains("@mix")) {
      int atIndex = groupJid.indexOf('@');
      if (atIndex == -1) {
        LogMessage.d("isValidGroupJid",
            "Invalid Group JID: '$groupJid' does not contain a '@' character.");
        return false;
      } else if (groupJid.indexOf('@', atIndex + 1) != -1) {
        LogMessage.d("isValidGroupJid",
            "Invalid Group JID: '$groupJid' contains multiple '@' characters.");
        return false;
      }

      String localPart = groupJid.split('@')[0];
      if (localPart.isEmpty) {
        LogMessage.d("isValidGroupJid",
            "Invalid Group JID: '$groupJid' has an empty localPart.");
        return false;
      }

      String domainPart = groupJid.split('@')[1];
      if (domainPart.isEmpty || !domainPart.contains("mix")) {
        LogMessage.d("isValidGroupJid",
            "Invalid Group JID: '$groupJid' has an invalid domain part (does not contain 'mix').");
        return false;
      }

      return true;
    }

    LogMessage.d("isValidGroupJid",
        "Invalid Group JID: '$groupJid' is empty or does not contain '@mix'.");
    return false;
  }

  /// Validates a user JID (Jabber ID).
  ///
  /// This method checks if the provided [userJid] is a valid JID. A valid JID must:
  /// - Contain exactly one '@' character.
  /// - Have a non-empty local part (the part before the '@').
  /// - Have a non-empty domain part (the part after the '@').
  ///
  /// Parameters:
  ///   - [userJid]: The JID to be validated. This parameter is required.
  ///
  /// Returns:
  ///   - `true` if the [userJid] is valid.
  ///   - `false` if the [userJid] is invalid.
  ///
  /// The method logs debug messages using [LogMessage.d] to indicate the reason for invalidity.
  ///
  /// Example usage:
  /// ```dart
  /// bool isValid = isValidUserJid(userJid: 'user@example.com');
  /// if (isValid) {
  ///   print('The JID is valid.');
  /// } else {
  ///   print('The JID is invalid.');
  /// }
  /// ```
  static bool isValidUserJid({required String userJid}) {
    int atIndex = userJid.indexOf('@');
    if (atIndex == -1) {
      LogMessage.d("isValidUserJid",
          "Invalid JID: '$userJid' does not contain a '@' character.");
      return false;
    } else if (userJid.indexOf('@', atIndex + 1) != -1) {
      LogMessage.d("isValidUserJid",
          "Invalid JID: '$userJid' contains multiple '@' characters.");
      return false;
    }

    String localPart = userJid.split('@')[0];
    if (localPart.isEmpty) {
      LogMessage.d(
          "isValidUserJid", "Invalid JID: '$userJid' has an empty localPart.");
      return false;
    }

    String domainPart = userJid.split('@')[1];
    if (domainPart.isEmpty) {
      LogMessage.d(
          "isValidUserJid", "Invalid JID: '$userJid' has an empty domainPart.");
      return false;
    }
    return true;
  }

  /// Checks if the device is locked.
  ///
  /// This method interacts with the platform-specific `FlyChatFlutterPlatform`
  /// instance to determine whether the lock screen feature is active.
  ///
  /// Returns:
  ///   A [Future] that completes with a [bool] value:
  ///   - `true` if the screen is locked,
  ///   - `false` otherwise.
  ///
  static Future<bool> isLockScreen() {
    return FlyChatFlutterPlatform.instance.isLockScreen();
  }
}
