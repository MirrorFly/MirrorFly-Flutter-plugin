import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'builder.dart';
import 'edit_message_params.dart';
import 'event_handlers.dart';
import 'fly_chat_platform_interface.dart';
import 'fly_constants.dart';
import 'internal_models/audio_devices_model.dart';
import 'internal_models/available_features_model.dart';
import 'internal_models/call_logs_model.dart';
import 'internal_models/chat_message_status_detail.dart';
import 'internal_models/chat_messages_model.dart';
import 'internal_models/export_chat_model.dart';
import 'internal_models/get_user_profile_model.dart';
import 'internal_models/internal_status_model.dart';
import 'internal_models/message_delivered_status_model.dart';
import 'internal_models/profile_detail_model.dart';
import 'internal_models/recent_chat_model.dart';
import 'internal_models/register_user_model.dart';
import 'internal_models/user_profile_update.dart';
import 'internal_models/users_list_model.dart';
import 'logmessage.dart';
import 'message_params.dart';
import 'model/available_features.dart' as client;
import 'model/callback.dart';
import 'model/chat_message_model.dart' as client;
import 'model/notification_applaunch_details.dart';
import 'model/profile_model.dart' as client;
import 'model/topic_metadata.dart';

class FlyErrorCode {
  static const unHandle = "1000";
}

class FlyErrorMessage {
  static const unHandle = "Unexpected Error";
}

/// An implementation of UikitFlutterPlatform that uses method channels.
class MethodChannelFlyChatFlutter extends FlyChatFlutterPlatform {
  /// The method channel used to interact with the native platform.
  ///

  MessageEventListeners? messageEventsListener;
  CallEventListeners? callEventsListener;
  ConnectionEventListeners? connectionEventsListener;
  ProfileEventListeners? profileEventsListener;
  GroupEventListeners? groupEventsListener;

  @visibleForTesting
  final mirrorFlyMethodChannel =
      const MethodChannel('contus.mirrorfly/flyChat');
  @visibleForTesting
  final mirrorFlyCallMethodChannel =
      const MethodChannel('contus.mirrorfly/flyCall');

  //Event Channels
  @visibleForTesting
  final messageOnReceivedChannel =
      const EventChannel('contus.mirrorfly/onMessageReceived');
  final StreamController<String> _messageOnReceivedStreamController =
      StreamController<String>.broadcast();
  @visibleForTesting
  final messageStatusUpdatedChanel =
      const EventChannel('contus.mirrorfly/onMessageStatusUpdated');
  final StreamController<dynamic> messageStatusUpdateStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final mediaStatusUpdatedChannel =
      const EventChannel('contus.mirrorfly/onMediaStatusUpdated');
  final StreamController<dynamic> mediaStatusUpdatedStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final uploadDownloadProgressChangedChannel =
      const EventChannel('contus.mirrorfly/onUploadDownloadProgressChanged');
  final StreamController<dynamic>
      uploadDownloadProgressChangedStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onGroupProfileFetchedChannel =
      const EventChannel('contus.mirrorfly/onGroupProfileFetched');
  final StreamController<dynamic> onGroupProfileFetchedStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onNewGroupCreatedChannel =
      const EventChannel('contus.mirrorfly/onNewGroupCreated');
  final StreamController<dynamic> onNewGroupCreatedStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onGroupProfileUpdatedChannel =
      const EventChannel('contus.mirrorfly/onGroupProfileUpdated');
  final StreamController<dynamic> onGroupProfileUpdatedStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onNewMemberAddedToGroupChannel =
      const EventChannel('contus.mirrorfly/onNewMemberAddedToGroup');
  final StreamController<dynamic> onNewMemberAddedToGroupStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onMemberRemovedFromGroupChannel =
      const EventChannel('contus.mirrorfly/onMemberRemovedFromGroup');
  final StreamController<dynamic> onMemberRemovedFromGroupStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onFetchingGroupMembersCompletedChannel =
      const EventChannel('contus.mirrorfly/onFetchingGroupMembersCompleted');
  final StreamController<dynamic>
      onFetchingGroupMembersCompletedStreamController =
      StreamController<dynamic>.broadcast();

  // @visibleForTesting
  // final onDeleteGroupChannel = const EventChannel('contus.mirrorfly/onDeleteGroup');
  // final StreamController<dynamic> onDeleteGroupStreamController = StreamController<dynamic>.broadcast();
  // @visibleForTesting
  // final onFetchingGroupListCompletedChannel = const EventChannel('contus.mirrorfly/onFetchingGroupListCompleted');
  // final StreamController<dynamic> onFetchingGroupListCompletedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onMemberMadeAsAdminChannel =
      const EventChannel('contus.mirrorfly/onMemberMadeAsAdmin');
  final StreamController<dynamic> onMemberMadeAsAdminStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onMemberRemovedAsAdminChannel =
      const EventChannel('contus.mirrorfly/onMemberRemovedAsAdmin');
  final StreamController<dynamic> onMemberRemovedAsAdminStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onLeftFromGroupChannel =
      const EventChannel('contus.mirrorfly/onLeftFromGroup');
  final StreamController<dynamic> onLeftFromGroupStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onGroupNotificationMessageChannel =
      const EventChannel('contus.mirrorfly/onGroupNotificationMessage');
  final StreamController<dynamic> onGroupNotificationMessageStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final showOrUpdateOrCancelNotificationChannel =
      const EventChannel('contus.mirrorfly/showOrUpdateOrCancelNotification');
  final StreamController<String>
      showOrUpdateOrCancelNotificationStreamController =
      StreamController<String>.broadcast();
  @visibleForTesting
  final onGroupDeletedLocallyChannel =
      const EventChannel('contus.mirrorfly/onGroupDeletedLocally');
  final StreamController<dynamic> onGroupDeletedLocallyStreamController =
      StreamController<dynamic>.broadcast();

  @visibleForTesting
  final blockedThisUserChannel =
      const EventChannel('contus.mirrorfly/blockedThisUser');
  final StreamController<dynamic> blockedThisUserStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final myProfileUpdatedChannel =
      const EventChannel('contus.mirrorfly/myProfileUpdated');
  final StreamController<dynamic> myProfileUpdatedStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onAdminBlockedOtherUserChannel =
      const EventChannel('contus.mirrorfly/onAdminBlockedOtherUser');
  final StreamController<dynamic> onAdminBlockedOtherUserStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onAdminBlockedUserChannel =
      const EventChannel('contus.mirrorfly/onAdminBlockedUser');
  final StreamController<dynamic> onAdminBlockedUserStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onContactSyncCompleteChannel =
      const EventChannel('contus.mirrorfly/onContactSyncComplete');
  final StreamController<dynamic> onContactSyncCompleteStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onLoggedOutChannel = const EventChannel('contus.mirrorfly/onLoggedOut');
  final StreamController<dynamic> onLoggedOutStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final unblockedThisUserChannel =
      const EventChannel('contus.mirrorfly/unblockedThisUser');
  final StreamController<dynamic> unblockedThisUserStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final userBlockedMeChannel =
      const EventChannel('contus.mirrorfly/userBlockedMe');
  final StreamController<dynamic> userBlockedMeStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final userCameOnlineChannel =
      const EventChannel('contus.mirrorfly/userCameOnline');
  final StreamController<dynamic> userCameOnlineStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final userDeletedHisProfileChannel =
      const EventChannel('contus.mirrorfly/userDeletedHisProfile');
  final StreamController<dynamic> userDeletedHisProfileStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final userProfileFetchedChannel =
      const EventChannel('contus.mirrorfly/userProfileFetched');
  final StreamController<dynamic> userProfileFetchedStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final userUnBlockedMeChannel =
      const EventChannel('contus.mirrorfly/userUnBlockedMe');
  final StreamController<dynamic> userUnBlockedMeStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final userUpdatedHisProfileChannel =
      const EventChannel('contus.mirrorfly/userUpdatedHisProfile');
  final StreamController<dynamic> userUpdatedHisProfileStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final userWentOfflineChannel =
      const EventChannel('contus.mirrorfly/userWentOffline');
  final StreamController<dynamic> userWentOfflineStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final usersIBlockedListFetchedChannel =
      const EventChannel('contus.mirrorfly/usersIBlockedListFetched');
  final StreamController<dynamic> usersIBlockedListFetchedStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final usersProfilesFetchedChannel =
      const EventChannel('contus.mirrorfly/usersProfilesFetched');
  final StreamController<dynamic> usersProfilesFetchedStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final usersWhoBlockedMeListFetchedChannel =
      const EventChannel('contus.mirrorfly/usersWhoBlockedMeListFetched');
  final StreamController<dynamic> usersWhoBlockedMeListFetchedStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onConnectedChannel = const EventChannel('contus.mirrorfly/onConnected');
  final StreamController<dynamic> onConnectedStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onDisconnectedChannel =
      const EventChannel('contus.mirrorfly/onDisconnected');
  final StreamController<dynamic> onDisconnectedStreamController =
      StreamController<dynamic>.broadcast();

  /*@visibleForTesting
  final onConnectionNotAuthorizedChannel =
      const EventChannel('contus.mirrorfly/onConnectionNotAuthorized');*/
  @visibleForTesting
  final onConnectionFailedChannel =
      const EventChannel('contus.mirrorfly/onConnectionFailed');
  final StreamController<dynamic> onConnectionFailedStreamController =
      StreamController<dynamic>.broadcast();

  // @visibleForTesting
  // final connectionFailedChannel = const EventChannel('contus.mirrorfly/connectionFailed');
  // final StreamController<dynamic> connectionFailedStreamController = StreamController<dynamic>.broadcast();
  // @visibleForTesting
  // final connectionSuccessChannel = const EventChannel('contus.mirrorfly/connectionSuccess');
  // final StreamController<dynamic> connectionSuccessStreamController = StreamController<dynamic>.broadcast();
  // @visibleForTesting
  // final onWebChatPasswordChangedChannel =
  //     const EventChannel('contus.mirrorfly/onWebChatPasswordChanged');
  // final StreamController<dynamic> onWebChatPasswordChangedStreamController =
  //     StreamController<dynamic>.broadcast();
  @visibleForTesting
  final setTypingStatusChannel =
      const EventChannel('contus.mirrorfly/setTypingStatus');
  final StreamController<dynamic> setTypingStatusStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onChatTypingStatusChannel =
      const EventChannel('contus.mirrorfly/onChatTypingStatus');
  final StreamController<dynamic> onChatTypingStatusStreamController =
      StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onGroupTypingStatusChannel =
      const EventChannel('contus.mirrorfly/onGroupTypingStatus');
  final StreamController<dynamic> onGroupTypingStatusStreamController =
      StreamController<dynamic>.broadcast();

  @visibleForTesting
  final messageOnEditedChannel =
      const EventChannel('contus.mirrorfly/onMessageEdited');
  final StreamController<String> _messageOnEditedStreamController =
      StreamController<String>.broadcast();

  // @visibleForTesting
  // final onFailureChannel = const EventChannel('contus.mirrorfly/onFailure');
  // final StreamController<dynamic> onFailureStreamController = StreamController<dynamic>.broadcast();
  // @visibleForTesting
  // final onProgressChangedChannel = const EventChannel('contus.mirrorfly/onProgressChanged');
  // final StreamController<dynamic> onProgressChangedStreamController = StreamController<dynamic>.broadcast();
  // @visibleForTesting
  // final onSuccessChannel = const EventChannel('contus.mirrorfly/onSuccess');
  // final StreamController<dynamic> onSuccessStreamController = StreamController<dynamic>.broadcast();

  //Need to add stream controller here
  // @visibleForTesting
  // final onCallReceivingChannel = const EventChannel('contus.mirrorfly/onCallReceiving');
  // final StreamController<dynamic> onCallReceivingStreamController = StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onLocalVideoTrackAddedChannel =
      const EventChannel('contus.mirrorfly/onLocalVideoTrackAdded');
  final StreamController<dynamic> onLocalVideoTrackAddedStreamController =
      StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onRemoteVideoTrackAddedChannel =
      const EventChannel('contus.mirrorfly/onRemoteVideoTrackAdded');
  final StreamController<dynamic> onRemoteVideoTrackAddedStreamController =
      StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onTrackAddedChannel =
      const EventChannel('contus.mirrorfly/onTrackAdded');
  final StreamController<dynamic> onTrackAddedStreamController =
      StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onCallStatusUpdatedChannel =
      const EventChannel('contus.mirrorfly/onCallStatusUpdated');
  final StreamController<dynamic> onCallStatusUpdatedStreamController =
      StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onCallActionChannel =
      const EventChannel('contus.mirrorfly/onCallAction');
  final StreamController<dynamic> onCallActionStreamController =
      StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onMuteStatusUpdatedChannel =
      const EventChannel('contus.mirrorfly/onMuteStatusUpdated');
  final StreamController<dynamic> onMuteStatusUpdatedStreamController =
      StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onUserSpeakingChannel =
      const EventChannel('contus.mirrorfly/onUserSpeaking');
  final StreamController<dynamic> onUserSpeakingStreamController =
      StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onUserStoppedSpeakingChannel =
      const EventChannel('contus.mirrorfly/onUserStoppedSpeaking');
  final StreamController<dynamic> onUserStoppedSpeakingStreamController =
      StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onMissedCallChannel =
      const EventChannel('contus.mirrorfly/onMissedCall');
  final StreamController<dynamic> onMissedCallStreamController =
      StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onAvailableFeaturesUpdatedChannel =
      const EventChannel('contus.mirrorfly/onAvailableFeaturesUpdated');
  final StreamController<dynamic> onAvailableFeaturesUpdatedStreamController =
      StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onCallLogsUpdatedChannel =
      const EventChannel('contus.mirrorfly/onCallLog');
  final StreamController<dynamic> onCallLogsUpdatedStreamController =
      StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onCallLogDeletedChannel =
      const EventChannel('contus.mirrorfly/onCallLogDeleted');
  final StreamController<dynamic> onCallLogDeletedStreamController =
      StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onClearAllCallLogChannel =
      const EventChannel('contus.mirrorfly/clearAllCallLog');
  final StreamController<dynamic> onClearAllCallLogStreamController =
      StreamController<dynamic>.broadcast();

  @override
  Stream<dynamic> get onMessageReceived =>
      _messageOnReceivedStreamController.stream;

  @override
  Stream<dynamic> get onMessageEdited =>
      _messageOnEditedStreamController.stream;

  @override
  Stream<dynamic> get onMessageStatusUpdated =>
      messageStatusUpdateStreamController.stream;

  @override
  Stream<dynamic> get onMediaStatusUpdated =>
      mediaStatusUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onUploadDownloadProgressChanged =>
      uploadDownloadProgressChangedStreamController.stream;

  @override
  Stream<dynamic> get onGroupProfileFetched =>
      onGroupProfileFetchedStreamController.stream;

  @override
  Stream<dynamic> get onNewGroupCreated =>
      onNewGroupCreatedStreamController.stream;

  @override
  Stream<dynamic> get onGroupProfileUpdated =>
      onGroupProfileUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onNewMemberAddedToGroup =>
      onNewMemberAddedToGroupStreamController.stream;

  @override
  Stream<dynamic> get onMemberRemovedFromGroup =>
      onMemberRemovedFromGroupStreamController.stream;

  @override
  Stream<dynamic> get onFetchingGroupMembersCompleted =>
      onFetchingGroupMembersCompletedStreamController.stream;

  // @override
  // Stream<dynamic> get onDeleteGroup => onDeleteGroupStreamController.stream;

  // @override
  // Stream<dynamic> get onFetchingGroupListCompleted => onFetchingGroupListCompletedStreamController.stream;

  @override
  Stream<dynamic> get onMemberMadeAsAdmin =>
      onMemberMadeAsAdminStreamController.stream;

  @override
  Stream<dynamic> get onMemberRemovedAsAdmin =>
      onMemberRemovedAsAdminStreamController.stream;

  @override
  Stream<dynamic> get onLeftFromGroup => onLeftFromGroupStreamController.stream;

  @override
  Stream<dynamic> get onGroupNotificationMessage =>
      onGroupNotificationMessageStreamController.stream;

  @override
  Stream<dynamic> get showOrUpdateOrCancelNotification =>
      showOrUpdateOrCancelNotificationStreamController.stream;

  @override
  Stream<dynamic> get onGroupDeletedLocally =>
      onGroupDeletedLocallyStreamController.stream;

  @override
  Stream<dynamic> get blockedThisUser => blockedThisUserStreamController.stream;

  @override
  Stream<dynamic> get myProfileUpdated =>
      myProfileUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onAdminBlockedOtherUser =>
      onAdminBlockedOtherUserStreamController.stream;

  @override
  Stream<dynamic> get onAdminBlockedUser =>
      onAdminBlockedUserStreamController.stream;

  @override
  Stream<dynamic> get onContactSyncComplete =>
      onContactSyncCompleteStreamController.stream;

  @override
  Stream<dynamic> get onLoggedOut => onLoggedOutStreamController.stream;

  @override
  Stream<dynamic> get unblockedThisUser =>
      unblockedThisUserStreamController.stream;

  @override
  Stream<dynamic> get userBlockedMe => userBlockedMeStreamController.stream;

  @override
  Stream<dynamic> get userCameOnline => userCameOnlineStreamController.stream;

  @override
  Stream<dynamic> get userDeletedHisProfile =>
      userDeletedHisProfileStreamController.stream;

  @override
  Stream<dynamic> get userProfileFetched =>
      userProfileFetchedStreamController.stream;

  @override
  Stream<dynamic> get userUnBlockedMe => userUnBlockedMeStreamController.stream;

  @override
  Stream<dynamic> get userUpdatedHisProfile =>
      userUpdatedHisProfileStreamController.stream;

  @override
  Stream<dynamic> get userWentOffline => userWentOfflineStreamController.stream;

  @override
  Stream<dynamic> get usersIBlockedListFetched =>
      usersIBlockedListFetchedStreamController.stream;

  @override
  Stream<dynamic> get usersProfilesFetched =>
      usersProfilesFetchedStreamController.stream;

  @override
  Stream<dynamic> get usersWhoBlockedMeListFetched =>
      usersWhoBlockedMeListFetchedStreamController.stream;

  @override
  Stream<dynamic> get onConnected => onConnectedStreamController.stream;

  @override
  Stream<dynamic> get onDisconnected => onDisconnectedStreamController.stream;

  /*@override
  Stream<dynamic> get onConnectionNotAuthorized =>
      onConnectionNotAuthorizedStreamController.stream;*/

  @override
  Stream<dynamic> get onConnectionFailed =>
      onConnectionFailedStreamController.stream;

  // @override
  // Stream<dynamic> get connectionFailed => connectionFailedStreamController.stream;

  // @override
  // Stream<dynamic> get connectionSuccess => connectionSuccessStreamController.stream;

  // @override
  // Stream<dynamic> get onWebChatPasswordChanged =>
  //     onWebChatPasswordChangedStreamController.stream;

  @override
  Stream<dynamic> get setTypingStatus => setTypingStatusStreamController.stream;

  @override
  Stream<dynamic> get onChatTypingStatus =>
      onChatTypingStatusStreamController.stream;

  @override
  Stream<dynamic> get onGroupTypingStatus =>
      onGroupTypingStatusStreamController.stream;

  // @override
  // Stream<dynamic> get onFailure => onFailureStreamController.stream;

  // @override
  // Stream<dynamic> get onProgressChanged => onProgressChangedStreamController.stream;
  //
  // @override
  // Stream<dynamic> get onSuccess => onSuccessStreamController.stream;

  // @override
  // Stream<dynamic> get onCallReceiving =>
  //     onCallReceivingStreamController.stream;

  @override
  Stream<dynamic> get onLocalVideoTrackAdded =>
      onLocalVideoTrackAddedStreamController.stream;

  @override
  Stream<dynamic> get onRemoteVideoTrackAdded =>
      onRemoteVideoTrackAddedStreamController.stream;

  @override
  Stream<dynamic> get onTrackAdded => onTrackAddedStreamController.stream;

  @override
  Stream<dynamic> get onCallStatusUpdated =>
      onCallStatusUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onCallAction => onCallActionStreamController.stream;

  @override
  Stream<dynamic> get onMuteStatusUpdated =>
      onMuteStatusUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onUserSpeaking => onUserSpeakingStreamController.stream;

  @override
  Stream<dynamic> get onUserStoppedSpeaking =>
      onUserStoppedSpeakingStreamController.stream;

  @override
  Stream<dynamic> get onMissedCall => onMissedCallStreamController.stream;

  @override
  Stream<dynamic> get onAvailableFeaturesUpdated =>
      onAvailableFeaturesUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onCallLogsUpdated =>
      onCallLogsUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onCallLogDeleted =>
      onCallLogDeletedStreamController.stream;

  @override
  Stream<dynamic> get onClearAllCallLog =>
      onClearAllCallLogStreamController.stream;

  ///Using [addStreamsAllToStreamController] to add all streams to stream controller
  ///benefit to use stream controller we can call multiple listeners to listen.
  addStreamsAllToStreamController() {
    messageOnReceivedChannel.receiveBroadcastStream().listen((event) {
      var message = convertChatMessageJsonFromString(event);
      _messageOnReceivedStreamController.add(message);
      messageEventsListener
          ?.onMessageReceived(client.sendMessageModelFromJson(message));
    });
    messageOnEditedChannel.receiveBroadcastStream().listen((event) {
      var message = convertChatMessageJsonFromString(event);
      _messageOnEditedStreamController.add(message);
      messageEventsListener
          ?.onMessageEdited(client.sendMessageModelFromJson(message));
    });
    messageStatusUpdatedChanel.receiveBroadcastStream().listen((event) {
      var messageStatus = convertChatMessageJsonFromString(event);
      messageStatusUpdateStreamController.add(messageStatus);
      messageEventsListener?.onMessageStatusUpdated(
          client.sendMessageModelFromJson(messageStatus));
    });
    mediaStatusUpdatedChannel.receiveBroadcastStream().listen((event) {
      var mediaStatus = convertChatMessageJsonFromString(event);
      mediaStatusUpdatedStreamController.add(mediaStatus);
      messageEventsListener
          ?.onMediaStatusUpdated(client.sendMessageModelFromJson(mediaStatus));
    });
    onGroupNotificationMessageChannel.receiveBroadcastStream().listen((event) {
      var groupNotification = convertChatMessageJsonFromString(event);
      onGroupNotificationMessageStreamController.add(groupNotification);
      groupEventsListener?.onGroupNotificationMessage(
          client.sendMessageModelFromJson(groupNotification));
    });
    showOrUpdateOrCancelNotificationChannel
        .receiveBroadcastStream()
        .listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"];
      var chatMessage = convertChatMessageJsonFromString(data["chatMessage"]);
      var map = {"jid": jid, "chatMessage": chatMessage};
      var notification = json.encode(map);
      showOrUpdateOrCancelNotificationStreamController.add(notification);
      messageEventsListener?.showOrUpdateOrCancelNotification(
          jid, client.sendMessageModelFromJson(chatMessage));
    });
    uploadDownloadProgressChangedChannel
        .receiveBroadcastStream()
        .listen((event) {
      var data = json.decode(event.toString());
      var messageId = data["message_id"] ?? "";
      var progressPercentage = data["progress_percentage"] ?? 0;
      uploadDownloadProgressChangedStreamController.add(event);
      messageEventsListener?.onUploadDownloadProgressChanged(
          messageId, progressPercentage);
    });
    onGroupProfileFetchedChannel.receiveBroadcastStream().listen((groupJid) {
      onGroupProfileFetchedStreamController.add(groupJid);
      groupEventsListener?.onGroupProfileFetched(groupJid);
    });
    onNewGroupCreatedChannel.receiveBroadcastStream().listen((groupJid) {
      onNewGroupCreatedStreamController.add(groupJid);
      groupEventsListener?.onNewGroupCreated(groupJid);
    });
    onGroupProfileUpdatedChannel.receiveBroadcastStream().listen((groupJid) {
      onGroupProfileUpdatedStreamController.add(groupJid);
      groupEventsListener?.onGroupProfileUpdated(groupJid);
    });
    onNewMemberAddedToGroupChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var groupJid = data["groupJid"] ?? "";
      var newMemberJid = data["newMemberJid"] ?? "";
      var addedByMemberJid = data["addedByMemberJid"] ?? "";
      onNewMemberAddedToGroupStreamController.add(event);
      groupEventsListener?.onNewMemberAddedToGroup(
          groupJid, newMemberJid, addedByMemberJid);
    });
    onMemberRemovedFromGroupChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var groupJid = data["groupJid"] ?? "";
      var removedMemberJid = data["removedMemberJid"] ?? "";
      var removedByMemberJid = data["removedByMemberJid"] ?? "";
      onMemberRemovedFromGroupStreamController.add(event);
      groupEventsListener?.onMemberRemovedFromGroup(
          groupJid, removedMemberJid, removedByMemberJid);
    });
    onFetchingGroupMembersCompletedChannel
        .receiveBroadcastStream()
        .listen((groupJid) {
      onFetchingGroupMembersCompletedStreamController.add(groupJid);
      groupEventsListener?.onFetchingGroupMembersCompleted(groupJid);
    });
    // onDeleteGroupChannel.receiveBroadcastStream().listen((event) {
    //   onDeleteGroupStreamController.add(event);
    //   groupEventsListener?.onDeleteGroup(event);
    // });
    // onFetchingGroupListCompletedChannel.receiveBroadcastStream().listen((event) {
    //   onFetchingGroupListCompletedStreamController.add(event);
    //   groupEventsListener?.onFetchingGroupListCompleted(event);
    // });
    onMemberMadeAsAdminChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var groupJid = data["groupJid"] ?? "";
      var newAdminMemberJid = data["newAdminMemberJid"] ?? "";
      var madeByMemberJid = data["madeByMemberJid"] ?? "";
      onMemberMadeAsAdminStreamController.add(event);
      groupEventsListener?.onMemberMadeAsAdmin(
          groupJid, newAdminMemberJid, madeByMemberJid);
    });
    onMemberRemovedAsAdminChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var groupJid = data["groupJid"] ?? "";
      var removedAdminMemberJid = data["removedAdminMemberJid"] ?? "";
      var removedByMemberJid = data["removedByMemberJid"] ?? "";
      onMemberRemovedAsAdminStreamController.add(event);
      groupEventsListener?.onMemberRemovedAsAdmin(
          groupJid, removedAdminMemberJid, removedByMemberJid);
    });
    onLeftFromGroupChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var groupJid = data["groupJid"] ?? "";
      var leftUserJid = data["leftUserJid"] ?? "";
      onLeftFromGroupStreamController.add(event);
      groupEventsListener?.onLeftFromGroup(groupJid, leftUserJid);
    });

    onGroupDeletedLocallyChannel.receiveBroadcastStream().listen((groupJid) {
      onGroupDeletedLocallyStreamController.add(groupJid);
      groupEventsListener?.onGroupDeletedLocally(groupJid);
    });
    blockedThisUserChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var userJid = data["jid"] ?? "";
      blockedThisUserStreamController.add(event);
      profileEventsListener?.blockedThisUser(userJid);
    });
    myProfileUpdatedChannel.receiveBroadcastStream().listen((event) {
      myProfileUpdatedStreamController.add(event);
      profileEventsListener?.myProfileUpdated();
    });
    onAdminBlockedOtherUserChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      var chatType = data["type"] ?? "";
      var isBlocked = data["status"] ?? "";
      onAdminBlockedOtherUserStreamController.add(event);
      profileEventsListener?.onAdminBlockedOtherUser(jid, chatType, isBlocked);
    });
    onAdminBlockedUserChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      var isBlocked = data["status"] ?? "";
      onAdminBlockedUserStreamController.add(event);
      profileEventsListener?.onAdminBlockedUser(jid, isBlocked);
    });
    onContactSyncCompleteChannel.receiveBroadcastStream().listen((isSuccess) {
      onContactSyncCompleteStreamController.add(isSuccess);
      profileEventsListener?.onContactSyncComplete(isSuccess);
    });
    onLoggedOutChannel.receiveBroadcastStream().listen((event) {
      onLoggedOutStreamController.add(event);
      connectionEventsListener?.onLoggedOut();
    });
    unblockedThisUserChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      unblockedThisUserStreamController.add(event);
      profileEventsListener?.unblockedThisUser(jid);
    });
    userBlockedMeChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      userBlockedMeStreamController.add(event);
      profileEventsListener?.userBlockedMe(jid);
    });
    userCameOnlineChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      userCameOnlineStreamController.add(event);
      messageEventsListener?.userCameOnline(jid);
    });
    userDeletedHisProfileChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      userDeletedHisProfileStreamController.add(event);
      profileEventsListener?.userDeletedHisProfile(jid);
    });
    userProfileFetchedChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      var profileDetails = data["profileDetails"] ?? "";
      client.ProfileData profileData = client.profileData(profileDetails);
      userProfileFetchedStreamController.add(event);
      profileEventsListener?.userProfileFetched(jid, profileData);
    });
    userUnBlockedMeChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      userUnBlockedMeStreamController.add(event);
      profileEventsListener?.userUnBlockedMe(jid);
    });
    userUpdatedHisProfileChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      userUpdatedHisProfileStreamController.add(event);
      profileEventsListener?.userUpdatedHisProfile(jid);
    });
    userWentOfflineChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      userWentOfflineStreamController.add(event);
      messageEventsListener?.userWentOffline(jid);
    });
    usersIBlockedListFetchedChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jidList = data["jidlist"] ?? "";
      usersIBlockedListFetchedStreamController.add(event);
      profileEventsListener?.usersIBlockedListFetched(jidList);
    });
    usersProfilesFetchedChannel.receiveBroadcastStream().listen((event) {
      usersProfilesFetchedStreamController.add(event);
      profileEventsListener?.usersProfilesFetched();
    });
    usersWhoBlockedMeListFetchedChannel
        .receiveBroadcastStream()
        .listen((event) {
      var data = json.decode(event.toString());
      var jidList = data["jidlist"] ?? "";
      usersWhoBlockedMeListFetchedStreamController.add(event);
      profileEventsListener?.usersWhoBlockedMeListFetched(jidList);
    });
    onConnectedChannel.receiveBroadcastStream().listen((event) {
      onConnectedStreamController.add(event);
      connectionEventsListener?.onConnected();
    });
    onDisconnectedChannel.receiveBroadcastStream().listen((event) {
      onDisconnectedStreamController.add(event);
      connectionEventsListener?.onDisconnected();
    });
    onConnectionFailedChannel.receiveBroadcastStream().listen((event) {
      onConnectionFailedStreamController.add(event);
      connectionEventsListener?.onConnectionFailed(event);
    });
    // connectionFailedChannel.receiveBroadcastStream().listen((event) {
    //   connectionFailedStreamController.add(event);});
    // connectionSuccessChannel.receiveBroadcastStream().listen((event) {
    //   connectionSuccessStreamController.add(event);});
    // onWebChatPasswordChangedChannel.receiveBroadcastStream().listen((event) {
    //   onWebChatPasswordChangedStreamController.add(event);
    // });
    setTypingStatusChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var singleOrGroupJid = data["singleOrgroupJid"] ?? "";
      var userJid = data["userJid"] ?? "";
      var status = data["status"] ?? "";
      setTypingStatusStreamController.add(event);
      messageEventsListener?.setTypingStatus(singleOrGroupJid, userJid, status);
    });
    onChatTypingStatusChannel.receiveBroadcastStream().listen((event) {
      onChatTypingStatusStreamController.add(event);
    });
    onGroupTypingStatusChannel.receiveBroadcastStream().listen((event) {
      onGroupTypingStatusStreamController.add(event);
    });
    // onFailureChannel.receiveBroadcastStream().listen((event) {
    //   onFailureStreamController.add(event);});
    // onProgressChangedChannel.receiveBroadcastStream().listen((event) {
    //   onProgressChangedStreamController.add(event);});
    // onSuccessChannel.receiveBroadcastStream().listen((event) {
    //   onSuccessStreamController.add(event);});
    // onCallReceivingChannel.receiveBroadcastStream().listen((event) {
    //   onCallReceivingStreamController.add(event);});
    onLocalVideoTrackAddedChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var userJid = data["userJid"] ?? "";
      onLocalVideoTrackAddedStreamController.add(event);
      callEventsListener?.onLocalVideoTrackAdded(userJid);
    });
    onRemoteVideoTrackAddedChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var userJid = data["userJid"] ?? "";
      onRemoteVideoTrackAddedStreamController.add(event);
      callEventsListener?.onRemoteVideoTrackAdded(userJid);
    });
    onTrackAddedChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var userJid = data["userJid"] ?? "";
      onTrackAddedStreamController.add(event);
      callEventsListener?.onTrackAdded(userJid);
    });
    onCallStatusUpdatedChannel.receiveBroadcastStream().listen((event) {
      var statusUpdateReceived = jsonDecode(event);
      var callMode = statusUpdateReceived["callMode"].toString();
      var userJid = statusUpdateReceived["userJid"].toString();
      var callType = statusUpdateReceived["callType"].toString();
      var callStatus = statusUpdateReceived["callStatus"].toString();
      onCallStatusUpdatedStreamController.add(event);
      callEventsListener?.onCallStatusUpdated(
          userJid, callMode, callType, callStatus);
    });
    onCallActionChannel.receiveBroadcastStream().listen((event) {
      var actionReceived = jsonDecode(event);
      var callAction = actionReceived["callAction"].toString();
      var userJid = actionReceived["userJid"].toString();
      var callMode = actionReceived["callMode"].toString();
      var callType = actionReceived["callType"].toString();
      onCallActionStreamController.add(event);
      callEventsListener?.onCallAction(userJid, callMode, callType, callAction);
    });
    onMuteStatusUpdatedChannel.receiveBroadcastStream().listen((event) {
      var muteStatus = jsonDecode(event);
      var muteEvent = muteStatus["muteEvent"].toString();
      var userJid = muteStatus["userJid"].toString();
      onMuteStatusUpdatedStreamController.add(event);
      callEventsListener?.onMuteStatusUpdated(userJid, muteEvent);
    });
    onUserSpeakingChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var audioLevel = data["audioLevel"];
      var userJid = data["userJid"];
      onUserSpeakingStreamController.add(event);
      callEventsListener?.onUserSpeaking(userJid, audioLevel);
    });
    onUserStoppedSpeakingChannel.receiveBroadcastStream().listen((userJid) {
      onUserStoppedSpeakingStreamController.add(userJid);
      callEventsListener?.onUserStoppedSpeaking(userJid);
    });
    onMissedCallChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var isOneToOneCall = data["isOneToOneCall"];
      var userJid = data["userJid"];
      var groupId = data["groupId"];
      var callType = data["callType"];
      var userList = data["userList"].toString().split(",");
      onMissedCallStreamController.add(event);
      callEventsListener?.onMissedCall(
          userJid, groupId, isOneToOneCall, callType, userList);
    });
    onAvailableFeaturesUpdatedChannel.receiveBroadcastStream().listen((event) {
      client.AvailableFeatures availableFeatures =
          client.availableFeaturesFromJson(event.toString());
      onAvailableFeaturesUpdatedStreamController.add(event);
      messageEventsListener?.onAvailableFeaturesUpdated(availableFeatures);
    });
    onCallLogsUpdatedChannel.receiveBroadcastStream().listen((event) {
      onCallLogsUpdatedStreamController.add(event);
      callEventsListener?.onCallLogsUpdated();
    });
    onCallLogDeletedChannel.receiveBroadcastStream().listen((callLogId) {
      onCallLogDeletedStreamController.add(callLogId);
      callEventsListener?.onCallLogDeleted(callLogId);
    });
    onClearAllCallLogChannel.receiveBroadcastStream().listen((event) {
      onClearAllCallLogStreamController.add(event);
      callEventsListener?.onCallLogsCleared();
    });
  }

  /*@override
  Future<String?> getPlatformVersion() async {
    final version =
    await mirrorFlyMethodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }*/
  static bool enableDebugLog = false;

  @override
  init(ChatBuilder builder) async {
    enableDebugLog = builder.enableDebugLog;
    if (!_messageOnReceivedStreamController.hasListener) {
      addStreamsAllToStreamController();
    }
    await mirrorFlyMethodChannel.invokeMethod('init', builder.build());
  }

  @override
  Future<void> initializeSDK(InitializeSDKBuilder builder,
      Function(FlyResponse response) callback) async {
    bool? res;
    enableDebugLog = builder.enableDebugLog;
    if (!_messageOnReceivedStreamController.hasListener) {
      addStreamsAllToStreamController();
    }
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'initializeSDK', builder.build());
      LogMessage.d("initializeSDK", res);
      callback.call(
          FlyResponse(true, FlyConstants.empty, "initializeSDK Successfully"));
      // return res;
      return;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
      // return res;
      return;
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
      // return res;
      return;
    }
  }

  @override
  Future<bool> isPrivateStorageEnabledOrNot() async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'isPrivateStorageEnabled');
      LogMessage.d("isPrivateStorageEnabled", res);
      return res ?? false;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      return res ?? false;
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      return res ?? false;
    }
  }

  @override
  Future<void> syncContacts(
      bool isfirsttime, Function(FlyResponse response)? callback) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('syncContacts', {"is_first_time": isfirsttime});
      LogMessage.d("syncContacts", res);
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String?> getSendData() async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<String>('sendData');
      LogMessage.d("sendData Result ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool> contactSyncStateValue() async {
    bool response = false;
    try {
      response = await mirrorFlyMethodChannel
              .invokeMethod<bool>('contactSyncStateValue') ??
          false;
      LogMessage.d("contactSyncStateValue Result ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  /*@override
  Future<dynamic> contactSyncState() async {
    dynamic response = FlyConstants.empty;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('contactSyncState');
      LogMessage.d("contactSyncState Result ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }*/

  @override
  Future<void> revokeContactSync(
      Function(FlyResponse response)? callback) async {
    dynamic response = FlyConstants.empty;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('revokeContactSync');
      LogMessage.d("revokeContactSync Result ", " $response");
      callback?.call(FlyResponse(true, response, FlyConstants.empty));
      // return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> getUsersWhoBlockedMe(
      [bool server = false, Function(FlyResponse response)? callback]) async {
    String response = FlyConstants.empty;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod('getUsersWhoBlockedMe', {"server": server});
      LogMessage.d("getUsersWhoBlockedMe Result ", " $response");
      callback?.call(FlyResponse(true,
          convertProfileDetailsJsonFromString(response), FlyConstants.empty));
      // return convertProfileDetailsJsonFromString(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  /*@override
  Future<dynamic> getUnKnownUserProfiles() async {
    dynamic response = FlyConstants.empty;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getUnKnownUserProfiles');
      LogMessage.d("getUnKnownUserProfiles Result ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }*/

  /*@override
  Future<dynamic> getMyProfileStatus() async {
    dynamic response = FlyConstants.empty;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getMyProfileStatus');
      LogMessage.d("getMyProfileStatus Result ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }*/

  @override
  Future<String> getMyBusyStatus() async {
    String? response = FlyConstants.empty;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getMyBusyStatus');
      return convertStatusFromJson(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String?> getBusyStatusList() async {
    String? response = FlyConstants.empty;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getBusyStatusList');
      return convertStatusListFromJson(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String?> getRecalledMessagesOfAConversation(String jid) async {
    String? response = FlyConstants.empty;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod('getRecalledMessagesOfAConversation', {"jid": jid});
      return convertChatMessagesJsonFromString(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> setMyBusyStatus(
      String busyStatus, Function(FlyResponse response)? callback) async {
    // bool? res;
    try {
      await mirrorFlyMethodChannel
          .invokeMethod<bool>('setMyBusyStatus', {"status": busyStatus});
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<bool?> insertBusyStatus(String busyStatus) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('insertBusyStatus', {"busy_status": busyStatus});
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> enableDisableBusyStatus(
      bool enable, Function(FlyResponse response)? callback) async {
    // bool? res;
    try {
      await mirrorFlyMethodChannel
          .invokeMethod<bool>('enableDisableBusyStatus', {"enable": enable});
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<bool?> enableDisableHideLastSeen(bool enable) async {
    bool? res;
    try {
      await mirrorFlyMethodChannel
          .invokeMethod<bool>('enableDisableHideLastSeen', {"enable": enable});
      // callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      // callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty, FlyException(e.code, e.message, e.details)));
      rethrow;
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      // callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty, FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
      rethrow;
    }
  }

  @override
  Future<void> setLastSeenVisibility(
      bool enable, Function(FlyResponse response)? callback) async {
    // bool? res;
    try {
      await mirrorFlyMethodChannel
          .invokeMethod<bool>('enableDisableHideLastSeen', {"enable": enable});
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<bool> isBusyStatusEnabled() async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('isBusyStatusEnabled');
      LogMessage.d("isBusyStatusEnabled", " $res");
      return res ?? false;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> deleteProfileStatus(
      String id, String status, bool isCurrentStatus) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('deleteProfileStatus', {
        "id": id,
        "status": status,
        "isCurrentStatus": isCurrentStatus,
      });
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> deleteBusyStatus(
      String id, String status, bool isCurrentStatus) async {
    bool? res;
    try {
      res =
          await mirrorFlyMethodChannel.invokeMethod<bool>('deleteBusyStatus', {
        "id": id,
        "status": status,
        "isCurrentStatus": isCurrentStatus,
      });
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String?> mediaEndPoint() async {
    String? response;
    try {
      response =
          await mirrorFlyMethodChannel.invokeMethod<String>('media_endpoint');
      LogMessage.d("media_endpoint Result ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> unFavouriteAllFavouriteMessages(
      Function(FlyResponse response)? callback) async {
    // bool? res;
    try {
      await mirrorFlyMethodChannel
          .invokeMethod<bool>('unFavouriteAllFavouriteMessages');
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<bool?> markAsRead(String jid) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('markAsRead', {"jid": jid});
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> uploadMedia(String messageid) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('uploadMedia', {"messageid": messageid});
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> deleteUnreadMessageSeparatorOfAConversation(String jid) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'deleteUnreadMessageSeparatorOfAConversation', {"jid": jid});
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<int?> getMembersCountOfGroup(String groupJid) async {
    int? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<int>('getMembersCountOfGroup', {"groupJid": groupJid});
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> doesFetchingMembersListFromServedRequired(
      String groupJid) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'doesFetchingMembersListFromServedRequired', {"groupJid": groupJid});
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> isHideLastSeenEnabled() async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('isHideLastSeenEnabled');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  deleteOfflineGroup(String groupJid) async {
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('deleteOfflineGroup', {"groupJid": groupJid});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  sendTypingStatus(String toJid, String chattype) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod(
          'sendTypingStatus', {"to_jid": toJid, "chattype": chattype});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  sendTypingGoneStatus(String toJid, String chattype) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod(
          'sendTypingGoneStatus', {"to_jid": toJid, "chattype": chattype});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  updateChatMuteStatus(String jid, bool muteStatus) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod(
          'updateChatMuteStatus', {"jid": jid, "mute_status": muteStatus});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  updateRecentChatPinStatus(String jid, bool pinStatus) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('updateRecentChatPinStatus',
          {"jid": jid, "pin_recent_chat": pinStatus});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> deleteRecentChat(
      String jid, Function(FlyResponse response)? callback) async {
    // bool? res;
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('deleteRecentChat', {"jid": jid});
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  setTypingStatusListener() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('setTypingStatusListener');
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> isUserUnArchived(String jid) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('isUserUnArchived', {"jid": jid});
      LogMessage.d("isUserUnArchived", "$res");
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> getIsProfileBlockedByAdmin() async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('getIsProfileBlockedByAdmin');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> deleteRecentChats(
      List<String> jidlist, Function(FlyResponse response)? callback) async {
    // bool? res;
    try {
      await mirrorFlyMethodChannel
          .invokeMethod<bool>('deleteRecentChats', {"jidlist": jidlist});
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  markConversationAsRead(List<String> jidlist) async {
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('markConversationAsRead', {"jidlist": jidlist});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  markConversationAsUnread(List<String> jidlist) async {
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('markConversationAsUnread', {"jidlist": jidlist});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  getArchivedChatsFromServer() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('getArchivedChatsFromServer');
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  setCustomValue(String messageId, String key, String value) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('setCustomValue',
          {"message_id": messageId, "key": key, "value": value});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  removeCustomValue(String messageId, String key) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod(
          'removeCustomValue', {"message_id": messageId, "key": key});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  inviteUserViaSMS(String mobileNo, String message) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod(
          'inviteUserViaSMS', {"mobile_no": mobileNo, "message": message});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  cancelBackup() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('cancelBackup');
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  startBackup() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('startBackup');
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  cancelRestore() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('cancelRestore');
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  clearAllSDKData() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('clearAllSDKData');
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  getRoster() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('getRoster');
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String?> getCustomValue(String messageId, String key) async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<String>(
          'getCustomValue', {"message_id": messageId, "key": key});
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> clearAllConversation(
      Function(FlyResponse response)? callback) async {
    // bool? res;
    try {
      await mirrorFlyMethodChannel.invokeMethod<bool>('clearAllConversation');
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> updateFcmToken(
      String firebasetoken, Function(FlyResponse response)? callback) async {
    // bool? res;
    try {
      await mirrorFlyMethodChannel
          .invokeMethod<bool>('updateFcmToken', {"token": firebasetoken});
      callback?.call(FlyResponse(
          true, FlyConstants.empty, "fcm token updated successfully"));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
      // rethrow;
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
      // rethrow;
    }
  }

  @override
  Future<bool?> isMuted(String jid) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('isMuted', {"jid": jid});
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> handleReceivedMessage(
      Map notificationData, Function(FlyResponse response)? callback) async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod(
          'handleReceivedMessage', {"notificationdata": notificationData});
      callback?.call(FlyResponse(
          true, convertChatMessageJsonFromString(res), FlyConstants.empty));
      // return convertChatMessageJsonFromString(res);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String?> getLastNUnreadMessages(int messagesCount) async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod(
          'getLastNUnreadMessages', {"messagecount": messagesCount});
      return convertChatMessagesJsonFromString(res);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  /*@override
  Future<dynamic> getNUnreadMessagesOfEachUsers(int messagesCount) async {
    dynamic res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod('getNUnreadMessagesOfEachUsers', {"messagecount": messagesCount});
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }*/

  @override
  Future<bool?> isArchivedSettingsEnabled() async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('isArchivedSettingsEnabled');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> enableDisableArchivedSettings(
      bool enable, Function(FlyResponse response)? callback) async {
    // bool? res;
    try {
      await mirrorFlyMethodChannel.invokeMethod<bool>(
          'enableDisableArchivedSettings', {"enable": enable});
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<bool?> updateArchiveUnArchiveChat(String jid, bool isArchived) async {
    bool? res;
    try {
      await mirrorFlyMethodChannel.invokeMethod<bool>(
          'updateArchiveUnArchiveChat', {"jid": jid, "isArchived": isArchived});
      // callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      // callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty, FlyException(e.code, e.message, e.details)));
      rethrow;
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      // callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty, FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
      rethrow;
    }
  }

  @override
  Future<void> setChatArchived(String jid, bool isArchived,
      Function(FlyResponse response)? callback) async {
    // bool? res;
    try {
      await mirrorFlyMethodChannel.invokeMethod<bool>(
          'updateArchiveUnArchiveChat', {"jid": jid, "isArchived": isArchived});
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<int?> getGroupMessageStatusCount(String messageid) async {
    int? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<int>(
          'getGroupMessageStatusCount', {"messageid": messageid});
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<int?> getUnreadMessageCountExceptMutedChat() async {
    int? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<int>('getUnreadMessageCountExceptMutedChat');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<int?> recentChatPinnedCount() async {
    int? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<int>('getGroupMessageStatusCount');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<int?> getUnreadMessagesCount() async {
    int? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<int>('getUnreadMessagesCount');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String?> getUnsentMessageOfAJid(String jid) async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<String>('getUnsentMessageOfAJid', {"jid": jid});
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  /*@override
  Future<String?> getUsersListToAddMembersInOldGroup(String groupJid) async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod('getUsersListToAddMembersInOldGroup', {"groupJid": groupJid});
      return convertProfileDetailsJsonFromString(res);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }*/

  /*@override
  Future<dynamic> prepareChatConversationToExport(String jid) async {
    dynamic res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod('prepareChatConversationToExport', {"jid": jid});
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }*/

  @override
  Future<void> getArchivedChatList(
      Function(FlyResponse response)? callback) async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod('getArchivedChatList');
      callback?.call(FlyResponse(
          true, convertRecentChatDataJsonFromString(res), FlyConstants.empty));
      // return convertRecentChatDataJsonFromString(res);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  /*@override
  Future<dynamic> getMessageActions(List<String> messageidlist) async {
    dynamic res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod('getMessageActions', {"messageidlist": messageidlist});
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }*/

  /*@override
  Future<String?> getUsersListToAddMembersInNewGroup() async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod('getUsersListToAddMembersInNewGroup');
      return convertProfileDetailsJsonFromString(res);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }*/

  @override
  Future<bool?> createOfflineGroupInOnline(String groupId) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'createOfflineGroupInOnline', {"groupId": groupId});
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> getGroupProfile(String groupJid, bool server,
      Function(FlyResponse response)? callback) async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod(
          'getGroupProfile', {"groupJid": groupJid, "server": server});
      callback?.call(FlyResponse(
          true, convertProfileDetailJsonFromString(res), FlyConstants.empty));
      // return convertProfileDetailJsonFromString(res);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  updateMediaDownloadStatus(String mediaMessageId, int progress,
      int downloadStatus, num dataTransferred) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('updateMediaDownloadStatus', {
        "mediaMessageId": mediaMessageId,
        "progress": progress,
        "downloadStatus": downloadStatus,
        "dataTransferred": dataTransferred
      });
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  updateMediaUploadStatus(String mediaMessageId, int progress, int uploadStatus,
      num dataTransferred) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('updateMediaUploadStatus', {
        "mediaMessageId": mediaMessageId,
        "progress": progress,
        "downloadStatus": uploadStatus,
        "dataTransferred": dataTransferred
      });
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  cancelMediaUploadOrDownload(String messageId) async {
    try {
      LogMessage.d("cancelMediaUploadOrDownload", messageId);
      await mirrorFlyMethodChannel.invokeMethod(
          'cancelMediaUploadOrDownload', {"messageId": messageId});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  setMediaEncryption(bool encryption) async {
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('setMediaEncryption', {"encryption": encryption});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception ", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  deleteAllMessages() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('deleteAllMessages');
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception ", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String?> getGroupJid(String groupId) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod<String>('getGroupJid', {"groupId": groupId});
      LogMessage.d("getGroupJid Result ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> getUserLastSeenTime(
      String jid, Function(FlyResponse response)? callback) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod<String>('getUserLastSeenTime', {"jid": jid});
      LogMessage.d("getUserLastSeenTime Result ", " $response");
      callback?.call(FlyResponse(
          true, response ?? FlyConstants.empty, FlyConstants.empty));
      // return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String?> authToken() async {
    String? registerResponse = FlyConstants.empty;
    try {
      registerResponse =
          await mirrorFlyMethodChannel.invokeMethod<String>('authtoken');
      LogMessage.d("authToken Result ", " $registerResponse");

      return registerResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> registerUser(String userIdentifier,
      {String fcmToken = FlyConstants.empty,
      bool isForceRegister = true,
      String userType = "",
      List<IdentifierMetaData>? identifierMetaData,
      required Function(FlyResponse response) callback}) async {
    String? registerResponse;
    try {
      registerResponse =
          await mirrorFlyMethodChannel.invokeMethod('register_user', {
        "userIdentifier": userIdentifier,
        "token": fcmToken,
        "userType": userType,
        "isForceRegister": isForceRegister,
        "metaData": identifierMetaData != null
            ? List<dynamic>.from(identifierMetaData.map((x) => x.toMap()))
            : null
      });
      var res = convertRegisterUserJsonFromString(registerResponse);
      callback.call(FlyResponse(true, res, "Registered Successfully"));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String?> verifyToken(String userName, String token) async {
    String? response = FlyConstants.empty;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<String>(
          'verifyToken', {"userName": userName, "googleToken": token});
      LogMessage.d("verifyToken Result ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getJid(String username) async {
    //getuserjid
    String? userJID;
    try {
      userJID = await mirrorFlyMethodChannel
          .invokeMethod<String?>('get_jid', {"username": username});
      LogMessage.d("User JID Result ", " $userJID");
      return userJID ?? '';
    } on PlatformException catch (e) {
      LogMessage.d("Flutter Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Flutter Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> sendTextMessage(
      String message, String jid, String replyMessageId,
      {String? topicId}) async {
    String? messageResp;
    try {
      messageResp = await mirrorFlyMethodChannel.invokeMethod('send_text_msg', {
        "message": message,
        "JID": jid,
        "replyMessageId": replyMessageId,
        "topicId": topicId
      });
      return convertChatMessageJsonFromString(messageResp);
    } on PlatformException catch (e) {
      LogMessage.d("Flutter Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Flutter Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> sendLocationMessage(
      String jid, double latitude, double longitude, String replyMessageId,
      {String? topicId}) async {
    //sentLocationMessage
    String? messageResp;
    try {
      messageResp =
          await mirrorFlyMethodChannel.invokeMethod('sendLocationMessage', {
        "jid": jid,
        "latitude": latitude,
        "longitude": longitude,
        "replyMessageId": replyMessageId,
        "topicId": topicId
      });
      return convertChatMessageJsonFromString(messageResp);
    } on PlatformException catch (e) {
      LogMessage.d("Flutter Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Flutter Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> sendImageMessage(
      String jid, String filePath, String? caption, String? replyMessageID,
      {String? imageFileUrl, String? topicId}) async {
    String? messageResp;
    try {
      messageResp =
          await mirrorFlyMethodChannel.invokeMethod('send_image_message', {
        "jid": jid,
        "filePath": filePath,
        "caption": caption?.trim(),
        "replyMessageId": replyMessageID,
        "imageFileUrl": imageFileUrl,
        "topicId": topicId
      });
      return convertChatMessageJsonFromString(messageResp);
    } on PlatformException catch (e) {
      LogMessage.d("Image Message Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Image Message Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> sendVideoMessage(
      String jid, String filePath, String? caption, String? replyMessageID,
      {String? videoFileUrl,
      num? videoDuration,
      String? thumbImageBase64,
      String? topicId}) async {
    String? messageResp;
    try {
      messageResp =
          await mirrorFlyMethodChannel.invokeMethod('send_video_message', {
        "jid": jid,
        "filePath": filePath,
        "caption": caption?.trim(),
        "replyMessageId": replyMessageID,
        "videoFileUrl": videoFileUrl,
        "videoDuration": videoDuration,
        "thumbImageBase64": thumbImageBase64,
        "topicId": topicId
      });
      return convertChatMessageJsonFromString(messageResp);
    } on PlatformException catch (e) {
      LogMessage.d("Video Message Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Video Message Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> sendDocumentMessage(
      String jid, String documentPath, String replyMessageId,
      {String? fileUrl, String? topicId}) async {
    String? documentResponse;
    try {
      documentResponse =
          await mirrorFlyMethodChannel.invokeMethod('sendDocumentMessage', {
        "file": documentPath,
        "jid": jid,
        "replyMessageId": replyMessageId,
        "file_url": fileUrl,
        "topicId": topicId
      });
      return convertChatMessageJsonFromString(documentResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> sendAudioMessage(String jid, String filePath, bool isRecorded,
      String duration, String replyMessageId,
      {String? audioFileUrl, String? topicId}) async {
    //sendAudio
    String? audioResponse;
    try {
      audioResponse =
          await mirrorFlyMethodChannel.invokeMethod('sendAudioMessage', {
        "filePath": filePath,
        "jid": jid,
        "isRecorded": isRecorded,
        "duration": duration,
        "replyMessageId": replyMessageId,
        "audiofileUrl": audioFileUrl,
        "topicId": topicId
      });
      return convertChatMessageJsonFromString(audioResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> sendMediaFileMessage(
      {required FileMessage messageParams,
      required Function(FlyResponse response) callback}) async {
    LogMessage.d("sendMediaFileMessage", messageParams.toMap());
    //sendMediaFileMessage
    String? messageResponse;
    try {
      messageResponse = await mirrorFlyMethodChannel.invokeMethod(
          'sendMediaFileMessage', messageParams.toMap());
      var res = convertChatMessageJsonFromString(messageResponse);
      callback.call(FlyResponse(true, res, "message send successfully"));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> sendMessage(
      {required MessageParams messageParams,
      required Function(FlyResponse response) callback}) async {
    LogMessage.d("sendMessage", messageParams.toMap());
    //sendMessage
    String? messageResponse;
    try {
      messageResponse = await mirrorFlyMethodChannel.invokeMethod(
          'sendMessage', messageParams.toMap());
      var res = convertChatMessageJsonFromString(messageResponse);
      callback.call(FlyResponse(true, res, "message send successfully"));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> editTextMessage(
      {required EditMessageParams editMessageParams,
      required Function(FlyResponse response) callback}) async {
    LogMessage.d("editMessageParams", editMessageParams.toMap());
    String? editMessageResponse;
    try {
      editMessageResponse = await mirrorFlyMethodChannel.invokeMethod(
          'editTextMessage', editMessageParams.toMap());
      var res = convertChatMessageJsonFromString(editMessageResponse);
      callback.call(FlyResponse(true, res, "Message edited successfully"));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> editMediaCaption(
      {required EditMessageParams editMessageParams,
      required Function(FlyResponse response) callback}) async {
    LogMessage.d("editMediaCaptionParams", editMessageParams.toMap());
    String? editMessageResponse;
    try {
      editMessageResponse = await mirrorFlyMethodChannel.invokeMethod(
          'editMediaCaption', editMessageParams.toMap());
      var res = convertChatMessageJsonFromString(editMessageResponse);
      callback.call(FlyResponse(true, res, "Caption edited successfully"));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String> getRegisteredUserList({required bool server}) async {
    //getRegisteredUserList
    String? messageResp;
    try {
      messageResp = await mirrorFlyMethodChannel
          .invokeMethod('getRegisteredUsers', {'server': server});
      return convertUsersDataJsonFromString(messageResp);
    } on PlatformException catch (e) {
      LogMessage.d("User list Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("User list Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> getUserList(
      int page,
      String search,
      MetaDataUserList? metaDataUserList,
      Function(FlyResponse response)? callback,
      {int perPageResultSize = 20}) async {
    String? re;
    try {
      re = await mirrorFlyMethodChannel.invokeMethod("get_user_list", {
        "page": page,
        "search": search,
        "perPageResultSize": perPageResultSize,
        "metaDataUserList": metaDataUserList?.toMap()
      });
      var res = convertUsersDataJsonFromString(re);
      callback?.call(FlyResponse(true, res, "users list fetched"));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> getCallLogsList(
      int currentPage, Function(FlyResponse response)? callback) async {
    String? re;
    try {
      re = await mirrorFlyCallMethodChannel
          .invokeMethod("getCallLogsList", {"currentPage": currentPage});
      callback?.call(
          FlyResponse(true, convertCallLogsToJson(re), FlyConstants.empty));
      // return convertCallLogsToJson(re);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String> getLocalCallLogs() async {
    String? re;
    try {
      re =
          await mirrorFlyCallMethodChannel.invokeMethod("getLocalCallLogs", {});
      return convertCallLogsToJson(re);
    } on PlatformException catch (e) {
      LogMessage.d("er", "$e");
      return convertCallLogsToJson(re);
    }
  }

  @override
  Future<void> deleteCallLog(List<String> jidlist, bool isClearAll,
      Function(FlyResponse response)? callback) async {
    bool? re;
    try {
      re = await mirrorFlyCallMethodChannel.invokeMethod<bool>(
          "deleteCallLog", {"jidList": jidlist, "isClearAll": isClearAll});
      LogMessage.d('deleteCallLog ', '$re');
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return re ?? false;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String> getAvailableFeatures() async {
    String? re;
    try {
      re = await mirrorFlyMethodChannel.invokeMethod("getAvailableFeatures");
      return convertAvailableFeaturesToJson(re);
    } on PlatformException catch (e) {
      LogMessage.d("getAvailableFeatures error", "$e");
      rethrow;
    }
  }

  @override
  Future<String?> imagePath(String imgurl) async {
    try {
      final result = await mirrorFlyMethodChannel
          .invokeMethod<String>("get_image_path", {"image": imgurl});
      LogMessage.d('RESULT ', '$result');
      return result;
    } on PlatformException catch (e) {
      LogMessage.d("er", "$e");
      rethrow;
    }
  }

  /*@override
  Future<dynamic> saveProfile(String name, String email) async {
    dynamic result;
    try {
      result = await mirrorFlyMethodChannel.invokeMethod("updateProfile", {
        "name": name,
        "email": email,
      });
      LogMessage.d('RESULT', '$result');
      return result;
    } on PlatformException catch (e) {
      LogMessage.d("er ", "$e");
      rethrow;
    }
  }*/

  @override
  Future<String> sentFileMessage(String? file, String jid) async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod("sent file",
          {"file": file, "jid": jid, "message": FlyConstants.empty});
      return convertChatMessageJsonFromString(res);
    } on PlatformException catch (e) {
      LogMessage.d("er", "$e");
      return convertChatMessageJsonFromString(res);
    }
  }

  @override
  Future<void> getRecentChatList(
      Function(FlyResponse response)? callback) async {
    //getRecentChats
    String? recentResponse;
    try {
      recentResponse =
          await mirrorFlyMethodChannel.invokeMethod('getRecentChatList');
      callback?.call(FlyResponse(
          true,
          convertRecentChatDataJsonFromString(recentResponse),
          FlyConstants.empty));
      // return convertRecentChatDataJsonFromString(recentResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> getRecentChatListHistory(
      {required bool firstSet,
      int limit = 15,
      required Function(FlyResponse response)? callback}) async {
    //getRecentChats
    String? recentResponse;
    try {
      recentResponse = await mirrorFlyMethodChannel.invokeMethod(
          'getRecentChatListHistory', {"firstSet": firstSet, "limit": limit});
      var res = convertRecentChatDataJsonFromString(recentResponse);
      callback?.call(FlyResponse(true, res, "recent chats fetched"));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<bool> initializeMessageList(
      {required String userJid,
      String? messageId,
      String? chatId,
      double? messageTime,
      bool? exclude,
      int limit = 25,
      String? topicId,
      MetaDataMessageList? metaDataMessageList,
      bool ascendingOrder = true}) async {
    bool initializeResponse;
    try {
      initializeResponse =
          await mirrorFlyMethodChannel.invokeMethod('initializeMessageList', {
        "userJid": userJid,
        "messageId": messageId,
        "messageTime": messageTime,
        "exclude": exclude,
        "limit": limit,
        "ascendingOrder": ascendingOrder,
        "topicId": topicId,
        "metaDataMessageList": metaDataMessageList?.toMap()
      });
      LogMessage.d("initializeMessageList", "$initializeResponse");
      return initializeResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> loadMessages(Function(FlyResponse response)? callback) async {
    String? initialMessageResponse;
    try {
      initialMessageResponse =
          await mirrorFlyMethodChannel.invokeMethod('loadMessages');
      var res = convertChatMessagesJsonFromString(initialMessageResponse);
      callback?.call(FlyResponse(true, res, "load message fetched"));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<bool> hasPreviousMessages() async {
    bool hasPreviousMessages;
    try {
      hasPreviousMessages =
          await mirrorFlyMethodChannel.invokeMethod('hasPreviousMessages');
      LogMessage.d("hasPreviousMessages", "$hasPreviousMessages");
      return hasPreviousMessages;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> loadPreviousMessages(
      Function(FlyResponse response) callback) async {
    String? previousMessageResponse;
    try {
      previousMessageResponse =
          await mirrorFlyMethodChannel.invokeMethod('loadPreviousMessages');
      var res = convertChatMessagesJsonFromString(previousMessageResponse);
      callback.call(FlyResponse(true, res, "load previous messages fetched"));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<bool> hasNextMessages() async {
    bool hasNextMessages;
    try {
      hasNextMessages =
          await mirrorFlyMethodChannel.invokeMethod('hasNextMessages');
      LogMessage.d("hasNextMessages", "$hasNextMessages");
      return hasNextMessages;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> loadNextMessages(Function(FlyResponse response) callback) async {
    String? nextMessageResponse;
    try {
      nextMessageResponse =
          await mirrorFlyMethodChannel.invokeMethod('loadNextMessages');
      var res = convertChatMessagesJsonFromString(nextMessageResponse);
      callback.call(FlyResponse(true, res, "load Next messages fetched"));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String> getProfileStatusList() async {
    //getStatusList
    String? statusResponse;
    try {
      statusResponse =
          await mirrorFlyMethodChannel.invokeMethod('getProfileStatusList');
      return convertStatusListFromJson(statusResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> insertDefaultStatus(String status) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('insertDefaultStatus', {"status": status});
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> updateMyProfile(
      String name,
      String? email,
      String? mobile,
      String? status,
      String? image,
      Function(FlyResponse response)? callback) async {
    //updateProfile
    String? profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel.invokeMethod(
          'updateMyProfile', {
        "name": name,
        "email": email,
        "mobile": mobile,
        "status": status,
        "image": image
      });
      var res = convertProfileUpdateJsonFromString(profileResponse);
      callback?.call(FlyResponse(true, res, "user profile updated"));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> getUserProfile(
      String jid, Function(FlyResponse response)? callback,
      [bool fromserver = false, bool saveasfriend = false]) async {
    String? profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel.invokeMethod(
          'getUserProfile',
          {"jid": jid, "server": fromserver, "saveasfriend": saveasfriend});
      var res = convertProfileJsonFromString(profileResponse);
      callback?.call(FlyResponse(true, res, "user profile fetched"));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String> getProfileDetails(String jid) async {
    String? profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel
          .invokeMethod('getProfileDetails', {"jid": jid});
      LogMessage.d("getProfileDetails", profileResponse);
      return convertProfileDetailJsonFromString(profileResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  /*@override
  Future<dynamic> getProfileLocal(String jid, bool server) async {
    dynamic profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel.invokeMethod('getUserProfile', {"jid": jid, "server": server});
      LogMessage.d("getProfileLocal Result ", " $profileResponse");
      return profileResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }*/

  @override
  Future<void> setMyProfileStatus(String status, String statusId,
      Function(FlyResponse response)? callback) async {
    //updateProfileStatus
    dynamic profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel.invokeMethod(
          'setMyProfileStatus', {"status": status, "statusId": statusId});
      LogMessage.d("setMyProfileStatus Result ", " $profileResponse");
      callback?.call(FlyResponse(true, profileResponse, FlyConstants.empty));
      // return profileResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<bool?> insertNewProfileStatus(String status) async {
    bool? profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel
          .invokeMethod<bool>('insertNewProfileStatus', {"status": status});
      LogMessage.d("insertNewProfileStatus Result ", " $profileResponse");
      return profileResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> updateMyProfileImage(
      String image, Function(FlyResponse response)? callback) async {
    //updateProfileImage
    String? profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel
          .invokeMethod('updateMyProfileImage', {"image": image});
      var res = convertProfileUpdateJsonFromString(profileResponse);
      callback?.call(FlyResponse(true, res, "user profile image updated"));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> removeProfileImage(
      Function(FlyResponse response)? callback) async {
    bool? profileResponse;
    try {
      profileResponse =
          await mirrorFlyMethodChannel.invokeMethod<bool>('removeProfileImage');
      LogMessage.d("removeProfileImage Result ", " $profileResponse");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return profileResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> removeGroupProfileImage(
      String jid, Function(FlyResponse response)? callback) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod<bool>('removeGroupProfileImage', {"jid": jid});
      LogMessage.d("grp_image Result ", " $response");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> refreshAndGetAuthToken(
      Function(FlyResponse response)? callback) async {
    String? tokenResponse;
    try {
      tokenResponse =
          await mirrorFlyMethodChannel.invokeMethod<String>('refreshAuthToken');
      LogMessage.d("refreshAuthToken Result ", " $tokenResponse");
      callback?.call(FlyResponse(
          true, tokenResponse ?? FlyConstants.empty, FlyConstants.empty));
      // return tokenResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String> getCurrentAuthToken() async {
    String? tokenResponse;
    try {
      tokenResponse = await mirrorFlyMethodChannel
          .invokeMethod<String>('getCurrentAuthToken');
      LogMessage.d("getCurrentAuthToken Result ", " $tokenResponse");
      return tokenResponse ?? FlyConstants.empty;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getMessagesOfJid(String jid) async {
    //getChatHistory
    String? chatResponse;
    try {
      chatResponse = await mirrorFlyMethodChannel
          .invokeMethod('getMessagesOfJid', {"JID": jid});
      return convertChatMessagesJsonFromString(chatResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  //Removed and added in MainActivity.kt during configuration. User just need to listen the event after initialization

  /*
@override
 Future<dynamic> listenMessageEvents() async {
    dynamic chatListenerResponse;
    try {
      chatListenerResponse = await mirrorFlyMethodChannel.invokeMethod('chat_listener');
      LogMessage.d("chatListenerResponse "," $chatListenerResponse");
      return chatListenerResponse;
    }on PlatformException catch (e){
      LogMessage.d("Platform Exception ="," $e");
      rethrow;
    } on Exception catch(error){
      LogMessage.d("Exception "," $error");
      rethrow;
    }
  }

@override
 Future<dynamic> listenGroupChatEvents() async {
    dynamic chatListenerResponse;
    try {
      chatListenerResponse = await mirrorFlyMethodChannel.invokeMethod('groupchat_listener');
      LogMessage.d("groupchatListenerResponse "," $chatListenerResponse");
      return chatListenerResponse;
    }on PlatformException catch (e){
      LogMessage.d("Platform Exception ="," $e");
      rethrow;
    } on Exception catch(error){
      LogMessage.d("Exception "," $error");
      rethrow;
    }
  }*/

  //Duplicate method call of getMessageOfId
  //
  //@override
  //Future<dynamic> getMedia(String mid) async {
  //   dynamic media;
  //   try {//
  //     media = await mirrorFlyMethodChannel.invokeMethod('get_media',{ "message_id" : mid });
  //     // LogMessage.d("mediaResponse "," $media");
  //     return media;
  //   }on PlatformException catch (e){
  //     LogMessage.d("Platform Exception ="," $e");
  //     rethrow;
  //   } on Exception catch(error){
  //     LogMessage.d("Exception "," $error");
  //     rethrow;
  //   }
  // }

  @override
  Future<bool?> markAsReadDeleteUnreadSeparator(String jid) async {
    //sendReadReceipts
    //Handled Both Functions ChatManager.markAsRead and FlyMessenger.deleteUnreadMessageSeparatorOfAConversation in this same Function
    bool? readReceiptResponse;
    try {
      readReceiptResponse = await mirrorFlyMethodChannel
          .invokeMethod<bool>('markAsReadDeleteUnreadSeparator', {"jid": jid});
      // LogMessage.d("mediaResponse "," $readReceiptResponse");
      return readReceiptResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> sendContactMessage(List<String> contactList, String jid,
      String contactName, String replyMessageId,
      {String? topicId}) async {
    String? contactResponse;
    try {
      contactResponse =
          await mirrorFlyMethodChannel.invokeMethod('sendContactMessage', {
        "contact_list": contactList,
        "jid": jid,
        "contact_name": contactName,
        "replyMessageId": replyMessageId,
        "topicId": topicId
      });
      return convertChatMessageJsonFromString(contactResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> logoutOfChatSDK(Function(FlyResponse response)? callback) async {
    //logout
    bool? logoutResponse;
    try {
      logoutResponse =
          await mirrorFlyMethodChannel.invokeMethod<bool>('logoutOfChatSDK');
      LogMessage.d("logoutResponse ", " $logoutResponse");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return logoutResponse ?? false;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  setOnGoingChatUser(String jid) async {
    //ongoingChat
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('setOnGoingChatUser', {"jid": jid});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  downloadMedia(String mid) async {
    //mediaDownload
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('downloadMedia', {"mediaMessage_id": mid});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  /*@override
  Future<dynamic> openFile(String filePath) async {
    dynamic documentResponse;
    try {
      documentResponse = await mirrorFlyMethodChannel.invokeMethod('open_file', {"filePath": filePath});
      LogMessage.d("documentResponse ", " $documentResponse");
      return documentResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }*/

  //Recent Chat Search

  @override
  Future<String> getRecentChatListIncludingArchived() async {
    //filteredRecentChatList
    String? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod('getRecentChatListIncludingArchived');
      return convertRecentChatListFromJson(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> searchConversation(String searchKey,
      [String? jidForSearch,
      bool globalSearch = true,
      Function(FlyResponse response)? callback]) async {
    //filteredMessageList
    String? response;
    try {
      response =
          await mirrorFlyMethodChannel.invokeMethod('searchConversation', {
        "searchKey": searchKey,
        "jidForSearch": jidForSearch,
        "globalSearch": globalSearch
      });
      callback?.call(FlyResponse(true,
          convertChatMessagesJsonFromString(response), FlyConstants.empty));
      // return convertChatMessagesJsonFromString(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> getRegisteredUsers(
      bool server, Function(FlyResponse response)? callback) async {
    //filteredContactList
    String? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod('getRegisteredUsers', {"server": server});
      var res = convertUsersDataJsonFromString(response);
      callback?.call(FlyResponse(true, res, "users list fetched"));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String> getMessageOfId(String mid) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod('getMessageOfId', {"mid": mid});
      return convertChatMessageJsonFromString(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getRecentChatOf(String jid) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod('getRecentChatOf', {"jid": jid});
      return convertRecentChatFromJson(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> clearChat(String jid, String chatType, bool clearExceptStarred,
      Function(FlyResponse response)? callback) async {
    bool? clearChatResponse;
    try {
      clearChatResponse = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'clear_chat', {
        "jid": jid,
        "chat_type": chatType,
        "clear_except_starred": clearExceptStarred
      });
      LogMessage.d("clearChat ", " $clearChatResponse");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return clearChatResponse ?? false;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  //Duplicate of reportUserOrMessages
  /*
@override
 Future<dynamic> reportChatOrUser(String jid, String chatType, String? messageId) async {
    dynamic reportResponse;
    try {
      reportResponse = await mirrorFlyMethodChannel.invokeMethod('report_chat',{ "jid" : jid, "chat_type" : chatType, "selectedMessageID" : messageId});
      LogMessage.d("clear chat Response "," $reportResponse");
      return reportResponse;
    }on PlatformException catch (e){
      LogMessage.d("Platform Exception ="," $e");
      rethrow;
    } on Exception catch(error){
      LogMessage.d("Exception "," $error");
      rethrow;
    }
  }*/

  @override
  Future<String> getMessagesUsingIds(List<String> messageIds) async {
    String? messageListResponse;
    try {
      messageListResponse = await mirrorFlyMethodChannel
          .invokeMethod('getMessagesUsingIds', {"MessageIds": messageIds});
      return convertChatMessagesJsonFromString(messageListResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  //Handled deleteMessagesForEveryone and deleteMessagesForMe in same function. so Named Commonly

  @override
  Future<void> deleteMessagesForMe(
      String jid,
      String chatType,
      List<String> messageIds,
      bool? isMediaDelete,
      Function(FlyResponse response)? callback) async {
    bool? messageDeleteResponse;
    try {
      messageDeleteResponse = await mirrorFlyMethodChannel
          .invokeMethod<bool>('deleteMessagesForMe', {
        "jid": jid,
        "chat_type": chatType,
        "isMediaDelete": isMediaDelete,
        "message_ids": messageIds
      });
      LogMessage.d("deleteMessagesForMe Response ", " $messageDeleteResponse");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return messageDeleteResponse ?? false;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> deleteMessagesForEveryone(
      String jid,
      String chatType,
      List<String> messageIds,
      bool? isMediaDelete,
      Function(FlyResponse response)? callback) async {
    bool? messageDeleteResponse;
    try {
      messageDeleteResponse = await mirrorFlyMethodChannel
          .invokeMethod<bool>('deleteMessagesForEveryone', {
        "jid": jid,
        "chat_type": chatType,
        "isMediaDelete": isMediaDelete,
        "message_ids": messageIds
      });
      LogMessage.d(
          "deleteMessagesForEveryone Response ", " $messageDeleteResponse");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return messageDeleteResponse ?? false;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  /*@override
  Future<dynamic> deleteMessages(String jid, List<String> messageIds, bool isDeleteForEveryOne) async {
    dynamic messageDeleteResponse;
    try {
      messageDeleteResponse = await mirrorFlyMethodChannel.invokeMethod(
          'delete_messages', {"jid": jid, "chat_type": "chat", "message_ids": messageIds, "is_delete_for_everyone": isDeleteForEveryOne});
      LogMessage.d("Message Delete Response ", " $messageDeleteResponse");
      return messageDeleteResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }*/

  @override
  Future<String> getGroupMessageDeliveredToList(
      String messageId, String jid) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod(
          'getGroupMessageDeliveredToList',
          {"messageId": messageId, "jid": jid});
      // callback?.call(FlyResponse(true, convertMessageDeliveredStatusToJson(response), FlyConstants.empty));
      return convertMessageDeliveredStatusToJson(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      // callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty, FlyException(e.code, e.message, e.details)));
      rethrow;
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      // callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty, FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
      rethrow;
    }
  }

  @override
  Future<void> getGroupMessageDeliveredRecipients(String messageId, String jid,
      Function(FlyResponse response)? callback) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod(
          'getGroupMessageDeliveredToList',
          {"messageId": messageId, "jid": jid});
      callback?.call(FlyResponse(true,
          convertMessageDeliveredStatusToJson(response), FlyConstants.empty));
      // return convertMessageDeliveredStatusToJson(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String> getGroupMessageReadByList(String messageId, String jid) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod(
          'getGroupMessageReadByList', {"messageId": messageId, "jid": jid});
      // callback?.call(FlyResponse(true, convertMessageDeliveredStatusToJson(response), FlyConstants.empty));
      return convertMessageDeliveredStatusToJson(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      // callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty, FlyException(e.code, e.message, e.details)));
      rethrow;
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      // callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty, FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
      rethrow;
    }
  }

  @override
  Future<void> getGroupMessageSeenRecipients(String messageId, String jid,
      Function(FlyResponse response)? callback) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod(
          'getGroupMessageReadByList', {"messageId": messageId, "jid": jid});
      callback?.call(FlyResponse(true,
          convertMessageDeliveredStatusToJson(response), FlyConstants.empty));
      // return convertMessageDeliveredStatusToJson(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String> getMessageStatusOfASingleChatMessage(String messageID) async {
    //getMessageInfo
    String messageInfoResponse;
    try {
      messageInfoResponse = await mirrorFlyMethodChannel.invokeMethod(
          'getMessageStatusOfASingleChatMessage', {"messageID": messageID});
      LogMessage.d("Message Info Response ", " $messageInfoResponse");
      return convertChatMessageStatusDetailToJson(messageInfoResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> blockUser(
      String userJID, Function(FlyResponse response)? callback) async {
    bool? userBlockResponse;
    try {
      userBlockResponse = await mirrorFlyMethodChannel
          .invokeMethod<bool>('block_user', {"userJID": userJID});
      LogMessage.d("blockUser Response ", " $userBlockResponse");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return userBlockResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> unblockUser(
      String userJID, Function(FlyResponse response)? callback) async {
    //unBlockUser
    bool? userBlockResponse;
    try {
      userBlockResponse = await mirrorFlyMethodChannel
          .invokeMethod<bool>('un_block_user', {"userJID": userJID});
      LogMessage.d("unblockUser Response ", " $userBlockResponse");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return userBlockResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String?> showCustomTones() async {
    String? response;
    try {
      response =
          await mirrorFlyMethodChannel.invokeMethod<String>('showCustomTones');
      LogMessage.d("showCustomTones Response ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String?> getRingtoneName() async {
    String? response;
    try {
      response =
          await mirrorFlyMethodChannel.invokeMethod<String>('getRingtoneName');
      LogMessage.d("getRingtoneName Response ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> loginWebChatViaQRCode(
      String barcode, Function(FlyResponse response)? callback) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod<bool>('loginWebChatViaQRCode', {"barcode": barcode});
      LogMessage.d("loginWebChatViaQRCode Response ", " $response");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<bool?> webLoginDetailsCleared() async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod<bool>('webLoginDetailsCleared');
      LogMessage.d("webLoginDetailsCleared Response ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> logoutWebUser(List<String> logins) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod<bool>('logoutWebUser', {"listWebLogin": logins});
      LogMessage.d("logoutWebUser Response ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> iOSFileExist(String filePath) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod<bool>('iOSFileExist', {"file_path": filePath});
      LogMessage.d("iOSFileExist Response ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<dynamic> getWebLoginDetails() async {
    dynamic response;
    try {
      response =
          await mirrorFlyMethodChannel.invokeMethod('getWebLoginDetails');
      LogMessage.d("getWebLoginDetails Response ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> updateFavouriteStatus(
      String messageID,
      String chatUserJID,
      bool isFavourite,
      String chatType,
      Function(FlyResponse response)? callback) async {
    //favouriteMessage
    bool? favResponse;
    try {
      favResponse = await mirrorFlyMethodChannel
          .invokeMethod<bool>('updateFavouriteStatus', {
        "messageID": messageID,
        "chatUserJID": chatUserJID,
        "isFavourite": isFavourite,
        "chatType": chatType,
      });
      LogMessage.d("Favourite Msg Response ", " $favResponse");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return favResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> forwardMessagesToMultipleUsers(List<String> messageIds,
      List<String> userList, Function(FlyResponse response)? callback) async {
    //forwardMessage
    bool? forwardMessageResponse;
    try {
      forwardMessageResponse = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'forwardMessagesToMultipleUsers',
          {"message_ids": messageIds, "userList": userList});
      LogMessage.d("Forward Msg Response ", " $forwardMessageResponse");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return forwardMessageResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  /*@override
  Future<dynamic> forwardMessages(List<String> messageIds, String tojid, String chattype) async {
    //forwardMessage
    dynamic forwardMessageResponse;
    try {
      forwardMessageResponse =
      await mirrorFlyMethodChannel.invokeMethod('forwardMessages', {"message_ids": messageIds, "to_jid": tojid, "chat_type": chattype});
      LogMessage.d("forwardMessages Response ", " $forwardMessageResponse");
      return forwardMessageResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }*/

  @override
  Future<void> createGroup(String groupName, List<String> userJidList,
      String imageFilePath, Function(FlyResponse response)? callback) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('createGroup', {
        "group_name": groupName,
        "members": userJidList,
        "file": imageFilePath,
      });
      LogMessage.d("create group Response ", " $response");
      callback?.call(FlyResponse(
          true, response ?? FlyConstants.empty, FlyConstants.empty));
      // return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> addUsersToGroup(String jid, List<String> userList,
      Function(FlyResponse response)? callback) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'addUsersToGroup', {"jid": jid, "members": userList});
      LogMessage.d("addUsersToGroup Response ", " $response");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> getGroupMembersList(String jid, bool? server,
      Function(FlyResponse response)? callback) async {
    //getGroupMembers
    String? response;
    try {
      response =
          await mirrorFlyMethodChannel.invokeMethod('getGroupMembersList', {
        "jid": jid,
        "server": server,
      });
      callback?.call(FlyResponse(true,
          convertProfileDetailsJsonFromString(response), FlyConstants.empty));
      // return convertProfileDetailsJsonFromString(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> getUsersIBlocked(
      bool? server, Function(FlyResponse response)? callback) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getUsersIBlocked', {
        "serverCall": server,
      });
      callback?.call(FlyResponse(true,
          convertProfileDetailsJsonFromString(response), FlyConstants.empty));
      // return convertProfileDetailsJsonFromString(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String> getMediaMessages(String jid) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getMediaMessages', {
        "jid": jid,
      });
      return convertChatMessagesJsonFromString(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getDocsMessages(String jid) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getDocsMessages', {
        "jid": jid,
      });
      return convertChatMessagesJsonFromString(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getLinkMessages(String jid) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getLinkMessages', {
        "jid": jid,
      });
      return convertChatMessagesJsonFromString(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> exportChatConversationToEmail(
      String jid, Function(FlyResponse response)? callback) async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod('exportChatConversationToEmail', {"jid": jid});
      callback?.call(FlyResponse(
          true, convertExportJsonFromString(res), FlyConstants.empty));
      // return convertExportJsonFromString(res);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> reportUserOrMessages(String jid, String type, String? messageId,
      Function(FlyResponse response)? callback) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'reportUserOrMessages',
          {"jid": jid, "chat_type": type, "selectedMessageID": messageId});
      LogMessage.d("report Result ", " $response");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> makeAdmin(String groupjid, String userjid,
      Function(FlyResponse response)? callback) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'makeAdmin', {"jid": groupjid, "userjid": userjid});
      LogMessage.d("report Result ", " $response");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> removeMemberFromGroup(String groupjid, String userjid,
      Function(FlyResponse response)? callback) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'removeMemberFromGroup', {"jid": groupjid, "userjid": userjid});
      LogMessage.d("report Result ", " $response");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> leaveFromGroup(String? userJid, String groupJid,
      Function(FlyResponse response)? callback) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'leaveFromGroup', {"userJid": userJid, "groupJid": groupJid});
      LogMessage.d("leaveFromGroup Result ", " $response");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> deleteGroup(
      String jid, Function(FlyResponse response)? callback) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod<bool>('deleteGroup', {"jid": jid});
      LogMessage.d("deleteGroup Result ", " $response");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<bool?> isAdmin(String userJid, String groupJID) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'isAdmin', {"jid": userJid, "group_jid": groupJID});
      LogMessage.d("isAdmin Result ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      return false;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      return false;
    }
  }

  @override
  Future<void> updateGroupProfileImage(
      String jid, String file, Function(FlyResponse response)? callback) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'updateGroupProfileImage', {"jid": jid, "file": file});
      LogMessage.d("updateGroupProfileImage Result ", " $response");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> updateGroupName(
      String jid, String name, Function(FlyResponse response)? callback) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod<bool>('updateGroupName', {"jid": jid, "name": name});
      LogMessage.d("updateGroupName Result ", " $response");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<bool?> isMemberOfGroup(String jid, String? userJid) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'isMemberOfGroup', {"jid": jid, "userjid": userJid});
      LogMessage.d("isMemberOfGroup Result ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      return false;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      return false;
    }
  }

  @override
  Future<void> sendContactUsInfo(String title, String description,
      Function(FlyResponse response)? callback) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'sendContactUsInfo', {"title": title, "description": description});
      LogMessage.d("sendContactUsInfo Result ", " $response");
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  copyTextMessages(List<String> messageIds) async {
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('copyTextMessages', {"messageidlist": messageIds});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  saveUnsentMessage(String jid, String message) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod(
          'saveUnsentMessage', {"jid": jid, "texMessage": message});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount(String reason, String? feedback,
      Function(FlyResponse response)? callback) async {
    // bool? response;
    try {
      await mirrorFlyMethodChannel.invokeMethod<bool>('delete_account',
          {"delete_reason": reason, "delete_feedback": feedback});
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String> getFavouriteMessages() async {
    String? favResponse;
    try {
      favResponse =
          await mirrorFlyMethodChannel.invokeMethod('get_favourite_messages');
      return convertChatMessagesJsonFromString(favResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> getAllGroups(
      [bool? server, Function(FlyResponse response)? callback]) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod('getAllGroups', {"server": server});
      callback?.call(FlyResponse(true,
          convertProfileDetailsJsonFromString(response), FlyConstants.empty));
      // return convertProfileDetailsJsonFromString(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String?> getDefaultNotificationUri() async {
    String? uri = FlyConstants.empty;
    try {
      uri = await mirrorFlyMethodChannel
          .invokeMethod<String?>('getDefaultNotificationUri');
      return uri;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  setDefaultNotificationSound() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('setDefaultNotificationSound');
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  setNotificationSound(bool enable) async {
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('setNotificationSound', {"enable": enable});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> getNotificationSound() async {
    bool? isEnabled = false;
    try {
      isEnabled =
          await mirrorFlyMethodChannel.invokeMethod('getNotificationSound');
      return isEnabled;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  setMuteNotification(bool enable) async {
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('setMuteNotification', {"enable": enable});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  setNotificationVibration(bool enable) async {
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('setNotificationVibration', {"enable": enable});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  /*@override
  cancelNotifications() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('cancelNotifications');
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }*/

  @override
  saveMediaSettings(bool photos, bool videos, bool audio, bool documents,
      int networkType) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('saveMediaSettings', {
        'Photos': photos,
        'Videos': videos,
        'Audio': audio,
        'Documents': documents,
        'NetworkType': networkType
      });
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> getMediaSetting(int networkType, String type) async {
    bool? val = false;
    try {
      val = await mirrorFlyMethodChannel.invokeMethod<bool?>(
          'getMediaSetting', {"NetworkType": networkType, "type": type});
      return val;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> getMediaAutoDownload() async {
    bool? val = false;
    try {
      val = await mirrorFlyMethodChannel
          .invokeMethod<bool?>('getMediaAutoDownload');
      LogMessage.d("getMediaAutoDownload", "$val");
      return val;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  setMediaAutoDownload(bool enable) async {
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('setMediaAutoDownload', {'enable': enable});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String?> getJidFromPhoneNumber(
      String mobileNumber, String countryCode) async {
    String? jid = FlyConstants.empty;
    try {
      jid = await mirrorFlyMethodChannel.invokeMethod<String?>(
          'getJidFromPhoneNumber',
          {"mobileNumber": mobileNumber, "countryCode": countryCode});
      return jid;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> isTrailLicence() async {
    bool? val = true;
    try {
      val =
          await mirrorFlyMethodChannel.invokeMethod<bool?>('IS_TRIAL_LICENSE');
      LogMessage.d('isTrailLicence', '$val');
      return val;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getNonChatUsers() async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod('getNonChatUsers');
      return convertProfileDetailsJsonFromString(res);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> addContact(String number, String name) async {
    bool? val = true;
    try {
      val = await mirrorFlyMethodChannel
          .invokeMethod('addContact', {'number': number, 'name': name});
      LogMessage.d('addContact', number);
      return val;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future setRegionCode(String regionCode) async {
    try {
      LogMessage.d('setRegionCode', regionCode);
      await mirrorFlyMethodChannel
          .invokeMethod('setRegionCode', {'regionCode': regionCode});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getValueFromManifestOrInfoPlist(
      {String? androidManifestKey, String? iOSPlistKey}) async {
    String? val = FlyConstants.empty;
    try {
      if (Platform.isAndroid) {
        val = await mirrorFlyMethodChannel
            .invokeMethod('getManifestValue', {'key': androidManifestKey});
        LogMessage.d('getValueFromManifestOrInfoPlist Android', ' $val');
        return val ?? FlyConstants.empty;
      } else if (Platform.isIOS) {
        val = await mirrorFlyMethodChannel
            .invokeMethod('getPlistValue', {'key': iOSPlistKey});
        LogMessage.d('getValueFromManifestOrInfoPlist iOS', ' $val');
        return val ?? FlyConstants.empty;
      } else {
        return val;
      }
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> createTopic(
      {required String topicName,
      List<TopicMetaData> metaData = const [],
      Function(FlyResponse response)? callback}) async {
    String? topicId = FlyConstants.empty;
    List<Map<String, dynamic>>? topic =
        metaData.map((topic) => topic.toMap()).toList();
    LogMessage.d("createTopic", topic);
    //if (metaData.length <= 3) {
    try {
      topicId = await mirrorFlyMethodChannel.invokeMethod(
          'createTopic', {'topicName': topicName, 'metaData': topic});
      LogMessage.d('createTopic', ' $topicId');
      callback?.call(FlyResponse(
          true, topicId ?? FlyConstants.empty, "Topic created successfully"));
      // return topicId;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
      // rethrow;
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
      // rethrow;
    }
    // } else {
    //   throw Exception("topicData Maximum Size is 3");
    // }
  }

  @override
  Future<void> getTopics(
      {required List<String> topicIds,
      Function(FlyResponse response)? callback}) async {
    String? val = FlyConstants.empty;
    try {
      val = await mirrorFlyMethodChannel
          .invokeMethod('getTopics', {'topicIds': topicIds});
      LogMessage.d('getTopics', ' $val');
      callback?.call(
          FlyResponse(true, val ?? FlyConstants.empty, FlyConstants.empty));
      // return val;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> getRecentChatListHistoryByTopic(
      {String? topicId,
      required bool firstSet,
      int limit = 15,
      required Function(FlyResponse response) callback}) async {
    //getRecentChats
    String? recentResponse;
    try {
      LogMessage.d("getRecentChatListHistoryByTopic", "firstSet $firstSet");
      recentResponse = await mirrorFlyMethodChannel.invokeMethod(
          'getRecentChatListHistoryByTopic',
          {"topicId": topicId, "firstSet": firstSet, "limit": limit});
      var res = convertRecentChatDataJsonFromString(recentResponse);
      callback.call(FlyResponse(true, res, "recent chats by topic fetched"));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> makeVideoCall(
      String userJid, Function(FlyResponse response)? callback) async {
    // bool val;
    try {
      LogMessage.d('makeVideoCall :', userJid);
      await mirrorFlyCallMethodChannel
          .invokeMethod('makeVideoCall', {"user_jid": userJid});
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return val;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> makeVoiceCall(
      String userJid, Function(FlyResponse response)? callback) async {
    // bool val;
    try {
      LogMessage.d('makeVoiceCall :', userJid);
      await mirrorFlyCallMethodChannel
          .invokeMethod('makeVoiceCall', {"user_jid": userJid});
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return val;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> makeGroupVoiceCall(String groupJid, List<String>? jidList,
      Function(FlyResponse response)? callback) async {
    // bool val;
    try {
      LogMessage.d(
          'makeGroupVoiceCall :', "groupJid : $groupJid, jidList : $jidList");
      await mirrorFlyCallMethodChannel.invokeMethod(
          'makeGroupVoiceCall', {"groupJid": groupJid, "jidList": jidList});
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return val;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> makeGroupVideoCall(String groupJid, List<String>? jidList,
      Function(FlyResponse response)? callback) async {
    // bool val;
    try {
      LogMessage.d(
          'makeGroupVideoCall :', "groupJid : $groupJid, jidList : $jidList");
      await mirrorFlyCallMethodChannel.invokeMethod(
          'makeGroupVideoCall', {"groupJid": groupJid, "jidList": jidList});
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return val;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String> getCallUsersList() async {
    String callList;
    try {
      callList =
          await mirrorFlyCallMethodChannel.invokeMethod('getCallUsersList');
      LogMessage.d('getCallUsers :', callList);
      return callList;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getCallType() async {
    String callType;
    try {
      LogMessage.d('getCallType :', '');
      callType = await mirrorFlyCallMethodChannel.invokeMethod('getCallType');
      return callType;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getCallGroupJid() async {
    String getGroupId;
    try {
      LogMessage.d('getCallGroupJid :', '');
      getGroupId = await mirrorFlyCallMethodChannel.invokeMethod('getGroupID');
      return getGroupId;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getCallDirection() async {
    String callDirection;
    try {
      LogMessage.d('getCallDirection :', '');
      callDirection =
          await mirrorFlyCallMethodChannel.invokeMethod('getCallDirection');
      return callDirection;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getAllAvailableAudioInput() async {
    String? audioInput;
    try {
      audioInput = await mirrorFlyCallMethodChannel
          .invokeMethod('getAllAvailableAudioInput');
      return convertAudioDevicesToJson(audioInput);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception ===>", "$e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ==>", "$error");
      rethrow;
    }
  }

  @override
  switchCamera() async {
    try {
      LogMessage.d('switchCamera :', '');
      await mirrorFlyCallMethodChannel.invokeMethod('switchCamera');
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> declineCall() async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel.invokeMethod('declineCall');
      LogMessage.d('declineCall', '$res');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> muteAudio(
      bool status, Function(FlyResponse response)? callback) async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel
          .invokeMethod('muteAudio', {"muteAudio": status});
      LogMessage.d('muteAudio', '$res');
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> muteVideo(
      bool status, Function(FlyResponse response)? callback) async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel
          .invokeMethod('muteVideo', {"muteVideo": status});
      LogMessage.d('muteVideo', '$res');
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<bool?> routeAudioTo({required String routeType}) async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel
          .invokeMethod('routeAudioTo', {"routeType": routeType});
      LogMessage.d('muteAudio', '$res');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> isOnGoingCall() async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel.invokeMethod('isOnGoingCall');
      LogMessage.d('isOnGoingCall', '$res');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> disconnectCall(Function(FlyResponse response)? callback) async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel.invokeMethod('disconnectCall');
      LogMessage.d('disconnectCall', '$res');
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<String?> selectedAudioDevice() async {
    String? res;
    try {
      res =
          await mirrorFlyCallMethodChannel.invokeMethod('selectedAudioDevice');
      LogMessage.d('selectedAudioDevice', '$res');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> isUserAudioMuted([String? userJid]) async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel
          .invokeMethod('isUserAudioMuted', {"userJid": userJid});
      LogMessage.d('isUserAudioMuted', '$res');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> isUserVideoMuted([String? userJid]) async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel
          .invokeMethod('isUserVideoMuted', {"userJid": userJid});
      LogMessage.d('isUserVideoMuted', '$res');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<int?> getUnreadMissedCallCount() async {
    int? res;
    try {
      res = await mirrorFlyCallMethodChannel
          .invokeMethod<int>('getUnreadMissedCallCount');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> appLaunchedFromMissedCall() async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('appLaunchedFromMissedCall');
      LogMessage.d('appLaunchedFromMissedCall', '$res');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<MirrorflyNotificationAppLaunchDetails?> getAppLaunchedDetails() async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<String>('appLaunchedDetails');
      LogMessage.d('getAppLaunchedDetails', '$res');
      return mirrorflyNotificationAppLaunchDetailsFromJson(res ?? "");
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String?> openAudioFilePicker() async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod('openAudioFilePicker');
      LogMessage.d('openAudioFilePicker', '$res');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool> requestVideoCallSwitch() async {
    bool res;
    try {
      res = await mirrorFlyCallMethodChannel
          .invokeMethod('requestVideoCallSwitch');
      LogMessage.d('requestVideoCallSwitch', '$res');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool> cancelVideoCallSwitch() async {
    bool res;
    try {
      res = await mirrorFlyCallMethodChannel
          .invokeMethod('cancelVideoCallSwitch');
      LogMessage.d('cancelVideoCallSwitch', '$res');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool> acceptVideoCallSwitchRequest() async {
    bool res;
    try {
      res = await mirrorFlyCallMethodChannel
          .invokeMethod('acceptVideoCallSwitchRequest');
      LogMessage.d('acceptVideoCallSwitchRequest', '$res');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool> declineVideoCallSwitchRequest() async {
    bool res;
    try {
      res = await mirrorFlyCallMethodChannel
          .invokeMethod('declineVideoCallSwitchRequest');
      LogMessage.d('declineVideoCallSwitchRequest', '$res');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<int?> getMaxCallUsersCount() async {
    int? res;
    try {
      res =
          await mirrorFlyCallMethodChannel.invokeMethod('getMaxCallUsersCount');
      LogMessage.d('getMaxCallUsersCount', '$res');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<void> inviteUsersToOngoingCall(
      List<String>? jidList, Function(FlyResponse response)? callback) async {
    try {
      LogMessage.d('inviteUsersToOngoingCall :', " jidList : $jidList");
      await mirrorFlyCallMethodChannel
          .invokeMethod<bool>('inviteUsersToOngoingCall', {"jidList": jidList});
      callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<List<String>> getInvitedUsersList() async {
    try {
      var users =
          await mirrorFlyCallMethodChannel.invokeMethod('getInvitedUsersList');
      LogMessage.d('getInvitedUsersList :', " jidList : $users");
      return List<String>.from(json
          .decode(users)
          .map((x) => x.toString())); //json.decode(users) as List<String>;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

/*@override
  Future<bool?> changeCallType({required String switchType}) async {
    bool? res;
    try {
      LogMessage.d('changeCallType --> switchType', switchType);
      res = await mirrorFlyCallMethodChannel.invokeMethod('changeCallType', {'switchType': switchType});
      LogMessage.d('changeCallType', '$res');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future reRouteAudio() async {
    try {
      await mirrorFlyCallMethodChannel
          .invokeMethod('reRouteAudio');
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }*/

  @override
  Future<bool?> markAllUnreadMissedCallsAsRead() async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel
          .invokeMethod<bool>('markAllUnreadMissedCallsAsRead');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> isCallConversionRequestAvailable() async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel
          .invokeMethod<bool>('isCallConversionRequestAvailable');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> syncCallLogs() async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel.invokeMethod<bool>('syncCallLogs');
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  void setMessageEventListener(MessageEventListeners messageEventsListener) {
    this.messageEventsListener = messageEventsListener;
  }

  @override
  void setConnectionEventListener(
      ConnectionEventListeners connectionEventsListener) {
    this.connectionEventsListener = connectionEventsListener;
  }

  @override
  void setProfileEventsListener(ProfileEventListeners profileEventsListener) {
    this.profileEventsListener = profileEventsListener;
  }

  @override
  void setGroupEventsListener(GroupEventListeners groupEventsListener) {
    this.groupEventsListener = groupEventsListener;
  }

  @override
  void setCallEventListener(CallEventListeners callEventsListener) {
    this.callEventsListener = callEventsListener;
  }

  @override
  Future<void> getMetaData(Function(FlyResponse response)? callback) async {
    String? val = FlyConstants.empty;
    try {
      val = await mirrorFlyMethodChannel.invokeMethod('getMetaData');
      LogMessage.d('getMetaData', ' $val');
      callback?.call(
          FlyResponse(true, val ?? FlyConstants.empty, FlyConstants.empty));
      // return val;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> updateMetaData(List<IdentifierMetaData>? identifierMetaData,
      Function(FlyResponse response)? callback) async {
    String? val = FlyConstants.empty;
    try {
      val = await mirrorFlyMethodChannel.invokeMethod('updateMetaData', {
        "metaData": identifierMetaData != null
            ? List<dynamic>.from(identifierMetaData.map((x) => x.toMap()))
            : null
      });
      LogMessage.d('updateMetaData', ' $val');
      callback?.call(
          FlyResponse(true, val ?? FlyConstants.empty, FlyConstants.empty));
      // return val;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }
}
