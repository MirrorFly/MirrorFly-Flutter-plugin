import Flutter
import UIKit
import FlyCore
import FlyCommon



let mirrorflyMethodChannel = "contus.mirrorfly/flyChat"

let onMessageReceivedChannel = "contus.mirrorfly/onMessageReceived"
let onMessageStatusUpdatedChannel = "contus.mirrorfly/onMessageStatusUpdated"
let onMediaStatusUpdatedChannel = "contus.mirrorfly/onMediaStatusUpdated"
let onUploadDownloadProgressChangedChannel =
"contus.mirrorfly/onUploadDownloadProgressChanged"
let showUpdateCancelNotificationChannel =
"contus.mirrorfly/showOrUpdateOrCancelNotification"

let onGroupProfileFetched_channel = "contus.mirrorfly/onGroupProfileFetched"
let onNewGroupCreated_channel = "contus.mirrorfly/onNewGroupCreated"
let onGroupProfileUpdated_channel = "contus.mirrorfly/onGroupProfileUpdated"
let onNewMemberAddedToGroup_channel = "contus.mirrorfly/onNewMemberAddedToGroup"
let onMemberRemovedFromGroup_channel = "contus.mirrorfly/onMemberRemovedFromGroup"
let onFetchingGroupMembersCompleted_channel =
"contus.mirrorfly/onFetchingGroupMembersCompleted"
let onDeleteGroup_channel = "contus.mirrorfly/onDeleteGroup"
let onFetchingGroupListCompleted_channel =
"contus.mirrorfly/onFetchingGroupListCompleted"
let onMemberMadeAsAdmin_channel = "contus.mirrorfly/onMemberMadeAsAdmin"
let onMemberRemovedAsAdmin_channel = "contus.mirrorfly/onMemberRemovedAsAdmin"
let onLeftFromGroup_channel = "contus.mirrorfly/onLeftFromGroup"
let onGroupNotificationMessage_channel = "contus.mirrorfly/onGroupNotificationMessage"
let onGroupDeletedLocally_channel = "contus.mirrorfly/onGroupDeletedLocally"

let blockedThisUser_channel = "contus.mirrorfly/blockedThisUser"
let myProfileUpdated_channel = "contus.mirrorfly/myProfileUpdated"
let onAdminBlockedOtherUser_channel = "contus.mirrorfly/onAdminBlockedOtherUser"
let onAdminBlockedUser_channel = "contus.mirrorfly/onAdminBlockedUser"
let onContactSyncComplete_channel = "contus.mirrorfly/onContactSyncComplete"
let onLoggedOut_channel = "contus.mirrorfly/onLoggedOut"
let unblockedThisUser_channel = "contus.mirrorfly/unblockedThisUser"
let userBlockedMe_channel = "contus.mirrorfly/userBlockedMe"
let userCameOnline_channel = "contus.mirrorfly/userCameOnline"
let userDeletedHisProfile_channel = "contus.mirrorfly/userDeletedHisProfile"
let userProfileFetched_channel = "contus.mirrorfly/userProfileFetched"
let userUnBlockedMe_channel = "contus.mirrorfly/userUnBlockedMe"
let userUpdatedHisProfile_channel = "contus.mirrorfly/userUpdatedHisProfile"
let userWentOffline_channel = "contus.mirrorfly/userWentOffline"
let usersIBlockedListFetched_channel = "contus.mirrorfly/usersIBlockedListFetched"
let usersProfilesFetched_channel = "contus.mirrorfly/usersProfilesFetched"
let usersWhoBlockedMeListFetched_channel = "contus.mirrorfly/usersWhoBlockedMeListFetched"
let onConnected_channel = "contus.mirrorfly/onConnected"
let onDisconnected_channel = "contus.mirrorfly/onDisconnected"
let onConnectionNotAuthorized_channel = "contus.mirrorfly/onConnectionNotAuthorized"
let connectionFailed_channel = "contus.mirrorfly/connectionFailed"
let connectionSuccess_channel = "contus.mirrorfly/connectionSuccess"
let onWebChatPasswordChanged_channel = "contus.mirrorfly/onWebChatPasswordChanged"
let setTypingStatus_channel = "contus.mirrorfly/setTypingStatus"
let onChatTypingStatus_channel = "contus.mirrorfly/onChatTypingStatus"
let onGroupTypingStatus_channel = "contus.mirrorfly/onGroupTypingStatus"
let onFailure_channel = "contus.mirrorfly/onFailure"
let onProgressChanged_channel = "contus.mirrorfly/onProgressChanged"
let onSuccess_channel = "contus.mirrorfly/onSuccess"
let onMessageDeleteForEveryOne_channel = "contus.mirrorfly/onMessageDeleteForEveryOne"

public class FlyChatPlugin: NSObject, FlutterPlugin {
    
    var messageReceivedStreamHandler: MessageReceivedStreamHandler?
    var messageStatusUpdatedStreamHandler: MessageStatusUpdatedStreamHandler?
    var mediaStatusUpdatedStreamHandler: MediaStatusUpdatedStreamHandler?
    var uploadDownloadProgressChangedStreamHandler: UploadDownloadProgressChangedStreamHandler?
    var showOrUpdateOrCancelNotificationStreamHandler: ShowOrUpdateOrCancelNotificationStreamHandler?
    var groupProfileFetchedStreamHandler: GroupProfileFetchedStreamHandler?
    var newGroupCreatedStreamHandler: NewGroupCreatedStreamHandler?
    var groupProfileUpdatedStreamHandler: GroupProfileUpdatedStreamHandler?
    var newMemberAddedToGroupStreamHandler: NewMemberAddedToGroupStreamHandler?
    var memberRemovedFromGroupStreamHandler: MemberRemovedFromGroupStreamHandler?
    var fetchingGroupMembersCompletedStreamHandler: FetchingGroupMembersCompletedStreamHandler?
    var deleteGroupStreamHandler: DeleteGroupStreamHandler?
    var fetchingGroupListCompletedStreamHandler: FetchingGroupListCompletedStreamHandler?//
    var memberMadeAsAdminStreamHandler: MemberMadeAsAdminStreamHandler?
    var memberRemovedAsAdminStreamHandler: MemberRemovedAsAdminStreamHandler?
    var userWentOfflineStreamHandler: UserWentOfflineStreamHandler?
    
    var leftFromGroupStreamHandler: LeftFromGroupStreamHandler?
    var onGroupNotificationMessageStreamHandler: GroupNotificationMessageStreamHandler?
    var onGroupDeletedLocallyStreamHandler: GroupDeletedLocallyStreamHandler?
    var blockedThisUserStreamHandler: BlockedThisUserStreamHandler?
    var myProfileUpdatedStreamHandler: MyProfileUpdatedStreamHandler?
    var onAdminBlockedOtherUserStreamHandler: OnAdminBlockedOtherUserStreamHandler?
    var onAdminBlockedUserStreamHandler: OnAdminBlockedUserStreamHandler?
    var onContactSyncCompleteStreamHandler: OnContactSyncCompleteStreamHandler?
    var onLoggedOutStreamHandler: OnLoggedOutStreamHandler?
    var unblockedThisUserStreamHandler: UnblockedThisUserStreamHandler?
    var userBlockedMeStreamHandler: UserBlockedMeStreamHandler?
    var userCameOnlineStreamHandler: UserCameOnlineStreamHandler?
    var userDeletedHisProfileStreamHandler: UserDeletedHisProfileStreamHandler?
    var userProfileFetchedStreamHandler: UserProfileFetchedStreamHandler?
    var userUnBlockedMeStreamHandler: UserUnBlockedMeStreamHandler?
    var userUpdatedHisProfileStreamHandler: UserUpdatedHisProfileStreamHandler?
    var usersIBlockedListFetchedStreamHandler: UsersIBlockedListFetchedStreamHandler?
    var usersProfilesFetchedStreamHandler: UsersProfilesFetchedStreamHandler?
    var usersWhoBlockedMeListFetchedStreamHandler: UsersWhoBlockedMeListFetchedStreamHandler?
    var onConnectedStreamHandler: OnConnectedStreamHandler?
    var onDisconnectedStreamHandler: OnDisconnectedStreamHandler?
    var onConnectionNotAuthorizedStreamHandler: OnConnectionNotAuthorizedStreamHandler?
    var connectionFailedStreamHandler: ConnectionFailedStreamHandler?
    var connectionSuccessStreamHandler: ConnectionSuccessStreamHandler?
    var onWebChatPasswordChangedStreamHandler: OnWebChatPasswordChangedStreamHandler?
    var onFailureStreamHandler: OnFailureStreamHandler?
    var onProgressChangedStreamHandler: OnProgressChangedStreamHandler?
    var onSuccessStreamHandler: OnSuccessStreamHandler?
    
    var onMessageDeleteForEveryOneStreamHandler: OnMessageDeleteForEveryOneStreamHandler?
    
    var onChatTypingStatusStreamHandler: OnChatTypingStatusStreamHandler?
    var onsetTypingStatusStreamHandler: OnsetTypingStatusStreamHandler?
    var onGroupTypingStatusStreamHandler: OnGroupTypingStatusStreamHandler?
    
    public override init() {
            super.init()
        }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: mirrorflyMethodChannel, binaryMessenger: registrar.messenger())
        let instance = FlyChatPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        instance.setupEventChannel(registrar: registrar)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        prepareMethodHandler(methodCall: call, result: result)
    }
    
    
    private func setupEventChannel(registrar: FlutterPluginRegistrar){
        
        if (self.messageReceivedStreamHandler == nil) {
            self.messageReceivedStreamHandler = MessageReceivedStreamHandler()
        }
        
        FlutterEventChannel(name: onMessageReceivedChannel, binaryMessenger: registrar.messenger()).setStreamHandler((self.messageReceivedStreamHandler as! FlutterStreamHandler & NSObjectProtocol))
        
        if (self.messageStatusUpdatedStreamHandler == nil) {
            self.messageStatusUpdatedStreamHandler = MessageStatusUpdatedStreamHandler()
        }
        FlutterEventChannel(name: onMessageStatusUpdatedChannel, binaryMessenger: registrar.messenger()).setStreamHandler((self.messageStatusUpdatedStreamHandler as! FlutterStreamHandler & NSObjectProtocol))
        
        if (self.mediaStatusUpdatedStreamHandler == nil) {
            self.mediaStatusUpdatedStreamHandler = MediaStatusUpdatedStreamHandler()
        }
        
        FlutterEventChannel(name: onMediaStatusUpdatedChannel, binaryMessenger: registrar.messenger()).setStreamHandler((self.mediaStatusUpdatedStreamHandler as! FlutterStreamHandler & NSObjectProtocol))
        
        if (self.onAdminBlockedOtherUserStreamHandler == nil) {
            self.onAdminBlockedOtherUserStreamHandler = OnAdminBlockedOtherUserStreamHandler()
        }
        
        FlutterEventChannel(name: onAdminBlockedOtherUser_channel, binaryMessenger: registrar.messenger()).setStreamHandler((self.onAdminBlockedOtherUserStreamHandler as! FlutterStreamHandler & NSObjectProtocol))
        
        if (self.uploadDownloadProgressChangedStreamHandler == nil) {
            self.uploadDownloadProgressChangedStreamHandler = UploadDownloadProgressChangedStreamHandler()
        }
        FlutterEventChannel(name: onUploadDownloadProgressChangedChannel, binaryMessenger: registrar.messenger()).setStreamHandler(self.uploadDownloadProgressChangedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.showOrUpdateOrCancelNotificationStreamHandler == nil) {
            self.showOrUpdateOrCancelNotificationStreamHandler = ShowOrUpdateOrCancelNotificationStreamHandler()
        }
        
        FlutterEventChannel(name: showUpdateCancelNotificationChannel, binaryMessenger: registrar.messenger()).setStreamHandler(self.showOrUpdateOrCancelNotificationStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.groupProfileFetchedStreamHandler == nil) {
            self.groupProfileFetchedStreamHandler = GroupProfileFetchedStreamHandler()
        }
        
        FlutterEventChannel(name: onGroupProfileFetched_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.groupProfileFetchedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.newGroupCreatedStreamHandler == nil) {
            self.newGroupCreatedStreamHandler = NewGroupCreatedStreamHandler()
        }
        
        FlutterEventChannel(name: onNewGroupCreated_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.newGroupCreatedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.groupProfileUpdatedStreamHandler == nil) {
            self.groupProfileUpdatedStreamHandler = GroupProfileUpdatedStreamHandler()
        }
        
        FlutterEventChannel(name: onGroupProfileUpdated_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.groupProfileUpdatedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.newMemberAddedToGroupStreamHandler == nil) {
            self.newMemberAddedToGroupStreamHandler = NewMemberAddedToGroupStreamHandler()
        }
        
        FlutterEventChannel(name: onNewMemberAddedToGroup_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.newMemberAddedToGroupStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        
        if (self.memberRemovedFromGroupStreamHandler == nil) {
            self.memberRemovedFromGroupStreamHandler = MemberRemovedFromGroupStreamHandler()
        }
        
        FlutterEventChannel(name: onMemberRemovedFromGroup_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.memberRemovedFromGroupStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.fetchingGroupMembersCompletedStreamHandler == nil) {
            self.fetchingGroupMembersCompletedStreamHandler = FetchingGroupMembersCompletedStreamHandler()
        }
        
        FlutterEventChannel(name: onFetchingGroupMembersCompleted_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.fetchingGroupMembersCompletedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.deleteGroupStreamHandler == nil) {
            self.deleteGroupStreamHandler = DeleteGroupStreamHandler()
        }
        
        FlutterEventChannel(name: onDeleteGroup_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.deleteGroupStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.fetchingGroupListCompletedStreamHandler == nil) {
            self.fetchingGroupListCompletedStreamHandler = FetchingGroupListCompletedStreamHandler()
        }
        
        
        FlutterEventChannel(name: onFetchingGroupListCompleted_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.fetchingGroupListCompletedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.memberMadeAsAdminStreamHandler == nil) {
            self.memberMadeAsAdminStreamHandler = MemberMadeAsAdminStreamHandler()
        }
        
        FlutterEventChannel(name: onMemberMadeAsAdmin_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.memberMadeAsAdminStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.memberRemovedAsAdminStreamHandler == nil) {
            self.memberRemovedAsAdminStreamHandler = MemberRemovedAsAdminStreamHandler()
        }
        
        FlutterEventChannel(name: onMemberRemovedAsAdmin_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.memberRemovedAsAdminStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.leftFromGroupStreamHandler == nil) {
            self.leftFromGroupStreamHandler = LeftFromGroupStreamHandler()
        }
        
        FlutterEventChannel(name: onLeftFromGroup_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.leftFromGroupStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.userWentOfflineStreamHandler == nil) {
            self.userWentOfflineStreamHandler = UserWentOfflineStreamHandler()
        }
        
        FlutterEventChannel(name: userWentOffline_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.userWentOfflineStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        
        if (self.onGroupNotificationMessageStreamHandler == nil) {
            self.onGroupNotificationMessageStreamHandler = GroupNotificationMessageStreamHandler()
        }
        
        FlutterEventChannel(name: onGroupNotificationMessage_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.onGroupNotificationMessageStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.onGroupDeletedLocallyStreamHandler == nil) {
            self.onGroupDeletedLocallyStreamHandler = GroupDeletedLocallyStreamHandler()
        }
        
        FlutterEventChannel(name: onGroupDeletedLocally_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.onGroupDeletedLocallyStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.blockedThisUserStreamHandler == nil) {
            self.blockedThisUserStreamHandler = BlockedThisUserStreamHandler()
        }
        
        FlutterEventChannel(name: blockedThisUser_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.blockedThisUserStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        
        if (self.myProfileUpdatedStreamHandler == nil) {
            self.myProfileUpdatedStreamHandler = MyProfileUpdatedStreamHandler()
        }
        
        FlutterEventChannel(name: myProfileUpdated_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.myProfileUpdatedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.onAdminBlockedUserStreamHandler == nil) {
            self.onAdminBlockedUserStreamHandler = OnAdminBlockedUserStreamHandler()
        }
        
        FlutterEventChannel(name: onAdminBlockedUser_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.onAdminBlockedUserStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        
        if (self.onContactSyncCompleteStreamHandler == nil) {
            self.onContactSyncCompleteStreamHandler = OnContactSyncCompleteStreamHandler()
        }
        
        FlutterEventChannel(name: onContactSyncComplete_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.onContactSyncCompleteStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.onLoggedOutStreamHandler == nil) {
            self.onLoggedOutStreamHandler = OnLoggedOutStreamHandler()
        }
        
        FlutterEventChannel(name: onLoggedOut_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.onLoggedOutStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        
        if (self.unblockedThisUserStreamHandler == nil) {
            self.unblockedThisUserStreamHandler = UnblockedThisUserStreamHandler()
        }
        
        FlutterEventChannel(name: unblockedThisUser_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.unblockedThisUserStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.userBlockedMeStreamHandler == nil) {
            self.userBlockedMeStreamHandler = UserBlockedMeStreamHandler()
        }
        
        FlutterEventChannel(name: userBlockedMe_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.userBlockedMeStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        
        if (self.userCameOnlineStreamHandler == nil) {
            self.userCameOnlineStreamHandler = UserCameOnlineStreamHandler()
        }
        
        FlutterEventChannel(name: userCameOnline_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.userCameOnlineStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        
        if (self.userDeletedHisProfileStreamHandler == nil) {
            self.userDeletedHisProfileStreamHandler = UserDeletedHisProfileStreamHandler()
        }
        
        FlutterEventChannel(name: userDeletedHisProfile_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.userDeletedHisProfileStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.userProfileFetchedStreamHandler == nil) {
            self.userProfileFetchedStreamHandler = UserProfileFetchedStreamHandler()
        }
        
        FlutterEventChannel(name: userProfileFetched_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.userProfileFetchedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        
        if (self.userUnBlockedMeStreamHandler == nil) {
            self.userUnBlockedMeStreamHandler = UserUnBlockedMeStreamHandler()
        }
        
        FlutterEventChannel(name: userUnBlockedMe_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.userUnBlockedMeStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.userUpdatedHisProfileStreamHandler == nil) {
            self.userUpdatedHisProfileStreamHandler = UserUpdatedHisProfileStreamHandler()
        }
        
        FlutterEventChannel(name: userUpdatedHisProfile_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.userUpdatedHisProfileStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.usersIBlockedListFetchedStreamHandler == nil) {
            self.usersIBlockedListFetchedStreamHandler = UsersIBlockedListFetchedStreamHandler()
        }
        
        FlutterEventChannel(name: usersIBlockedListFetched_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.usersIBlockedListFetchedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        
        
        if (self.usersProfilesFetchedStreamHandler == nil) {
            self.usersProfilesFetchedStreamHandler = UsersProfilesFetchedStreamHandler()
        }
        
        FlutterEventChannel(name: userProfileFetched_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.usersProfilesFetchedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        
        
        if (self.usersWhoBlockedMeListFetchedStreamHandler == nil) {
            self.usersWhoBlockedMeListFetchedStreamHandler = UsersWhoBlockedMeListFetchedStreamHandler()
        }
        
        FlutterEventChannel(name: usersWhoBlockedMeListFetched_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.usersWhoBlockedMeListFetchedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        
        if (self.onConnectedStreamHandler == nil) {
            self.onConnectedStreamHandler = OnConnectedStreamHandler()
        }
        
        FlutterEventChannel(name: onConnected_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.onConnectedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.onDisconnectedStreamHandler == nil) {
            self.onDisconnectedStreamHandler = OnDisconnectedStreamHandler()
        }
        
        FlutterEventChannel(name: onDisconnected_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.onDisconnectedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.onConnectionNotAuthorizedStreamHandler == nil) {
            self.onConnectionNotAuthorizedStreamHandler = OnConnectionNotAuthorizedStreamHandler()
        }
        
        FlutterEventChannel(name: onConnectionNotAuthorized_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.onConnectionNotAuthorizedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        
        if (self.connectionFailedStreamHandler == nil) {
            self.connectionFailedStreamHandler = ConnectionFailedStreamHandler()
        }
        
        FlutterEventChannel(name: connectionFailed_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.connectionFailedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        
        if (self.connectionSuccessStreamHandler == nil) {
            self.connectionSuccessStreamHandler = ConnectionSuccessStreamHandler()
        }
        
        FlutterEventChannel(name: connectionSuccess_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.connectionSuccessStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.onMessageDeleteForEveryOneStreamHandler == nil) {
            self.onMessageDeleteForEveryOneStreamHandler = OnMessageDeleteForEveryOneStreamHandler()
        }
        
        FlutterEventChannel(name: onMessageDeleteForEveryOne_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.onMessageDeleteForEveryOneStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        
        if (self.onWebChatPasswordChangedStreamHandler == nil) {
            self.onWebChatPasswordChangedStreamHandler = OnWebChatPasswordChangedStreamHandler()
        }
        
        FlutterEventChannel(name: onWebChatPasswordChanged_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.onWebChatPasswordChangedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.onFailureStreamHandler == nil) {
            self.onFailureStreamHandler = OnFailureStreamHandler()
        }
        
        FlutterEventChannel(name: onFailure_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.onFailureStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.onProgressChangedStreamHandler == nil) {
            self.onProgressChangedStreamHandler = OnProgressChangedStreamHandler()
        }
        
        FlutterEventChannel(name: onProgressChanged_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.onProgressChangedStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        if (self.onSuccessStreamHandler == nil) {
            self.onSuccessStreamHandler = OnSuccessStreamHandler()
        }
        
        FlutterEventChannel(name: onSuccess_channel, binaryMessenger: registrar.messenger()).setStreamHandler(self.onSuccessStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
        
        
        if (self.onChatTypingStatusStreamHandler == nil) {
            self.onChatTypingStatusStreamHandler = OnChatTypingStatusStreamHandler()
        }
        
        FlutterEventChannel(name: onChatTypingStatus_channel, binaryMessenger: registrar.messenger()).setStreamHandler((self.onChatTypingStatusStreamHandler!))
        
        if (self.onsetTypingStatusStreamHandler == nil) {
            self.onsetTypingStatusStreamHandler = OnsetTypingStatusStreamHandler()
        }
        
        FlutterEventChannel(name: setTypingStatus_channel, binaryMessenger: registrar.messenger()).setStreamHandler((self.onsetTypingStatusStreamHandler!))
        
        if (self.onGroupTypingStatusStreamHandler == nil) {
            self.onGroupTypingStatusStreamHandler = OnGroupTypingStatusStreamHandler()
        }
        
        FlutterEventChannel(name: onGroupTypingStatus_channel, binaryMessenger: registrar.messenger()).setStreamHandler((self.onGroupTypingStatusStreamHandler!))
        
    }
    
    func initializeEventListeners(){
        ChatManager.shared.logoutDelegate = self
        FlyMessenger.shared.messageEventsDelegate = self
        ChatManager.shared.messageEventsDelegate = self
        GroupManager.shared.groupDelegate = self
        ChatManager.shared.connectionDelegate = self
        ChatManager.shared.adminBlockCurrentUserDelegate = self
        ChatManager.shared.typingStatusDelegate = self
        
        ContactManager.shared.profileDelegate = self
        ChatManager.shared.adminBlockDelegate = self
        ChatManager.shared.availableFeaturesDelegate = self
        BackupManager.shared.backupDelegate = self
        BackupManager.shared.restoreDelegate = self
    }
    
    func prepareMethodHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult){
        
        switch methodCall.method {
        case "init":
            FlySdkMethodCalls.buildChatSDK(call: methodCall)
            initializeEventListeners()
        case "syncContacts":
            FlySdkMethodCalls.syncContacts(call: methodCall,  result: result)
        case "contactSyncStateValue":
            FlySdkMethodCalls.contactSyncStateValue(call: methodCall,  result: result)
        case "contactSyncState":
            FlySdkMethodCalls.contactSyncState(call: methodCall,  result: result)
        case "revokeContactSync":
            FlySdkMethodCalls.revokeContactSync(call: methodCall,  result: result)
        case "getUsersWhoBlockedMe":
            FlySdkMethodCalls.getUsersWhoBlockedMe(call: methodCall,  result: result)
        case "getUnKnownUserProfiles":
            FlySdkMethodCalls.getUnKnownUserProfiles(call: methodCall,  result: result)
        case "getMyProfileStatus":
            FlySdkMethodCalls.getMyProfileStatus(call: methodCall,  result: result)
        case "getMyBusyStatus":
            FlySdkMethodCalls.getMyBusyStatus(call: methodCall,  result: result)
        case "setMyBusyStatus":
            FlySdkMethodCalls.setMyBusyStatus(call: methodCall,  result: result)
        case "enableDisableBusyStatus":
            FlySdkMethodCalls.enableDisableBusyStatus(call: methodCall,  result: result)
        case "getBusyStatusList":
            FlySdkMethodCalls.getBusyStatusList(call: methodCall,  result: result)
        case "deleteProfileStatus":
            FlySdkMethodCalls.deleteProfileStatus(call: methodCall,  result: result)
        case "deleteBusyStatus":
            FlySdkMethodCalls.deleteBusyStatus(call: methodCall,  result: result)
        case "enableDisableHideLastSeen":
            FlySdkMethodCalls.enableDisableHideLastSeen(call: methodCall,  result: result)
        case "isHideLastSeenEnabled":
            FlySdkMethodCalls.isHideLastSeenEnabled(call: methodCall,  result: result)
        case "deleteMessagesForMe":
            FlySdkMethodCalls.deleteMessagesForMe(call: methodCall,  result: result)
        case "deleteMessagesForEveryone":
            FlySdkMethodCalls.deleteMessagesForEveryone(call: methodCall,  result: result)
        case "markAsRead":
            FlySdkMethodCalls.markAsRead(call: methodCall,  result: result)
        case "deleteUnreadMessageSeparatorOfAConversation":
            FlySdkMethodCalls.deleteUnreadMessageSeparatorOfAConversation(call: methodCall,  result: result)
        case "getRecalledMessagesOfAConversation":
            FlySdkMethodCalls.getRecalledMessagesOfAConversation(call: methodCall,  result: result)
        case "uploadMedia":
            FlySdkMethodCalls.uploadMedia(call: methodCall,  result: result)
        case "getMessagesUsingIds":
            FlySdkMethodCalls.getMessagesUsingIds(call: methodCall,  result: result)
        case "updateMediaDownloadStatus":
            FlySdkMethodCalls.updateMediaDownloadStatus(call: methodCall,  result: result)
        case "updateMediaUploadStatus":
            FlySdkMethodCalls.updateMediaUploadStatus(call: methodCall,  result: result)
        case "cancelMediaUploadOrDownload":
            FlySdkMethodCalls.cancelMediaUploadOrDownload(call: methodCall,  result: result)
        case "setMediaEncryption":
            FlySdkMethodCalls.setMediaEncryption(call: methodCall,  result: result)
        case "deleteAllMessages":
            FlySdkMethodCalls.deleteAllMessages(call: methodCall,  result: result)
        case "getGroupJid":
            FlySdkMethodCalls.getGroupJid(call: methodCall,  result: result)
        case "getProfileDetails":
            FlySdkMethodCalls.getProfileDetails(call: methodCall,  result: result)
        case "getProfileStatusList":
            FlySdkMethodCalls.getProfileStatusList(call: methodCall,  result: result)
        case "insertDefaultStatus":
            FlySdkMethodCalls.insertDefaultStatus(call: methodCall,  result: result)
        case "getRingtoneName":
            FlySdkMethodCalls.getRingtoneName(call: methodCall,  result: result)
            
        case "setOnGoingChatUser":
            FlySdkMethodCalls.setOnGoingChatUser(call: methodCall,  result: result)
            
        case "markAsReadDeleteUnreadSeparator":
            FlySdkMethodCalls.markAsReadDeleteUnreadSeparator(call: methodCall,  result: result)
        case "getMessagesOfJid":
            FlySdkMethodCalls.getMessagesOfJid(call: methodCall,  result: result)
            
            
        case "updateRecentChatPinStatus":
            FlySdkMethodCalls.updateRecentChatPinStatus(call: methodCall,  result: result)
            
        case "deleteRecentChat":
            FlySdkMethodCalls.deleteRecentChat(call: methodCall,  result: result)
        case "recentChatPinnedCount":
            FlySdkMethodCalls.recentChatPinnedCount(call: methodCall,  result: result)
        case "getRecentChatList":
            FlySdkMethodCalls.getRecentChatList(call: methodCall,  result: result)
        case "getRecentChatListIncludingArchived":
            FlySdkMethodCalls.getRecentChatListIncludingArchived(call: methodCall,  result: result)
        case "getRecentChatOf":
            FlySdkMethodCalls.getRecentChatOf(call: methodCall,  result: result)
            
        case "register_user":
            FlySdkMethodCalls.registerUser(call: methodCall,  result: result)
        case "authtoken":
            FlySdkMethodCalls.refreshAndGetAuthToken(call: methodCall,  result: result)
        case "refreshAuthToken":
            FlySdkMethodCalls.refreshAndGetAuthToken(call: methodCall,  result: result)
        case "verifyToken":
            FlySdkMethodCalls.verifyToken(call: methodCall,  result: result)
        case "get_jid":
            FlySdkMethodCalls.getJid(call: methodCall,  result: result)
        case "send_text_msg":
            FlySdkMethodCalls.sendTextMessage(call: methodCall,  result: result)
        case "sendLocationMessage":
            FlySdkMethodCalls.sendLocationMessage(call: methodCall,  result: result)
        case "send_image_message":
            FlySdkMethodCalls.sendImageMessage(call: methodCall,  result: result)
        case "send_video_message":
            FlySdkMethodCalls.sendVideoMessage(call: methodCall,  result: result)
        case "sendContactMessage":
            FlySdkMethodCalls.sendContactMessage(call: methodCall,  result: result)
        case "sendDocumentMessage":
            FlySdkMethodCalls.sendDocumentMessage(call: methodCall,  result: result)
        case "sendAudioMessage":
            FlySdkMethodCalls.sendAudioMessage(call: methodCall,  result: result)
        case "get_user_list":
            FlySdkMethodCalls.getUserList(call: methodCall,  result: result)
        case "getRegisteredUsers":
            FlySdkMethodCalls.getRegisteredUsers(call: methodCall,  result: result)
            
        case "getUserProfile":
            FlySdkMethodCalls.getUserProfile(call: methodCall,  result: result)
        case "clear_chat":
            FlySdkMethodCalls.clearChat(call: methodCall,  result: result)
            
        case "updateMyProfile":
            FlySdkMethodCalls.updateMyProfile(call: methodCall,  result: result)
            
        case "media_endpoint":
            FlySdkMethodCalls.getMediaEndPoint(call: methodCall,  result: result)
            
        case "reportUserOrMessages":
            FlySdkMethodCalls.reportUserOrMessages(call: methodCall,  result: result)
        case "block_user":
            FlySdkMethodCalls.blockUser(call: methodCall,  result: result)
        case "un_block_user":
            FlySdkMethodCalls.unblockUser(call: methodCall,  result: result)
        case "createGroup":
            FlySdkMethodCalls.createGroup(call: methodCall,  result: result)
        case "getUserLastSeenTime":
            FlySdkMethodCalls.getUserLastSeenTime(call: methodCall,  result: result)
        case "getUsersIBlocked":
            FlySdkMethodCalls.getUsersIBlocked(call: methodCall,  result: result)
        case "setMyProfileStatus":
            FlySdkMethodCalls.setMyProfileStatus(call: methodCall,  result: result)
            //            case "sendData":
            //                let UserJid = Utility.getStringFromPreference(key: notificationUserJid)
            //                Utility.saveInPreference(key: notificationUserJid, value: "")
            //                result(UserJid)
        case "getMediaMessages":
            FlySdkMethodCalls.getMediaMessages(call: methodCall,  result: result)
        case "isMemberOfGroup":
            FlySdkMethodCalls.isMemberOfGroup(call: methodCall,  result: result)
        case "updateArchiveUnArchiveChat":
            FlySdkMethodCalls.updateArchiveUnArchiveChat(call: methodCall,  result: result)
        case "getArchivedChatList":
            FlySdkMethodCalls.getArchivedChatList(call: methodCall,  result: result)
        case "updateChatMuteStatus":
            FlySdkMethodCalls.updateChatMuteStatus(call: methodCall,  result: result)
        case "sendTypingStatus":
            FlySdkMethodCalls.sendTypingStatus(call: methodCall,  result: result)
        case "sendTypingGoneStatus":
            FlySdkMethodCalls.sendTypingGoneStatus(call: methodCall,  result: result)
        case "setNotificationSound":
            FlySdkMethodCalls.setNotificationSound(call: methodCall,  result: result)
        case "isBusyStatusEnabled":
            FlySdkMethodCalls.isBusyStatusEnabled(call: methodCall,  result: result)
        case "updateMyProfileImage":
            FlySdkMethodCalls.updateMyProfileImage(call: methodCall,  result: result)
        case "isUserUnArchived":
            FlySdkMethodCalls.isUserUnArchived(call: methodCall,  result: result)
        case "forwardMessagesToMultipleUsers":
            FlySdkMethodCalls.forwardMessagesToMultipleUsers(call: methodCall,  result: result)
        case "removeProfileImage":
            FlySdkMethodCalls.removeProfileImage(call: methodCall,  result: result)
        case "isArchivedSettingsEnabled":
            FlySdkMethodCalls.isArchivedSettingsEnabled(call: methodCall,  result: result)
        case "getGroupMembersList":
            FlySdkMethodCalls.getGroupMembersList(call: methodCall,  result: result)
        case "enableDisableArchivedSettings":
            FlySdkMethodCalls.enableDisableArchivedSettings(call: methodCall,  result: result)
        case "clearAllConversation":
            FlySdkMethodCalls.clearAllConversation(call: methodCall,  result: result)
        case "cancelNotifications":
            FlySdkMethodCalls.cancelNotifications(call: methodCall,  result: result)
        case "insertBusyStatus":
            FlySdkMethodCalls.insertBusyStatus(call: methodCall,  result: result)
        case "getDocsMessages":
            FlySdkMethodCalls.getDocsMessages(call: methodCall,  result: result)
        case "getLinkMessages":
            FlySdkMethodCalls.getLinkMessages(call: methodCall,  result: result)
        case "isAdmin":
            FlySdkMethodCalls.isAdmin(call: methodCall,  result: result)
        case "leaveFromGroup":
            FlySdkMethodCalls.leaveFromGroup(call: methodCall,  result: result)
        case "getMediaAutoDownload":
            FlySdkMethodCalls.getMediaAutoDownload(call: methodCall,  result: result)
        case "setMediaAutoDownload":
            FlySdkMethodCalls.setMediaAutoDownload(call: methodCall,  result: result)
        case "getMediaSetting":
            FlySdkMethodCalls.getMediaSetting(call: methodCall,  result: result)
        case "saveMediaSettings":
            FlySdkMethodCalls.saveMediaSettings(call: methodCall,  result: result)
        case "downloadMedia":
            FlySdkMethodCalls.downloadMedia(call: methodCall,  result: result)
        case "updateFavouriteStatus":
            FlySdkMethodCalls.updateFavouriteStatus(call: methodCall,  result: result)
        case "iOSFileExist":
            FlySdkMethodCalls.iOSFileExist(call: methodCall,  result: result)
        case "get_favourite_messages":
            FlySdkMethodCalls.getFavouriteMessages(call: methodCall,  result: result)
        case "getUnsentMessageOfAJid":
            FlySdkMethodCalls.getUnsentMessageOfAJid(call: methodCall,  result: result)
        case "saveUnsentMessage":
            FlySdkMethodCalls.saveUnsentMessage(call: methodCall,  result: result)
        case "deleteRecentChats":
            FlySdkMethodCalls.deleteRecentChats(call: methodCall,  result: result)
        case "getDefaultNotificationUri":
            FlySdkMethodCalls.getDefaultNotificationUri(call: methodCall,  result: result)
        case "logoutOfChatSDK":
            FlySdkMethodCalls.logoutOfChatSDK(call: methodCall,  result: result)
        case "getMessageOfId":
            FlySdkMethodCalls.getMessageOfId(call: methodCall,  result: result)
        case "insertNewProfileStatus":
            FlySdkMethodCalls.insertNewProfileStatus(call: methodCall,  result: result)
        case "IS_TRIAL_LICENSE":
            FlySdkMethodCalls.isTrailLicence(call: methodCall,  result: result)
        case "makeAdmin":
            FlySdkMethodCalls.makeAdmin(call: methodCall,  result: result)
        case "updateGroupName":
            FlySdkMethodCalls.updateGroupName(call: methodCall,  result: result)
        case "updateGroupProfileImage":
            FlySdkMethodCalls.updateGroupProfileImage(call: methodCall,  result: result)
        case "removeGroupProfileImage":
            FlySdkMethodCalls.removeGroupProfileImage(call: methodCall,  result: result)
        case "addUsersToGroup":
            FlySdkMethodCalls.addUsersToGroup(call: methodCall,  result: result)
        case "removeMemberFromGroup":
            FlySdkMethodCalls.removeMemberFromGroup(call: methodCall,  result: result)
        case "isMuted":
            FlySdkMethodCalls.isMuted(call: methodCall,  result: result)
        case "exportChatConversationToEmail":
            FlySdkMethodCalls.exportChatConversationToEmail(call: methodCall,  result: result)
        case "getAllGroups":
            FlySdkMethodCalls.getAllGroups(call: methodCall,  result: result)
        case "searchConversation":
            FlySdkMethodCalls.searchConversation(call: methodCall,  result: result)
        case "delete_account":
            FlySdkMethodCalls.deleteAccount(call: methodCall, result: result)
        case "getGroupMessageDeliveredToList":
            FlySdkMethodCalls.getGroupMessageDeliveredToList(call: methodCall, result: result)
        case "getGroupMessageReadByList":
            FlySdkMethodCalls.getGroupMessageReadByList(call: methodCall, result: result)
            
        default:
            result(FlutterMethodNotImplemented)
        }
        
    }
}

extension FlyChatPlugin : MessageEventsDelegate, ConnectionEventDelegate, LogoutDelegate, GroupEventsDelegate,AdminBlockCurrentUserDelegate, TypingStatusDelegate, ProfileEventsDelegate,AdminBlockDelegate,AvailableFeaturesDelegate, BackupEventDelegate, RestoreEventDelegate {
    
    public func clearAllConversationForSyncedDevice() {
        
    }
    
    
    public func onMessagesCleared(toJid: String, deleteType: String?) {
        
    }
    
    public func restoreProgressDidReceive(completedCount: Double, completedPercentage: String, completedSize: String) {
        
    }
    
    public func restoreDidFinish() {
        
    }
    
    public func restoreDidFailed(errorMessage: String) {
        
    }
    
    
    public func didUpdateAvailableFeatures(features: FlyCommon.AvailableFeaturesModel) {
        
    }
    
    public func backupProgressDidReceive(completedCount: String, completedSize: String) {
        
    }
    
    public func backupDidFinish(fileUrl: String) {
        
    }
    
    public func backupDidFailed(errorMessage: String) {
        
    }
    
    public func userCameOnline(for jid: String) {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(userCameOnlineStreamHandler?.userCameOnline != nil){
            userCameOnlineStreamHandler?.userCameOnline?(jsonString)
        }else{
            print("Chat Typing Stream Handler is Nil")
        }
        
    }
    
    public func userWentOffline(for jid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(userWentOfflineStreamHandler?.userWentOffline != nil){
            userWentOfflineStreamHandler?.userWentOffline?(jsonString)
        }else{
            print("userWentOffline Stream Handler is Nil")
        }
    }
    
    public func userProfileFetched(for jid: String, profileDetails: FlyCommon.ProfileDetails?) {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        jsonObject.setValue(profileDetails, forKey: "profileDetails")
        let jsonString = JSONSerializer.toJson(jsonObject)
        if(userProfileFetchedStreamHandler?.userProfileFetched != nil){
            userProfileFetchedStreamHandler?.userProfileFetched?(jsonString)
        }else{
            print("userProfileFetched Stream Handler is Nil")
        }
    }
    
    public func myProfileUpdated() {
        if(myProfileUpdatedStreamHandler?.myProfileUpdated != nil){
            myProfileUpdatedStreamHandler?.myProfileUpdated?(true)
        }else{
            print("myProfileUpdated Stream Handler is Nil")
        }
    }
    
    public func usersProfilesFetched() {
        if(usersProfilesFetchedStreamHandler?.usersProfilesFetched != nil){
            usersProfilesFetchedStreamHandler?.usersProfilesFetched?(true)
        }else{
            print("usersProfilesFetched Stream Handler is Nil")
        }
    }
    
    public func blockedThisUser(jid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(blockedThisUserStreamHandler?.blockedThisUser != nil){
            blockedThisUserStreamHandler?.blockedThisUser?(jsonString)
        }else{
            print("blockedThisUser Stream Handler is Nil")
        }
    }
    
    public func unblockedThisUser(jid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(unblockedThisUserStreamHandler?.unblockedThisUser != nil){
            unblockedThisUserStreamHandler?.unblockedThisUser?(jsonString)
        }else{
            print("unblockedThisUser Stream Handler is Nil")
        }
    }
    
    public  func usersIBlockedListFetched(jidList: [String]) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jidList, forKey: "jidlist")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(usersIBlockedListFetchedStreamHandler?.usersIBlockedListFetched != nil){
            usersIBlockedListFetchedStreamHandler?.usersIBlockedListFetched?(jsonString)
        }else{
            print("usersIBlockedListFetched Stream Handler is Nil")
        }
    }
    
    public func usersBlockedMeListFetched(jidList: [String]) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jidList, forKey: "jidlist")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(usersWhoBlockedMeListFetchedStreamHandler?.usersWhoBlockedMeListFetched != nil){
            usersWhoBlockedMeListFetchedStreamHandler?.usersWhoBlockedMeListFetched?(jsonString)
        }else{
            print("usersBlockedMeListFetched Stream Handler is Nil")
        }
    }
    
    public func userUpdatedTheirProfile(for jid: String, profileDetails: FlyCommon.ProfileDetails) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(userUpdatedHisProfileStreamHandler?.userUpdatedHisProfile != nil){
            userUpdatedHisProfileStreamHandler?.userUpdatedHisProfile?(jsonString)
        }else{
            print("userUpdatedTheirProfile Stream Handler is Nil")
        }
        
    }
    
    public func userBlockedMe(jid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(userBlockedMeStreamHandler?.userBlockedMe != nil){
            userBlockedMeStreamHandler?.userBlockedMe?(jsonString)
        }else{
            print("userBlockedMe Stream Handler is Nil")
        }
    }
    
    public func userUnBlockedMe(jid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(userUnBlockedMeStreamHandler?.userUnBlockedMe != nil){
            userUnBlockedMeStreamHandler?.userUnBlockedMe?(jsonString)
        }else{
            print("userUnBlockedMe Stream Handler is Nil")
        }
    }
    
    public func hideUserLastSeen() {
        
    }
    
    public func getUserLastSeen() {
        
    }
    
    public func userDeletedTheirProfile(for jid: String, profileDetails: FlyCommon.ProfileDetails) {
        print("userDeletedTheirProfile called jid --> \(jid)")
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(userDeletedHisProfileStreamHandler?.userDeletedHisProfile != nil){
            userDeletedHisProfileStreamHandler?.userDeletedHisProfile?(jsonString)
        }else{
            print("userDeletedTheirProfile Stream Handler is Nil")
        }
    }
    
    public func didBlockOrUnblockSelf(userJid: String, isBlocked: Bool) {
        
    }
    
    public func onChatTypingStatus(userJid: String, status: FlyCommon.TypingStatus) {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        
        
        jsonObject.setValue(userJid, forKey: "singleOrgroupJid")
        jsonObject.setValue(userJid, forKey: "userId")
        jsonObject.setValue(status == TypingStatus.composing ? "composing" : "Gone", forKey: "composing")
        
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        
        if(onsetTypingStatusStreamHandler?.onSetTyping != nil){
            onsetTypingStatusStreamHandler?.onSetTyping?(jsonString)
            
        }else{
            print("Chat Typing Stream Handler is Nil")
        }
        
    }
    
    public func onGroupTypingStatus(groupJid: String, groupUserJid: String, status: FlyCommon.TypingStatus) {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(groupJid, forKey: "singleOrgroupJid")
        jsonObject.setValue(groupUserJid, forKey: "userId")
        jsonObject.setValue(status == TypingStatus.composing ? "composing" : "Gone", forKey: "composing")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        
        if(onsetTypingStatusStreamHandler?.onSetTyping != nil){
            onsetTypingStatusStreamHandler?.onSetTyping?(jsonString)
        }else{
            print("Group Chat Typing Stream Handler is Nil")
        }
    }
    
    public func onMessageReceived(message: FlyCommon.ChatMessage, chatJid: String) {
        
        var messageReceivedJson = JSONSerializer.toJson(message)
        messageReceivedJson = messageReceivedJson.replacingOccurrences(of: "{\"some\":", with: "")
        messageReceivedJson = messageReceivedJson.replacingOccurrences(of: "}}", with: "}")
        
        if(messageReceivedStreamHandler?.onMessageReceived != nil){
            messageReceivedStreamHandler?.onMessageReceived?(messageReceivedJson)
            
        }else{
            print("Message Stream Handler is Nil")
        }
        
    }
    
    public func onMessageStatusUpdated(messageId: String, chatJid: String, status: FlyCommon.MessageStatus) {
        
        let chatMessage = ChatManager.getMessageOfId(messageId: messageId)
        
        if(chatMessage == nil){
            return
        }
        var chatMessageJson = JSONSerializer.toJson(chatMessage as Any)
        
        chatMessageJson = chatMessageJson.replacingOccurrences(of: "{\"some\":", with: "")
        chatMessageJson = chatMessageJson.replacingOccurrences(of: "}}", with: "}")
        print(chatMessageJson)
        
        if(messageStatusUpdatedStreamHandler?.onMessageStatusUpdated != nil){
            messageStatusUpdatedStreamHandler?.onMessageStatusUpdated?(chatMessageJson)
            
        }else{
            print("Message status Stream Handler is Nil")
        }
        
    }
    
    public func onMediaStatusUpdated(message : FlyCommon.ChatMessage) {
        var chatMediaJson = JSONSerializer.toJson(message as Any)
        chatMediaJson = chatMediaJson.replacingOccurrences(of: "{\"some\":", with: "")
        chatMediaJson = chatMediaJson.replacingOccurrences(of: "}}", with: "}")
        
        if(mediaStatusUpdatedStreamHandler?.onMediaStatusUpdated != nil){
            mediaStatusUpdatedStreamHandler?.onMediaStatusUpdated?(chatMediaJson)
        }else{
            print("chatMediaJson Stream Handler is Nil")
        }
    }
    
    public func onMediaStatusFailed(error: String, messageId: String) {
        
        let chatMessage = ChatManager.getMessageOfId(messageId: messageId)
        
        var chatMediaJson = JSONSerializer.toJson(chatMessage as Any)
        chatMediaJson = chatMediaJson.replacingOccurrences(of: "{\"some\":", with: "")
        chatMediaJson = chatMediaJson.replacingOccurrences(of: "}}", with: "}")
        
        if(mediaStatusUpdatedStreamHandler?.onMediaStatusUpdated != nil){
            mediaStatusUpdatedStreamHandler?.onMediaStatusUpdated?(chatMediaJson)
        }else{
            print("chatMediaJson Stream Handler is Nil")
        }
    }
    
    public func onMediaProgressChanged(message: FlyCommon.ChatMessage, progressPercentage: Float) {
        
        let progressPercentageString = String(format:"%.0f", progressPercentage)
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(message.messageId, forKey: "message_id")
        jsonObject.setValue(progressPercentageString, forKey: "progress_percentage")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        
        if(uploadDownloadProgressChangedStreamHandler?.onUploadDownloadProgressChanged != nil){
            uploadDownloadProgressChangedStreamHandler?.onUploadDownloadProgressChanged?(jsonString)
        }else{
            print("upload Download Progress Changed Stream Handler is Nil")
        }
        
    }
    
    public func onMessagesClearedOrDeleted(messageIds: Array<String>) {
        print("Message Cleared--->")
    }
    
    public func onMessagesDeletedforEveryone(messageIds: Array<String>) {
        
        messageIds.forEach { messageId in
            let chatMessage = ChatManager.getMessageOfId(messageId: messageId)
            
            if(chatMessage == nil){
                return
            }
            var chatMessageJson = JSONSerializer.toJson(chatMessage as Any)
            
            chatMessageJson = chatMessageJson.replacingOccurrences(of: "{\"some\":", with: "")
            chatMessageJson = chatMessageJson.replacingOccurrences(of: "}}", with: "}")
            
            if(messageStatusUpdatedStreamHandler?.onMessageStatusUpdated != nil){
                messageStatusUpdatedStreamHandler?.onMessageStatusUpdated?(chatMessageJson)
                
            }else{
                print("Message status Stream Handler is Nil")
            }
        }
        
    }
    
    public func showOrUpdateOrCancelNotification() {
        print("Message showOrUpdateOrCancelNotification--->")
        
    }
    
    public func onMessagesCleared(toJid: String) {
        print("Message onMessagesCleared--->")
    }
    
    public func setOrUpdateFavourite(messageId: String, favourite: Bool, removeAllFavourite: Bool) {
        print("Message setOrUpdateFavourite--->")
    }
    
    public func onMessageTranslated(message: FlyCommon.ChatMessage, jid: String) {
        print("Message onMessageTranslated--->")
    }
    
    public func didBlockOrUnblockCurrentUser(userJid: String, isBlocked: Bool) {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(userJid, forKey: "jid")
        jsonObject.setValue(isBlocked, forKey: "status")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(onAdminBlockedUserStreamHandler?.onAdminBlockedUser != nil){
            onAdminBlockedUserStreamHandler?.onAdminBlockedUser?(jsonString)
        }else{
            print("didBlockOrUnblockContact Stream Handler is Nil")
        }
        
    }
    
    public func didBlockOrUnblockGroup(groupJid: String, isBlocked: Bool) {
        
    }
    
    public func didBlockOrUnblockContact(userJid: String, isBlocked: Bool) {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(userJid, forKey: "jid")
        jsonObject.setValue("", forKey: "type")
        jsonObject.setValue(isBlocked, forKey: "status")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(onAdminBlockedOtherUserStreamHandler?.onAdminBlockedOtherUser != nil){
            onAdminBlockedOtherUserStreamHandler?.onAdminBlockedOtherUser?(jsonString)
        }else{
            print("didBlockOrUnblockContact Stream Handler is Nil")
        }
        
    }
    
    public func didAddNewMemeberToGroup(groupJid: String, newMemberJid: String, addedByMemberJid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(groupJid, forKey: "groupJid")
        jsonObject.setValue(newMemberJid, forKey: "newMemberJid")
        jsonObject.setValue(addedByMemberJid, forKey: "addedByMemberJid")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(newMemberAddedToGroupStreamHandler?.onNewMemberAddedToGroup != nil){
            newMemberAddedToGroupStreamHandler?.onNewMemberAddedToGroup?(jsonString)
        }else{
            print("didAddNewMemeberToGroup Stream Handler is Nil")
        }
    }
    
    public func didRemoveMemberFromGroup(groupJid: String, removedMemberJid: String, removedByMemberJid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(groupJid, forKey: "groupJid")
        jsonObject.setValue(removedMemberJid, forKey: "removedMemberJid")
        jsonObject.setValue(removedByMemberJid, forKey: "removedByMemberJid")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(memberRemovedFromGroupStreamHandler?.onMemberRemovedFromGroup != nil){
            memberRemovedFromGroupStreamHandler?.onMemberRemovedFromGroup?(jsonString)
        }else{
            print("didRemoveMemberFromGroup Stream Handler is Nil")
        }
        
    }
    
    public func didFetchGroupProfile(groupJid: String) {
        
        if(groupProfileFetchedStreamHandler?.onGroupProfileFetched != nil){
            groupProfileFetchedStreamHandler?.onGroupProfileFetched?(groupJid)
        }else{
            print("didFetchGroupProfile Stream Handler is Nil")
        }
        
    }
    
    public func didUpdateGroupProfile(groupJid: String) {
        
        if(groupProfileUpdatedStreamHandler?.onGroupProfileUpdated != nil){
            groupProfileUpdatedStreamHandler?.onGroupProfileUpdated?(groupJid)
        }else{
            print("didUpdateGroupProfile Stream Handler is Nil")
        }
        
    }
    
    public func didMakeMemberAsAdmin(groupJid: String, newAdminMemberJid: String, madeByMemberJid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(groupJid, forKey: "groupJid")
        jsonObject.setValue(newAdminMemberJid, forKey: "newAdminMemberJid")
        jsonObject.setValue(madeByMemberJid, forKey: "madeByMemberJid")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(memberMadeAsAdminStreamHandler?.onMemberMadeAsAdmin != nil){
            memberMadeAsAdminStreamHandler?.onMemberMadeAsAdmin?(jsonString)
        }else{
            print("didMakeMemberAsAdmin Stream Handler is Nil")
        }
        
    }
    
    public func didRemoveMemberFromAdmin(groupJid: String, removedAdminMemberJid: String, removedByMemberJid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(groupJid, forKey: "groupJid")
        jsonObject.setValue(removedAdminMemberJid, forKey: "removedAdminMemberJid")
        jsonObject.setValue(removedByMemberJid, forKey: "removedByMemberJid")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(memberRemovedAsAdminStreamHandler?.onMemberRemovedAsAdmin != nil){
            memberRemovedAsAdminStreamHandler?.onMemberRemovedAsAdmin?(jsonString)
        }else{
            print("didRemoveMemberFromAdmin Stream Handler is Nil")
        }
        
    }
    
    public func didDeleteGroupLocally(groupJid: String) {
        if(onGroupDeletedLocallyStreamHandler?.onGroupDeletedLocally != nil){
            onGroupDeletedLocallyStreamHandler?.onGroupDeletedLocally?(groupJid)
        }else{
            print("didDeleteGroupLocally Stream Handler is Nil")
        }
        
    }
    
    public func didLeftFromGroup(groupJid: String, leftUserJid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(groupJid, forKey: "groupJid")
        jsonObject.setValue(leftUserJid, forKey: "leftUserJid")
        let jsonString = JSONSerializer.toSimpleJson(from: jsonObject)
        if(leftFromGroupStreamHandler?.onLeftFromGroup != nil){
            leftFromGroupStreamHandler?.onLeftFromGroup?(jsonString)
        }else{
            print("didRemoveMemberFromAdmin Stream Handler is Nil")
        }
    }
    
    public func didCreateGroup(groupJid: String) {
        if(newGroupCreatedStreamHandler?.onNewGroupCreated != nil){
            newGroupCreatedStreamHandler?.onNewGroupCreated?(groupJid)
        }else{
            print("didCreateGroup Stream Handler is Nil")
        }
    }
    
    public func didFetchGroups(groups: [FlyCommon.ProfileDetails]) {
        
    }
    
    public func didFetchGroupMembers(groupJid: String) {
        if(fetchingGroupMembersCompletedStreamHandler?.onFetchingGroupMembersCompleted != nil){
            fetchingGroupMembersCompletedStreamHandler?.onFetchingGroupMembersCompleted?(groupJid)
        }else{
            print("didFetchGroupMembers Stream Handler is Nil")
        }
    }
    
    public func didReceiveGroupNotificationMessage(message: FlyCommon.ChatMessage) {
        
        var groupNotificationJson = JSONSerializer.toJson(message)
        groupNotificationJson = groupNotificationJson.replacingOccurrences(of: "{\"some\":", with: "")
        groupNotificationJson = groupNotificationJson.replacingOccurrences(of: "}}", with: "}")
        
        if(onGroupNotificationMessageStreamHandler?.onGroupNotificationMessage != nil){
            onGroupNotificationMessageStreamHandler?.onGroupNotificationMessage?(groupNotificationJson)
        }else{
            print("on group notification Stream Handler is Nil")
        }
        
    }
    
    public func didReceiveLogout() {
        
        if(onLoggedOutStreamHandler?.onLoggedOut != nil){
            onLoggedOutStreamHandler?.onLoggedOut?(true)
        }else{
            print("logout Stream Handler is Nil")
        }
    }
    
    public func onConnected() {
        if(onConnectedStreamHandler?.onConnected != nil){
            onConnectedStreamHandler?.onConnected?(true)
        }else{
            print("onConnected Stream Handler is Nil")
        }
    }
    
    public func onDisconnected() {
        if(onDisconnectedStreamHandler?.onDisconnected != nil){
            onDisconnectedStreamHandler?.onDisconnected?(true)
        }else{
            print("onDisconnected Stream Handler is Nil")
        }
    }
    
    public func onConnectionNotAuthorized() {
        if(onConnectionNotAuthorizedStreamHandler?.onConnectionNotAuthorized != nil){
            onConnectionNotAuthorizedStreamHandler?.onConnectionNotAuthorized?(true)
        }else{
            print("onConnectionNotAuthorized Stream Handler is Nil")
        }
    }
}
