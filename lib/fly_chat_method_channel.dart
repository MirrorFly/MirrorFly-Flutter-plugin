import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mirrorfly_plugin/fly_chat_platform_interface.dart';
import 'package:mirrorfly_plugin/internal_models/audio_devices_model.dart';
import 'package:mirrorfly_plugin/internal_models/available_features_model.dart';
import 'package:mirrorfly_plugin/internal_models/call_logs_model.dart';
import 'package:mirrorfly_plugin/internal_models/chat_messages_model.dart';
import 'package:mirrorfly_plugin/internal_models/export_chat_model.dart';
import 'package:mirrorfly_plugin/internal_models/get_user_profile_model.dart';
import 'package:mirrorfly_plugin/internal_models/internal_status_model.dart';
import 'package:mirrorfly_plugin/internal_models/message_delivered_status_model.dart';
import 'package:mirrorfly_plugin/internal_models/profile_detail_model.dart';
import 'package:mirrorfly_plugin/internal_models/recent_chat_model.dart';
import 'package:mirrorfly_plugin/internal_models/register_user_model.dart';
import 'package:mirrorfly_plugin/internal_models/user_profile_update.dart';
import 'package:mirrorfly_plugin/internal_models/users_list_model.dart';
import 'package:mirrorfly_plugin/logmessage.dart';
import 'package:mirrorfly_plugin/model/topic_metadata.dart';

import 'builder.dart';
import 'internal_models/callback.dart';

/// An implementation of UikitFlutterPlatform that uses method channels.
class MethodChannelFlyChatFlutter extends FlyChatFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final mirrorFlyMethodChannel = const MethodChannel('contus.mirrorfly/flyChat');
  @visibleForTesting
  final mirrorFlyCallMethodChannel = const MethodChannel('contus.mirrorfly/flyCall');

  //Event Channels
  @visibleForTesting
  final messageOnReceivedChannel = const EventChannel('contus.mirrorfly/onMessageReceived');
  final StreamController<String> _messageOnReceivedStreamController = StreamController<String>.broadcast();
  @visibleForTesting
  final messageStatusUpdatedChanel = const EventChannel('contus.mirrorfly/onMessageStatusUpdated');
  final StreamController<dynamic> messageStatusUpdateStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final mediaStatusUpdatedChannel = const EventChannel('contus.mirrorfly/onMediaStatusUpdated');
  final StreamController<dynamic> mediaStatusUpdatedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final uploadDownloadProgressChangedChannel = const EventChannel('contus.mirrorfly/onUploadDownloadProgressChanged');
  final StreamController<dynamic> uploadDownloadProgressChangedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final showUpdateCancelNotificationChannel = const EventChannel('contus.mirrorfly/showOrUpdateOrCancelNotification');
  final StreamController<dynamic> showUpdateCancelNotificationStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onGroupProfileFetchedChannel = const EventChannel('contus.mirrorfly/onGroupProfileFetched');
  final StreamController<dynamic> onGroupProfileFetchedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onNewGroupCreatedChannel = const EventChannel('contus.mirrorfly/onNewGroupCreated');
  final StreamController<dynamic> onNewGroupCreatedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onGroupProfileUpdatedChannel = const EventChannel('contus.mirrorfly/onGroupProfileUpdated');
  final StreamController<dynamic> onGroupProfileUpdatedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onNewMemberAddedToGroupChannel = const EventChannel('contus.mirrorfly/onNewMemberAddedToGroup');
  final StreamController<dynamic> onNewMemberAddedToGroupStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onMemberRemovedFromGroupChannel = const EventChannel('contus.mirrorfly/onMemberRemovedFromGroup');
  final StreamController<dynamic> onMemberRemovedFromGroupStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onFetchingGroupMembersCompletedChannel = const EventChannel('contus.mirrorfly/onFetchingGroupMembersCompleted');
  final StreamController<dynamic> onFetchingGroupMembersCompletedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onDeleteGroupChannel = const EventChannel('contus.mirrorfly/onDeleteGroup');
  final StreamController<dynamic> onDeleteGroupStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onFetchingGroupListCompletedChannel = const EventChannel('contus.mirrorfly/onFetchingGroupListCompleted');
  final StreamController<dynamic> onFetchingGroupListCompletedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onMemberMadeAsAdminChannel = const EventChannel('contus.mirrorfly/onMemberMadeAsAdmin');
  final StreamController<dynamic> onMemberMadeAsAdminStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onMemberRemovedAsAdminChannel = const EventChannel('contus.mirrorfly/onMemberRemovedAsAdmin');
  final StreamController<dynamic> onMemberRemovedAsAdminStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onLeftFromGroupChannel = const EventChannel('contus.mirrorfly/onLeftFromGroup');
  final StreamController<dynamic> onLeftFromGroupStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onGroupNotificationMessageChannel = const EventChannel('contus.mirrorfly/onGroupNotificationMessage');
  final StreamController<dynamic> onGroupNotificationMessageStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final showOrUpdateOrCancelNotificationChannel = const EventChannel('contus.mirrorfly/showOrUpdateOrCancelNotification');
  final StreamController<dynamic> showOrUpdateOrCancelNotificationStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onGroupDeletedLocallyChannel = const EventChannel('contus.mirrorfly/onGroupDeletedLocally');
  final StreamController<dynamic> onGroupDeletedLocallyStreamController = StreamController<dynamic>.broadcast();

  @visibleForTesting
  final blockedThisUserChannel = const EventChannel('contus.mirrorfly/blockedThisUser');
  final StreamController<dynamic> blockedThisUserStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final myProfileUpdatedChannel = const EventChannel('contus.mirrorfly/myProfileUpdated');
  final StreamController<dynamic> myProfileUpdatedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onAdminBlockedOtherUserChannel = const EventChannel('contus.mirrorfly/onAdminBlockedOtherUser');
  final StreamController<dynamic> onAdminBlockedOtherUserStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onAdminBlockedUserChannel = const EventChannel('contus.mirrorfly/onAdminBlockedUser');
  final StreamController<dynamic> onAdminBlockedUserStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onContactSyncCompleteChannel = const EventChannel('contus.mirrorfly/onContactSyncComplete');
  final StreamController<dynamic> onContactSyncCompleteStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onLoggedOutChannel = const EventChannel('contus.mirrorfly/onLoggedOut');
  final StreamController<dynamic> onLoggedOutStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final unblockedThisUserChannel = const EventChannel('contus.mirrorfly/unblockedThisUser');
  final StreamController<dynamic> unblockedThisUserStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final userBlockedMeChannel = const EventChannel('contus.mirrorfly/userBlockedMe');
  final StreamController<dynamic> userBlockedMeStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final userCameOnlineChannel = const EventChannel('contus.mirrorfly/userCameOnline');
  final StreamController<dynamic> userCameOnlineStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final userDeletedHisProfileChannel = const EventChannel('contus.mirrorfly/userDeletedHisProfile');
  final StreamController<dynamic> userDeletedHisProfileStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final userProfileFetchedChannel = const EventChannel('contus.mirrorfly/userProfileFetched');
  final StreamController<dynamic> userProfileFetchedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final userUnBlockedMeChannel = const EventChannel('contus.mirrorfly/userUnBlockedMe');
  final StreamController<dynamic> userUnBlockedMeStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final userUpdatedHisProfileChannel = const EventChannel('contus.mirrorfly/userUpdatedHisProfile');
  final StreamController<dynamic> userUpdatedHisProfileStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final userWentOfflineChannel = const EventChannel('contus.mirrorfly/userWentOffline');
  final StreamController<dynamic> userWentOfflineStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final usersIBlockedListFetchedChannel = const EventChannel('contus.mirrorfly/usersIBlockedListFetched');
  final StreamController<dynamic> usersIBlockedListFetchedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final usersProfilesFetchedChannel = const EventChannel('contus.mirrorfly/usersProfilesFetched');
  final StreamController<dynamic> usersProfilesFetchedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final usersWhoBlockedMeListFetchedChannel = const EventChannel('contus.mirrorfly/usersWhoBlockedMeListFetched');
  final StreamController<dynamic> usersWhoBlockedMeListFetchedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onConnectedChannel = const EventChannel('contus.mirrorfly/onConnected');
  final StreamController<dynamic> onConnectedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onDisconnectedChannel = const EventChannel('contus.mirrorfly/onDisconnected');
  final StreamController<dynamic> onDisconnectedStreamController = StreamController<dynamic>.broadcast();

  /*@visibleForTesting
  final onConnectionNotAuthorizedChannel =
      const EventChannel('contus.mirrorfly/onConnectionNotAuthorized');*/
  @visibleForTesting
  final onConnectionFailedChannel = const EventChannel('contus.mirrorfly/onConnectionFailed');
  final StreamController<dynamic> onConnectionFailedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final connectionFailedChannel = const EventChannel('contus.mirrorfly/connectionFailed');
  final StreamController<dynamic> connectionFailedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final connectionSuccessChannel = const EventChannel('contus.mirrorfly/connectionSuccess');
  final StreamController<dynamic> connectionSuccessStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onWebChatPasswordChangedChannel = const EventChannel('contus.mirrorfly/onWebChatPasswordChanged');
  final StreamController<dynamic> onWebChatPasswordChangedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final setTypingStatusChannel = const EventChannel('contus.mirrorfly/setTypingStatus');
  final StreamController<dynamic> setTypingStatusStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onChatTypingStatusChannel = const EventChannel('contus.mirrorfly/onChatTypingStatus');
  final StreamController<dynamic> onChatTypingStatusStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onGroupTypingStatusChannel = const EventChannel('contus.mirrorfly/onGroupTypingStatus');
  final StreamController<dynamic> onGroupTypingStatusStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onFailureChannel = const EventChannel('contus.mirrorfly/onFailure');
  final StreamController<dynamic> onFailureStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onProgressChangedChannel = const EventChannel('contus.mirrorfly/onProgressChanged');
  final StreamController<dynamic> onProgressChangedStreamController = StreamController<dynamic>.broadcast();
  @visibleForTesting
  final onSuccessChannel = const EventChannel('contus.mirrorfly/onSuccess');
  final StreamController<dynamic> onSuccessStreamController = StreamController<dynamic>.broadcast();

  //Need to add stream controller here
  // @visibleForTesting
  // final onCallReceivingChannel = const EventChannel('contus.mirrorfly/onCallReceiving');
  // final StreamController<dynamic> onCallReceivingStreamController = StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onLocalVideoTrackAddedChannel = const EventChannel('contus.mirrorfly/onLocalVideoTrackAdded');
  final StreamController<dynamic> onLocalVideoTrackAddedStreamController = StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onRemoteVideoTrackAddedChannel = const EventChannel('contus.mirrorfly/onRemoteVideoTrackAdded');
  final StreamController<dynamic> onRemoteVideoTrackAddedStreamController = StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onTrackAddedChannel = const EventChannel('contus.mirrorfly/onTrackAdded');
  final StreamController<dynamic> onTrackAddedStreamController = StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onCallStatusUpdatedChannel = const EventChannel('contus.mirrorfly/onCallStatusUpdated');
  final StreamController<dynamic> onCallStatusUpdatedStreamController = StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onCallActionChannel = const EventChannel('contus.mirrorfly/onCallAction');
  final StreamController<dynamic> onCallActionStreamController = StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onMuteStatusUpdatedChannel = const EventChannel('contus.mirrorfly/onMuteStatusUpdated');
  final StreamController<dynamic> onMuteStatusUpdatedStreamController = StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onUserSpeakingChannel = const EventChannel('contus.mirrorfly/onUserSpeaking');
  final StreamController<dynamic> onUserSpeakingStreamController = StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onUserStoppedSpeakingChannel = const EventChannel('contus.mirrorfly/onUserStoppedSpeaking');
  final StreamController<dynamic> onUserStoppedSpeakingStreamController = StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onMissedCallChannel = const EventChannel('contus.mirrorfly/onMissedCall');
  final StreamController<dynamic> onMissedCallStreamController = StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onAvailableFeaturesUpdatedChannel = const EventChannel('contus.mirrorfly/onAvailableFeaturesUpdated');
  final StreamController<dynamic> onAvailableFeaturesUpdatedStreamController = StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onCallLogsUpdatedChannel = const EventChannel('contus.mirrorfly/onCallLog');
  final StreamController<dynamic> onCallLogsUpdatedStreamController = StreamController<dynamic>.broadcast();

  @visibleForTesting
  final onCallLogsDeletedChannel = const EventChannel('contus.mirrorfly/onCallLogsDeleted');
  final StreamController<dynamic> onCallLogsDeletedStreamController = StreamController<dynamic>.broadcast();

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
  Future<void> initializeSDK(InitializeSDKBuilder builder,Callback callback ) async {

    bool? res;
    enableDebugLog = builder.enableDebugLog;
    if (!_messageOnReceivedStreamController.hasListener) {
      addStreamsAllToStreamController();
    }
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('initializeSDK', builder.build());
      LogMessage.d("syncContacts", res);
      callback.onSuccessful(FlyResponse(true,"","initializeSDK Successfully"));
      // return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      callback.onSuccessful(FlyResponse(false, "","",FlyException(e.code,e.message,e.details)));
      // return res;
    } on Exception catch (e) {
      LogMessage.d("Exception ", " $e");
      callback.onSuccessful(FlyResponse(false, "","",FlyException("FL-401","Un handle Exception",e)));
      // return res;
    }
  }

  ///Using [addStreamsAllToStreamController] to add all streams to stream controller
  ///benefit to use stream controller we can call multiple listeners to listen.
  addStreamsAllToStreamController() {
    messageOnReceivedChannel.receiveBroadcastStream().listen((event) {
      LogMessage.d("messageOnReceivedChannel",event);
      _messageOnReceivedStreamController.addStream(Stream.value(convertChatMessageJsonFromString(event)));
    });
    messageStatusUpdatedChanel.receiveBroadcastStream().listen((event) {
      messageStatusUpdateStreamController.addStream(Stream.value(convertChatMessageJsonFromString(event)));
    });
    mediaStatusUpdatedChannel.receiveBroadcastStream().listen((event) {
      mediaStatusUpdatedStreamController.addStream(Stream.value(convertChatMessageJsonFromString(event)));
    });
    onGroupNotificationMessageChannel.receiveBroadcastStream().listen((event) {
      onGroupNotificationMessageStreamController.addStream(Stream.value(convertChatMessageJsonFromString(event)));
    });
    showOrUpdateOrCancelNotificationChannel.receiveBroadcastStream().listen((event){
      var data  = json.decode(event.toString());
      var jid = data["jid"];
      var chatMessage = convertChatMessageJsonFromString(data["chatMessage"]);
      var map = {"jid":jid,"chatMessage":chatMessage};
      showOrUpdateOrCancelNotificationStreamController.addStream(Stream.value( json.encode(map)));
    });
    uploadDownloadProgressChangedStreamController.addStream(uploadDownloadProgressChangedChannel.receiveBroadcastStream());
    showUpdateCancelNotificationStreamController.addStream(showUpdateCancelNotificationChannel.receiveBroadcastStream());
    onGroupProfileFetchedStreamController.addStream(onGroupProfileFetchedChannel.receiveBroadcastStream() /*as Stream<String>*/);
    onNewGroupCreatedStreamController.addStream(onNewGroupCreatedChannel.receiveBroadcastStream() /*as Stream<String>*/);
    onGroupProfileUpdatedStreamController.addStream(onGroupProfileUpdatedChannel.receiveBroadcastStream() /*as Stream<String>*/);
    onNewMemberAddedToGroupStreamController.addStream(onNewMemberAddedToGroupChannel.receiveBroadcastStream());
    onMemberRemovedFromGroupStreamController.addStream(onMemberRemovedFromGroupChannel.receiveBroadcastStream());
    onFetchingGroupMembersCompletedStreamController.addStream(onFetchingGroupMembersCompletedChannel.receiveBroadcastStream() /*as Stream<String>*/);
    onDeleteGroupStreamController.addStream(onDeleteGroupChannel.receiveBroadcastStream());
    onFetchingGroupListCompletedStreamController.addStream(onFetchingGroupListCompletedChannel.receiveBroadcastStream());
    onMemberMadeAsAdminStreamController.addStream(onMemberMadeAsAdminChannel.receiveBroadcastStream());
    onMemberRemovedAsAdminStreamController.addStream(onMemberRemovedAsAdminChannel.receiveBroadcastStream());
    onLeftFromGroupStreamController.addStream(onLeftFromGroupChannel.receiveBroadcastStream());


    onGroupDeletedLocallyStreamController.addStream(onGroupDeletedLocallyChannel.receiveBroadcastStream() /*as Stream<String>*/);
    blockedThisUserStreamController.addStream(blockedThisUserChannel.receiveBroadcastStream());
    myProfileUpdatedStreamController.addStream(myProfileUpdatedChannel.receiveBroadcastStream() /*as Stream<bool>*/);
    onAdminBlockedOtherUserStreamController.addStream(onAdminBlockedOtherUserChannel.receiveBroadcastStream());
    onAdminBlockedUserStreamController.addStream(onAdminBlockedUserChannel.receiveBroadcastStream());
    onContactSyncCompleteStreamController.addStream(onContactSyncCompleteChannel.receiveBroadcastStream() /*as Stream<bool>*/);
    onLoggedOutStreamController.addStream(onLoggedOutChannel.receiveBroadcastStream() /*as Stream<bool>*/);
    unblockedThisUserStreamController.addStream(unblockedThisUserChannel.receiveBroadcastStream());
    userBlockedMeStreamController.addStream(userBlockedMeChannel.receiveBroadcastStream());
    userCameOnlineStreamController.addStream(userCameOnlineChannel.receiveBroadcastStream());
    userDeletedHisProfileStreamController.addStream(userDeletedHisProfileChannel.receiveBroadcastStream() /*as Stream<String>*/);
    userProfileFetchedStreamController.addStream(userProfileFetchedChannel.receiveBroadcastStream());
    userUnBlockedMeStreamController.addStream(userUnBlockedMeChannel.receiveBroadcastStream());
    userUpdatedHisProfileStreamController.addStream(userUpdatedHisProfileChannel.receiveBroadcastStream());
    userWentOfflineStreamController.addStream(userWentOfflineChannel.receiveBroadcastStream());
    usersIBlockedListFetchedStreamController.addStream(usersIBlockedListFetchedChannel.receiveBroadcastStream());
    usersProfilesFetchedStreamController.addStream(usersProfilesFetchedChannel.receiveBroadcastStream() /*as Stream<bool>*/);
    usersWhoBlockedMeListFetchedStreamController.addStream(usersWhoBlockedMeListFetchedChannel.receiveBroadcastStream());
    onConnectedStreamController.addStream(onConnectedChannel.receiveBroadcastStream());
    onDisconnectedStreamController.addStream(onDisconnectedChannel.receiveBroadcastStream());
    onConnectionFailedStreamController.addStream(onConnectionFailedChannel.receiveBroadcastStream());
    connectionFailedStreamController.addStream(connectionFailedChannel.receiveBroadcastStream());
    connectionSuccessStreamController.addStream(connectionSuccessChannel.receiveBroadcastStream());
    onWebChatPasswordChangedStreamController.addStream(onWebChatPasswordChangedChannel.receiveBroadcastStream());
    setTypingStatusStreamController.addStream(setTypingStatusChannel.receiveBroadcastStream());
    onChatTypingStatusStreamController.addStream(onChatTypingStatusChannel.receiveBroadcastStream());
    onGroupTypingStatusStreamController.addStream(onGroupTypingStatusChannel.receiveBroadcastStream());
    onFailureStreamController.addStream(onFailureChannel.receiveBroadcastStream());
    onProgressChangedStreamController.addStream(onProgressChangedChannel.receiveBroadcastStream());
    onSuccessStreamController.addStream(onSuccessChannel.receiveBroadcastStream());
    // onCallReceivingStreamController.addStream(onCallReceivingChannel.receiveBroadcastStream());
    onLocalVideoTrackAddedStreamController.addStream(onLocalVideoTrackAddedChannel.receiveBroadcastStream());
    onRemoteVideoTrackAddedStreamController.addStream(onRemoteVideoTrackAddedChannel.receiveBroadcastStream());
    onTrackAddedStreamController.addStream(onTrackAddedChannel.receiveBroadcastStream());
    onCallStatusUpdatedStreamController.addStream(onCallStatusUpdatedChannel.receiveBroadcastStream());
    onCallActionStreamController.addStream(onCallActionChannel.receiveBroadcastStream());
    onMuteStatusUpdatedStreamController.addStream(onMuteStatusUpdatedChannel.receiveBroadcastStream());
    onUserSpeakingStreamController.addStream(onUserSpeakingChannel.receiveBroadcastStream());
    onUserStoppedSpeakingStreamController.addStream(onUserStoppedSpeakingChannel.receiveBroadcastStream());
    onMissedCallStreamController.addStream(onMissedCallChannel.receiveBroadcastStream());
    onAvailableFeaturesUpdatedStreamController.addStream(onAvailableFeaturesUpdatedChannel.receiveBroadcastStream());
    onCallLogsUpdatedStreamController.addStream(onCallLogsUpdatedChannel.receiveBroadcastStream());
    onCallLogsDeletedStreamController.addStream(onCallLogsDeletedChannel.receiveBroadcastStream());
  }

  @override
  Future<bool?> syncContacts(bool isfirsttime) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('syncContacts', {"is_first_time": isfirsttime});
      LogMessage.d("syncContacts", res);
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
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('contactSyncStateValue') ?? false;
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
    dynamic response = "";
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
  Future<dynamic> revokeContactSync() async {
    dynamic response = "";
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('revokeContactSync');
      LogMessage.d("revokeContactSync Result ", " $response");
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
  Future<dynamic> getUsersWhoBlockedMe([bool server = false]) async {
    dynamic response = "";
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getUsersWhoBlockedMe', {"server": server});
      LogMessage.d("getUsersWhoBlockedMe Result ", " $response");
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
  Future<dynamic> getUnKnownUserProfiles() async {
    dynamic response = "";
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
    dynamic response = "";
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
    String? response = "";
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
    String? response = "";
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
    String? response = "";
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getRecalledMessagesOfAConversation', {"jid": jid});
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
  Future<bool?> setMyBusyStatus(String busyStatus) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('setMyBusyStatus', {"status": busyStatus});
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
  Future<bool?> insertBusyStatus(String busyStatus) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('insertBusyStatus', {"busy_status": busyStatus});
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
  Future<bool?> enableDisableBusyStatus(bool enable) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('enableDisableBusyStatus', {"enable": enable});
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
  Future<bool?> enableDisableHideLastSeen(bool enable) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('enableDisableHideLastSeen', {"enable": enable});
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
  Future<bool?> isBusyStatusEnabled() async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('isBusyStatusEnabled');
      LogMessage.d("isBusyStatusEnabled", " $res");
      return res;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> deleteProfileStatus(String id, String status, bool isCurrentStatus) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('deleteProfileStatus', {
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
  Future<bool?> deleteBusyStatus(String id, String status, bool isCurrentStatus) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('deleteBusyStatus', {
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
      response = await mirrorFlyMethodChannel.invokeMethod<String>('media_endpoint');
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
  Future<bool?> unFavouriteAllFavouriteMessages() async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('unFavouriteAllFavouriteMessages');
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
  Future<bool?> markAsRead(String jid) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('markAsRead', {"jid": jid});
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
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('uploadMedia', {"messageid": messageid});
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
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('deleteUnreadMessageSeparatorOfAConversation', {"jid": jid});
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
      res = await mirrorFlyMethodChannel.invokeMethod<int>('getMembersCountOfGroup', {"groupJid": groupJid});
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
  Future<bool?> doesFetchingMembersListFromServedRequired(String groupJid) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('doesFetchingMembersListFromServedRequired', {"groupJid": groupJid});
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
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('isHideLastSeenEnabled');
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
      await mirrorFlyMethodChannel.invokeMethod('deleteOfflineGroup', {"groupJid": groupJid});
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
      await mirrorFlyMethodChannel.invokeMethod('sendTypingStatus', {"to_jid": toJid, "chattype": chattype});
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
      await mirrorFlyMethodChannel.invokeMethod('sendTypingGoneStatus', {"to_jid": toJid, "chattype": chattype});
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
      await mirrorFlyMethodChannel.invokeMethod('updateChatMuteStatus', {"jid": jid, "mute_status": muteStatus});
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
      await mirrorFlyMethodChannel.invokeMethod('updateRecentChatPinStatus', {"jid": jid, "pin_recent_chat": pinStatus});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> deleteRecentChat(String jid) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod('deleteRecentChat', {"jid": jid});
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
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('isUserUnArchived', {"jid": jid});
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
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('getIsProfileBlockedByAdmin');
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
  Future<bool?> deleteRecentChats(List<String> jidlist) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('deleteRecentChats', {"jidlist": jidlist});
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
  markConversationAsRead(List<String> jidlist) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('markConversationAsRead', {"jidlist": jidlist});
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
      await mirrorFlyMethodChannel.invokeMethod('markConversationAsUnread', {"jidlist": jidlist});
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
      await mirrorFlyMethodChannel.invokeMethod('setCustomValue', {"message_id": messageId, "key": key, "value": value});
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
      await mirrorFlyMethodChannel.invokeMethod('removeCustomValue', {"message_id": messageId, "key": key});
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
      await mirrorFlyMethodChannel.invokeMethod('inviteUserViaSMS', {"mobile_no": mobileNo, "message": message});
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
      res = await mirrorFlyMethodChannel.invokeMethod<String>('getCustomValue', {"message_id": messageId, "key": key});
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
  Future<bool?> clearAllConversation() async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('clearAllConversation');
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
  Future<bool?> updateFcmToken(String firebasetoken) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('updateFcmToken', {"token": firebasetoken});
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
  Future<bool?> isMuted(String jid) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('isMuted', {"jid": jid});
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
  Future<String?> handleReceivedMessage(Map notificationData) async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod('handleReceivedMessage', {"notificationdata": notificationData});
      return convertChatMessageJsonFromString(res);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String?> getLastNUnreadMessages(int messagesCount) async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod('getLastNUnreadMessages', {"messagecount": messagesCount});
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
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('isArchivedSettingsEnabled');
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
  Future<bool?> enableDisableArchivedSettings(bool enable) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('enableDisableArchivedSettings', {"enable": enable});
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
  Future<bool?> updateArchiveUnArchiveChat(String jid, bool isArchived) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('updateArchiveUnArchiveChat', {"jid": jid, "isArchived": isArchived});
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
  Future<int?> getGroupMessageStatusCount(String messageid) async {
    int? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<int>('getGroupMessageStatusCount', {"messageid": messageid});
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
      res = await mirrorFlyMethodChannel.invokeMethod<int>('getUnreadMessageCountExceptMutedChat');
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
      res = await mirrorFlyMethodChannel.invokeMethod<int>('getGroupMessageStatusCount');
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
      res = await mirrorFlyMethodChannel.invokeMethod<int>('getUnreadMessagesCount');
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
      res = await mirrorFlyMethodChannel.invokeMethod<String>('getUnsentMessageOfAJid', {"jid": jid});
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
  Future<String?> getArchivedChatList() async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod('getArchivedChatList');
      return convertRecentChatDataJsonFromString(res);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
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
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('createOfflineGroupInOnline', {"groupId": groupId});
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
  Future<String?> getGroupProfile(String groupJid, bool server) async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod('getGroupProfile', {"groupJid": groupJid, "server": server});
      return convertProfileDetailJsonFromString(res);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  updateMediaDownloadStatus(String mediaMessageId, int progress, int downloadStatus, num dataTransferred) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('updateMediaDownloadStatus',
          {"mediaMessageId": mediaMessageId, "progress": progress, "downloadStatus": downloadStatus, "dataTransferred": dataTransferred});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  updateMediaUploadStatus(String mediaMessageId, int progress, int uploadStatus, num dataTransferred) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('updateMediaUploadStatus',
          {"mediaMessageId": mediaMessageId, "progress": progress, "downloadStatus": uploadStatus, "dataTransferred": dataTransferred});
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
      await mirrorFlyMethodChannel.invokeMethod('cancelMediaUploadOrDownload', {"messageId": messageId});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  setMediaEncryption(String encryption) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('setMediaEncryption', {"encryption": encryption});
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
      response = await mirrorFlyMethodChannel.invokeMethod<String>('getGroupJid', {"groupId": groupId});
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
  Future<String?> getUserLastSeenTime(String jid) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<String>('getUserLastSeenTime', {"jid": jid});
      LogMessage.d("getUserLastSeenTime Result ", " $response");
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
  Future<String?> authToken() async {
    String? registerResponse = "";
    try {
      registerResponse = await mirrorFlyMethodChannel.invokeMethod<String>('authtoken');
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
  Future<String?> registerUser(String userIdentifier, {String fcmToken = "", bool isForceRegister = true}) async {
    String? registerResponse;
    try {
      registerResponse = await mirrorFlyMethodChannel.invokeMethod('register_user', {"userIdentifier": userIdentifier, "token": fcmToken, "isForceRegister": isForceRegister});
      return convertRegisterUserJsonFromString(registerResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String?> verifyToken(String userName, String token) async {
    String? response = "";
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<String>('verifyToken', {"userName": userName, "googleToken": token});
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
      userJID = await mirrorFlyMethodChannel.invokeMethod<String?>('get_jid', {"username": username});
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
  Future<String> sendTextMessage(String message, String jid, String replyMessageId, {String? topicId}) async {
    String? messageResp;
    try {
      messageResp = await mirrorFlyMethodChannel
          .invokeMethod('send_text_msg', {"message": message, "JID": jid, "replyMessageId": replyMessageId, "topicId": topicId});
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
  Future<String> sendLocationMessage(String jid, double latitude, double longitude, String replyMessageId, {String? topicId}) async {
    //sentLocationMessage
    String? messageResp;
    try {
      messageResp = await mirrorFlyMethodChannel.invokeMethod(
          'sendLocationMessage', {"jid": jid, "latitude": latitude, "longitude": longitude, "replyMessageId": replyMessageId, "topicId": topicId});
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
  Future<String> sendImageMessage(String jid, String filePath, String? caption, String? replyMessageID,
      {String? imageFileUrl, String? topicId}) async {
    String? messageResp;
    try {
      messageResp = await mirrorFlyMethodChannel.invokeMethod('send_image_message', {
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
      //sendMediaMessage
      String jid,
      String filePath,
      String? caption,
      String? replyMessageID,
      {String? videoFileUrl,
        num? videoDuration,
        String? thumbImageBase64,
        String? topicId}) async {
    String? messageResp;
    try {
      messageResp = await mirrorFlyMethodChannel.invokeMethod('send_video_message', {
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
  Future<String> getRegisteredUserList({required bool server}) async {
    //getRegisteredUserList
    String? messageResp;
    try {
      messageResp = await mirrorFlyMethodChannel.invokeMethod('getRegisteredUsers', {'server': server});
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
  Future<String> getUserList(int page, String search, [int perPageResultSize = 20]) async {
    String? re;
    try {
      re = await mirrorFlyMethodChannel.invokeMethod("get_user_list", {"page": page, "search": search, "perPageResultSize": perPageResultSize});
      return convertUsersDataJsonFromString(re);
    } on PlatformException catch (e) {
      LogMessage.d("getUserList", "$e");
      rethrow;
    }
  }

  @override
  Future<String> getCallLogsList(int currentPage) async {
    String? re;
    try {
      re = await mirrorFlyCallMethodChannel.invokeMethod("getCallLogsList", {"currentPage": currentPage});
      return convertCallLogsToJson(re);
    } on PlatformException catch (e) {
      LogMessage.d("er", "$e");
      rethrow;
    }
  }

  @override
  Future<String> getLocalCallLogs() async {
    String? re;
    try {
      re = await mirrorFlyCallMethodChannel.invokeMethod("getLocalCallLogs", {});
      return convertCallLogsToJson(re);
    } on PlatformException catch (e) {
      LogMessage.d("er", "$e");
      return convertCallLogsToJson(re);
    }
  }

  @override
  Future<bool> deleteCallLog(List<String> jidlist, bool isClearAll) async {
    bool? re;
    try {
      re = await mirrorFlyCallMethodChannel.invokeMethod<bool>("deleteCallLog", {"jidList": jidlist, "isClearAll": isClearAll});
      LogMessage.d('deleteCallLog ', '$re');
      return re ?? false;
    } on PlatformException catch (e) {
      LogMessage.d("er", "$e");
      rethrow;
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
  Stream<dynamic> get onMessageReceived => _messageOnReceivedStreamController.stream;

  @override
  Stream<dynamic> get onMessageStatusUpdated => messageStatusUpdateStreamController.stream;

  @override
  Stream<dynamic> get onMediaStatusUpdated => mediaStatusUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onUploadDownloadProgressChanged => uploadDownloadProgressChangedStreamController.stream;

  @override
  Stream<dynamic> get onGroupProfileFetched => onGroupProfileFetchedStreamController.stream;

  @override
  Stream<dynamic> get onNewGroupCreated => onNewGroupCreatedStreamController.stream;

  @override
  Stream<dynamic> get onGroupProfileUpdated => onGroupProfileUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onNewMemberAddedToGroup => onNewMemberAddedToGroupStreamController.stream;

  @override
  Stream<dynamic> get onMemberRemovedFromGroup => onMemberRemovedFromGroupStreamController.stream;

  @override
  Stream<dynamic> get onFetchingGroupMembersCompleted => onFetchingGroupMembersCompletedStreamController.stream;

  @override
  Stream<dynamic> get onDeleteGroup => onDeleteGroupStreamController.stream;

  @override
  Stream<dynamic> get onFetchingGroupListCompleted => onFetchingGroupListCompletedStreamController.stream;

  @override
  Stream<dynamic> get onMemberMadeAsAdmin => onMemberMadeAsAdminStreamController.stream;

  @override
  Stream<dynamic> get onMemberRemovedAsAdmin => onMemberRemovedAsAdminStreamController.stream;

  @override
  Stream<dynamic> get onLeftFromGroup => onLeftFromGroupStreamController.stream;

  @override
  Stream<dynamic> get onGroupNotificationMessage => onGroupNotificationMessageStreamController.stream;

  @override
  Stream<dynamic> get showOrUpdateOrCancelNotification => showOrUpdateOrCancelNotificationStreamController.stream;

  @override
  Stream<dynamic> get onGroupDeletedLocally => onGroupDeletedLocallyStreamController.stream;

  @override
  Stream<dynamic> get blockedThisUser => blockedThisUserStreamController.stream;

  @override
  Stream<dynamic> get myProfileUpdated => myProfileUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onAdminBlockedOtherUser => onAdminBlockedOtherUserStreamController.stream;

  @override
  Stream<dynamic> get onAdminBlockedUser => onAdminBlockedUserStreamController.stream;

  @override
  Stream<dynamic> get onContactSyncComplete => onContactSyncCompleteStreamController.stream;

  @override
  Stream<dynamic> get onLoggedOut => onLoggedOutStreamController.stream;

  @override
  Stream<dynamic> get unblockedThisUser => unblockedThisUserStreamController.stream;

  @override
  Stream<dynamic> get userBlockedMe => userBlockedMeStreamController.stream;

  @override
  Stream<dynamic> get userCameOnline => userCameOnlineStreamController.stream;

  @override
  Stream<dynamic> get userDeletedHisProfile => userDeletedHisProfileStreamController.stream;

  @override
  Stream<dynamic> get userProfileFetched => userProfileFetchedStreamController.stream;

  @override
  Stream<dynamic> get userUnBlockedMe => userUnBlockedMeStreamController.stream;

  @override
  Stream<dynamic> get userUpdatedHisProfile => userUpdatedHisProfileStreamController.stream;

  @override
  Stream<dynamic> get userWentOffline => userWentOfflineStreamController.stream;

  @override
  Stream<dynamic> get usersIBlockedListFetched => usersIBlockedListFetchedStreamController.stream;

  @override
  Stream<dynamic> get usersProfilesFetched => usersProfilesFetchedStreamController.stream;

  @override
  Stream<dynamic> get usersWhoBlockedMeListFetched => usersWhoBlockedMeListFetchedStreamController.stream;

  @override
  Stream<dynamic> get onConnected => onConnectedStreamController.stream;

  @override
  Stream<dynamic> get onDisconnected => onDisconnectedStreamController.stream;

  /*@override
  Stream<dynamic> get onConnectionNotAuthorized =>
      onConnectionNotAuthorizedStreamController.stream;*/

  @override
  Stream<dynamic> get onConnectionFailed => onConnectionFailedStreamController.stream;

  @override
  Stream<dynamic> get connectionFailed => connectionFailedStreamController.stream;

  @override
  Stream<dynamic> get connectionSuccess => connectionSuccessStreamController.stream;

  @override
  Stream<dynamic> get onWebChatPasswordChanged => onWebChatPasswordChangedStreamController.stream;

  @override
  Stream<dynamic> get setTypingStatus => setTypingStatusStreamController.stream;

  @override
  Stream<dynamic> get onChatTypingStatus => onChatTypingStatusStreamController.stream;

  @override
  Stream<dynamic> get onGroupTypingStatus => onGroupTypingStatusStreamController.stream;

  @override
  Stream<dynamic> get onFailure => onFailureStreamController.stream;

  @override
  Stream<dynamic> get onProgressChanged => onProgressChangedStreamController.stream;

  @override
  Stream<dynamic> get onSuccess => onSuccessStreamController.stream;

  // @override
  // Stream<dynamic> get onCallReceiving =>
  //     onCallReceivingStreamController.stream;

  @override
  Stream<dynamic> get onLocalVideoTrackAdded => onLocalVideoTrackAddedStreamController.stream;

  @override
  Stream<dynamic> get onRemoteVideoTrackAdded => onRemoteVideoTrackAddedStreamController.stream;

  @override
  Stream<dynamic> get onTrackAdded => onTrackAddedStreamController.stream;

  @override
  Stream<dynamic> get onCallStatusUpdated => onCallStatusUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onCallAction => onCallActionStreamController.stream;

  @override
  Stream<dynamic> get onMuteStatusUpdated => onMuteStatusUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onUserSpeaking => onUserSpeakingStreamController.stream;

  @override
  Stream<dynamic> get onUserStoppedSpeaking => onUserStoppedSpeakingStreamController.stream;

  @override
  Stream<dynamic> get onMissedCall => onMissedCallStreamController.stream;

  @override
  Stream<dynamic> get onAvailableFeaturesUpdated => onAvailableFeaturesUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onCallLogsUpdated => onCallLogsUpdatedStreamController.stream;

  @override
  Stream<dynamic> get onCallLogsDeleted => onCallLogsDeletedStreamController.stream;

  @override
  Future<String?> imagePath(String imgurl) async {
    try {
      final result = await mirrorFlyMethodChannel.invokeMethod<String>("get_image_path", {"image": imgurl});
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
      res = await mirrorFlyMethodChannel.invokeMethod("sent file", {"file": file, "jid": jid, "message": ""});
      return convertChatMessageJsonFromString(res);
    } on PlatformException catch (e) {
      LogMessage.d("er", "$e");
      return convertChatMessageJsonFromString(res);
    }
  }

  @override
  Future<String> getRecentChatList() async {
    //getRecentChats
    String? recentResponse;
    try {
      recentResponse = await mirrorFlyMethodChannel.invokeMethod('getRecentChatList');
      return convertRecentChatDataJsonFromString(recentResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getRecentChatListHistory({required bool firstSet, int limit = 15}) async {
    //getRecentChats
    String? recentResponse;
    try {
      recentResponse = await mirrorFlyMethodChannel.invokeMethod('getRecentChatListHistory', {"firstSet": firstSet, "limit": limit});
      return convertRecentChatDataJsonFromString(recentResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
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
        bool ascendingOrder = true}) async {
    bool initializeResponse;
    try {
      initializeResponse = await mirrorFlyMethodChannel.invokeMethod('initializeMessageList', {
        "userJid": userJid,
        "messageId": messageId,
        "messageTime": messageTime,
        "exclude": exclude,
        "limit": limit,
        "ascendingOrder": ascendingOrder,
        "topicId": topicId
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
  Future<String> loadMessages() async {
    String? initialMessageResponse;
    try {
      initialMessageResponse = await mirrorFlyMethodChannel.invokeMethod('loadMessages');
      var res = convertChatMessagesJsonFromString(initialMessageResponse);
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
  Future<bool> hasPreviousMessages() async {
    bool hasPreviousMessages;
    try {
      hasPreviousMessages = await mirrorFlyMethodChannel.invokeMethod('hasPreviousMessages');
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
  Future<String> loadPreviousMessages() async {
    String? previousMessageResponse;
    try {
      previousMessageResponse = await mirrorFlyMethodChannel.invokeMethod('loadPreviousMessages');
      return convertChatMessagesJsonFromString(previousMessageResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool> hasNextMessages() async {
    bool hasNextMessages;
    try {
      hasNextMessages = await mirrorFlyMethodChannel.invokeMethod('hasNextMessages');
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
  Future<String> loadNextMessages() async {
    String? nextMessageResponse;
    try {
      nextMessageResponse = await mirrorFlyMethodChannel.invokeMethod('loadNextMessages');
      return convertChatMessagesJsonFromString(nextMessageResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getProfileStatusList() async {
    //getStatusList
    String? statusResponse;
    try {
      statusResponse = await mirrorFlyMethodChannel.invokeMethod('getProfileStatusList');
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
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('insertDefaultStatus', {"status": status});
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
  Future<String> updateMyProfile(String name, String email, String mobile, String status, String? image) async {
    //updateProfile
    String? profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel
          .invokeMethod('updateMyProfile', {"name": name, "email": email, "mobile": mobile, "status": status, "image": image});
      return convertProfileUpdateJsonFromString(profileResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getUserProfile(String jid, [bool fromserver = false, bool saveasfriend = false]) async {
    String? profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel.invokeMethod('getUserProfile', {"jid": jid, "server": fromserver, "saveasfriend": saveasfriend});
      return convertProfileJsonFromString(profileResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getProfileDetails(String jid) async {
    String? profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel.invokeMethod('getProfileDetails', {"jid": jid});
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
  Future<dynamic> setMyProfileStatus(String status, String statusId) async {
    //updateProfileStatus
    dynamic profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel.invokeMethod('setMyProfileStatus', {"status": status, "statusId": statusId});
      LogMessage.d("setMyProfileStatus Result ", " $profileResponse");
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
  Future<bool?> insertNewProfileStatus(String status) async {
    bool? profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel.invokeMethod<bool>('insertNewProfileStatus', {"status": status});
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
  Future<String> updateMyProfileImage(String image) async {
    //updateProfileImage
    String? profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel.invokeMethod('updateMyProfileImage', {"image": image});
      return convertProfileUpdateJsonFromString(profileResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> removeProfileImage() async {
    bool? profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel.invokeMethod<bool>('removeProfileImage');
      LogMessage.d("removeProfileImage Result ", " $profileResponse");
      return profileResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      return false;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      return false;
    }
  }

  @override
  Future<bool?> removeGroupProfileImage(String jid) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('removeGroupProfileImage', {"jid": jid});
      LogMessage.d("grp_image Result ", " $response");
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
  Future<String?> refreshAndGetAuthToken() async {
    String? tokenResponse;
    try {
      tokenResponse = await mirrorFlyMethodChannel.invokeMethod<String>('refreshAuthToken');
      LogMessage.d("refreshAuthToken Result ", " $tokenResponse");
      return tokenResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getCurrentAuthToken() async {
    String? tokenResponse;
    try {
      tokenResponse = await mirrorFlyMethodChannel.invokeMethod<String>('getCurrentAuthToken');
      LogMessage.d("getCurrentAuthToken Result ", " $tokenResponse");
      return tokenResponse ?? "";
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
      chatResponse = await mirrorFlyMethodChannel.invokeMethod('getMessagesOfJid', {"JID": jid});
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
      readReceiptResponse = await mirrorFlyMethodChannel.invokeMethod<bool>('markAsReadDeleteUnreadSeparator', {"jid": jid});
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
  Future<String> sendContactMessage(List<String> contactList, String jid, String contactName, String replyMessageId, {String? topicId}) async {
    String? contactResponse;
    try {
      contactResponse = await mirrorFlyMethodChannel.invokeMethod('sendContactMessage',
          {"contact_list": contactList, "jid": jid, "contact_name": contactName, "replyMessageId": replyMessageId, "topicId": topicId});
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
  Future<bool> logoutOfChatSDK() async {
    //logout
    bool? logoutResponse;
    try {
      logoutResponse = await mirrorFlyMethodChannel.invokeMethod<bool>('logoutOfChatSDK');
      LogMessage.d("logoutResponse ", " $logoutResponse");
      return logoutResponse ?? false;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  setOnGoingChatUser(String jid) async {
    //ongoingChat
    try {
      await mirrorFlyMethodChannel.invokeMethod('setOnGoingChatUser', {"jid": jid});
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
      await mirrorFlyMethodChannel.invokeMethod('downloadMedia', {"mediaMessage_id": mid});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> sendDocumentMessage(String jid, String documentPath, String replyMessageId, {String? fileUrl, String? topicId}) async {
    String? documentResponse;
    try {
      documentResponse = await mirrorFlyMethodChannel.invokeMethod(
          'sendDocumentMessage', {"file": documentPath, "jid": jid, "replyMessageId": replyMessageId, "file_url": fileUrl, "topicId": topicId});
      return convertChatMessageJsonFromString(documentResponse);
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

  @override
  Future<String> sendAudioMessage(String jid, String filePath, bool isRecorded, String duration, String replyMessageId,
      {String? audioFileUrl, String? topicId}) async {
    //sendAudio
    String? audioResponse;
    try {
      audioResponse = await mirrorFlyMethodChannel.invokeMethod('sendAudioMessage', {
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

  //Recent Chat Search

  @override
  Future<String> getRecentChatListIncludingArchived() async {
    //filteredRecentChatList
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getRecentChatListIncludingArchived');
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
  Future<String> searchConversation(String searchKey, [String? jidForSearch, bool globalSearch = true]) async {
    //filteredMessageList
    String? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod('searchConversation', {"searchKey": searchKey, "jidForSearch": jidForSearch, "globalSearch": globalSearch});
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
  Future<String> getRegisteredUsers(bool server) async {
    //filteredContactList
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getRegisteredUsers', {"server": server});
      return convertUsersDataJsonFromString(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getMessageOfId(String mid) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getMessageOfId', {"mid": mid});
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
      response = await mirrorFlyMethodChannel.invokeMethod('getRecentChatOf', {"jid": jid});
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
  Future<bool> clearChat(String jid, String chatType, bool clearExceptStarred) async {
    bool? clearChatResponse;
    try {
      clearChatResponse =
      await mirrorFlyMethodChannel.invokeMethod<bool>('clear_chat', {"jid": jid, "chat_type": chatType, "clear_except_starred": clearExceptStarred});
      LogMessage.d("clearChat ", " $clearChatResponse");
      return clearChatResponse ?? false;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
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
      messageListResponse = await mirrorFlyMethodChannel.invokeMethod('getMessagesUsingIds', {"MessageIds": messageIds});
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
  Future<bool?> deleteMessagesForMe(String jid, String chatType, List<String> messageIds, bool? isMediaDelete) async {
    bool? messageDeleteResponse;
    try {
      messageDeleteResponse = await mirrorFlyMethodChannel
          .invokeMethod<bool>('deleteMessagesForMe', {"jid": jid, "chat_type": chatType, "isMediaDelete": isMediaDelete, "message_ids": messageIds});
      LogMessage.d("deleteMessagesForMe Response ", " $messageDeleteResponse");
      return messageDeleteResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool> deleteMessagesForEveryone(String jid, String chatType, List<String> messageIds, bool? isMediaDelete) async {
    bool? messageDeleteResponse;
    try {
      messageDeleteResponse = await mirrorFlyMethodChannel
          .invokeMethod<bool>('deleteMessagesForEveryone', {"jid": jid, "chat_type": chatType, "isMediaDelete": isMediaDelete, "message_ids": messageIds});
      LogMessage.d("deleteMessagesForEveryone Response ", " $messageDeleteResponse");
      return messageDeleteResponse ?? false;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
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
  Future<String> getGroupMessageDeliveredToList(String messageId, String jid) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getGroupMessageDeliveredToList', {"messageId": messageId, "jid": jid});
      return convertMessageDeliveredStatusToJson(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getGroupMessageReadByList(String messageId, String jid) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getGroupMessageReadByList', {"messageId": messageId, "jid": jid});
      return convertMessageDeliveredStatusToJson(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<dynamic> getMessageStatusOfASingleChatMessage(String messageID) async {
    //getMessageInfo
    dynamic messageInfoResponse;
    try {
      messageInfoResponse = await mirrorFlyMethodChannel.invokeMethod('getMessageStatusOfASingleChatMessage', {"messageID": messageID});
      LogMessage.d("Message Info Response ", " $messageInfoResponse");
      return messageInfoResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> blockUser(String userJID) async {
    bool? userBlockResponse;
    try {
      userBlockResponse = await mirrorFlyMethodChannel.invokeMethod<bool>('block_user', {"userJID": userJID});
      LogMessage.d("blockUser Response ", " $userBlockResponse");
      return userBlockResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> unblockUser(String userJID) async {
    //unBlockUser
    bool? userBlockResponse;
    try {
      userBlockResponse = await mirrorFlyMethodChannel.invokeMethod<bool>('un_block_user', {"userJID": userJID});
      LogMessage.d("unblockUser Response ", " $userBlockResponse");
      return userBlockResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String?> showCustomTones() async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<String>('showCustomTones');
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
      response = await mirrorFlyMethodChannel.invokeMethod<String>('getRingtoneName');
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
  Future<bool?> loginWebChatViaQRCode(String barcode) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('loginWebChatViaQRCode', {"barcode": barcode});
      LogMessage.d("loginWebChatViaQRCode Response ", " $response");
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
  Future<bool?> webLoginDetailsCleared() async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('webLoginDetailsCleared');
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
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('logoutWebUser', {"listWebLogin": logins});
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
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('iOSFileExist', {"file_path": filePath});
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
      response = await mirrorFlyMethodChannel.invokeMethod('getWebLoginDetails');
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
  Future<bool?> updateFavouriteStatus(String messageID, String chatUserJID, bool isFavourite, String chatType) async {
    //favouriteMessage
    bool? favResponse;
    try {
      favResponse = await mirrorFlyMethodChannel.invokeMethod<bool>('updateFavouriteStatus', {
        "messageID": messageID,
        "chatUserJID": chatUserJID,
        "isFavourite": isFavourite,
        "chatType": chatType,
      });
      LogMessage.d("Favourite Msg Response ", " $favResponse");
      return favResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> forwardMessagesToMultipleUsers(List<String> messageIds, List<String> userList) async {
    //forwardMessage
    bool? forwardMessageResponse;
    try {
      forwardMessageResponse =
      await mirrorFlyMethodChannel.invokeMethod<bool>('forwardMessagesToMultipleUsers', {"message_ids": messageIds, "userList": userList});
      LogMessage.d("Forward Msg Response ", " $forwardMessageResponse");
      return forwardMessageResponse;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
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
  Future<bool?> createGroup(String groupName, List<String> userJidList, String imageFilePath) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('createGroup', {
        "group_name": groupName,
        "members": userJidList,
        "file": imageFilePath,
      });
      LogMessage.d("create group Response ", " $response");
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
  Future<bool?> addUsersToGroup(String jid, List<String> userList) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('addUsersToGroup', {"jid": jid, "members": userList});
      LogMessage.d("addUsersToGroup Response ", " $response");
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
  Future<String> getGroupMembersList(String jid, bool? server) async {
    //getGroupMembers
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getGroupMembersList', {
        "jid": jid,
        "server": server,
      });
      return convertProfileDetailsJsonFromString(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getUsersIBlocked(bool? server) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getUsersIBlocked', {
        "serverCall": server,
      });
      return convertProfileDetailsJsonFromString(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
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
  Future<String> exportChatConversationToEmail(String jid) async {
    String? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod('exportChatConversationToEmail', {"jid": jid});
      return convertExportJsonFromString(res);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> reportUserOrMessages(String jid, String type, String? messageId) async {
    bool? response;
    try {
      response =
      await mirrorFlyMethodChannel.invokeMethod<bool>('reportUserOrMessages', {"jid": jid, "chat_type": type, "selectedMessageID": messageId});
      LogMessage.d("report Result ", " $response");
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
  Future<bool?> makeAdmin(String groupjid, String userjid) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('makeAdmin', {"jid": groupjid, "userjid": userjid});
      LogMessage.d("report Result ", " $response");
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
  Future<bool?> removeMemberFromGroup(String groupjid, String userjid) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('removeMemberFromGroup', {"jid": groupjid, "userjid": userjid});
      LogMessage.d("report Result ", " $response");
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
  Future<bool?> leaveFromGroup(String? userJid, String groupJid) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('leaveFromGroup', {"userJid": userJid, "groupJid": groupJid});
      LogMessage.d("leaveFromGroup Result ", " $response");
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
  Future<bool?> deleteGroup(String jid) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('deleteGroup', {"jid": jid});
      LogMessage.d("deleteGroup Result ", " $response");
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
  Future<bool?> isAdmin(String userJid, String groupJID) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('isAdmin', {"jid": userJid, "group_jid": groupJID});
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
  Future<bool?> updateGroupProfileImage(String jid, String file) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('updateGroupProfileImage', {"jid": jid, "file": file});
      LogMessage.d("updateGroupProfileImage Result ", " $response");
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
  Future<bool?> updateGroupName(String jid, String name) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('updateGroupName', {"jid": jid, "name": name});
      LogMessage.d("updateGroupName Result ", " $response");
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
  Future<bool?> isMemberOfGroup(String jid, String? userJid) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('isMemberOfGroup', {"jid": jid, "userjid": userJid});
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
  Future<bool?> sendContactUsInfo(String title, String description) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('sendContactUsInfo', {"title": title, "description": description});
      LogMessage.d("sendContactUsInfo Result ", " $response");
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
  copyTextMessages(List<String> messageIds) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('copyTextMessages', {"messageidlist": messageIds});
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
      await mirrorFlyMethodChannel.invokeMethod('saveUnsentMessage', {"jid": jid, "texMessage": message});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool?> deleteAccount(String reason, String? feedback) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<bool>('delete_account', {"delete_reason": reason, "delete_feedback": feedback});
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
  Future<String> getFavouriteMessages() async {
    String? favResponse;
    try {
      favResponse = await mirrorFlyMethodChannel.invokeMethod('get_favourite_messages');
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
  Future<String> getAllGroups([bool? server]) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getAllGroups', {"server": server});
      return convertProfileDetailsJsonFromString(response);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String?> getDefaultNotificationUri() async {
    String? uri = "";
    try {
      uri = await mirrorFlyMethodChannel.invokeMethod<String?>('getDefaultNotificationUri');
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
      await mirrorFlyMethodChannel.invokeMethod('setNotificationSound', {"enable": enable});
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
      isEnabled = await mirrorFlyMethodChannel.invokeMethod('getNotificationSound');
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
      await mirrorFlyMethodChannel.invokeMethod('setMuteNotification', {"enable": enable});
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
      await mirrorFlyMethodChannel.invokeMethod('setNotificationVibration', {"enable": enable});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
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
  }

  @override
  saveMediaSettings(bool photos, bool videos, bool audio, bool documents, int networkType) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod(
          'saveMediaSettings', {'Photos': photos, 'Videos': videos, 'Audio': audio, 'Documents': documents, 'NetworkType': networkType});
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
      val = await mirrorFlyMethodChannel.invokeMethod<bool?>('getMediaSetting', {"NetworkType": networkType, "type": type});
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
      val = await mirrorFlyMethodChannel.invokeMethod<bool?>('getMediaAutoDownload');
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
      await mirrorFlyMethodChannel.invokeMethod('setMediaAutoDownload', {'enable': enable});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String?> getJidFromPhoneNumber(String mobileNumber, String countryCode) async {
    String? jid = "";
    try {
      jid = await mirrorFlyMethodChannel.invokeMethod<String?>('getJidFromPhoneNumber', {"mobileNumber": mobileNumber, "countryCode": countryCode});
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
      val = await mirrorFlyMethodChannel.invokeMethod<bool?>('IS_TRIAL_LICENSE');
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
      val = await mirrorFlyMethodChannel.invokeMethod('addContact', {'number': number, 'name': name});
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
      await mirrorFlyMethodChannel.invokeMethod('setRegionCode', {'regionCode': regionCode});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<String> getValueFromManifestOrInfoPlist({String? androidManifestKey, String? iOSPlistKey}) async {
    String? val = "";
    try {
      if (Platform.isAndroid) {
        val = await mirrorFlyMethodChannel.invokeMethod('getManifestValue', {'key': androidManifestKey});
        LogMessage.d('getValueFromManifestOrInfoPlist Android', ' $val');
        return val ?? "";
      } else if (Platform.isIOS) {
        val = await mirrorFlyMethodChannel.invokeMethod('getPlistValue', {'key': iOSPlistKey});
        LogMessage.d('getValueFromManifestOrInfoPlist iOS', ' $val');
        return val ?? "";
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
  Future<String?> createTopic({required String topicName, List<TopicMetaData> metaData = const []}) async {
    String? val = "";
    List<Map<String, dynamic>>? topic = metaData.map((topic) => topic.toMap()).toList();
    LogMessage.d("createTopic", topic);
    //if (metaData.length <= 3) {
    try {
      val = await mirrorFlyMethodChannel.invokeMethod('createTopic', {'topicName': topicName, 'metaData': topic});
      LogMessage.d('createTopic', ' $val');
      return val;
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
    // } else {
    //   throw Exception("topicData Maximum Size is 3");
    // }
  }

  @override
  Future<String?> getTopics({required List<String> topicIds}) async {
    String? val = "";
    try {
      val = await mirrorFlyMethodChannel.invokeMethod('getTopics', {'topicIds': topicIds});
      LogMessage.d('getTopics', ' $val');
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
  Future<String> getRecentChatListHistoryByTopic({String? topicId, required bool firstSet, int limit = 15}) async {
    //getRecentChats
    String? recentResponse;
    try {
      LogMessage.d("getRecentChatListHistoryByTopic", "firstSet $firstSet");
      recentResponse =
      await mirrorFlyMethodChannel.invokeMethod('getRecentChatListHistoryByTopic', {"topicId": topicId, "firstSet": firstSet, "limit": limit});
      return convertRecentChatDataJsonFromString(recentResponse);
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<bool> makeVideoCall(String userJid) async {
    bool val;
    try {
      LogMessage.d('makeVideoCall :', userJid);
      val = await mirrorFlyCallMethodChannel.invokeMethod('makeVideoCall', {"user_jid": userJid});
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
  Future<bool> makeVoiceCall(String userJid) async {
    bool val;
    try {
      LogMessage.d('makeVoiceCall :', userJid);
      val = await mirrorFlyCallMethodChannel.invokeMethod('makeVoiceCall', {"user_jid": userJid});
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
  Future<bool> makeGroupVoiceCall(String groupJid, List<String>? jidList) async {
    bool val;
    try {
      LogMessage.d('makeGroupVoiceCall :', "groupJid : $groupJid, jidList : $jidList");
      val = await mirrorFlyCallMethodChannel.invokeMethod('makeGroupVoiceCall', {"groupJid": groupJid, "jidList": jidList});
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
  Future<bool> makeGroupVideoCall(String groupJid, List<String>? jidList) async {
    bool val;
    try {
      LogMessage.d('makeGroupVideoCall :', "groupJid : $groupJid, jidList : $jidList");
      val = await mirrorFlyCallMethodChannel.invokeMethod('makeGroupVideoCall', {"groupJid": groupJid, "jidList": jidList});
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
  Future<dynamic> getCallUsersList() async {
    dynamic callList;
    try {
      callList = await mirrorFlyCallMethodChannel.invokeMethod('getCallUsersList');
      LogMessage.d('getCallUsers :', '$callList');
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
      callDirection = await mirrorFlyCallMethodChannel.invokeMethod('getCallDirection');
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
      audioInput = await mirrorFlyCallMethodChannel.invokeMethod('getAllAvailableAudioInput');
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
  Future<bool?> muteAudio(bool status) async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel.invokeMethod('muteAudio', {"muteAudio": status});
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
  Future<bool?> muteVideo(bool status) async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel.invokeMethod('muteVideo', {"muteVideo": status});
      LogMessage.d('muteVideo', '$res');
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
  Future<bool?> routeAudioTo({required String routeType}) async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel.invokeMethod('routeAudioTo', {"routeType": routeType});
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
  Future<bool?> disconnectCall() async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel.invokeMethod('disconnectCall');
      LogMessage.d('disconnectCall', '$res');
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
  Future<String?> selectedAudioDevice() async {
    String? res;
    try {
      res = await mirrorFlyCallMethodChannel.invokeMethod('selectedAudioDevice');
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
      res = await mirrorFlyCallMethodChannel.invokeMethod('isUserAudioMuted', {"userJid": userJid});
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
      res = await mirrorFlyCallMethodChannel.invokeMethod('isUserVideoMuted', {"userJid": userJid});
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
      res = await mirrorFlyCallMethodChannel.invokeMethod<int>('getUnreadMissedCallCount');
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
      res = await mirrorFlyMethodChannel.invokeMethod<bool>('appLaunchedFromMissedCall');
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
  Future<bool?> requestVideoCallSwitch() async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel.invokeMethod('requestVideoCallSwitch');
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
  Future<bool?> cancelVideoCallSwitch() async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel.invokeMethod('cancelVideoCallSwitch');
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
  Future<bool?> acceptVideoCallSwitchRequest() async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel.invokeMethod('acceptVideoCallSwitchRequest');
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
  Future<bool?> declineVideoCallSwitchRequest() async {
    bool? res;
    try {
      res = await mirrorFlyCallMethodChannel.invokeMethod('declineVideoCallSwitchRequest');
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
      res = await mirrorFlyCallMethodChannel.invokeMethod('getMaxCallUsersCount');
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
  Future inviteUsersToOngoingCall(List<String>? jidList) async {
    try {
      LogMessage.d('inviteUsersToOngoingCall :', " jidList : $jidList");
      await mirrorFlyCallMethodChannel.invokeMethod('inviteUsersToOngoingCall', {"jidList": jidList});
    } on PlatformException catch (e) {
      LogMessage.d("Platform Exception =", " $e");
      rethrow;
    } on Exception catch (error) {
      LogMessage.d("Exception ", " $error");
      rethrow;
    }
  }

  @override
  Future<List<String>> getInvitedUsersList() async {
    try {
      var users = await mirrorFlyCallMethodChannel.invokeMethod('getInvitedUsersList');
      LogMessage.d('getInvitedUsersList :', " jidList : $users");
      return List<String>.from(json.decode(users).map((x) => x.toString())); //json.decode(users) as List<String>;
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
      res = await mirrorFlyCallMethodChannel.invokeMethod<bool>('markAllUnreadMissedCallsAsRead');
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
      res = await mirrorFlyCallMethodChannel.invokeMethod<bool>('isCallConversionRequestAvailable');
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
}
