import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mirrorfly_flutter_call_kit/mirrorfly_flutter_call_kit.dart';
import 'package:mirrorfly_plugin/flychat.dart';
import 'package:mirrorfly_plugin/android_call_config_builder.dart';
import 'package:mirrorfly_plugin/helpers/file_helper.dart';
import 'package:mirrorfly_plugin/helpers/file_helper_model.dart';

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
import 'internal_models/notification_token_update_model.dart';
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

/// A Error code class to categorize the error codes.
class FlyErrorCode {
  /// Error code for unhandled errors.
  static const unHandle = "1000";
}

/// A Error message class to categorize the error messages for the error codes.
class FlyErrorMessage {
  /// Error message for unhandled errors.
  static const unHandle = "Unexpected Error";
}

/// A class to handle the platform specific methods and events.
class MethodChannelFlyChatFlutter extends FlyChatFlutterPlatform {
  /// initialized is used to check whether the sdk isInitialized or not.
  static var initialized = false;

  /// isSDKInitialized is used to check whether the sdk isInitialized or not.
  @override
  get isSDKInitialized => initialized;

  /// A Event channel to communicate chat related events with the native platform.
  MessageEventListeners? messageEventsListener;

  /// A Event channel to communicate call link related events with the native platform.
  CallLinkEventListeners? callLinkEventsListener;

  /// A Event channel to communicate call related events with the native platform.
  CallEventListeners? callEventsListener;

  /// A Event channel to communicate connection related events with the native platform.
  ConnectionEventListeners? connectionEventsListener;

  /// A Event channel to communicate profile related events with the native platform.
  ProfileEventListeners? profileEventsListener;

  /// A Event channel to communicate group related events with the native platform.
  GroupEventListeners? groupEventsListener;

  /// A method channel to communicate chat related methods with the native platform.
  @visibleForTesting
  final mirrorFlyMethodChannel =
      const MethodChannel('contus.mirrorfly/flyChat');

  /// A method channel to communicate call related methods with the native platform.
  @visibleForTesting
  final mirrorFlyCallMethodChannel =
      const MethodChannel('contus.mirrorfly/flyCall');

  //Event Channels
  /// A event channel for message listening events.
  @visibleForTesting
  final messageOnReceivedChannel =
      const EventChannel('contus.mirrorfly/onMessageReceived');

  /// A broadcast stream controller for message listening events.
  final StreamController<String> _messageOnReceivedStreamController =
      StreamController<String>.broadcast();

  /// A event channel for message status update events.
  @visibleForTesting
  final messageStatusUpdatedChanel =
      const EventChannel('contus.mirrorfly/onMessageStatusUpdated');

  /// A broadcast stream controller for message status update events.
  final StreamController<dynamic> messageStatusUpdateStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for media status update events.
  @visibleForTesting
  final mediaStatusUpdatedChannel =
      const EventChannel('contus.mirrorfly/onMediaStatusUpdated');

  /// A broadcast stream controller for media status update events.
  final StreamController<dynamic> mediaStatusUpdatedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for upload/download progress update events.
  @visibleForTesting
  final uploadDownloadProgressChangedChannel =
      const EventChannel('contus.mirrorfly/onUploadDownloadProgressChanged');

  /// A broadcast stream controller for upload/download progress update events.
  final StreamController<dynamic>
      uploadDownloadProgressChangedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for group profile fetched events.
  @visibleForTesting
  final onGroupProfileFetchedChannel =
      const EventChannel('contus.mirrorfly/onGroupProfileFetched');

  /// A broadcast stream controller for group profile fetched events.
  final StreamController<dynamic> onGroupProfileFetchedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for new group created events.
  @visibleForTesting
  final onNewGroupCreatedChannel =
      const EventChannel('contus.mirrorfly/onNewGroupCreated');

  /// A broadcast stream controller for new group created events.
  final StreamController<dynamic> onNewGroupCreatedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for group profile updated events.
  @visibleForTesting
  final onGroupProfileUpdatedChannel =
      const EventChannel('contus.mirrorfly/onGroupProfileUpdated');

  /// A broadcast stream controller for group profile updated events.
  final StreamController<dynamic> onGroupProfileUpdatedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for new member added to group events.
  @visibleForTesting
  final onNewMemberAddedToGroupChannel =
      const EventChannel('contus.mirrorfly/onNewMemberAddedToGroup');

  /// A broadcast stream controller for new member added to group events.
  final StreamController<dynamic> onNewMemberAddedToGroupStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for member removed from group events.
  @visibleForTesting
  final onMemberRemovedFromGroupChannel =
      const EventChannel('contus.mirrorfly/onMemberRemovedFromGroup');

  /// A broadcast stream controller for member removed from group events.
  final StreamController<dynamic> onMemberRemovedFromGroupStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for fetching group members completed events.
  @visibleForTesting
  final onFetchingGroupMembersCompletedChannel =
      const EventChannel('contus.mirrorfly/onFetchingGroupMembersCompleted');

  /// A broadcast stream controller for fetching group members completed events.
  final StreamController<dynamic>
      onFetchingGroupMembersCompletedStreamController =
      StreamController<dynamic>.broadcast();

  // @visibleForTesting
  // final onDeleteGroupChannel = const EventChannel('contus.mirrorfly/onDeleteGroup');
  // final StreamController<dynamic> onDeleteGroupStreamController = StreamController<dynamic>.broadcast();
  // @visibleForTesting
  // final onFetchingGroupListCompletedChannel = const EventChannel('contus.mirrorfly/onFetchingGroupListCompleted');
  // final StreamController<dynamic> onFetchingGroupListCompletedStreamController = StreamController<dynamic>.broadcast();

  /// A event channel for member made as admin events.
  @visibleForTesting
  final onMemberMadeAsAdminChannel =
      const EventChannel('contus.mirrorfly/onMemberMadeAsAdmin');

  /// A broadcast stream controller for member made as admin events.
  final StreamController<dynamic> onMemberMadeAsAdminStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for member removed as admin events.
  @visibleForTesting
  final onMemberRemovedAsAdminChannel =
      const EventChannel('contus.mirrorfly/onMemberRemovedAsAdmin');

  /// A broadcast stream controller for member removed as admin events.
  final StreamController<dynamic> onMemberRemovedAsAdminStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for left from group events.
  @visibleForTesting
  final onLeftFromGroupChannel =
      const EventChannel('contus.mirrorfly/onLeftFromGroup');

  /// A broadcast stream controller for left from group events.
  final StreamController<dynamic> onLeftFromGroupStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for group notification message events.
  @visibleForTesting
  final onGroupNotificationMessageChannel =
      const EventChannel('contus.mirrorfly/onGroupNotificationMessage');

  /// A broadcast stream controller for group notification message events.
  final StreamController<dynamic> onGroupNotificationMessageStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for show or update or cancel notification events.
  @visibleForTesting
  final showOrUpdateOrCancelNotificationChannel =
      const EventChannel('contus.mirrorfly/showOrUpdateOrCancelNotification');

  /// A broadcast stream controller for show or update or cancel notification events.
  final StreamController<String>
      showOrUpdateOrCancelNotificationStreamController =
      StreamController<String>.broadcast();

  /// A event channel for group deleted locally events.
  @visibleForTesting
  final onGroupDeletedLocallyChannel =
      const EventChannel('contus.mirrorfly/onGroupDeletedLocally');

  /// A broadcast stream controller for group deleted locally events.
  final StreamController<dynamic> onGroupDeletedLocallyStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for blocked this user events.
  @visibleForTesting
  final blockedThisUserChannel =
      const EventChannel('contus.mirrorfly/blockedThisUser');

  /// A broadcast stream controller for blocked this user events.
  final StreamController<dynamic> blockedThisUserStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for my profile updated events.
  @visibleForTesting
  final myProfileUpdatedChannel =
      const EventChannel('contus.mirrorfly/myProfileUpdated');

  /// A broadcast stream controller for my profile updated events.
  final StreamController<dynamic> myProfileUpdatedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for on admin blocked other user events.
  @visibleForTesting
  final onAdminBlockedOtherUserChannel =
      const EventChannel('contus.mirrorfly/onAdminBlockedOtherUser');

  /// A broadcast stream controller for on admin blocked other user events.
  final StreamController<dynamic> onAdminBlockedOtherUserStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for on admin blocked user events.
  @visibleForTesting
  final onAdminBlockedUserChannel =
      const EventChannel('contus.mirrorfly/onAdminBlockedUser');

  /// A broadcast stream controller for on admin blocked user events.
  final StreamController<dynamic> onAdminBlockedUserStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for on contact sync complete events.
  @visibleForTesting
  final onContactSyncCompleteChannel =
      const EventChannel('contus.mirrorfly/onContactSyncComplete');

  /// A broadcast stream controller for on contact sync complete events.
  final StreamController<dynamic> onContactSyncCompleteStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for on logged out events.
  @visibleForTesting
  final onLoggedOutChannel = const EventChannel('contus.mirrorfly/onLoggedOut');

  /// A broadcast stream controller for on logged out events.
  final StreamController<dynamic> onLoggedOutStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for unblocked this user events.
  @visibleForTesting
  final unblockedThisUserChannel =
      const EventChannel('contus.mirrorfly/unblockedThisUser');

  /// A broadcast stream controller for unblocked this user events.
  final StreamController<dynamic> unblockedThisUserStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for user blocked me events.
  @visibleForTesting
  final userBlockedMeChannel =
      const EventChannel('contus.mirrorfly/userBlockedMe');

  /// A broadcast stream controller for user blocked me events.
  final StreamController<dynamic> userBlockedMeStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for user came online events.
  @visibleForTesting
  final userCameOnlineChannel =
      const EventChannel('contus.mirrorfly/userCameOnline');

  /// A broadcast stream controller for user came online events.
  final StreamController<dynamic> userCameOnlineStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for user deleted his profile events.
  @visibleForTesting
  final userDeletedHisProfileChannel =
      const EventChannel('contus.mirrorfly/userDeletedHisProfile');

  /// A broadcast stream controller for user deleted his profile events.
  final StreamController<dynamic> userDeletedHisProfileStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for user profile fetched events.
  @visibleForTesting
  final userProfileFetchedChannel =
      const EventChannel('contus.mirrorfly/userProfileFetched');

  /// A broadcast stream controller for user profile fetched events.
  final StreamController<dynamic> userProfileFetchedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for user unblocked me events.
  @visibleForTesting
  final userUnBlockedMeChannel =
      const EventChannel('contus.mirrorfly/userUnBlockedMe');

  /// A broadcast stream controller for user unblocked me events.
  final StreamController<dynamic> userUnBlockedMeStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for user updated his profile events.
  @visibleForTesting
  final userUpdatedHisProfileChannel =
      const EventChannel('contus.mirrorfly/userUpdatedHisProfile');

  /// A broadcast stream controller for user updated his profile events.
  final StreamController<dynamic> userUpdatedHisProfileStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for user went offline events.
  @visibleForTesting
  final userWentOfflineChannel =
      const EventChannel('contus.mirrorfly/userWentOffline');

  /// A broadcast stream controller for user went offline events.
  final StreamController<dynamic> userWentOfflineStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for users I blocked list fetched events.
  @visibleForTesting
  final usersIBlockedListFetchedChannel =
      const EventChannel('contus.mirrorfly/usersIBlockedListFetched');

  /// A broadcast stream controller for users I blocked list fetched events.
  final StreamController<dynamic> usersIBlockedListFetchedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for users profiles fetched events.
  @visibleForTesting
  final usersProfilesFetchedChannel =
      const EventChannel('contus.mirrorfly/usersProfilesFetched');

  /// A broadcast stream controller for users profiles fetched events.
  final StreamController<dynamic> usersProfilesFetchedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for users who blocked me list fetched events.
  @visibleForTesting
  final usersWhoBlockedMeListFetchedChannel =
      const EventChannel('contus.mirrorfly/usersWhoBlockedMeListFetched');

  /// A broadcast stream controller for users who blocked me list fetched events.
  final StreamController<dynamic> usersWhoBlockedMeListFetchedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for connected events.
  @visibleForTesting
  final onConnectedChannel = const EventChannel('contus.mirrorfly/onConnected');

  /// A broadcast stream controller for connected events.
  final StreamController<dynamic> onConnectedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for disconnected events.
  @visibleForTesting
  final onDisconnectedChannel =
      const EventChannel('contus.mirrorfly/onDisconnected');

  /// A broadcast stream controller for disconnected events.
  final StreamController<dynamic> onDisconnectedStreamController =
      StreamController<dynamic>.broadcast();

  /*@visibleForTesting
  final onConnectionNotAuthorizedChannel =
      const EventChannel('contus.mirrorfly/onConnectionNotAuthorized');*/

  /// A event channel for connection failed events.
  @visibleForTesting
  final onConnectionFailedChannel =
      const EventChannel('contus.mirrorfly/onConnectionFailed');

  /// A broadcast stream controller for connection failed events.
  final StreamController<dynamic> onConnectionFailedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for reconnection events.
  @visibleForTesting
  final onReconnectingChannel =
      const EventChannel('contus.mirrorfly/onReconnecting');

  /// A broadcast stream controller for connection failed events.
  final StreamController<dynamic> onReconnectingStreamController =
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

  /// A event channel for set typing status events.
  @visibleForTesting
  final setTypingStatusChannel =
      const EventChannel('contus.mirrorfly/setTypingStatus');

  /// A broadcast stream controller for set typing status events.
  final StreamController<dynamic> setTypingStatusStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for chat typing status events.
  @visibleForTesting
  final onChatTypingStatusChannel =
      const EventChannel('contus.mirrorfly/onChatTypingStatus');

  /// A broadcast stream controller for chat typing status events.
  final StreamController<dynamic> onChatTypingStatusStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for group typing status events.
  @visibleForTesting
  final onGroupTypingStatusChannel =
      const EventChannel('contus.mirrorfly/onGroupTypingStatus');

  /// A broadcast stream controller for group typing status events.
  final StreamController<dynamic> onGroupTypingStatusStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for message edited events.
  @visibleForTesting
  final messageOnEditedChannel =
      const EventChannel('contus.mirrorfly/onMessageEdited');

  /// A broadcast stream controller for message edited events.
  final StreamController<String> _messageOnEditedStreamController =
      StreamController<String>.broadcast();

  /// A event channel for backup listening events.
  @visibleForTesting
  final onBackupFailureChannel =
      const EventChannel('contus.mirrorfly/onBackupFailure');

  /// A broadcast stream controller for message backup events.
  final StreamController<String> onBackupFailureStreamController =
      StreamController<String>.broadcast();

  /// A event channel for backup progress listening events.
  @visibleForTesting
  final onBackupProgressChangedChannel =
      const EventChannel('contus.mirrorfly/onBackupProgressChanged');

  /// A broadcast stream controller for message backup events.
  final StreamController<int> onBackupProgressStreamController =
      StreamController<int>.broadcast();

  /// A event channel for backup success listening events.
  @visibleForTesting
  final onBackupSuccessChannel =
      const EventChannel('contus.mirrorfly/onBackupSuccess');

  /// A broadcast stream controller for message backup events.
  final StreamController<String> onBackupSuccessStreamController =
      StreamController<String>.broadcast();

  /// A event channel for restore failure listening events.
  @visibleForTesting
  final onRestoreFailureChannel =
      const EventChannel('contus.mirrorfly/onRestoreFailure');

  /// A broadcast stream controller for message backup events.
  final StreamController<String> onRestoreFailureStreamController =
      StreamController<String>.broadcast();

  /// A event channel for restore success listening events.
  @visibleForTesting
  final onRestoreSuccessChannel =
      const EventChannel('contus.mirrorfly/onRestoreSuccess');

  /// A broadcast stream controller for message backup events.
  final StreamController<bool> onRestoreSuccessStreamController =
      StreamController<bool>.broadcast();

  /// A event channel for restore progress listening events.
  @visibleForTesting
  final onRestoreProgressChangedChannel =
      const EventChannel('contus.mirrorfly/onRestoreProgressChanged');

  /// A broadcast stream controller for message backup events.
  final StreamController<int> onRestoreProgressStreamController =
      StreamController<int>.broadcast();

  /// A event channel for chat cleared listening events.
  @visibleForTesting
  final onChatClearedChannel =
      const EventChannel('contus.mirrorfly/onChatCleared');

  /// A broadcast stream controller for chat cleared events.
  final StreamController<dynamic> onChatClearedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for message deleted listening events.
  @visibleForTesting
  final onMessageDeletedChannel =
      const EventChannel('contus.mirrorfly/onMessageDeleted');

  /// A broadcast stream controller for message deleted events.
  final StreamController<dynamic> onMessageDeletedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for all chats cleared listening events.
  @visibleForTesting
  final onAllChatsClearedChannel =
      const EventChannel('contus.mirrorfly/onAllChatsCleared');

  /// A broadcast stream controller for all chats cleared events.
  final StreamController<bool> onAllChatsClearedStreamController =
      StreamController<bool>.broadcast();

  /// A event channel for favourite message listening events.
  @visibleForTesting
  final onUpdateFavouritesChannel =
      const EventChannel('contus.mirrorfly/onUpdateFavourites');

  /// A broadcast stream controller for favourite message update events.
  final StreamController<dynamic> onUpdateFavouritesStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for corresponding web logout listening events.
  @visibleForTesting
  final onWebLogoutChannel = const EventChannel('contus.mirrorfly/onWebLogout');

  /// A broadcast stream controller for web logout events.
  final StreamController<dynamic> onWebLogoutStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for chat Mute/UnMute listening events.
  @visibleForTesting
  final onChatMuteStatusUpdatedChannel =
      const EventChannel('contus.mirrorfly/onChatMuteStatusUpdated');

  /// A broadcast stream controller for chat Mute/UnMute events.
  final StreamController<dynamic> onChatMuteStatusUpdatedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for Mute/UnMute Settings listening events.
  @visibleForTesting
  final onUpdateMuteSettingsChannel =
      const EventChannel('contus.mirrorfly/didUpdateMuteSettings');

  /// A broadcast stream controller for Mute/UnMute settings events.
  final StreamController<dynamic> onUpdateMuteSettingsStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for chat Archive/Unarchive listening events.
  @visibleForTesting
  final onArchiveUnArchiveChatsChannel =
      const EventChannel('contus.mirrorfly/updateArchiveUnArchiveChats');

  /// A broadcast stream controller for chat Archive/Unarchive listening events.
  final StreamController<dynamic> onArchiveUnArchiveChatsStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for chat Archive/Unarchive listening events.
  @visibleForTesting
  final onArchivedSettingsUpdatedChannel =
      const EventChannel('contus.mirrorfly/updateArchivedSettings');

  /// A broadcast stream controller for chat Archive/Unarchive listening events.
  final StreamController<dynamic> onArchivedSettingsUpdatedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for chat Archive/Unarchive listening events.
  @visibleForTesting
  final onSuperAdminDeleteGroupChannel =
      const EventChannel('contus.mirrorfly/onSuperAdminDeleteGroup');

  /// A broadcast stream controller for chat Archive/Unarchive listening events.
  final StreamController<dynamic> onSuperAdminDeleteGroupStreamController =
      StreamController<dynamic>.broadcast();

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

  /// A event channel for local video track added events.
  @visibleForTesting
  final onLocalVideoTrackAddedChannel =
      const EventChannel('contus.mirrorfly/onLocalVideoTrackAdded');

  /// A broadcast stream controller for local video track added events.
  final StreamController<dynamic> onLocalVideoTrackAddedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for remote video track added events.
  @visibleForTesting
  final onRemoteVideoTrackAddedChannel =
      const EventChannel('contus.mirrorfly/onRemoteVideoTrackAdded');

  /// A broadcast stream controller for remote video track added events.
  final StreamController<dynamic> onRemoteVideoTrackAddedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for track added events.
  @visibleForTesting
  final onTrackAddedChannel =
      const EventChannel('contus.mirrorfly/onTrackAdded');

  /// A broadcast stream controller for track added events.
  final StreamController<dynamic> onTrackAddedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for call status updated events.
  @visibleForTesting
  final onCallStatusUpdatedChannel =
      const EventChannel('contus.mirrorfly/onCallStatusUpdated');

  /// A broadcast stream controller for call status updated events.
  final StreamController<dynamic> onCallStatusUpdatedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for call Action events.
  @visibleForTesting
  final onCallActionChannel =
      const EventChannel('contus.mirrorfly/onCallAction');

  /// A broadcast stream controller for call Action events.
  final StreamController<dynamic> onCallActionStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for on mute status updated events.
  @visibleForTesting
  final onMuteStatusUpdatedChannel =
      const EventChannel('contus.mirrorfly/onMuteStatusUpdated');

  /// A broadcast stream controller for on mute status updated events.
  final StreamController<dynamic> onMuteStatusUpdatedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for on user speaking events.
  @visibleForTesting
  final onUserSpeakingChannel =
      const EventChannel('contus.mirrorfly/onUserSpeaking');

  /// A broadcast stream controller for on user speaking events.
  final StreamController<dynamic> onUserSpeakingStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for on user stopped speaking events.
  @visibleForTesting
  final onUserStoppedSpeakingChannel =
      const EventChannel('contus.mirrorfly/onUserStoppedSpeaking');

  /// A broadcast stream controller for on user stopped speaking events.
  final StreamController<dynamic> onUserStoppedSpeakingStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for missed call events.
  @visibleForTesting
  final onMissedCallChannel =
      const EventChannel('contus.mirrorfly/onMissedCall');

  /// A broadcast stream controller for missed call events.
  final StreamController<dynamic> onMissedCallStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for available features updated events.
  @visibleForTesting
  final onAvailableFeaturesUpdatedChannel =
      const EventChannel('contus.mirrorfly/onAvailableFeaturesUpdated');

  /// A broadcast stream controller for available features updated events.
  final StreamController<dynamic> onAvailableFeaturesUpdatedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for call logs updated events.
  @visibleForTesting
  final onCallLogsUpdatedChannel =
      const EventChannel('contus.mirrorfly/onCallLog');

  /// A broadcast stream controller for call logs updated events.
  final StreamController<dynamic> onCallLogsUpdatedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for call log deleted events.
  @visibleForTesting
  final onCallLogDeletedChannel =
      const EventChannel('contus.mirrorfly/onCallLogDeleted');

  /// A broadcast stream controller for call log deleted events.
  final StreamController<dynamic> onCallLogDeletedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for call logs cleared events.
  @visibleForTesting
  final onClearAllCallLogChannel =
      const EventChannel('contus.mirrorfly/clearAllCallLog');

  /// A broadcast stream controller for call logs cleared events.
  final StreamController<dynamic> onClearAllCallLogStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for call link subscribe success events.
  @visibleForTesting
  final onSubscribeSuccessChannel =
      const EventChannel('contus.mirrorfly/onSubscribeSuccess');

  /// A event channel for call link subscribe success events.
  final StreamController<dynamic> onSubscribeSuccessStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for call link subscribe onError events.
  @visibleForTesting
  final onErrorChannel = const EventChannel('contus.mirrorfly/onError');

  /// A event channel for call link subscribe onError events.
  final StreamController<dynamic> onErrorStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for call link users are update events.
  @visibleForTesting
  final onUsersUpdatedChannel =
      const EventChannel('contus.mirrorfly/onUsersUpdated');

  /// A event channel for call link users are update events.
  final StreamController<dynamic> onUsersUpdatedStreamController =
      StreamController<dynamic>.broadcast();

  /// A event channel for incoming call when the dafault and.
  @visibleForTesting
  final onIncomingCallReceivedChannel =
      const EventChannel('contus.mirrorfly/onIncomingCallReceived');

  /// A stream controller to update the incoming call event as a stream.
  final StreamController<dynamic> onIncomingCallReceivedStreamController =
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

  @override
  Stream<dynamic> get onReconnecting => onReconnectingStreamController.stream;

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

  @override
  Stream<dynamic> get onBackupFailure => onBackupFailureStreamController.stream;

  @override
  Stream<dynamic> get onBackupProgressChanged =>
      onBackupProgressStreamController.stream;

  @override
  Stream<dynamic> get onBackupSuccess => onBackupSuccessStreamController.stream;

  @override
  Stream<dynamic> get onRestoreFailure =>
      onRestoreFailureStreamController.stream;

  @override
  Stream<dynamic> get onRestoreProgressChanged =>
      onRestoreProgressStreamController.stream;

  @override
  Stream<dynamic> get onRestoreSuccess =>
      onRestoreSuccessStreamController.stream;

  @override
  Stream<dynamic> get onChatCleared => onChatClearedStreamController.stream;

  @override
  Stream<dynamic> get onMessageDeleted =>
      onMessageDeletedStreamController.stream;

  @override
  Stream<dynamic> get onAllChatsCleared =>
      onAllChatsClearedStreamController.stream;

  @override
  Stream<dynamic> get onUpdateFavourites =>
      onUpdateFavouritesStreamController.stream;

  @override
  Stream<dynamic> get onWebLogout => onWebLogoutStreamController.stream;

  @override
  Stream<dynamic> get onChatMuteStatusUpdated =>
      onChatMuteStatusUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onUpdateMuteSettings =>
      onUpdateMuteSettingsStreamController.stream;

  @override
  Stream<dynamic> get onArchiveUnArchiveChats =>
      onArchiveUnArchiveChatsStreamController.stream;

  @override
  Stream<dynamic> get onArchivedSettingsUpdated =>
      onArchivedSettingsUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onSuperAdminDeleteGroup =>
      onSuperAdminDeleteGroupStreamController.stream;

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

  @override
  Stream<dynamic> get onIncomingCallReceived =>
      onIncomingCallReceivedStreamController.stream;

  ///Using [addStreamsAllToStreamController] to add all streams to stream controller
  ///benefit to use stream controller we can call multiple listeners to listen.
  addStreamsAllToStreamController() {
    messageOnReceivedChannel.receiveBroadcastStream().listen((event) {
      var message = convertChatMessageJsonFromString(event);
      _messageOnReceivedStreamController.add(message);
      messageEventsListener
          ?.onMessageReceived(client.sendMessageModelFromJson(message));
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on message received: $error");
      _messageOnReceivedStreamController.addError(error);
    });

    messageOnEditedChannel.receiveBroadcastStream().listen((event) {
      var message = convertChatMessageJsonFromString(event);
      _messageOnEditedStreamController.add(message);
      messageEventsListener
          ?.onMessageEdited(client.sendMessageModelFromJson(message));
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on message edited: $error");
      _messageOnEditedStreamController.addError(error);
    });

    messageStatusUpdatedChanel.receiveBroadcastStream().listen((event) {
      var messageStatus = convertChatMessageJsonFromString(event);
      messageStatusUpdateStreamController.add(messageStatus);
      messageEventsListener?.onMessageStatusUpdated(
          client.sendMessageModelFromJson(messageStatus));
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on message status updated: $error");
      messageStatusUpdateStreamController.addError(error);
    });

    mediaStatusUpdatedChannel.receiveBroadcastStream().listen((event) {
      var mediaStatus = convertChatMessageJsonFromString(event);
      mediaStatusUpdatedStreamController.add(mediaStatus);
      messageEventsListener
          ?.onMediaStatusUpdated(client.sendMessageModelFromJson(mediaStatus));
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on media status updated: $error");
      mediaStatusUpdatedStreamController.addError(error);
    });

    onGroupNotificationMessageChannel.receiveBroadcastStream().listen((event) {
      var groupNotification = convertChatMessageJsonFromString(event);
      onGroupNotificationMessageStreamController.add(groupNotification);
      groupEventsListener?.onGroupNotificationMessage(
          client.sendMessageModelFromJson(groupNotification));
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on group notification: $error");
      onGroupNotificationMessageStreamController.addError(error);
    });

    showOrUpdateOrCancelNotificationChannel.receiveBroadcastStream().listen(
        (event) {
      var data = json.decode(event.toString());
      var jid = data["jid"];
      var chatMessage = convertChatMessageJsonFromString(data["chatMessage"]);
      var map = {"jid": jid, "chatMessage": chatMessage};
      var notification = json.encode(map);
      showOrUpdateOrCancelNotificationStreamController.add(notification);
      messageEventsListener?.showOrUpdateOrCancelNotification(
          jid, client.sendMessageModelFromJson(chatMessage));
    }, onError: (error) {
      LogMessage.d(
          "MirrorFly", "Error on show/update/cancel notification: $error");
      showOrUpdateOrCancelNotificationStreamController.addError(error);
    });

    uploadDownloadProgressChangedChannel.receiveBroadcastStream().listen(
        (event) {
      var data = json.decode(event.toString());
      var messageId = data["message_id"] ?? "";
      var progressPercentage = data["progress_percentage"] ?? 0;
      uploadDownloadProgressChangedStreamController.add(event);
      messageEventsListener?.onUploadDownloadProgressChanged(
          messageId, progressPercentage);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on upload/download progress: $error");
      uploadDownloadProgressChangedStreamController.addError(error);
    });

    onGroupProfileFetchedChannel.receiveBroadcastStream().listen((groupJid) {
      onGroupProfileFetchedStreamController.add(groupJid);
      groupEventsListener?.onGroupProfileFetched(groupJid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on group profile fetched: $error");
      onGroupProfileFetchedStreamController.addError(error);
    });

    onNewGroupCreatedChannel.receiveBroadcastStream().listen((groupJid) {
      onNewGroupCreatedStreamController.add(groupJid);
      groupEventsListener?.onNewGroupCreated(groupJid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on new group created: $error");
      onNewGroupCreatedStreamController.addError(error);
    });

    onGroupProfileUpdatedChannel.receiveBroadcastStream().listen((groupJid) {
      onGroupProfileUpdatedStreamController.add(groupJid);
      groupEventsListener?.onGroupProfileUpdated(groupJid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on group profile updated: $error");
      onGroupProfileUpdatedStreamController.addError(error);
    });

    onNewMemberAddedToGroupChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var groupJid = data["groupJid"] ?? "";
      var newMemberJid = data["newMemberJid"] ?? "";
      var addedByMemberJid = data["addedByMemberJid"] ?? "";
      onNewMemberAddedToGroupStreamController.add(event);
      groupEventsListener?.onNewMemberAddedToGroup(
          groupJid, newMemberJid, addedByMemberJid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on new member added to group: $error");
      onNewMemberAddedToGroupStreamController.addError(error);
    });

    onMemberRemovedFromGroupChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var groupJid = data["groupJid"] ?? "";
      var removedMemberJid = data["removedMemberJid"] ?? "";
      var removedByMemberJid = data["removedByMemberJid"] ?? "";
      onMemberRemovedFromGroupStreamController.add(event);
      groupEventsListener?.onMemberRemovedFromGroup(
          groupJid, removedMemberJid, removedByMemberJid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on member removed from group: $error");
      onMemberRemovedFromGroupStreamController.addError(error);
    });

    onFetchingGroupMembersCompletedChannel.receiveBroadcastStream().listen(
        (groupJid) {
      onFetchingGroupMembersCompletedStreamController.add(groupJid);
      groupEventsListener?.onFetchingGroupMembersCompleted(groupJid);
    }, onError: (error) {
      LogMessage.d(
          "MirrorFly", "Error on fetching group members completed: $error");
      onFetchingGroupMembersCompletedStreamController.addError(error);
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
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on member made as admin: $error");
      onMemberMadeAsAdminStreamController.addError(error);
    });

    onMemberRemovedAsAdminChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var groupJid = data["groupJid"] ?? "";
      var removedAdminMemberJid = data["removedAdminMemberJid"] ?? "";
      var removedByMemberJid = data["removedByMemberJid"] ?? "";
      onMemberRemovedAsAdminStreamController.add(event);
      groupEventsListener?.onMemberRemovedAsAdmin(
          groupJid, removedAdminMemberJid, removedByMemberJid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on member removed as admin: $error");
      onMemberRemovedAsAdminStreamController.addError(error);
    });

    onLeftFromGroupChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var groupJid = data["groupJid"] ?? "";
      var leftUserJid = data["leftUserJid"] ?? "";
      onLeftFromGroupStreamController.add(event);
      groupEventsListener?.onLeftFromGroup(groupJid, leftUserJid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on left from group: $error");
      onLeftFromGroupStreamController.addError(error);
    });

    onGroupDeletedLocallyChannel.receiveBroadcastStream().listen((groupJid) {
      onGroupDeletedLocallyStreamController.add(groupJid);
      groupEventsListener?.onGroupDeletedLocally(groupJid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on group deleted locally: $error");
      onGroupDeletedLocallyStreamController.addError(error);
    });

    blockedThisUserChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var userJid = data["jid"] ?? "";
      blockedThisUserStreamController.add(event);
      profileEventsListener?.blockedThisUser(userJid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on blocked this user: $error");
      blockedThisUserStreamController.addError(error);
    });

    myProfileUpdatedChannel.receiveBroadcastStream().listen((event) {
      myProfileUpdatedStreamController.add(event);
      profileEventsListener?.myProfileUpdated();
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on my profile updated: $error");
      myProfileUpdatedStreamController.addError(error);
    });

    onAdminBlockedOtherUserChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      var chatType = data["type"] ?? "";
      var isBlocked = data["status"] ?? "";
      onAdminBlockedOtherUserStreamController.add(event);
      profileEventsListener?.onAdminBlockedOtherUser(jid, chatType, isBlocked);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on admin blocked other user: $error");
      onAdminBlockedOtherUserStreamController.addError(error);
    });

    onAdminBlockedUserChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      var isBlocked = data["status"] ?? "";
      onAdminBlockedUserStreamController.add(event);
      profileEventsListener?.onAdminBlockedUser(jid, isBlocked);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on admin blocked user: $error");
      onAdminBlockedUserStreamController.addError(error);
    });

    onContactSyncCompleteChannel.receiveBroadcastStream().listen((isSuccess) {
      onContactSyncCompleteStreamController.add(isSuccess);
      profileEventsListener?.onContactSyncComplete(isSuccess);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on contact sync complete: $error");
      onContactSyncCompleteStreamController.addError(error);
    });

    onLoggedOutChannel.receiveBroadcastStream().listen((event) {
      onLoggedOutStreamController.add(event);
      connectionEventsListener?.onLoggedOut();
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on logged out: $error");
      onLoggedOutStreamController.addError(error);
    });

    unblockedThisUserChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      unblockedThisUserStreamController.add(event);
      profileEventsListener?.unblockedThisUser(jid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on unblocking user: $error");
      unblockedThisUserStreamController.addError(error);
    });

    userBlockedMeChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      userBlockedMeStreamController.add(event);
      profileEventsListener?.userBlockedMe(jid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on user blocked me: $error");
      userBlockedMeStreamController.addError(error);
    });

    userCameOnlineChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      userCameOnlineStreamController.add(event);
      messageEventsListener?.userCameOnline(jid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on user came online: $error");
      userCameOnlineStreamController.addError(error);
    });

    userDeletedHisProfileChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      userDeletedHisProfileStreamController.add(event);
      profileEventsListener?.userDeletedHisProfile(jid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on user deleted his profile: $error");
      userDeletedHisProfileStreamController.addError(error);
    });

    userProfileFetchedChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      var profileDetails = data["profileDetails"] ?? "";
      client.ProfileData profileData = client.profileData(profileDetails);
      userProfileFetchedStreamController.add(event);
      profileEventsListener?.userProfileFetched(jid, profileData);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on user profile fetched: $error");
      userProfileFetchedStreamController.addError(error);
    });

    userUnBlockedMeChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      userUnBlockedMeStreamController.add(event);
      profileEventsListener?.userUnBlockedMe(jid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on user unblocked me: $error");
      userUnBlockedMeStreamController.addError(error);
    });

    userUpdatedHisProfileChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      userUpdatedHisProfileStreamController.add(event);
      profileEventsListener?.userUpdatedHisProfile(jid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on user updated his profile: $error");
      userUpdatedHisProfileStreamController.addError(error);
    });

    userWentOfflineChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var jid = data["jid"] ?? "";
      userWentOfflineStreamController.add(event);
      messageEventsListener?.userWentOffline(jid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on user went offline: $error");
      userWentOfflineStreamController.addError(error);
    });

    usersIBlockedListFetchedChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      usersIBlockedListFetchedStreamController.add(event);
      profileEventsListener?.usersIBlockedListFetched(
          List<String>.from((data ?? []).map((x) => x.toString())));
    }, onError: (error) {
      LogMessage.d(
          "MirrorFly", "Error on users I blocked list fetched: $error");
      usersIBlockedListFetchedStreamController.addError(error);
    });

    usersProfilesFetchedChannel.receiveBroadcastStream().listen((event) {
      usersProfilesFetchedStreamController.add(event);
      profileEventsListener?.usersProfilesFetched();
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on users profiles fetched: $error");
      usersProfilesFetchedStreamController.addError(error);
    });

    usersWhoBlockedMeListFetchedChannel.receiveBroadcastStream().listen(
        (event) {
      var data = json.decode(event.toString());
      usersWhoBlockedMeListFetchedStreamController.add(event);
      profileEventsListener?.usersWhoBlockedMeListFetched(
          List<String>.from((data ?? []).map((x) => x.toString())));
    }, onError: (error) {
      LogMessage.d(
          "MirrorFly", "Error on users who blocked me list fetched: $error");
      usersWhoBlockedMeListFetchedStreamController.addError(error);
    });

    onConnectedChannel.receiveBroadcastStream().listen((event) {
      onConnectedStreamController.add(event);
      connectionEventsListener?.onConnected();
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on connected: $error");
      onConnectedStreamController.addError(error);
    });

    onDisconnectedChannel.receiveBroadcastStream().listen((event) {
      onDisconnectedStreamController.add(event);
      connectionEventsListener?.onDisconnected();
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on disconnected: $error");
      onDisconnectedStreamController.addError(error);
    });

    onConnectionFailedChannel.receiveBroadcastStream().listen((event) {
      onConnectionFailedStreamController.add(event);
      connectionEventsListener?.onConnectionFailed(event);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on connection failed: $error");
      onConnectionFailedStreamController.addError(error);
    });

    onReconnectingChannel.receiveBroadcastStream().listen((event) {
      onReconnectingStreamController.add(event);
      connectionEventsListener?.onReconnecting();
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on reconnecting : $error");
      onReconnectingStreamController.addError(error);
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
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on set typing status: $error");
      setTypingStatusStreamController.addError(error);
    });

    onChatTypingStatusChannel.receiveBroadcastStream().listen((event) {
      onChatTypingStatusStreamController.add(event);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on chat typing status: $error");
      onChatTypingStatusStreamController.addError(error);
    });

    onGroupTypingStatusChannel.receiveBroadcastStream().listen((event) {
      onGroupTypingStatusStreamController.add(event);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on group typing status: $error");
      onGroupTypingStatusStreamController.addError(error);
    });

    onBackupFailureChannel.receiveBroadcastStream().listen((event) {
      onBackupFailureStreamController.add(event);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on backup: $error");
      onBackupFailureStreamController.addError(error);
    });

    onBackupSuccessChannel.receiveBroadcastStream().listen((event) {
      onBackupSuccessStreamController.add(event);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on backup: $error");
      onBackupSuccessStreamController.addError(error);
    });

    onBackupProgressChangedChannel.receiveBroadcastStream().listen((event) {
      onBackupProgressStreamController.add(event);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on backup: $error");
      onBackupProgressStreamController.addError(error);
    });

    onRestoreFailureChannel.receiveBroadcastStream().listen((event) {
      onRestoreFailureStreamController.add(event);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on backup: $error");
      onRestoreFailureStreamController.addError(error);
    });

    onRestoreProgressChangedChannel.receiveBroadcastStream().listen((event) {
      onRestoreProgressStreamController.add(event);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on backup: $error");
      onRestoreProgressStreamController.addError(error);
    });

    onRestoreSuccessChannel.receiveBroadcastStream().listen((event) {
      onRestoreSuccessStreamController.add(event);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on backup: $error");
      onRestoreSuccessStreamController.addError(error);
    });

    onChatClearedChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var toJid = data["toJid"] ?? "";
      var chatClearType = data["chatClearType"] ?? "";

      onChatClearedStreamController.add(event);
      messageEventsListener?.onChatCleared(toJid, chatClearType);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on chat clear listener: $error");
      onChatClearedStreamController.addError(error);
    });

    onMessageDeletedChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      String toJid = data["toJid"] ?? "";
      List<String> messageIds = List<String>.from(
          (data["messageIds"] ?? []).map((x) => x.toString()));
      String messageDeleteType = data["messageDeleteType"] ?? "";
      onMessageDeletedStreamController.add(event);
      messageEventsListener?.onMessageDeleted(
          toJid, messageIds, messageDeleteType);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on message deleted listener: $error");
      onMessageDeletedStreamController.addError(error);
    });

    onAllChatsClearedChannel.receiveBroadcastStream().listen((event) {
      onAllChatsClearedStreamController.add(event);
      messageEventsListener?.onAllChatsCleared(event);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on all chat cleared listener: $error");
      onAllChatsClearedStreamController.addError(error);
    });

    onUpdateFavouritesChannel.receiveBroadcastStream().listen((event) {
      onUpdateFavouritesStreamController.add(event);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on update favourites listener: $error");
      onUpdateFavouritesStreamController.addError(error);
    });

    onWebLogoutChannel.receiveBroadcastStream().listen((event) {
      onWebLogoutStreamController.add(event);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on web logout listener: $error");
      onWebLogoutStreamController.addError(error);
    });

    onChatMuteStatusUpdatedChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var isSuccess = data["isSuccess"] ?? false;
      var message = data["message"] ?? "";
      List<String> jidList =
          List<String>.from((data["jidList"] ?? []).map((x) => x.toString()));
      var muteStatus = data["muteStatus"] ?? false;

      onChatMuteStatusUpdatedStreamController.add(event);
      messageEventsListener?.onChatMuteStatusUpdated(
          isSuccess, message, jidList, muteStatus);
    }, onError: (error) {
      LogMessage.d(
          "MirrorFly", "Error on chat mute or un-mute listener: $error");
      onChatMuteStatusUpdatedStreamController.addError(error);
    });

    onUpdateMuteSettingsChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var isSuccess = data["isSuccess"] ?? false;
      var message = data["message"] ?? "";
      var isMuteStatus = data["isMuteStatus"] ?? false;
      onUpdateMuteSettingsStreamController.add(event);
      messageEventsListener?.onUpdateMuteSettings(
          isSuccess, message, isMuteStatus);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on chat mute settings update: $error");
      onUpdateMuteSettingsStreamController.addError(error);
    });

    onArchiveUnArchiveChatsChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var chatJid = data["toUser"] ?? "";
      var archiveStatus = data["archiveStatus"] ?? false;
      onArchiveUnArchiveChatsStreamController.add(event);
      messageEventsListener?.onArchiveUnArchiveChats(chatJid, archiveStatus);
    }, onError: (error) {
      LogMessage.d(
          "MirrorFly", "Error on chat archive / Unarchive updates: $error");
      onArchiveUnArchiveChatsStreamController.addError(error);
    });

    onArchivedSettingsUpdatedChannel.receiveBroadcastStream().listen((event) {
      onArchivedSettingsUpdatedStreamController.add(event);
      messageEventsListener?.onArchivedSettingsUpdated(event);
    }, onError: (error) {
      LogMessage.d("MirrorFly",
          "Error on chat archive / Unarchive settings toggle: $error");
      onArchivedSettingsUpdatedStreamController.addError(error);
    });

    onSuperAdminDeleteGroupChannel.receiveBroadcastStream().listen((event) {
      onSuperAdminDeleteGroupStreamController.add(event);
      var data = json.decode(event.toString());
      var groupJid = data["groupJid"] ?? "";
      var groupName = data["groupName"] ?? "";
      groupEventsListener?.onSuperAdminDeleteGroup(groupJid, groupName);
    }, onError: (error) {
      LogMessage.d(
          "MirrorFly", "Error on Super admin delete group channel: $error");
      onSuperAdminDeleteGroupStreamController.addError(error);
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
      callLinkEventsListener?.onLocalVideoTrackAdded(userJid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on local video track added: $error");
      onLocalVideoTrackAddedStreamController.addError(error);
    });

    onRemoteVideoTrackAddedChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var userJid = data["userJid"] ?? "";
      onRemoteVideoTrackAddedStreamController.add(event);
      callEventsListener?.onRemoteVideoTrackAdded(userJid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on remote video track added: $error");
      onRemoteVideoTrackAddedStreamController.addError(error);
    });

    onTrackAddedChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var userJid = data["userJid"] ?? "";
      onTrackAddedStreamController.add(event);
      callEventsListener?.onTrackAdded(userJid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on track added: $error");
      onTrackAddedStreamController.addError(error);
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
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on call status updated: $error");
      onCallStatusUpdatedStreamController.addError(error);
    });

    onCallActionChannel.receiveBroadcastStream().listen((event) {
      var actionReceived = jsonDecode(event);
      var callAction = actionReceived["callAction"].toString();
      var userJid = actionReceived["userJid"].toString();
      var callMode = actionReceived["callMode"].toString();
      var callType = actionReceived["callType"].toString();
      onCallActionStreamController.add(event);
      callEventsListener?.onCallAction(userJid, callMode, callType, callAction);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on call action: $error");
      onCallActionStreamController.addError(error);
    });

    onMuteStatusUpdatedChannel.receiveBroadcastStream().listen((event) {
      var muteStatus = jsonDecode(event);
      var muteEvent = muteStatus["muteEvent"].toString();
      var userJid = muteStatus["userJid"].toString();
      onMuteStatusUpdatedStreamController.add(event);
      callEventsListener?.onMuteStatusUpdated(userJid, muteEvent);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on mute status updated: $error");
      onMuteStatusUpdatedStreamController.addError(error);
    });

    onUserSpeakingChannel.receiveBroadcastStream().listen((event) {
      var data = json.decode(event.toString());
      var audioLevel = data["audioLevel"];
      var userJid = data["userJid"];
      onUserSpeakingStreamController.add(event);
      callEventsListener?.onUserSpeaking(userJid, audioLevel);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on user speaking: $error");
      onUserSpeakingStreamController.addError(error);
    });

    onUserStoppedSpeakingChannel.receiveBroadcastStream().listen((userJid) {
      onUserStoppedSpeakingStreamController.add(userJid);
      callEventsListener?.onUserStoppedSpeaking(userJid);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on user stopped speaking: $error");
      onUserStoppedSpeakingStreamController.addError(error);
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
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on missed call: $error");
      onMissedCallStreamController.addError(error);
    });

    onAvailableFeaturesUpdatedChannel.receiveBroadcastStream().listen((event) {
      client.AvailableFeatures availableFeatures =
          client.availableFeaturesFromJson(event.toString());
      onAvailableFeaturesUpdatedStreamController.add(event);
      messageEventsListener?.onAvailableFeaturesUpdated(availableFeatures);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on available features updated: $error");
      onAvailableFeaturesUpdatedStreamController.addError(error);
    });

    onCallLogsUpdatedChannel.receiveBroadcastStream().listen((event) {
      onCallLogsUpdatedStreamController.add(event);
      callEventsListener?.onCallLogsUpdated();
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on call logs updated: $error");
      onCallLogsUpdatedStreamController.addError(error);
    });

    onCallLogDeletedChannel.receiveBroadcastStream().listen((callLogId) {
      onCallLogDeletedStreamController.add(callLogId);
      callEventsListener?.onCallLogDeleted(callLogId);
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on call log deleted: $error");
      onCallLogDeletedStreamController.addError(error);
    });

    onClearAllCallLogChannel.receiveBroadcastStream().listen((event) {
      onClearAllCallLogStreamController.add(event);
      callEventsListener?.onCallLogsCleared();
    }, onError: (error) {
      LogMessage.d("MirrorFly", "Error on clear all call log: $error");
      onClearAllCallLogStreamController.addError(error);
    });

    onSubscribeSuccessChannel.receiveBroadcastStream().listen((event) {
      debugPrint("onSubscribeSuccessChannel event = $event");
      onSubscribeSuccessStreamController.add(event);
      callLinkEventsListener?.onSubscribeSuccess();
    }, onError: (error) {
      debugPrint("onSubscribeSuccessChannel error = $error");
      onSubscribeSuccessStreamController.addError(error);
    });

    onErrorChannel.receiveBroadcastStream().listen((event) {
      debugPrint("onErrorChannel event = $event");
      onErrorStreamController.add(event);
      var data = json.decode(event.toString());
      var code = data["code"];
      var description = data["description"];
      callLinkEventsListener?.onError(FlyException(code, description, null));
    }, onError: (error) {
      debugPrint("onErrorChannel error = $error");
      onErrorStreamController.addError(error);
    });

    onUsersUpdatedChannel.receiveBroadcastStream().listen((event) {
      debugPrint("onUsersUpdatedChannel event = $event");
      onUsersUpdatedStreamController.add(event);
      var data = json.decode(event.toString());
      callLinkEventsListener?.onUsersUpdated(List<String>.from(data ?? []));
    }, onError: (error) {
      debugPrint("onUsersUpdatedChannel error = $error");
      onUsersUpdatedStreamController.addError(error);
    });

    onIncomingCallReceivedChannel.receiveBroadcastStream().listen((event) {
      debugPrint("onIncomingCallReceivedChannel event = $event");
      onIncomingCallReceivedStreamController.add(event);
      callEventsListener?.onIncomingCallReceived(event);
    });
  }

  /*@override
  Future<String?> getPlatformVersion() async {
    final version =
    await mirrorFlyMethodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }*/

  /// A variable to store the enableDebugLog value, default value is false.
  static bool enableDebugLog = false;

  @override
  init(ChatBuilder builder) async {
    enableDebugLog = builder.enableDebugLog;
    if (!_messageOnReceivedStreamController.hasListener) {
      addStreamsAllToStreamController();
    }
    initialized = true;
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
      initialized = true;
      callback.call(
          FlyResponse(true, FlyConstants.empty, "initializeSDK Successfully"));
      // return res;
      return;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      initialized = false;
      callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
          FlyException(e.code, e.message, e.details)));
      // return res;
      return;
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      initialized = false;
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
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('isPrivateStorageEnabled');
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
  Future<bool?> configureAndroidCallKit(AndroidCallKitSettings builder) async {
    bool? response = false;
    if (Platform.isAndroid) {
      try {
        response = await mirrorFlyCallMethodChannel.invokeMethod<bool>(
          "configureAndroidCallKit",
          builder.toMap(),
        );
        return response;
      } on PlatformException catch (e) {
        LogMessage.d("#Platform Exception =", " $e");
        rethrow;
      } on Exception catch (e) {
        LogMessage.d("Exception ", " $e");
        rethrow;
      }
    } else {
      return false;
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
  updateChatMuteStatusList(List<String> jidList, bool muteStatus) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('updateChatMuteStatusList',
          {"jidList": jidList, "mute_status": muteStatus});
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

  /*@override
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
  }*/

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
  Future<void> updateFcmToken(String firebasetoken, bool isForceUpdate,
      Function(FlyResponse response)? callback) async {
    // bool? res;
    try {
      final String? res = await mirrorFlyMethodChannel.invokeMethod<String>(
          'updateFcmToken',
          {"token": firebasetoken, "isForceUpdate": isForceUpdate});
      LogMessage.d("updateFcmToken", " $res");
      callback?.call(FlyResponse(true, convertTokenResponseToJson(res),
          "fcm token updated successfully"));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback?.call(FlyResponse(false, convertTokenResponseToJson(e.message),
          FlyConstants.empty, FlyException(e.code, e.message, e.details)));
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

  @override
  Future<String?> getUnsentMessageOf(String jid) async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<String>('getUnsentMessageOf', {"jid": jid});
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
    LogMessage.d("sendMessage from plugin", messageParams.toMap());
    //sendMessage
    String? messageResponse;
    try {
      messageResponse = await mirrorFlyMethodChannel.invokeMethod(
          'sendMessage', messageParams.toMap());
      LogMessage.d("sendMessage response ", messageResponse);
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

  /* @override
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
  }*/

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

/*  @override
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
  }*/

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

  /*@override
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
   */

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
  Future<bool?> logoutWebUser() async {
    bool? response;
    try {
      response =
          await mirrorFlyMethodChannel.invokeMethod<bool>('logoutWebUser');
      LogMessage.d("logoutWebUser Response ", " $response");
      return response;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      return false;
      // rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      return false;
      // rethrow;
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
      if (Platform.isIOS) {
        if (response!) {
          callback
              ?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
        } else {
          callback?.call(
              FlyResponse(false, FlyConstants.empty, FlyConstants.empty));
        }
      } else {
        callback
            ?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      } // return response;
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
  saveUnsentMessage(
      String jid, String message, List<String>? mentionedUsers) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('saveUnsentMessage', {
        "jid": jid,
        "texMessage": message,
        "mentionedUsers": mentionedUsers
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
      // rethrow;
      return FlyConstants.empty;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      // rethrow;
      return FlyConstants.empty;
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
  Future<bool> isLockScreen() async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('isLockScreen');
      LogMessage.d("isLockScreen", res);
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
  Future<void> startBackup(bool enableEncryption) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod<bool>(
          'startBackup', {'enableEncryption': enableEncryption});
    } on PlatformException catch (e) {
      LogMessage.d("startBackup Platform Exception =", " $e");
    } on Exception catch (e) {
      LogMessage.d("startBackup Exception ", " $e");
    }
  }

  @override
  Future<void> restoreBackup({required String backupPath}) async {
    try {
      await mirrorFlyMethodChannel
          .invokeMethod<bool>('restoreBackup', {'backupPath': backupPath});
    } on PlatformException catch (e) {
      LogMessage.d("restoreBackup Platform Exception =", " $e");
    } on Exception catch (e) {
      LogMessage.d("restoreBackup Exception ", " $e");
    }
  }

  @override
  Future<void> cancelBackup() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod<bool>('cancelBackup');
    } on PlatformException catch (e) {
      LogMessage.d("cancelBackup Platform Exception =", " $e");
    } on Exception catch (e) {
      LogMessage.d("cancelBackup Exception ", " $e");
    }
  }

  @override
  Future<void> cancelRestore() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod<bool>('cancelRestore');
    } on PlatformException catch (e) {
      LogMessage.d("cancelRestore Platform Exception =", " $e");
    } on Exception catch (e) {
      LogMessage.d("cancelRestore Exception ", " $e");
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
  Future<int?> getCurrentCallDuration() async {
    if (Platform.isAndroid) {
      int? res;
      try {
        res = await mirrorFlyCallMethodChannel
            .invokeMethod('getCurrentCallDuration');
        LogMessage.d('getCurrentCallDuration', '$res');
        return res;
      } on PlatformException catch (e) {
        LogMessage.d("Platform Exception =", " $e");
        rethrow;
      } on Exception catch (error) {
        LogMessage.d("Exception ", " $error");
        rethrow;
      }
    } else {
      return null;
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
  void setMessageEventListener(MessageEventListeners? messageEventsListener) {
    this.messageEventsListener = messageEventsListener;
  }

  @override
  void setConnectionEventListener(
      ConnectionEventListeners? connectionEventsListener) {
    this.connectionEventsListener = connectionEventsListener;
  }

  @override
  void setProfileEventsListener(ProfileEventListeners? profileEventsListener) {
    this.profileEventsListener = profileEventsListener;
  }

  @override
  void setGroupEventsListener(GroupEventListeners? groupEventsListener) {
    this.groupEventsListener = groupEventsListener;
  }

  @override
  void setCallEventListener(CallEventListeners? callEventsListener) {
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

  @override
  void setCallLinkEventListener(CallLinkEventListeners callLinkEventsListener) {
    this.callLinkEventsListener = callLinkEventsListener;
  }

  @override
  Future<void> createMeetLink(Function(FlyResponse response)? callback) async {
    String? val = FlyConstants.empty;
    try {
      val = await mirrorFlyCallMethodChannel
          .invokeMethod<String>('createMeetLink');
      LogMessage.d('createMeetLink', ' $val');
      callback?.call(
          FlyResponse(true, val ?? FlyConstants.empty, FlyConstants.empty));
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
  Future<String> getCallLink() async {
    String? val = FlyConstants.empty;
    try {
      val =
          await mirrorFlyCallMethodChannel.invokeMethod<String>('getCallLink');
      LogMessage.d('getCallLink', ' $val');
      return val ?? FlyConstants.empty;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      return FlyConstants.empty;
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      return FlyConstants.empty;
    }
  }

  @override
  Future<void> initializeMeet(String callLink, String userName,
      Function(FlyResponse response)? callback) async {
    bool? val = false;
    try {
      val = await mirrorFlyCallMethodChannel.invokeMethod(
          'initializeMeet', {"callLink": callLink, "userName": userName});
      LogMessage.d('initializeMeet', ' $val');
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
  Future<void> disposePreview() async {
    bool? val = false;
    try {
      val = await mirrorFlyCallMethodChannel.invokeMethod('disposePreview');
      LogMessage.d('disposePreview', ' $val');
      return;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      rethrow;
    }
  }

  @override
  Future<void> joinCall(Function(FlyResponse response)? callback) async {
    bool? val = false;
    try {
      val = await mirrorFlyCallMethodChannel.invokeMethod('joinCall');
      LogMessage.d('joinCall', ' $val');
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
  Future<void> startVideoCapture(
      Function(FlyResponse response)? callback) async {
    bool? val = false;
    try {
      val = await mirrorFlyCallMethodChannel.invokeMethod('startVideoCapture');
      LogMessage.d('startVideoCapture', ' $val');
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
  Future<String> getMeetUsername(String jid) async {
    String? val = FlyConstants.empty;
    try {
      val = await mirrorFlyCallMethodChannel
          .invokeMethod<String>('getMeetUsername', {'userJid': jid});
      LogMessage.d('getMeetUsername', ' $val');
      return val ?? FlyConstants.empty;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      return FlyConstants.empty;
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      return FlyConstants.empty;
    }
  }

  @override
  Future<String> getCurrentCameraPosition() async {
    String? val = "";
    try {
      val = await mirrorFlyCallMethodChannel
          .invokeMethod<String>('getCurrentCameraPosition');
      LogMessage.d('getCurrentCameraPosition', ' $val');
      return val ?? "";
      // callback?.call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      return "";
      // callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty, FlyException(e.code, e.message, e.details)));
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      return "";
      // callback?.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty, FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
    }
  }

  @override
  Future<void> setTranslations(
      {required fileNameOrPath,
      String? packageName,
      required Function(FlyResponse response) callback}) async {
    final FileReadResult result = await MirrorFlyFileHelper.readFile(
        fileNameOrPath: fileNameOrPath, packageName: packageName);
    if (result.isSuccess) {
      try {
        LogMessage.d(
            "setTranslations loadString success", "true, map: ${result.map}");
        await mirrorFlyMethodChannel
            .invokeMethod<bool>('setTranslations', {"stringSet": result.map});
        callback
            .call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      } on PlatformException catch (e) {
        LogMessage.d("Platform Exception =", " $e");
        callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
            FlyException(e.code, e.message, e.details)));
      } on Exception catch (e) {
        LogMessage.d("Exception ", " $e");
        callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
            FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
      }
    } else {
      LogMessage.d("Exception ", " ${result.errorMessage}");
      callback.call(
          FlyResponse(false, FlyConstants.empty, result.errorMessage, null));
    }
  }

  @override
  void getAuthToken({required Function(FlyResponse response) callback}) async {
    try {
      // final String? token = await mirrorFlyMethodChannel.invokeMethod<String>('getAuthToken');
      // callback
      //     .call(FlyResponse(true, token ?? 'token empty', FlyConstants.empty));
    } catch(e) {
      // LogMessage.d("initializeCallKit",'error... $e');
    }
  }

  @override
  Future<void> initializeCallKit(
      Function(FlyResponse response)? callback) async {
    try {
      LogMessage.d("initializeCallKit", 'started...');
      MirrorFlyCallKit.initialize(
        enableLogs: true,
        centrifugeUrl: 'wss://mf-core.contus.us/connection/websocket',
        authToken : await Mirrorfly.getCurrentAuthToken(),
        // userId: "917530066369",
        liveKitUrl:"wss://livekit-product.contus.us/",
        //wss://livekit-product.contus.us // wss://livekit-uikit-dev.contus.us //wss://livekit-uikit-qa.contus.us
      );
    } catch (e) {
      LogMessage.d("initializeCallKit", 'error... $e');
    }
  }

  @override
  Future<void> makeAudioCall(
      {required List<String> callersId,
      required String chatId,
      required Function(FlyResult response) flyResult}) async {
    try {
      LogMessage.d("makeLiveKitAudioCall", 'started...');
      MirrorFlyCallKit.makeAudioCall(
          callersId: callersId,
          chatId: chatId,
          flyResult: flyResult
      );
    } catch (e) {
      flyResult(FlyResult(isSuccess: false, data: "error... $e"));
      LogMessage.d("makeLiveKitAudioCall", 'error... $e');
    }
  }

  @override
  Future<void> makeLKVideoCall(
      {required List<String> callersId,
      required String chatId,
      required Function(FlyResult response) flyResult}) async {
    try {
      LogMessage.d("makeLiveKitAudioCall", 'started...');
      MirrorFlyCallKit.makeVideoCall(
          flyResult: flyResult,
          callersId: callersId,
          chatId: chatId);
    } catch (e) {
      flyResult(FlyResult(isSuccess: false, data: "error... $e"));
      LogMessage.d("makeLiveKitAudioCall", 'error... $e');
    }
  }

  // @override
  // Future<void> disconnectLiveKitCall(Function(FlyResponse response) flyCallback) async {
  //   try {
  //     LogMessage.d("makeLiveKitAudioCall", 'started...');
  //     MirrorFlyCallKit.disconnectCall();
  //   } catch (e) {
  //     LogMessage.d("makeLiveKitAudioCall", 'error... $e');
  //   }
  // }

  ///
  @override
  Future<void> liveKitLocalHangup(Function(FlyResponse response) flyCallback) async {
    try {
      LogMessage.d("liveKitLocalHangup", 'started...');
      MirrorFlyCallKit.localHangup();
    } catch (e) {
      LogMessage.d("liveKitLocalHangup", 'error... $e');
    }
  }

  @override
  Future<void> answerCall(
      {required Function(FlyResponse response) callback}) async {
    if (Platform.isAndroid) {
      try {
        LogMessage.d("answerCall", "answerCall");
        await mirrorFlyCallMethodChannel.invokeMethod<bool>('answerCall');
        callback
            .call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
      } on PlatformException catch (e) {
        LogMessage.d("Platform Exception =", " $e");
        callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
            FlyException(e.code, e.message, e.details)));
      } on Exception catch (e) {
        LogMessage.d("Exception ", " $e");
        callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
            FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
      }
    } else {
      const String errorMessage = "This method call is not supported for iOS";
      LogMessage.d("Exception ", " $errorMessage");
      callback.call(FlyResponse(
          false,
          FlyConstants.empty,
          FlyConstants.empty,
          FlyException(
              FlyErrorCode.unHandle, FlyErrorMessage.unHandle, errorMessage)));
    }
  }

  @override
  Future<bool?> isCallConnected(
      {required Function(FlyResponse response) callback}) async {
    bool? getIsCallConnected = false;
    if (Platform.isAndroid) {
      try {
        LogMessage.d("answerCall", "answerCall");
        getIsCallConnected = await mirrorFlyCallMethodChannel
            .invokeMethod<bool>('isCallConnected');
        callback
            .call(FlyResponse(true, FlyConstants.empty, FlyConstants.empty));
        return getIsCallConnected;
      } on PlatformException catch (e) {
        LogMessage.d("Platform Exception =", " $e");
        callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
            FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
        return getIsCallConnected;
      } on Exception catch (e) {
        LogMessage.d("Exception ", " $e");
        callback.call(FlyResponse(false, FlyConstants.empty, FlyConstants.empty,
            FlyException(FlyErrorCode.unHandle, FlyErrorMessage.unHandle, e)));
        return getIsCallConnected;
      }
    } else {
      const String errorMessage = "This method call is not supported for iOS";
      LogMessage.d("Exception ", " $errorMessage");
      callback.call(FlyResponse(
          false,
          FlyConstants.empty,
          FlyConstants.empty,
          FlyException(
              FlyErrorCode.unHandle, FlyErrorMessage.unHandle, errorMessage)));
    }
    return getIsCallConnected;
  }

  @override
  Future<void> updateVoipTokenForLiveKitCalls() async {
    if (Platform.isIOS) {
      try {
        LogMessage.d("#MirrorFly Livekit", "updateVoipTokenForLiveKitCalls");
        await mirrorFlyMethodChannel.invokeMethod<bool>('updateVoipTokenForLiveKitCalls');
      } on PlatformException catch (e) {
        LogMessage.d("#MirrorFly Livekit Platform Exception =", " $e");
      } on Exception catch (e) {
        LogMessage.d("#MirrorFly Livekit Exception ", " $e");
      }
    } else {
      LogMessage.d("#MirrorFly Livekit", "updateVoipTokenForLiveKitCalls");
    }
  }
}
