import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mirrorfly_plugin/mirrorfly.dart';

import 'event_handlers.dart';
import 'fly_chat_platform_interface.dart';

class Mirrorfly {
  Mirrorfly._();
  @Deprecated(
      'This method is deprecated. Please refrain from using it, as the functionality has been internally managed within the plugin')
  static var isTrialLicence = true;
  static var isChatHistoryEnabled = false;

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
  ///   - [licenseKey]: The license key used for SDK initialization. Must not be null.
  ///   - [iOSContainerID]: The iOSContainerID represents App Group ID for iOS app sharing data between app extensions and containing apps. Must not be null for iOS.
  ///   - [storageFolderName]: The name of the storage folder to be used by the SDK. Defaults to "Mirrorfly".
  ///   - [chatHistoryEnable]: Flag indicating whether chat history should be enabled. Defaults to false.
  ///   - [enableMobileNumberLogin]: Flag indicating whether mobile number login should be enabled. Defaults to true.
  ///   - [enableDebugLog]: Flag indicating whether debug logs should be enabled. Defaults to false.
  ///   - [flyCallback]: A callback function to handle the response from the SDK initialization. Must not be null.
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
      required Function(FlyResponse response) flyCallback}) {
    var builder = InitializeSDKBuilder(
        iOSContainerID: iOSContainerID,
        licenseKey: licenseKey,
        storageFolderName: storageFolderName,
        chatHistoryEnable: chatHistoryEnable,
        enableMobileNumberLogin: enableMobileNumberLogin,
        enableDebugLog: enableDebugLog);
    isChatHistoryEnabled = chatHistoryEnable;
    return FlyChatFlutterPlatform.instance.initializeSDK(builder, flyCallback);
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
      {required bool isFirstTime, required Function(FlyResponse response) flyCallBack}) async {
    return FlyChatFlutterPlatform.instance.syncContacts(isFirstTime, flyCallBack);
  }

  static Future<bool> contactSyncStateValue() {
    return FlyChatFlutterPlatform.instance.contactSyncStateValue();
  }

  /*static Future<dynamic> contactSyncState() {
    return FlyChatFlutterPlatform.instance.contactSyncState();
  }*/

  static Future<void> revokeContactSync({required Function(FlyResponse response) flyCallBack}) {
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
      {bool fetchFromServer = false, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.getUsersWhoBlockedMe(fetchFromServer, flyCallBack);
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
      {required String busyStatus, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.setMyBusyStatus(busyStatus, flyCallBack);
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
      {required bool enable, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.enableDisableBusyStatus(enable, flyCallBack);
  }

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
      {required bool enable, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.setLastSeenVisibility(enable, flyCallBack);
  }

  /// Checks whether the busy status feature is enabled in the Mirrorfly chat platform.
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
  static Future<bool> isBusyStatusEnabled() {
    return FlyChatFlutterPlatform.instance.isBusyStatusEnabled();
  }

  static Future<bool?> deleteProfileStatus(
      {required String id, required String status, required bool isCurrentStatus}) {
    return FlyChatFlutterPlatform.instance.deleteProfileStatus(id, status, isCurrentStatus);
  }

  static Future<bool?> deleteBusyStatus({required String id, required String status, required bool isCurrentStatus}) {
    return FlyChatFlutterPlatform.instance.deleteBusyStatus(id, status, isCurrentStatus);
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
  static Future<void> unFavouriteAllFavouriteMessages({required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.unFavouriteAllFavouriteMessages(flyCallBack);
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
  static Future<bool?> deleteUnreadMessageSeparatorOfAConversation({required String jid}) {
    return FlyChatFlutterPlatform.instance.deleteUnreadMessageSeparatorOfAConversation(jid);
  }

  /*static Future<int?> getMembersCountOfGroup({required String groupJid}) {
    return FlyChatFlutterPlatform.instance.getMembersCountOfGroup(groupJid);
  }*/

  /*static Future<bool?> doesFetchingMembersListFromServedRequired({required String groupJid}) {
    return FlyChatFlutterPlatform.instance.doesFetchingMembersListFromServedRequired(groupJid);
  }*/

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
  static sendTypingGoneStatus({required String toJid, required String chatType}) {
    return FlyChatFlutterPlatform.instance.sendTypingGoneStatus(toJid, chatType);
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
    return FlyChatFlutterPlatform.instance.updateChatMuteStatus(jid, muteStatus);
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
  static updateRecentChatPinStatus({required String jid, required bool pinStatus}) {
    return FlyChatFlutterPlatform.instance.updateRecentChatPinStatus(jid, pinStatus);
  }

  @Deprecated('Instead of use Mirrorfly.deleteRecentChats()')
  static deleteRecentChat(String jid) {
    return FlyChatFlutterPlatform.instance.deleteRecentChat(jid, null);
  }

  /*static setTypingStatusListener() {
    return FlyChatFlutterPlatform.instance.setTypingStatusListener();
  }*/

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
      {required List<String> jidList, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.deleteRecentChats(jidList, flyCallBack);
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
  static Future<void> clearAllConversation({required Function(FlyResponse response) flyCallBack}) {
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
      {required String firebaseToken, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.updateFcmToken(firebaseToken, flyCallBack);
  }

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
      {required Map notificationData, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.handleReceivedMessage(notificationData, flyCallBack);
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
      {required bool enable, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.enableDisableArchivedSettings(enable, flyCallBack);
  }

  @Deprecated('Instead of use Mirrorfly.setChatArchived()')
  static Future<bool?> updateArchiveUnArchiveChat(String jid, bool isArchived) async {
    return FlyChatFlutterPlatform.instance.updateArchiveUnArchiveChat(jid, isArchived);
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
      {required String jid, required bool isArchived, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.setChatArchived(jid, isArchived, flyCallBack);
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
    return FlyChatFlutterPlatform.instance.getUnreadMessageCountExceptMutedChat();
  }

  @Deprecated('Instead of use Mirrorfly.getRecentChatPinnedCount()')
  static Future<int?> recentChatPinnedCount() {
    return FlyChatFlutterPlatform.instance.recentChatPinnedCount();
  }

  // Retrieves the count of recent chats that are pinned.
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
  static Future<void> getArchivedChatList({required Function(FlyResponse response) flyCallBack}) {
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
  /*static Future<String?> getGroupProfile({required String groupJid, bool fetchFromServer = false}) {
    return FlyChatFlutterPlatform.instance.getGroupProfile(groupJid, fetchFromServer);
  }*/

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
    return FlyChatFlutterPlatform.instance.cancelMediaUploadOrDownload(messageId);
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
  ///       DateTime lastSeen = DateTime.fromMillisecondsSinceEpoch(int.parse(seconds), isUtc: true);
  ///       print('Last seen time: $lastSeen');
  ///     } else {
  ///       print('Last seen time is not available.');
  ///     }
  ///   }
  /// });
  /// ```
  static Future<void> getUserLastSeenTime({required String jid, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.getUserLastSeenTime(jid, flyCallBack);
  }

  @Deprecated('Instead of use refreshAndGetAuthToken')

  /// This [authToken] is used to get refreshed Auth Token.
  static Future<String?> authToken() {
    return FlyChatFlutterPlatform.instance.authToken();
  }

  @Deprecated('Instead of use Mirrorfly.login()')
  static Future<void> registerUser(
      {required String userIdentifier,
      String fcmToken = "",
      bool isForceRegister = true,
      required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance
        .registerUser(userIdentifier, fcmToken: fcmToken, isForceRegister: isForceRegister, callback: flyCallback);
  }

  /// Provides functionality to log in a user to the Mirrorfly platform.
  ///
  /// This static method initiates the login process for a user with the specified [userIdentifier] to the Mirrorfly platform.
  /// Optionally, you can provide the [fcmToken] for Firebase Cloud Messaging (FCM) integration,
  /// and specify whether to forcefully register the user if not already registered with [isForceRegister].
  ///
  /// The [flyCallback] function is called upon completion of the login operation,
  /// providing a [FlyResponse] object containing information about the operation's success or failure.
  ///
  /// Throws an error if the [userIdentifier] is not provided.
  ///
  /// Example usage:
  /// ```dart
  ///   await Mirrorfly.login(
  ///     userIdentifier: 'example_user_id',
  ///     fcmToken: 'example_fcm_token',
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
      bool isForceRegister = true,
      required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance
        .registerUser(userIdentifier, fcmToken: fcmToken, isForceRegister: isForceRegister, callback: flyCallback);
  }

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

  @Deprecated('Instead of use Mirrorfly.sendMessage(messageParams: MessageParams.text())')
  static Future<String> sendTextMessage(String message, String jid, String replyMessageId, {String? topicId}) {
    return FlyChatFlutterPlatform.instance.sendTextMessage(message, jid, replyMessageId, topicId: topicId);
  }

  @Deprecated('Instead of use Mirrorfly.sendMessage(messageParams: MessageParams.location())')
  static Future<String> sendLocationMessage(String jid, double latitude, double longitude, String replyMessageId,
      {String? topicId}) {
    return FlyChatFlutterPlatform.instance
        .sendLocationMessage(jid, latitude, longitude, replyMessageId, topicId: topicId);
  }

  @Deprecated('Instead of use Mirrorfly.sendMessage(messageParams: MessageParams.image())')
  static Future<String> sendImageMessage(String jid, String filePath, String? caption, String? replyMessageID,
      {String? imageFileUrl, String? topicId}) {
    return FlyChatFlutterPlatform.instance
        .sendImageMessage(jid, filePath, caption, replyMessageID, imageFileUrl: imageFileUrl, topicId: topicId);
  }

  @Deprecated('Instead of use Mirrorfly.sendMessage(messageParams: MessageParams.video())')
  static Future<String> sendVideoMessage(String jid, String filePath, String? caption, String? replyMessageID,
      {String? videoFileUrl, num? videoDuration, String? thumbImageBase64, String? topicId}) {
    return FlyChatFlutterPlatform.instance.sendVideoMessage(jid, filePath, caption, replyMessageID,
        videoFileUrl: videoFileUrl, videoDuration: videoDuration, thumbImageBase64: thumbImageBase64, topicId: topicId);
  }

  @Deprecated('Instead of use Mirrorfly.sendMessage(messageParams: MessageParams.document())')
  static Future<String> sendDocumentMessage(String jid, String documentPath, String replyMessageId,
      {String? fileUrl, String? topicId}) {
    return FlyChatFlutterPlatform.instance
        .sendDocumentMessage(jid, documentPath, replyMessageId, fileUrl: fileUrl, topicId: topicId);
  }

  @Deprecated('Instead of use Mirrorfly.sendMessage(messageParams: MessageParams.audio())')
  static Future<String> sendAudioMessage(
      String jid, String filePath, bool isRecorded, String duration, String replyMessageId,
      {String? audioFileUrl, String? topicId}) {
    return FlyChatFlutterPlatform.instance.sendAudioMessage(jid, filePath, isRecorded, duration, replyMessageId,
        audioFileUrl: audioFileUrl, topicId: topicId);
  }

  @Deprecated('Instead of use Mirrorfly.sendMessage(messageParams: MessageParams.contact())')
  static Future<String> sendContactMessage(
      List<String> contactList, String jid, String contactName, String replyMessageId,
      {String? topicId}) {
    return FlyChatFlutterPlatform.instance
        .sendContactMessage(contactList, jid, contactName, replyMessageId, topicId: topicId);
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
      {required MessageParams messageParams, required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.sendMessage(messageParams: messageParams, callback: flyCallback);
  }

  @Deprecated('Instead of use Mirrorfly.getRegisteredUsers()')
  static Future<String?> getRegisteredUserList({required bool fetchFromServer}) {
    return FlyChatFlutterPlatform.instance.getRegisteredUserList(server: fetchFromServer);
  }

  /// Retrieves a list of users from the Mirrorfly platform.
  ///
  /// Retrieves a paginated list of users based on the specified [page] number and optional search [query].
  /// The [page] parameter specifies the page number to retrieve.
  /// The optional [search] parameter allows filtering users based on a search query.
  /// The [perPageResultSize] parameter specifies the number of users to retrieve per page (default is 20).
  /// The [flyCallback] parameter is a callback function that handles the response from the platform.
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
      required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.getUserList(page, search, flyCallback, perPageResultSize: perPageResultSize);
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
  static Future<void> getCallLogsList({required int currentPage, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.getCallLogsList(currentPage, flyCallBack);
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
      {required List<String> jidList, required bool isClearAll, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.deleteCallLog(jidList, isClearAll, flyCallBack);
  }

  static Stream<dynamic> get onMessageReceived => FlyChatFlutterPlatform.instance.onMessageReceived;

  static Stream<dynamic> get onMessageStatusUpdated => FlyChatFlutterPlatform.instance.onMessageStatusUpdated;

  static Stream<dynamic> get onMediaStatusUpdated => FlyChatFlutterPlatform.instance.onMediaStatusUpdated;

  static Stream<dynamic> get onUploadDownloadProgressChanged =>
      FlyChatFlutterPlatform.instance.onUploadDownloadProgressChanged;

  static Stream<dynamic> get onGroupProfileFetched => FlyChatFlutterPlatform.instance.onGroupProfileFetched;

  static Stream<dynamic> get onNewGroupCreated => FlyChatFlutterPlatform.instance.onNewGroupCreated;

  static Stream<dynamic> get onGroupProfileUpdated => FlyChatFlutterPlatform.instance.onGroupProfileUpdated;

  static Stream<dynamic> get onNewMemberAddedToGroup => FlyChatFlutterPlatform.instance.onNewMemberAddedToGroup;

  static Stream<dynamic> get onMemberRemovedFromGroup => FlyChatFlutterPlatform.instance.onMemberRemovedFromGroup;

  static Stream<dynamic> get onFetchingGroupMembersCompleted =>
      FlyChatFlutterPlatform.instance.onFetchingGroupMembersCompleted;

  // static Stream<dynamic> get onDeleteGroup => FlyChatFlutterPlatform.instance.onDeleteGroup;
  //
  // static Stream<dynamic> get onFetchingGroupListCompleted =>
  //     FlyChatFlutterPlatform.instance.onFetchingGroupListCompleted;

  static Stream<dynamic> get onMemberMadeAsAdmin => FlyChatFlutterPlatform.instance.onMemberMadeAsAdmin;

  static Stream<dynamic> get onMemberRemovedAsAdmin => FlyChatFlutterPlatform.instance.onMemberRemovedAsAdmin;

  static Stream<dynamic> get onLeftFromGroup => FlyChatFlutterPlatform.instance.onLeftFromGroup;

  static Stream<dynamic> get onGroupNotificationMessage => FlyChatFlutterPlatform.instance.onGroupNotificationMessage;

  static Stream<dynamic> get showOrUpdateOrCancelNotification =>
      FlyChatFlutterPlatform.instance.showOrUpdateOrCancelNotification;

  static Stream<dynamic> get onGroupDeletedLocally => FlyChatFlutterPlatform.instance.onGroupDeletedLocally;

  static Stream<dynamic> get blockedThisUser => FlyChatFlutterPlatform.instance.blockedThisUser;

  static Stream<dynamic> get myProfileUpdated => FlyChatFlutterPlatform.instance.myProfileUpdated;

  static Stream<dynamic> get onAdminBlockedOtherUser => FlyChatFlutterPlatform.instance.onAdminBlockedOtherUser;

  static Stream<dynamic> get onAdminBlockedUser => FlyChatFlutterPlatform.instance.onAdminBlockedUser;

  static Stream<dynamic> get onContactSyncComplete => FlyChatFlutterPlatform.instance.onContactSyncComplete;

  static Stream<dynamic> get onLoggedOut => FlyChatFlutterPlatform.instance.onLoggedOut;

  static Stream<dynamic> get unblockedThisUser => FlyChatFlutterPlatform.instance.unblockedThisUser;

  static Stream<dynamic> get userBlockedMe => FlyChatFlutterPlatform.instance.userBlockedMe;

  static Stream<dynamic> get userCameOnline => FlyChatFlutterPlatform.instance.userCameOnline;

  static Stream<dynamic> get userDeletedHisProfile => FlyChatFlutterPlatform.instance.userDeletedHisProfile;

  static Stream<dynamic> get usersProfilesFetched => FlyChatFlutterPlatform.instance.usersProfilesFetched;

  static Stream<dynamic> get userProfileFetched => FlyChatFlutterPlatform.instance.userProfileFetched;

  static Stream<dynamic> get userUnBlockedMe => FlyChatFlutterPlatform.instance.userUnBlockedMe;

  static Stream<dynamic> get userUpdatedHisProfile => FlyChatFlutterPlatform.instance.userUpdatedHisProfile;

  static Stream<dynamic> get userWentOffline => FlyChatFlutterPlatform.instance.userWentOffline;

  static Stream<dynamic> get usersIBlockedListFetched => FlyChatFlutterPlatform.instance.usersIBlockedListFetched;

  static Stream<dynamic> get usersWhoBlockedMeListFetched =>
      FlyChatFlutterPlatform.instance.usersWhoBlockedMeListFetched;

  static Stream<dynamic> get onConnected => FlyChatFlutterPlatform.instance.onConnected;

  static Stream<dynamic> get onDisconnected => FlyChatFlutterPlatform.instance.onDisconnected;

  /*static Stream<dynamic> get onConnectionNotAuthorized =>
      FlyChatFlutterPlatform.instance.onConnectionNotAuthorized;*/

  static Stream<dynamic> get onConnectionFailed => FlyChatFlutterPlatform.instance.onConnectionFailed;

  // static Stream<dynamic> get connectionFailed => FlyChatFlutterPlatform.instance.connectionFailed;

  // static Stream<dynamic> get connectionSuccess => FlyChatFlutterPlatform.instance.connectionSuccess;

  static Stream<dynamic> get onWebChatPasswordChanged => FlyChatFlutterPlatform.instance.onWebChatPasswordChanged;

  @Deprecated('Instead of use Mirrorfly.typingStatus')
  static Stream<dynamic> get setTypingStatus => FlyChatFlutterPlatform.instance.setTypingStatus;

  static Stream<dynamic> get typingStatus => FlyChatFlutterPlatform.instance.setTypingStatus;

  @Deprecated('Instead of use Mirrorfly.typingStatus')
  static Stream<dynamic> get onChatTypingStatus => FlyChatFlutterPlatform.instance.onChatTypingStatus;
  @Deprecated('Instead of use Mirrorfly.typingStatus')
  static Stream<dynamic> get onGroupTypingStatus => FlyChatFlutterPlatform.instance.onGroupTypingStatus;

  // static Stream<dynamic> get onFailure => FlyChatFlutterPlatform.instance.onFailure;

  // static Stream<dynamic> get onProgressChanged => FlyChatFlutterPlatform.instance.onProgressChanged;
  //
  // static Stream<dynamic> get onSuccess => FlyChatFlutterPlatform.instance.onSuccess;

  // static Stream<dynamic> get onCallReceiving =>
  //     FlyChatFlutterPlatform.instance.onCallReceiving;

  static Stream<dynamic> get onLocalVideoTrackAdded => FlyChatFlutterPlatform.instance.onLocalVideoTrackAdded;

  static Stream<dynamic> get onRemoteVideoTrackAdded => FlyChatFlutterPlatform.instance.onRemoteVideoTrackAdded;

  static Stream<dynamic> get onTrackAdded => FlyChatFlutterPlatform.instance.onTrackAdded;

  static Stream<dynamic> get onCallStatusUpdated => FlyChatFlutterPlatform.instance.onCallStatusUpdated;

  static Stream<dynamic> get onCallAction => FlyChatFlutterPlatform.instance.onCallAction;

  static Stream<dynamic> get onMuteStatusUpdated => FlyChatFlutterPlatform.instance.onMuteStatusUpdated;

  static Stream<dynamic> get onUserSpeaking => FlyChatFlutterPlatform.instance.onUserSpeaking;

  static Stream<dynamic> get onUserStoppedSpeaking => FlyChatFlutterPlatform.instance.onUserStoppedSpeaking;

  static Stream<dynamic> get onMissedCall => FlyChatFlutterPlatform.instance.onMissedCall;

  static Stream<dynamic> get onAvailableFeaturesUpdated => FlyChatFlutterPlatform.instance.onAvailableFeaturesUpdated;

  static Stream<dynamic> get onCallLogsUpdated => FlyChatFlutterPlatform.instance.onCallLogsUpdated;

  static Stream<dynamic> get onCallLogDeleted => FlyChatFlutterPlatform.instance.onCallLogDeleted;

  static Stream<dynamic> get onCallLogsCleared => FlyChatFlutterPlatform.instance.onClearAllCallLog;

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
  static Future<void> getRecentChatList({required Function(FlyResponse response) flyCallBack}) {
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
      {required bool firstSet, int limit = 15, required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance
        .getRecentChatListHistory(firstSet: firstSet, limit: limit, callback: flyCallback);
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
      int limit = 25}) {
    return FlyChatFlutterPlatform.instance.initializeMessageList(
        userJid: userJid,
        messageId: messageId,
        messageTime: messageTime,
        exclude: exclude,
        ascendingOrder: ascendingOrder,
        topicId: topicId,
        limit: limit);
  }

  /// This [loadMessages] is used to Fetch initial conversations between you and a single chat user or group.
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  /// This method should be called only after the initializeMessageList Method.
  static Future<void> loadMessages({required Function(FlyResponse response) flyCallback}) {
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
  static Future<void> loadPreviousMessages({required Function(FlyResponse response) flyCallback}) {
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
  static Future<void> loadNextMessages({required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.loadNextMessages(flyCallback);
  }

  static Future<String?> getProfileStatusList() {
    return FlyChatFlutterPlatform.instance.getProfileStatusList();
  }

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
    return FlyChatFlutterPlatform.instance.updateMyProfile(name, email, mobile, status, image, flyCallback);
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
    return FlyChatFlutterPlatform.instance.getUserProfile(jid, flyCallback, fetchFromServer, saveAsFriend);
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

  static Future<void> setMyProfileStatus(
      {required String status, required String statusId, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.setMyProfileStatus(status, statusId, flyCallBack);
  }

  static Future<bool?> insertNewProfileStatus({required String status}) {
    return FlyChatFlutterPlatform.instance.insertNewProfileStatus(status);
  }

  static Future<void> updateMyProfileImage(
      {required String image, required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.updateMyProfileImage(image, flyCallback);
  }

  static Future<void> removeProfileImage({required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.removeProfileImage(flyCallBack);
  }

  static Future<void> removeGroupProfileImage(
      {required String jid, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.removeGroupProfileImage(jid, flyCallBack);
  }

  /// This [refreshAndGetAuthToken] is used to get refreshed Auth Token.
  /// The [flyCallBack] parameter is a function that will be called upon completion of the operation.
  /// It receives a [FlyResponse] object as a parameter, which contains information about the success or failure of the operation.
  ///
  static Future<void> refreshAndGetAuthToken({required Function(FlyResponse response) flyCallBack}) {
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

  static Future<bool?> markAsReadDeleteUnreadSeparator({required String jid}) {
    return FlyChatFlutterPlatform.instance.markAsReadDeleteUnreadSeparator(jid);
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
  static Future<void> logoutOfChatSDK({required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.logoutOfChatSDK(flyCallBack);
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

  static Future<String> getRecentChatListIncludingArchived() {
    return FlyChatFlutterPlatform.instance.getRecentChatListIncludingArchived();
  }

  static Future<void> searchConversation(
      {required String searchKey,
      String? jidForSearch,
      bool globalSearch = true,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.searchConversation(searchKey, jidForSearch, globalSearch, flyCallBack);
  }

  static Future<void> getRegisteredUsers(
      {required bool fetchFromServer, required Function(FlyResponse response) flyCallback}) {
    return FlyChatFlutterPlatform.instance.getRegisteredUsers(fetchFromServer, flyCallback);
  }

  static Future<String?> getMessageOfId({required String messageId}) {
    return FlyChatFlutterPlatform.instance.getMessageOfId(messageId);
  }

  static Future<String> getRecentChatOf({required String jid}) {
    return FlyChatFlutterPlatform.instance.getRecentChatOf(jid);
  }

  static Future<void> clearChat(
      {required String jid,
      required String chatType,
      required bool clearExceptStarred,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.clearChat(jid, chatType, clearExceptStarred, flyCallBack);
  }

  /*static Future<dynamic> reportChatOrUser({required String jid, required String chatType, String? messageId}) {
    return FlyChatFlutterPlatform.instance.reportChatOrUser(jid, chatType, messageId);
  }*/

  static Future<String?> getMessagesUsingIds({required List<String> messageIds}) {
    return FlyChatFlutterPlatform.instance.getMessagesUsingIds(messageIds);
  }

  static Future<void> deleteMessagesForMe(
      {required String jid,
      required String chatType,
      required List<String> messageIds,
      bool? isMediaDelete,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.deleteMessagesForMe(jid, chatType, messageIds, isMediaDelete, flyCallBack);
  }

  static Future<void> deleteMessagesForEveryone(
      {required String jid,
      required String chatType,
      required List<String> messageIds,
      bool? isMediaDelete,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .deleteMessagesForEveryone(jid, chatType, messageIds, isMediaDelete, flyCallBack);
  }

  /*static Future<dynamic> deleteMessages(
      {required String jid, required List<String> messageIds, required bool isDeleteForEveryOne}) {
    return FlyChatFlutterPlatform.instance.deleteMessages(jid, messageIds, isDeleteForEveryOne);
  }*/

  @Deprecated('Instead of use Mirrorfly.getGroupMessageDeliveredRecipients()')
  static Future<String> getGroupMessageDeliveredToList(String messageId, String jid) async {
    return FlyChatFlutterPlatform.instance.getGroupMessageDeliveredToList(messageId, jid);
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
      {required String messageId, required String groupJid, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.getGroupMessageDeliveredRecipients(messageId, groupJid, flyCallBack);
  }

  @Deprecated('Instead of use Mirrorfly.getGroupMessageSeenRecipients()')
  static Future<String> getGroupMessageReadByList(String messageId, String jid) async {
    return FlyChatFlutterPlatform.instance.getGroupMessageReadByList(messageId, jid);
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
      {required String messageId, required String groupJid, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.getGroupMessageSeenRecipients(messageId, groupJid, flyCallBack);
  }

  @Deprecated('Instead of use Mirrorfly.getMessageStatusOf()')
  static Future<String> getMessageStatusOfASingleChatMessage(String messageID) {
    return FlyChatFlutterPlatform.instance.getMessageStatusOfASingleChatMessage(messageID);
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
    return FlyChatFlutterPlatform.instance.getMessageStatusOfASingleChatMessage(messageId);
  }

  static Future<void> blockUser({required String userJid, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.blockUser(userJid, flyCallBack);
  }

  static Future<void> unblockUser({required String userJid, required Function(FlyResponse response) flyCallBack}) {
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

  static Future<void> updateFavouriteStatus(
      {required String messageId,
      required String chatUserJid,
      required bool isFavourite,
      required String chatType,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance
        .updateFavouriteStatus(messageId, chatUserJid, isFavourite, chatType, flyCallBack);
  }

  static Future<void> forwardMessagesToMultipleUsers(
      {required List<String> messageIds,
      required List<String> userList,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.forwardMessagesToMultipleUsers(messageIds, userList, flyCallBack);
  }

  /*static Future<dynamic> forwardMessages(List<String> messageIds, String tojid, String chattype) {
    return FlyChatFlutterPlatform.instance.forwardMessages(messageIds, tojid, chattype);
  }*/

  static Future<void> createGroup(
      {required String groupName,
      required List<String> userList,
      required String image,
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.createGroup(groupName, userList, image, flyCallBack);
  }

  static Future<void> addUsersToGroup(
      {required String jid, required List<String> userList, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.addUsersToGroup(jid, userList, flyCallBack);
  }

  static Future<void> getGroupMembersList(
      {required String jid, bool? fetchFromServer, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.getGroupMembersList(jid, fetchFromServer, flyCallBack);
  }

  static Future<void> getUsersIBlocked(
      {bool fetchFromServer = false, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.getUsersIBlocked(fetchFromServer, flyCallBack);
  }

  static Future<String?> getMediaMessages({required String jid}) {
    return FlyChatFlutterPlatform.instance.getMediaMessages(jid);
  }

  static Future<String?> getDocsMessages({required String jid}) {
    return FlyChatFlutterPlatform.instance.getDocsMessages(jid);
  }

  static Future<String?> getLinkMessages({required String jid}) {
    return FlyChatFlutterPlatform.instance.getLinkMessages(jid);
  }

  static Future<void> exportChatConversationToEmail(
      {required String jid, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.exportChatConversationToEmail(jid, flyCallBack);
  }

  static Future<void> reportUserOrMessages(
      {required String jid,
      required String type,
      String messageId = "",
      required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.reportUserOrMessages(jid, type, messageId, flyCallBack);
  }

  static Future<void> makeAdmin(
      {required String groupJid, required String userJid, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.makeAdmin(groupJid, userJid, flyCallBack);
  }

  static Future<void> removeMemberFromGroup(
      {required String groupJid, required String userJid, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.removeMemberFromGroup(groupJid, userJid, flyCallBack);
  }

  static Future<void> leaveFromGroup(
      {required String userJid, required String groupJid, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.leaveFromGroup(userJid, groupJid, flyCallBack);
  }

  static Future<void> deleteGroup({required String jid, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.deleteGroup(jid, flyCallBack);
  }

  @Deprecated('Instead of use Mirrorfly.isGroupAdmin()')
  static Future<bool?> isAdmin(String userJid, String groupJID) {
    return FlyChatFlutterPlatform.instance.isAdmin(userJid, groupJID);
  }

  static Future<bool?> isGroupAdmin({required String userJid, required String groupJid}) {
    return FlyChatFlutterPlatform.instance.isAdmin(userJid, groupJid);
  }

  static Future<void> updateGroupProfileImage(
      {required String jid, required String file, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.updateGroupProfileImage(jid, file, flyCallBack);
  }

  static Future<void> updateGroupName(
      {required String jid, required String name, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.updateGroupName(jid, name, flyCallBack);
  }

  static Future<bool?> isMemberOfGroup({required String userJid, required String groupJid}) {
    return FlyChatFlutterPlatform.instance.isMemberOfGroup(groupJid, userJid);
  }

  static Future<void> sendContactUsInfo(
      {required String title, required String description, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.sendContactUsInfo(title, description, flyCallBack);
  }

  /*static copyTextMessages({required List<String> messageIds}) {
    return FlyChatFlutterPlatform.instance.copyTextMessages(messageIds);
  }*/

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
      {required String reason, String? feedback, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.deleteAccount(reason, feedback, flyCallBack);
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
      {bool fetchFromServer = false, required Function(FlyResponse response) flyCallBack}) {
    return FlyChatFlutterPlatform.instance.getAllGroups(fetchFromServer, flyCallBack);
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
    return FlyChatFlutterPlatform.instance.saveMediaSettings(photos, videos, audios, documents, networkType);
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
  static Future<bool?> getMediaSetting({required int networkType, required String type}) async {
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

  static Future<String?> getJidFromPhoneNumber({required String mobileNumber, required String countryCode}) async {
    return FlyChatFlutterPlatform.instance.getJidFromPhoneNumber(mobileNumber, countryCode);
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

  @Deprecated(
      'This method is deprecated. Please refrain from using it, as the functionality has been internally managed within the plugin')
  static Future<bool?> isTrailLicence() async {
    return FlyChatFlutterPlatform.instance.isTrailLicence();
  }

  /*static Future<String?> getNonChatUsers() async {
    return FlyChatFlutterPlatform.instance.getNonChatUsers();
  }*/

  static Future<bool?> addContact({required String number, required String name}) async {
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
  static Future<String> getValueFromManifestOrInfoPlist({String? androidManifestKey, String? iOSPlistKey}) async {
    return FlyChatFlutterPlatform.instance
        .getValueFromManifestOrInfoPlist(androidManifestKey: androidManifestKey, iOSPlistKey: iOSPlistKey);
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
    return FlyChatFlutterPlatform.instance.createTopic(topicName: topicName, metaData: metaData, callback: flyCallBack);
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
      {required List<String> topicIds, required Function(FlyResponse response) flyCallBack}) async {
    return FlyChatFlutterPlatform.instance.getTopics(topicIds: topicIds, callback: flyCallBack);
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
    return FlyChatFlutterPlatform.instance
        .getRecentChatListHistoryByTopic(topicId: topicId, firstSet: firstSet, limit: limit, callback: flyCallback);
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
      {required String toUserJid, required Function(FlyResponse response) flyCallBack}) async {
    return FlyChatFlutterPlatform.instance.makeVideoCall(toUserJid, flyCallBack);
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
      {required String toUserJid, required Function(FlyResponse response) flyCallBack}) async {
    return FlyChatFlutterPlatform.instance.makeVoiceCall(toUserJid, flyCallBack);
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
    return FlyChatFlutterPlatform.instance.makeGroupVoiceCall(groupJid, toUserJidList, flyCallBack);
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
    return FlyChatFlutterPlatform.instance.makeGroupVideoCall(groupJid, toUserJidList, flyCallBack);
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
  static Future<void> muteAudio({required bool status, required Function(FlyResponse response) flyCallBack}) async {
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
  static Future<void> muteVideo({required bool status, required Function(FlyResponse response) flyCallBack}) async {
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
  static Future<void> disconnectCall({required Function(FlyResponse response) flyCallBack}) async {
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

  /// Opens the audio file picker to select an audio file for [Platform.isAndroid].
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
  /// Returns a Future that completes with the result of the invitation operation.
  ///
  static Future inviteUsersToOngoingCall({List<String> jidList = const []}) async {
    return FlyChatFlutterPlatform.instance.inviteUsersToOngoingCall(jidList);
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

  static setMessageEventListener(MessageEventListeners messageEventListeners) {
    return FlyChatFlutterPlatform.instance.setMessageEventListener(messageEventListeners);
  }
  static setConnectionEventListener(ConnectionEventListeners connectionEventListeners) {
    return FlyChatFlutterPlatform.instance.setConnectionEventListener(connectionEventListeners);
  }
  static setProfileEventListener(ProfileEventListeners profileEventListeners) {
    return FlyChatFlutterPlatform.instance.setProfileEventsListener(profileEventListeners);
  }
  static setGroupEventListener(GroupEventListeners groupEventListeners) {
    return FlyChatFlutterPlatform.instance.setGroupEventsListener(groupEventListeners);
  }
  static setCallEventListener(CallEventListeners callEventListeners) {
    return FlyChatFlutterPlatform.instance.setCallEventListener(callEventListeners);
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
}
