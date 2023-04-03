import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fly_chat/fly_chat_platform_interface.dart';

import 'builder.dart';

/// An implementation of [UikitFlutterPlatform] that uses method channels.
class MethodChannelFlyChatFlutter extends FlyChatFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final mirrorFlyMethodChannel =
  const MethodChannel('contus.mirrorfly/flyChat');

  //Event Channels
  @visibleForTesting
  final messageOnReceivedChannel =
  const EventChannel('contus.mirrorfly/onMessageReceived');
  @visibleForTesting
  final messageStatusUpdatedChanel =
  const EventChannel('contus.mirrorfly/onMessageStatusUpdated');
  @visibleForTesting
  final mediaStatusUpdatedChannel =
  const EventChannel('contus.mirrorfly/onMediaStatusUpdated');
  @visibleForTesting
  final uploadDownloadProgressChangedChannel =
  const EventChannel('contus.mirrorfly/onUploadDownloadProgressChanged');
  @visibleForTesting
  final showUpdateCancelNotificationChannel =
  const EventChannel('contus.mirrorfly/showOrUpdateOrCancelNotification');
  @visibleForTesting
  final onGroupProfileFetchedChannel =
  const EventChannel('contus.mirrorfly/onGroupProfileFetched');
  @visibleForTesting
  final onNewGroupCreatedChannel =
  const EventChannel('contus.mirrorfly/onNewGroupCreated');
  @visibleForTesting
  final onGroupProfileUpdatedChannel =
  const EventChannel('contus.mirrorfly/onGroupProfileUpdated');
  @visibleForTesting
  final onNewMemberAddedToGroupChannel =
  const EventChannel('contus.mirrorfly/onNewMemberAddedToGroup');
  @visibleForTesting
  final onMemberRemovedFromGroupChannel =
  const EventChannel('contus.mirrorfly/onMemberRemovedFromGroup');
  @visibleForTesting
  final onFetchingGroupMembersCompletedChannel =
  const EventChannel('contus.mirrorfly/onFetchingGroupMembersCompleted');
  @visibleForTesting
  final onDeleteGroupChannel =
  const EventChannel('contus.mirrorfly/onDeleteGroup');
  @visibleForTesting
  final onFetchingGroupListCompletedChannel =
  const EventChannel('contus.mirrorfly/onFetchingGroupListCompleted');
  @visibleForTesting
  final onMemberMadeAsAdminChannel =
  const EventChannel('contus.mirrorfly/onMemberMadeAsAdmin');
  @visibleForTesting
  final onMemberRemovedAsAdminChannel =
  const EventChannel('contus.mirrorfly/onMemberRemovedAsAdmin');
  @visibleForTesting
  final onLeftFromGroupChannel =
  const EventChannel('contus.mirrorfly/onLeftFromGroup');
  @visibleForTesting
  final onGroupNotificationMessageChannel =
  const EventChannel('contus.mirrorfly/onGroupNotificationMessage');
  @visibleForTesting
  final onGroupDeletedLocallyChannel =
  const EventChannel('contus.mirrorfly/onGroupDeletedLocally');

  @visibleForTesting
  final blockedThisUserChannel =
  const EventChannel('contus.mirrorfly/blockedThisUser');
  @visibleForTesting
  final myProfileUpdatedChannel =
  const EventChannel('contus.mirrorfly/myProfileUpdated');
  @visibleForTesting
  final onAdminBlockedOtherUserChannel =
  const EventChannel('contus.mirrorfly/onAdminBlockedOtherUser');
  @visibleForTesting
  final onAdminBlockedUserChannel =
  const EventChannel('contus.mirrorfly/onAdminBlockedUser');
  @visibleForTesting
  final onContactSyncCompleteChannel =
  const EventChannel('contus.mirrorfly/onContactSyncComplete');
  @visibleForTesting
  final onLoggedOutChannel = const EventChannel('contus.mirrorfly/onLoggedOut');
  @visibleForTesting
  final unblockedThisUserChannel =
  const EventChannel('contus.mirrorfly/unblockedThisUser');
  @visibleForTesting
  final userBlockedMeChannel =
  const EventChannel('contus.mirrorfly/userBlockedMe');
  @visibleForTesting
  final userCameOnlineChannel =
  const EventChannel('contus.mirrorfly/userCameOnline');
  @visibleForTesting
  final userDeletedHisProfileChannel =
  const EventChannel('contus.mirrorfly/userDeletedHisProfile');
  @visibleForTesting
  final userProfileFetchedChannel =
  const EventChannel('contus.mirrorfly/userProfileFetched');
  @visibleForTesting
  final userUnBlockedMeChannel =
  const EventChannel('contus.mirrorfly/userUnBlockedMe');
  @visibleForTesting
  final userUpdatedHisProfileChannel =
  const EventChannel('contus.mirrorfly/userUpdatedHisProfile');
  @visibleForTesting
  final userWentOfflineChannel =
  const EventChannel('contus.mirrorfly/userWentOffline');
  @visibleForTesting
  final usersIBlockedListFetchedChannel =
  const EventChannel('contus.mirrorfly/usersIBlockedListFetched');
  @visibleForTesting
  final usersProfilesFetchedChannel =
  const EventChannel('contus.mirrorfly/usersProfilesFetched');
  @visibleForTesting
  final usersWhoBlockedMeListFetchedChannel =
  const EventChannel('contus.mirrorfly/usersWhoBlockedMeListFetched');
  @visibleForTesting
  final onConnectedChannel = const EventChannel('contus.mirrorfly/onConnected');
  @visibleForTesting
  final onDisconnectedChannel =
  const EventChannel('contus.mirrorfly/onDisconnected');
  @visibleForTesting
  final onConnectionNotAuthorizedChannel =
  const EventChannel('contus.mirrorfly/onConnectionNotAuthorized');
  @visibleForTesting
  final connectionFailedChannel =
  const EventChannel('contus.mirrorfly/connectionFailed');
  @visibleForTesting
  final connectionSuccessChannel =
  const EventChannel('contus.mirrorfly/connectionSuccess');
  @visibleForTesting
  final onWebChatPasswordChangedChannel =
  const EventChannel('contus.mirrorfly/onWebChatPasswordChanged');
  @visibleForTesting
  final setTypingStatusChannel =
  const EventChannel('contus.mirrorfly/setTypingStatus');
  @visibleForTesting
  final onChatTypingStatusChannel =
  const EventChannel('contus.mirrorfly/onChatTypingStatus');
  @visibleForTesting
  final onGroupTypingStatusChannel =
  const EventChannel('contus.mirrorfly/onGroupTypingStatus');
  @visibleForTesting
  final onFailureChannel = const EventChannel('contus.mirrorfly/onFailure');
  @visibleForTesting
  final onProgressChangedChannel =
  const EventChannel('contus.mirrorfly/onProgressChanged');
  @visibleForTesting
  final onSuccessChannel = const EventChannel('contus.mirrorfly/onSuccess');

  /*@override
  Future<String?> getPlatformVersion() async {
    final version =
    await mirrorFlyMethodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }*/

  @override
  init(ChatBuilder builder) async {
    await mirrorFlyMethodChannel.invokeMethod('init',builder.build());
  }

  @override
  Future<bool?> syncContacts(bool isfirsttime) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('syncContacts', {"is_first_time": isfirsttime});
      debugPrint('syncContacts $res');
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<String?> getSendData() async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<String>('sendData');
      debugPrint("sendData Result ==> $response");
      return response;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool> contactSyncStateValue() async {
    bool response = false;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod<bool>('contactSyncStateValue') ?? false;
      debugPrint("contactSyncStateValue Result ==> $response");
      return response;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> contactSyncState() async {
    dynamic response = "";
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('contactSyncState');
      debugPrint("contactSyncState Result ==> $response");
      return response;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> revokeContactSync() async {
    dynamic response = "";
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('revokeContactSync');
      debugPrint("revokeContactSync Result ==> $response");
      return response;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getUsersWhoBlockedMe([bool server = false]) async {
    dynamic response = "";
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod('getUsersWhoBlockedMe', {"server": server});
      debugPrint("getUsersWhoBlockedMe Result ==> $response");
      return response;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getUnKnownUserProfiles() async {
    dynamic response = "";
    try {
      response =
      await mirrorFlyMethodChannel.invokeMethod('getUnKnownUserProfiles');
      debugPrint("getUnKnownUserProfiles Result ==> $response");
      return response;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getMyProfileStatus() async {
    dynamic response = "";
    try {
      response =
      await mirrorFlyMethodChannel.invokeMethod('getMyProfileStatus');
      debugPrint("getMyProfileStatus Result ==> $response");
      return response;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getMyBusyStatus() async {
    dynamic response = "";
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getMyBusyStatus');
      debugPrint("getMyBusyStatus Result ==> $response");
      return response;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getBusyStatusList() async {
    dynamic response = "";
    try {
      response = await mirrorFlyMethodChannel.invokeMethod('getBusyStatusList');
      debugPrint("getBusyStatusList Result ==> $response");
      return response;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getRecalledMessagesOfAConversation(String jid) async {
    dynamic response = "";
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod('getRecalledMessagesOfAConversation', {"jid": jid});
      debugPrint("getRecalledMessagesOfAConversation Result ==> $response");
      return response;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> setMyBusyStatus(String busyStatus) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('setMyBusyStatus', {"status": busyStatus});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> enableDisableBusyStatus(bool enable) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('enableDisableBusyStatus', {"enable": enable});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> enableDisableHideLastSeen(bool enable) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('enableDisableHideLastSeen', {"enable": enable});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> isBusyStatusEnabled() async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('isBusyStatusEnabled');
      debugPrint("isBusyStatusEnabled--> $res");
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> deleteProfileStatus(String id, String status,
      bool isCurrentStatus) async {
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> deleteBusyStatus(String id, String status,
      bool isCurrentStatus) async {
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<String?> mediaEndPoint() async {
    String? response;
    try {
      response =
      await mirrorFlyMethodChannel.invokeMethod<String>('media_endpoint');
      debugPrint("media_endpoint Result ==> $response");
      return response;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> unFavouriteAllFavouriteMessages() async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('unFavouriteAllFavouriteMessages');
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  deleteOfflineGroup(String groupJid) async {
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('deleteOfflineGroup', {"groupJid": groupJid});
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  sendTypingStatus(String toJid, String chattype) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod(
          'sendTypingStatus', {"to_jid": toJid, "chattype": chattype});
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  sendTypingGoneStatus(String toJid, String chattype) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod(
          'sendTypingGoneStatus', {"to_jid": toJid, "chattype": chattype});
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  updateChatMuteStatus(String jid, bool muteStatus) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod(
          'updateChatMuteStatus', {"jid": jid, "mute_status": muteStatus});
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  updateRecentChatPinStatus(String jid, bool pinStatus) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('updateRecentChatPinStatus',
          {"jid": jid, "pin_recent_chat": pinStatus});
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> deleteRecentChat(String jid) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod('deleteRecentChat', {"jid": jid});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  setTypingStatusListener() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('setTypingStatusListener');
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> isUserUnArchived(String jid) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('isUserUnArchived', {"jid": jid});
      debugPrint("isUserUnArchived==>$res");
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> deleteRecentChats(List<String> jidlist) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('deleteRecentChats', {"jidlist": jidlist});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  markConversationAsRead(List<String> jidlist) async {
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('markConversationAsRead', {"jidlist": jidlist});
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  markConversationAsUnread(List<String> jidlist) async {
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('markConversationAsUnread', {"jidlist": jidlist});
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  getArchivedChatsFromServer() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('getArchivedChatsFromServer');
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  setCustomValue(String messageId, String key, String value) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('setCustomValue',
          {"message_id": messageId, "key": key, "value": value});
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  removeCustomValue(String messageId, String key) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod(
          'removeCustomValue', {"message_id": messageId, "key": key});
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  inviteUserViaSMS(String mobileNo, String message) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod(
          'inviteUserViaSMS', {"mobile_no": mobileNo, "message": message});
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  cancelBackup() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('cancelBackup');
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  startBackup() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('startBackup');
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  cancelRestore() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('cancelRestore');
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  clearAllSDKData() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('clearAllSDKData');
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  getRoster() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('getRoster');
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> clearAllConversation() async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('clearAllConversation');
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> updateFcmToken(String firebasetoken) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('updateFcmToken', {"token": firebasetoken});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> handleReceivedMessage(Map notificationdata) async {
    dynamic res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod(
          'handleReceivedMessage', {"notificationdata": notificationdata});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getLastNUnreadMessages(int messagesCount) async {
    dynamic res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod(
          'getLastNUnreadMessages', {"messagecount": messagesCount});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getNUnreadMessagesOfEachUsers(int messagesCount) async {
    dynamic res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod(
          'getNUnreadMessagesOfEachUsers', {"messagecount": messagesCount});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> isArchivedSettingsEnabled() async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod<bool>('isArchivedSettingsEnabled');
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> enableDisableArchivedSettings(bool enable) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'enableDisableArchivedSettings', {"enable": enable});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> updateArchiveUnArchiveChat(String jid, bool isArchived) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'updateArchiveUnArchiveChat', {"jid": jid, "isArchived": isArchived});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getUsersListToAddMembersInOldGroup(String groupJid) async {
    dynamic res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod(
          'getUsersListToAddMembersInOldGroup', {"groupJid": groupJid});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> prepareChatConversationToExport(String jid) async {
    dynamic res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod('prepareChatConversationToExport', {"jid": jid});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getArchivedChatList() async {
    dynamic res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod('getArchivedChatList');
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getMessageActions(List<String> messageidlist) async {
    dynamic res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod('getMessageActions', {"messageidlist": messageidlist});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getUsersListToAddMembersInNewGroup() async {
    dynamic res;
    try {
      res = await mirrorFlyMethodChannel
          .invokeMethod('getUsersListToAddMembersInNewGroup');
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> createOfflineGroupInOnline(String groupId) async {
    bool? res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod<bool>(
          'createOfflineGroupInOnline', {"groupId": groupId});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getGroupProfile(String groupJid, bool server) async {
    dynamic res;
    try {
      res = await mirrorFlyMethodChannel.invokeMethod(
          'getGroupProfile', {"groupJid": groupJid, "server": server});
      return res;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
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
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  updateMediaUploadStatus(String mediaMessageId, int progress,
      int uploadStatus, num dataTransferred) async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('updateMediaUploadStatus', {
        "mediaMessageId": mediaMessageId,
        "progress": progress,
        "downloadStatus": uploadStatus,
        "dataTransferred": dataTransferred
      });
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  cancelMediaUploadOrDownload(String messageId) async {
    try {
      debugPrint("cancelMediaUploadOrDownload--> $messageId");
      await mirrorFlyMethodChannel.invokeMethod(
          'cancelMediaUploadOrDownload', {"messageId": messageId});
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  setMediaEncryption(String encryption) async {
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('setMediaEncryption', {"encryption": encryption});
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  deleteAllMessages() async {
    try {
      await mirrorFlyMethodChannel.invokeMethod('deleteAllMessages');
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<String?> getGroupJid(String jid) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod<String>('getGroupJid', {"jid": jid});
      debugPrint("getGroupJid Result ==> $response");
      return response;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<String?> getUserLastSeenTime(String jid) async {
    String? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod<String>('getUserLastSeenTime', {"jid": jid});
      debugPrint("getUserLastSeenTime Result ==> $response");
      return response;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<String?> authToken() async {
    String? registerResponse = "";
    try {
      registerResponse =
      await mirrorFlyMethodChannel.invokeMethod<String>('authtoken');
      debugPrint("authToken Result ==> $registerResponse");

      return registerResponse;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> registerUser(String userIdentifier,
      {String token = ""}) async {
    dynamic registerResponse;
    try {
      registerResponse = await mirrorFlyMethodChannel.invokeMethod(
          'register_user', {"userIdentifier": userIdentifier, "token": token});
      debugPrint("Register Result ==> $registerResponse");
      return registerResponse;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<String?> verifyToken(String userName, String token) async {
    String? response = "";
    try {
      response = await mirrorFlyMethodChannel.invokeMethod<String>(
          'verifyToken', {"userName": userName, "googleToken": token});
      debugPrint("verifyToken Result ==> $response");
      return response;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
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
      debugPrint("User JID Result ==> $userJID");
      return userJID ?? '';
    } on PlatformException catch (e) {
      debugPrint("Flutter Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Flutter Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> sendTextMessage(String message, String jid,
      String replyMessageId) async {
    dynamic messageResp;
    try {
      messageResp = await mirrorFlyMethodChannel.invokeMethod('send_text_msg',
          {"message": message, "JID": jid, "replyMessageId": replyMessageId});
      debugPrint("Text Message Result ==> $messageResp");
      return messageResp;
    } on PlatformException catch (e) {
      debugPrint("Flutter Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Flutter Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> sendLocationMessage(String jid, double latitude,
      double longitude, String replyMessageId) async {
    //sentLocationMessage
    dynamic messageResp;
    try {
      messageResp =
      await mirrorFlyMethodChannel.invokeMethod('sendLocationMessage', {
        "jid": jid,
        "latitude": latitude,
        "longitude": longitude,
        "replyMessageId": replyMessageId
      });
      debugPrint("Location Message Result ==> $messageResp");
      return messageResp;
    } on PlatformException catch (e) {
      debugPrint("Flutter Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Flutter Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> sendImageMessage(String jid, String filePath, String? caption,
      String? replyMessageID,
      [String? imageFileUrl]) async {
    dynamic messageResp;
    try {
      messageResp =
      await mirrorFlyMethodChannel.invokeMethod('send_image_message', {
        "jid": jid,
        "filePath": filePath,
        "caption": caption?.trim(),
        "replyMessageId": replyMessageID,
        "imageFileUrl": imageFileUrl
      });
      debugPrint("Image Message Result ==> $messageResp");
      return messageResp;
    } on PlatformException catch (e) {
      debugPrint("Image Message Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Image Message Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> sendVideoMessage(//sendMediaMessage
      String jid,
      String filePath,
      String? caption,
      String? replyMessageID,
      [String? videoFileUrl,
        num? videoDuration,
        String? thumbImageBase64]) async {
    dynamic messageResp;
    try {
      messageResp =
      await mirrorFlyMethodChannel.invokeMethod('send_video_message', {
        "jid": jid,
        "filePath": filePath,
        "caption": caption?.trim(),
        "replyMessageId": replyMessageID,
        "videoFileUrl": videoFileUrl,
        "videoDuration": videoDuration,
        "thumbImageBase64": thumbImageBase64
      });
      debugPrint("Video Message Result ==> $messageResp");
      return messageResp;
    } on PlatformException catch (e) {
      debugPrint("Video Message Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Video Message Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getRegisteredUserList({required bool server}) async {
    //getRegisteredUserList
    dynamic messageResp;
    try {
      messageResp = await mirrorFlyMethodChannel
          .invokeMethod('getRegisteredUsers', {'server': server});
      debugPrint("User list Result ==> $messageResp");
      return messageResp;
    } on PlatformException catch (e) {
      debugPrint("User list Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("User list Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getUserList(int page, String search,
      [int perPageResultSize = 20]) async {
    dynamic re;
    try {
      re = await mirrorFlyMethodChannel.invokeMethod("get_user_list", {
        "page": page,
        "search": search,
        "perPageResultSize": perPageResultSize
      });
      debugPrint('RESULT ==> $re');
      return re;
    } on PlatformException catch (e) {
      debugPrint("er $e");
      return re;
    }
  }


  @override
  Stream<dynamic> get onMessageReceived =>
      messageOnReceivedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onMessageStatusUpdated =>
      messageStatusUpdatedChanel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onMediaStatusUpdated =>
      mediaStatusUpdatedChannel.receiveBroadcastStream().cast();

  @override
  Stream<dynamic> get onUploadDownloadProgressChanged =>
      uploadDownloadProgressChangedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onGroupProfileFetched =>
      onGroupProfileFetchedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onNewGroupCreated =>
      onNewGroupCreatedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onGroupProfileUpdated =>
      onGroupProfileUpdatedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onNewMemberAddedToGroup =>
      onNewMemberAddedToGroupChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onMemberRemovedFromGroup =>
      onMemberRemovedFromGroupChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onFetchingGroupMembersCompleted =>
      onFetchingGroupMembersCompletedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onDeleteGroup =>
      onDeleteGroupChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onFetchingGroupListCompleted =>
      onFetchingGroupListCompletedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onMemberMadeAsAdmin =>
      onMemberMadeAsAdminChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onMemberRemovedAsAdmin =>
      onMemberRemovedAsAdminChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onLeftFromGroup =>
      onLeftFromGroupChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onGroupNotificationMessage =>
      onGroupNotificationMessageChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onGroupDeletedLocally =>
      onGroupDeletedLocallyChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get blockedThisUser =>
      blockedThisUserChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get myProfileUpdated =>
      myProfileUpdatedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onAdminBlockedOtherUser =>
      onAdminBlockedOtherUserChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onAdminBlockedUser =>
      onAdminBlockedUserChannel.receiveBroadcastStream().cast();


  @override
  Stream<bool> get onContactSyncComplete =>
      onContactSyncCompleteChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onLoggedOut =>
      onLoggedOutChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get unblockedThisUser =>
      unblockedThisUserChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get userBlockedMe =>
      userBlockedMeChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get userCameOnline =>
      userCameOnlineChannel.receiveBroadcastStream().cast();


  @override
  Stream<String> get userDeletedHisProfile =>
      userDeletedHisProfileChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get userProfileFetched =>
      userProfileFetchedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get userUnBlockedMe =>
      userUnBlockedMeChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get userUpdatedHisProfile =>
      userUpdatedHisProfileChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get userWentOffline =>
      userWentOfflineChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get usersIBlockedListFetched =>
      usersIBlockedListFetchedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get usersWhoBlockedMeListFetched =>
      usersWhoBlockedMeListFetchedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onConnected =>
      onConnectedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onDisconnected =>
      onDisconnectedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onConnectionNotAuthorized =>
      onConnectionNotAuthorizedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get connectionFailed =>
      connectionFailedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get connectionSuccess =>
      connectionSuccessChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onWebChatPasswordChanged =>
      onWebChatPasswordChangedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get setTypingStatus =>
      setTypingStatusChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onChatTypingStatus =>
      onChatTypingStatusChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onGroupTypingStatus =>
      onGroupTypingStatusChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onFailure =>
      onFailureChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onProgressChanged =>
      onProgressChangedChannel.receiveBroadcastStream().cast();


  @override
  Stream<dynamic> get onSuccess =>
      onSuccessChannel.receiveBroadcastStream().cast();


  @override
  Future<String?> imagePath(String imgurl) async {
    var re = "";
    try {
      final result = await mirrorFlyMethodChannel
          .invokeMethod<String>("get_image_path", {"image": imgurl});
      debugPrint('RESULT ==> $result');
      return result;
    } on PlatformException catch (e) {
      debugPrint("er $e");
      return re;
    }
  }


  @override
  Future<dynamic> saveProfile(String name, String email) async {
    dynamic result;
    try {
      result = await mirrorFlyMethodChannel.invokeMethod("updateProfile", {
        "name": name,
        "email": email,
      });
      debugPrint('RESULT $result');
      return result;
    } on PlatformException catch (e) {
      debugPrint("er $e");
      return result;
    }
  }


  @override
  Future<dynamic> sentFileMessage(String? file, String jid) async {
    var re = "";
    try {
      final result = await mirrorFlyMethodChannel
          .invokeMethod("sent file", {"file": file, "jid": jid, "message": ""});
      debugPrint('RESULT $result');
      return result;
    } on PlatformException catch (e) {
      debugPrint("er $e");
      return re;
    }
  }


  @override
  Future<dynamic> getRecentChatList() async {
    //getRecentChats
    dynamic recentResponse;
    try {
      recentResponse =
      await mirrorFlyMethodChannel.invokeMethod('getRecentChatList');
      debugPrint("recent Result ==> $recentResponse");
      return recentResponse;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getProfileStatusList() async {
    //getStatusList
    dynamic statusResponse;
    try {
      statusResponse =
      await mirrorFlyMethodChannel.invokeMethod('getProfileStatusList');
      debugPrint("statuslist $statusResponse");
      return statusResponse;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> insertDefaultStatus(String status) async {
    try {
      await mirrorFlyMethodChannel
          .invokeMethod('insertDefaultStatus', {"status": status});
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }

  /*
@override
 void insertDefaultStatusToUser() async{
    try {
      await mirrorFlyMethodChannel.invokeMethod('getProfileStatusList').then((value) {
        mirrorFlyLog("status list", "$value");
        if (value != null) {
          var profileStatus = statusDataFromJson(value);
          if (profileStatus.isNotEmpty) {
            var defaultStatus = Constants.defaultStatusList;
            for (var statusValue in defaultStatus) {
              var isStatusNotExist = true;
              for (var flyStatus in profileStatus) {
                if (flyStatus.status == (statusValue)) {
                  isStatusNotExist = false;
                }
              }
              if (isStatusNotExist) {
                FlyChat.insertDefaultStatus(statusValue);
              }
            }
            SessionManagement.vibrationType("0");
            FlyChat.getRingtoneName(null).then((value) {
              if (value != null) {
                SessionManagement.setNotificationUri(value);
              }
            });
            SessionManagement.convSound(true);
            SessionManagement.muteAll( false);
          }else{
            var defaultStatus = Constants.defaultStatusList;
            for (var statusValue in defaultStatus) {
              FlyChat.insertDefaultStatus(statusValue);
            }
            FlyChat.getRingtoneName(null).then((value) {
              if (value != null) {
                SessionManagement.setNotificationUri(value);
              }
            });
          }
        }
      });
    } on Exception catch(er){
      debugPrint("Exception ==> $er");
    }
  }*/

  @override
  Future<dynamic> updateMyProfile(String name, String email,
      String mobile, String status, String? image) async {
    //updateProfile
    dynamic profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel.invokeMethod(
          'updateMyProfile', {
        "name": name,
        "email": email,
        "mobile": mobile,
        "status": status,
        "image": image
      });
      debugPrint("updateMyProfile Result ==> $profileResponse");
      return profileResponse;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getUserProfile(String jid,
      [bool fromserver = false, bool saveasfriend = false]) async {
    //getProfile
    dynamic profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel.invokeMethod(
          'getUserProfile',
          {"jid": jid, "server": fromserver, "saveasfriend": saveasfriend});
      debugPrint("getUserProfile Result ==> $profileResponse");
      //insertDefaultStatusToUser();
      return profileResponse;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getProfileDetails(String jid, bool fromServer) async {
    dynamic profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel.invokeMethod(
          'getProfileDetails', {"jid": jid, "server": fromServer});
      debugPrint("getProfileDetails Result ==> $profileResponse");
      return profileResponse;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> getProfileLocal(String jid, bool server) async {
    dynamic profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel
          .invokeMethod('getUserProfile', {"jid": jid, "server": server});
      debugPrint("getProfileLocal Result ==> $profileResponse");
      return profileResponse;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> setMyProfileStatus(String status, String statusId) async {
    //updateProfileStatus
    dynamic profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel
          .invokeMethod(
          'setMyProfileStatus', {"status": status, "statusId": statusId});
      debugPrint("setMyProfileStatus Result ==> $profileResponse");
      return profileResponse;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> insertNewProfileStatus(String status) async {
    dynamic profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel
          .invokeMethod('insertNewProfileStatus', {"status": status});
      debugPrint("insertNewProfileStatus Result ==> $profileResponse");
      return profileResponse;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<dynamic> updateMyProfileImage(String image) async {
    //updateProfileImage
    dynamic profileResponse;
    try {
      profileResponse = await mirrorFlyMethodChannel
          .invokeMethod('updateMyProfileImage', {"image": image});
      debugPrint("updateMyProfileImage Result ==> $profileResponse");
      return profileResponse;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }


  @override
  Future<bool?> removeProfileImage() async {
    bool? profileResponse;
    try {
      profileResponse =
      await mirrorFlyMethodChannel.invokeMethod<bool>('removeProfileImage');
      debugPrint("removeProfileImage Result ==> $profileResponse");
      return profileResponse;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      return false;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      return false;
    }
  }


  @override
  Future<bool?> removeGroupProfileImage(String jid) async {
    bool? response;
    try {
      response = await mirrorFlyMethodChannel
          .invokeMethod<bool>('removeGroupProfileImage', {"jid": jid});
      debugPrint("grp_image Result ==> $response");
      return response;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      return false;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      return false;
    }
  }


  @override
  Future<bool?> refreshAndGetAuthToken() async {
    bool? tokenResponse;
    try {
      tokenResponse =
      await mirrorFlyMethodChannel.invokeMethod<bool>('refreshAuthToken');
      debugPrint("refreshAuthToken Result ==> $tokenResponse");
      return tokenResponse;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      return false;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
      return false;
    }
  }


  @override
  Future<dynamic> getMessagesOfJid(String jid) async {
    //getChatHistory
    dynamic chatResponse;
    try {
      chatResponse = await mirrorFlyMethodChannel
          .invokeMethod('getMessagesOfJid', {"JID": jid});
      debugPrint("user Chat Result ==> $chatResponse");
      // List<ChatMessageModel> chatMessageModel = chatMessageModelFromJson(chatResponse);
      // return chatMessageModel;
      return chatResponse;
    } on PlatformException catch (e) {
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch (error) {
      debugPrint("Exception ==> $error");
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
      debugPrint("chatListenerResponse ==> $chatListenerResponse");
      return chatListenerResponse;
    }on PlatformException catch (e){
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch(error){
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }
  
@override
 Future<dynamic> listenGroupChatEvents() async {
    dynamic chatListenerResponse;
    try {
      chatListenerResponse = await mirrorFlyMethodChannel.invokeMethod('groupchat_listener');
      debugPrint("groupchatListenerResponse ==> $chatListenerResponse");
      return chatListenerResponse;
    }on PlatformException catch (e){
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch(error){
      debugPrint("Exception ==> $error");
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
    //     // debugPrint("mediaResponse ==> $media");
    //     return media;
    //   }on PlatformException catch (e){
    //     debugPrint("Platform Exception ===> $e");
    //     rethrow;
    //   } on Exception catch(error){
    //     debugPrint("Exception ==> $error");
    //     rethrow;
    //   }
    // }


    @override
    Future<dynamic> markAsReadDeleteUnreadSeparator(String jid) async {
      //sendReadReceipts
      //Handled Both Functions ChatManager.markAsRead and FlyMessenger.deleteUnreadMessageSeparatorOfAConversation in this same Function
      dynamic readReceiptResponse;
      try {
        readReceiptResponse = await mirrorFlyMethodChannel
            .invokeMethod('markAsReadDeleteUnreadSeparator', {"jid": jid});
        // debugPrint("mediaResponse ==> $readReceiptResponse");
        return readReceiptResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> sendContactMessage(List<String> contactList,
        String jid, String contactName, String replyMessageId) async {
      dynamic contactResponse;
      try {
        contactResponse =
        await mirrorFlyMethodChannel.invokeMethod('sendContactMessage', {
          "contact_list": contactList,
          "jid": jid,
          "contact_name": contactName,
          "replyMessageId": replyMessageId
        });
        // debugPrint("mediaResponse ==> $readReceiptResponse");
        return contactResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> logoutOfChatSDK() async {
      //logout
      dynamic logoutResponse;
      try {
        logoutResponse =
        await mirrorFlyMethodChannel.invokeMethod('logoutOfChatSDK');
        debugPrint("logoutResponse ==> $logoutResponse");
        return logoutResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    setOnGoingChatUser(String jid) async {
      //ongoingChat
      try {
        await mirrorFlyMethodChannel
            .invokeMethod('setOnGoingChatUser', {"jid": jid});
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
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
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> sendDocumentMessage(String jid, String documentPath,
        String replyMessageId,
        [String? fileUrl]) async {
      dynamic documentResponse;
      try {
        documentResponse =
        await mirrorFlyMethodChannel.invokeMethod('sendDocumentMessage', {
          "file": documentPath,
          "jid": jid,
          "replyMessageId": replyMessageId,
          "file_url": fileUrl
        });
        debugPrint("documentResponse ==> $documentResponse");
        return documentResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> openFile(String filePath) async {
      dynamic documentResponse;
      try {
        documentResponse = await mirrorFlyMethodChannel
            .invokeMethod('open_file', {"filePath": filePath});
        debugPrint("documentResponse ==> $documentResponse");
        return documentResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> sendAudioMessage(String jid, String filePath,
        bool isRecorded, String duration, String replyMessageId,
        [String? audiofileUrl]) async {
      //sendAudio
      dynamic audioResponse;
      try {
        audioResponse =
        await mirrorFlyMethodChannel.invokeMethod('sendAudioMessage', {
          "filePath": filePath,
          "jid": jid,
          "isRecorded": isRecorded,
          "duration": duration,
          "replyMessageId": replyMessageId,
          "audiofileUrl": audiofileUrl
        });
        debugPrint("audioResponse ==> $audioResponse");
        return audioResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }

    //Recent Chat Search


    @override
    Future<dynamic> getRecentChatListIncludingArchived() async {
      //filteredRecentChatList
      dynamic response;
      try {
        response = await mirrorFlyMethodChannel
            .invokeMethod('getRecentChatListIncludingArchived');
        debugPrint("getRecentChatListIncludingArchived ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> searchConversation(String searchKey,
        [String? jidForSearch, bool globalSearch = true]) async {
      //filteredMessageList
      dynamic response;
      try {
        response =
        await mirrorFlyMethodChannel.invokeMethod('searchConversation', {
          "searchKey": searchKey,
          "jidForSearch": jidForSearch,
          "globalSearch": globalSearch
        });
        debugPrint("searchConversation ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> getRegisteredUsers(bool server) async {
      //filteredContactList
      dynamic response;
      try {
        response =
        await mirrorFlyMethodChannel.invokeMethod(
            'getRegisteredUsers', {"server": server});
        debugPrint("getRegisteredUsers $server ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> getMessageOfId(String mid) async {
      dynamic response;
      try {
        response = await mirrorFlyMethodChannel
            .invokeMethod('getMessageOfId', {"mid": mid});
        // debugPrint("response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> getRecentChatOf(String jid) async {
      dynamic response;
      try {
        response = await mirrorFlyMethodChannel
            .invokeMethod('getRecentChatOf', {"jid": jid});
        debugPrint("getRecentChatOf response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> clearChat(String jid, String chatType,
        bool clearExceptStarred) async {
      dynamic clearChatResponse;
      try {
        clearChatResponse = await mirrorFlyMethodChannel.invokeMethod(
            'clear_chat', {
          "jid": jid,
          "chat_type": chatType,
          "clear_except_starred": clearExceptStarred
        });
        debugPrint("clear chat Response ==> $clearChatResponse");
        return clearChatResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
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
      debugPrint("clear chat Response ==> $reportResponse");
      return reportResponse;
    }on PlatformException catch (e){
      debugPrint("Platform Exception ===> $e");
      rethrow;
    } on Exception catch(error){
      debugPrint("Exception ==> $error");
      rethrow;
    }
  }*/


    @override
    Future<dynamic> getMessagesUsingIds(List<String> messageIds) async {
      dynamic messageListResponse;
      try {
        messageListResponse = await mirrorFlyMethodChannel
            .invokeMethod('getMessagesUsingIds', {"MessageIds": messageIds});
        debugPrint("getMessagesUsingIds Response ==> $messageListResponse");
        return messageListResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }

    //Handled deleteMessagesForEveryone and deleteMessagesForMe in same function. so Named Commonly

    @override
    Future<dynamic> deleteMessagesForMe(String jid, String chatType,
        List<String> messageIds, bool? isMediaDelete) async {
      dynamic messageDeleteResponse;
      try {
        messageDeleteResponse =
        await mirrorFlyMethodChannel.invokeMethod('deleteMessagesForMe', {
          "jid": jid,
          "chat_type": chatType,
          "isMediaDelete": isMediaDelete,
          "message_ids": messageIds
        });
        debugPrint("deleteMessagesForMe Response ==> $messageDeleteResponse");
        return messageDeleteResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> deleteMessagesForEveryone(String jid, String chatType,
        List<String> messageIds, bool? isMediaDelete) async {
      dynamic messageDeleteResponse;
      try {
        messageDeleteResponse = await mirrorFlyMethodChannel
            .invokeMethod('deleteMessagesForEveryone', {
          "jid": jid,
          "chat_type": chatType,
          "isMediaDelete": isMediaDelete,
          "message_ids": messageIds
        });
        debugPrint(
            "deleteMessagesForEveryone Response ==> $messageDeleteResponse");
        return messageDeleteResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> deleteMessages(String jid, List<String> messageIds,
        bool isDeleteForEveryOne) async {
      dynamic messageDeleteResponse;
      try {
        messageDeleteResponse =
        await mirrorFlyMethodChannel.invokeMethod('delete_messages', {
          "jid": jid,
          "chat_type": "chat",
          "message_ids": messageIds,
          "is_delete_for_everyone": isDeleteForEveryOne
        });
        debugPrint("Message Delete Response ==> $messageDeleteResponse");
        return messageDeleteResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> getGroupMessageDeliveredToList(String messageId, String jid) async {
      dynamic messageDeleteResponse;
      try {
        messageDeleteResponse = await mirrorFlyMethodChannel.invokeMethod(
            'getGroupMessageDeliveredToList', {"messageId": messageId, "jid": jid});
        debugPrint(
            "getGroupMessageDeliveredToList Response ==> $messageDeleteResponse");
        return messageDeleteResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> getGroupMessageReadByList(String messageId, String jid) async {
      dynamic messageDeleteResponse;
      try {
        messageDeleteResponse = await mirrorFlyMethodChannel
            .invokeMethod(
            'getGroupMessageReadByList', {"messageId": messageId, "jid": jid});
        debugPrint(
            "getGroupMessageReadByList Response ==> $messageDeleteResponse");
        return messageDeleteResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> getMessageStatusOfASingleChatMessage(
        String messageID) async {
      //getMessageInfo
      dynamic messageInfoResponse;
      try {
        messageInfoResponse = await mirrorFlyMethodChannel.invokeMethod(
            'getMessageStatusOfASingleChatMessage', {"messageID": messageID});
        debugPrint("Message Info Response ==> $messageInfoResponse");
        return messageInfoResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> blockUser(String userJID) async {
      dynamic userBlockResponse;
      try {
        userBlockResponse = await mirrorFlyMethodChannel
            .invokeMethod('block_user', {"userJID": userJID});
        debugPrint("Blocked Response ==> $userBlockResponse");
        return userBlockResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<bool?> unblockUser(String userJID) async {
      //unBlockUser
      bool? userBlockResponse;
      try {
        userBlockResponse = await mirrorFlyMethodChannel
            .invokeMethod<bool>('un_block_user', {"userJID": userJID});
        debugPrint("Un-Blocked Response ==> $userBlockResponse");
        return userBlockResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<String?> showCustomTones() async {
      String? response;
      try {
        response = await mirrorFlyMethodChannel
            .invokeMethod<String>('showCustomTones');
        debugPrint("showCustomTones Response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<String?> getRingtoneName() async {
      String? response;
      try {
        response = await mirrorFlyMethodChannel
            .invokeMethod<String>('getRingtoneName');
        debugPrint("getRingtoneName Response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<bool?> loginWebChatViaQRCode(String barcode) async {
      bool? response;
      try {
        response = await mirrorFlyMethodChannel
            .invokeMethod<bool>('loginWebChatViaQRCode', {"barcode": barcode});
        debugPrint("loginWebChatViaQRCode Response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<bool?> webLoginDetailsCleared() async {
      bool? response;
      try {
        response = await mirrorFlyMethodChannel
            .invokeMethod<bool>('webLoginDetailsCleared');
        debugPrint("webLoginDetailsCleared Response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<bool?> logoutWebUser(List<String> logins) async {
      bool? response;
      try {
        response = await mirrorFlyMethodChannel
            .invokeMethod<bool>('logoutWebUser', {"listWebLogin": logins});
        debugPrint("logoutWebUser Response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }

    @override
    Future<bool?> iOSFileExist(String filePath) async {
      bool? response;
      try {
        response = await mirrorFlyMethodChannel
            .invokeMethod<bool>('iOSFileExist', {"file_path": filePath});
        debugPrint("iOSFileExist Response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> getWebLoginDetails() async {
      dynamic response;
      try {
        response =
        await mirrorFlyMethodChannel.invokeMethod('getWebLoginDetails');
        debugPrint("getWebLoginDetails Response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> updateFavouriteStatus(String messageID, String chatUserJID,
        bool isFavourite, String chatType) async {
      //favouriteMessage
      dynamic favResponse;
      try {
        favResponse = await mirrorFlyMethodChannel.invokeMethod(
            'updateFavouriteStatus', {
          "messageID": messageID,
          "chatUserJID": chatUserJID,
          "isFavourite": isFavourite,
          "chatType": chatType,
        });
        debugPrint("Favourite Msg Response ==> $favResponse");
        return favResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> forwardMessagesToMultipleUsers(List<String> messageIds,
        List<String> userList) async {
      //forwardMessage
      dynamic forwardMessageResponse;
      try {
        forwardMessageResponse = await mirrorFlyMethodChannel.invokeMethod(
            'forwardMessagesToMultipleUsers',
            {"message_ids": messageIds, "userList": userList});
        debugPrint("Forward Msg Response ==> $forwardMessageResponse");
        return forwardMessageResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> forwardMessages(List<String> messageIds, String tojid,
        String chattype) async {
      //forwardMessage
      dynamic forwardMessageResponse;
      try {
        forwardMessageResponse = await mirrorFlyMethodChannel.invokeMethod(
            'forwardMessages',
            {
              "message_ids": messageIds,
              "to_jid": tojid,
              "chat_type": chattype
            });
        debugPrint("forwardMessages Response ==> $forwardMessageResponse");
        return forwardMessageResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> createGroup(String groupName, List<String> userJidList,
        String imageFilePath) async {
      dynamic response;
      try {
        response = await mirrorFlyMethodChannel.invokeMethod('createGroup', {
          "group_name": groupName,
          "members": userJidList,
          "file": imageFilePath,
        });
        debugPrint("create group Response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<bool?> addUsersToGroup(String jid, List<String> userList) async {
      bool? response;
      try {
        response = await mirrorFlyMethodChannel.invokeMethod<bool>(
            'addUsersToGroup', {"jid": jid, "members": userList});
        debugPrint("addUsersToGroup Response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> getGroupMembersList(String jid, bool? server) async {
      //getGroupMembers
      dynamic response;
      try {
        response =
        await mirrorFlyMethodChannel.invokeMethod('getGroupMembersList', {
          "jid": jid,
          "server": server,
        });
        debugPrint("getGroupMembersList Response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> getUsersIBlocked(bool? server) async {
      dynamic response;
      try {
        response =
        await mirrorFlyMethodChannel.invokeMethod('getUsersIBlocked', {
          "serverCall": server,
        });
        debugPrint("getUsersIBlocked Response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> getMediaMessages(String jid) async {
      dynamic response;
      try {
        response =
        await mirrorFlyMethodChannel.invokeMethod('getMediaMessages', {
          "jid": jid,
        });
        debugPrint("getMediaMessages Response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> getDocsMessages(String jid) async {
      dynamic response;
      try {
        response =
        await mirrorFlyMethodChannel.invokeMethod('getDocsMessages', {
          "jid": jid,
        });
        debugPrint("getDocsMessages Response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> getLinkMessages(String jid) async {
      dynamic response;
      try {
        response =
        await mirrorFlyMethodChannel.invokeMethod('getLinkMessages', {
          "jid": jid,
        });
        debugPrint("getLinkMessages Response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    exportChatConversationToEmail(String jid) async {
      try {
        await mirrorFlyMethodChannel
            .invokeMethod('exportChatConversationToEmail', {"jid": jid});
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<bool?> reportUserOrMessages(String jid, String type,
        String? messageId) async {
      bool? response;
      try {
        response = await mirrorFlyMethodChannel.invokeMethod<bool>(
            'reportUserOrMessages',
            {"jid": jid, "chat_type": type, "selectedMessageID": messageId});
        debugPrint("report Result ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        return false;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        return false;
      }
    }


    @override
    Future<bool?> makeAdmin(String groupjid, String userjid) async {
      bool? response;
      try {
        response = await mirrorFlyMethodChannel.invokeMethod<bool>(
            'makeAdmin', {"jid": groupjid, "userjid": userjid});
        debugPrint("report Result ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        return false;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        return false;
      }
    }


    @override
    Future<bool?> removeMemberFromGroup(String groupjid, String userjid) async {
      bool? response;
      try {
        response = await mirrorFlyMethodChannel.invokeMethod<bool>(
            'removeMemberFromGroup', {"jid": groupjid, "userjid": userjid});
        debugPrint("report Result ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        return false;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        return false;
      }
    }


    @override
    Future<bool?> leaveFromGroup(String? userJid, String groupJid) async {
      bool? response;
      try {
        response = await mirrorFlyMethodChannel
            .invokeMethod<bool>(
            'leaveFromGroup', {"userJid": userJid, "groupJid": groupJid});
        debugPrint("leaveFromGroup Result ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        return false;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        return false;
      }
    }


    @override
    Future<bool?> deleteGroup(String jid) async {
      bool? response;
      try {
        response = await mirrorFlyMethodChannel
            .invokeMethod<bool>('deleteGroup', {"jid": jid});
        debugPrint("deleteGroup Result ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        return false;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        return false;
      }
    }


    @override
    Future<bool?> isAdmin(String userJid, String groupJID) async {
      bool? response;
      try {
        response = await mirrorFlyMethodChannel
            .invokeMethod<bool>(
            'isAdmin', {"jid": userJid, "group_jid": groupJID});
        debugPrint("isAdmin Result ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        return false;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        return false;
      }
    }


    @override
    Future<bool?> updateGroupProfileImage(String jid, String file) async {
      bool? response;
      try {
        response = await mirrorFlyMethodChannel.invokeMethod<bool>(
            'updateGroupProfileImage', {"jid": jid, "file": file});
        debugPrint("updateGroupProfileImage Result ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        return false;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        return false;
      }
    }


    @override
    Future<bool?> updateGroupName(String jid, String name) async {
      bool? response;
      try {
        response = await mirrorFlyMethodChannel
            .invokeMethod<bool>('updateGroupName', {"jid": jid, "name": name});
        debugPrint("updateGroupName Result ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        return false;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        return false;
      }
    }


    @override
    Future<bool?> isMemberOfGroup(String jid, String? userJid) async {
      bool? response;
      try {
        response = await mirrorFlyMethodChannel.invokeMethod<bool>(
            'isMemberOfGroup', {"jid": jid, "userjid": userJid});
        debugPrint("isMemberOfGroup Result ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        return false;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        return false;
      }
    }


    @override
    Future<bool?> sendContactUsInfo(String title, String description) async {
      bool? response;
      try {
        response = await mirrorFlyMethodChannel.invokeMethod<bool>(
            'sendContactUsInfo', {"title": title, "description": description});
        debugPrint("sendContactUsInfo Result ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        return false;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        return false;
      }
    }


    @override
    copyTextMessages(List<String> messageIds) async {
      try {
        await mirrorFlyMethodChannel
            .invokeMethod('copyTextMessages', {"messageidlist": messageIds});
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    saveUnsentMessage(String jid, String message) async {
      try {
        await mirrorFlyMethodChannel
            .invokeMethod(
            'saveUnsentMessage', {"jid": jid, "texMessage": message});
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> deleteAccount(String reason, String? feedback) async {
      dynamic response;
      try {
        response = await mirrorFlyMethodChannel.invokeMethod('delete_account',
            {"delete_reason": reason, "delete_feedback": feedback});
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> getFavouriteMessages() async {
      dynamic favResponse;
      try {
        favResponse =
        await mirrorFlyMethodChannel.invokeMethod('get_favourite_messages');
        debugPrint("fav response ==> $favResponse");
        return favResponse;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<dynamic> getAllGroups([bool? server]) async {
      dynamic response;
      try {
        response = await mirrorFlyMethodChannel
            .invokeMethod('getAllGroups', {"server": server});
        debugPrint("getAllGroups response ==> $response");
        return response;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<String?> getDefaultNotificationUri() async {
      String? uri = "";
      try {
        uri = await mirrorFlyMethodChannel
            .invokeMethod<String?>('getDefaultNotificationUri');
        return uri;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    setDefaultNotificationSound() async {
      try {
        await mirrorFlyMethodChannel
            .invokeMethod('setDefaultNotificationSound');
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    setNotificationSound(bool enable) async {
      try {
        await mirrorFlyMethodChannel
            .invokeMethod('setNotificationSound', {"enable": enable});
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<bool?> getNotificationSound() async {
      bool? isEnabled = false;
      try {
        isEnabled = await mirrorFlyMethodChannel
            .invokeMethod('getNotificationSound');
        return isEnabled;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    setMuteNotification(bool enable) async {
      try {
        await mirrorFlyMethodChannel
            .invokeMethod('setMuteNotification', {"enable": enable});
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    setNotificationVibration(bool enable) async {
      try {
        await mirrorFlyMethodChannel
            .invokeMethod('setNotificationVibration', {"enable": enable});
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    cancelNotifications() async {
      try {
        await mirrorFlyMethodChannel.invokeMethod('cancelNotifications');
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


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
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
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
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }

    @override
    Future<bool?> getMediaAutoDownload() async {
      bool? val = false;
      try {
        val = await mirrorFlyMethodChannel.invokeMethod<bool?>(
            'getMediaAutoDownload');
        debugPrint("MediaAutoDownloadEnabled--> $val");
        return val;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }

    @override
    setMediaAutoDownload(bool enable) async {
      try {
        await mirrorFlyMethodChannel.invokeMethod('setMediaAutoDownload', {
          'enable': enable
        });
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }


    @override
    Future<String?> getJidFromPhoneNumber(String mobileNumber,
        String countryCode) async {
      String? jid = "";
      try {
        jid = await mirrorFlyMethodChannel
            .invokeMethod<String?>('getJidFromPhoneNumber',
            {"mobileNumber": mobileNumber, "countryCode": countryCode});
        return jid;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }

    @override
    Future<bool?> isTrailLicence() async {
      bool? val = true;
      try {
        val = await mirrorFlyMethodChannel
            .invokeMethod<bool?>('IS_TRIAL_LICENSE');
        debugPrint('isTrailLicence : $val');
        return val;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }

    @override
    Future<dynamic> getNonChatUsers() async {
      dynamic val;
      try {
        val = await mirrorFlyMethodChannel
            .invokeMethod('getNonChatUsers');
        debugPrint('getNonChatUsers : $val');
        return val;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }

    @override
    Future<bool?> addContact(String number, String name) async {
      bool? val = true;
      try {
        val = await mirrorFlyMethodChannel
            .invokeMethod('addContact', {'number': number, 'name': name});
        debugPrint('addContact : $number');
        return val;
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }

    @override
    Future setRegionCode(String regionCode) async {
      try {
        debugPrint('setRegionCode : $regionCode');
        await mirrorFlyMethodChannel
            .invokeMethod('setRegionCode', {'regionCode': regionCode});
      } on PlatformException catch (e) {
        debugPrint("Platform Exception ===> $e");
        rethrow;
      } on Exception catch (error) {
        debugPrint("Exception ==> $error");
        rethrow;
      }
    }
  }
