//
//  Constants.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation

struct Constants {
    private static let domain = "contus.mirrorfly"
    /// Method Channels for Chats
    static let mirrorflyMethodChannel = "\(domain)/flyChat"
     
     /// Method Channels for Calls
    static let callMethodChannel = "\(domain)/flyCall"
    static let onLocalVideoTrackAddedChannel = "\(domain)/onLocalVideoTrackAdded"
    static let onRemoteVideoTrackAddedChannel = "\(domain)/onRemoteVideoTrackAdded"
    static let onTrackAddedChannel = "\(domain)/onTrackAdded"
    static let onCallStatusUpdateChannel = "\(domain)/onCallStatusUpdated"
    static let onCallActionChannel = "\(domain)/onCallAction"
    static let onMuteStatusUpdatedChannel = "\(domain)/onMuteStatusUpdated"
    static let onUserSpeakingChannel = "\(domain)/onUserSpeaking"
    static let onUserStoppedSpeakingChannel = "\(domain)/onUserStoppedSpeaking"
    static let onMissedCallChannel = "\(domain)/onMissedCall"
    static let oncallLogUpdateChannel = "\(domain)/onCallLog"
    static let oncallLogDeletedChannel = "\(domain)/onCallLogsDeleted"
    
    /// Method Channels for Chats
        static let onMessageReceivedChannel = "\(domain)/onMessageReceived"
        static let onMessageStatusUpdatedChannel = "\(domain)/onMessageStatusUpdated"
        static let onMediaStatusUpdatedChannel = "\(domain)/onMediaStatusUpdated"
        static let onUploadDownloadProgressChangedChannel = "\(domain)/onUploadDownloadProgressChanged"
        static let showUpdateCancelNotificationChannel = "\(domain)/showOrUpdateOrCancelNotification"

        static let onGroupProfileFetched_channel = "\(domain)/onGroupProfileFetched"
        static let onNewGroupCreated_channel = "\(domain)/onNewGroupCreated"
        static let onGroupProfileUpdated_channel = "\(domain)/onGroupProfileUpdated"
        static let onNewMemberAddedToGroup_channel = "\(domain)/onNewMemberAddedToGroup"
        static let onMemberRemovedFromGroup_channel = "\(domain)/onMemberRemovedFromGroup"
        static let onFetchingGroupMembersCompleted_channel = "\(domain)/onFetchingGroupMembersCompleted"
        static let onDeleteGroup_channel = "\(domain)/onDeleteGroup"
        static let onFetchingGroupListCompleted_channel = "\(domain)/onFetchingGroupListCompleted"
        static let onMemberMadeAsAdmin_channel = "\(domain)/onMemberMadeAsAdmin"
        static let onMemberRemovedAsAdmin_channel = "\(domain)/onMemberRemovedAsAdmin"
        static let onLeftFromGroup_channel = "\(domain)/onLeftFromGroup"
        static let onGroupNotificationMessage_channel = "\(domain)/onGroupNotificationMessage"
        static let onGroupDeletedLocally_channel = "\(domain)/onGroupDeletedLocally"

        static let blockedThisUser_channel = "\(domain)/blockedThisUser"
        static let myProfileUpdated_channel = "\(domain)/myProfileUpdated"
        static let onAdminBlockedOtherUser_channel = "\(domain)/onAdminBlockedOtherUser"
        static let onAdminBlockedUser_channel = "\(domain)/onAdminBlockedUser"
        static let onContactSyncComplete_channel = "\(domain)/onContactSyncComplete"
        static let onLoggedOut_channel = "\(domain)/onLoggedOut"
        static let unblockedThisUser_channel = "\(domain)/unblockedThisUser"
        static let userBlockedMe_channel = "\(domain)/userBlockedMe"
        static let userCameOnline_channel = "\(domain)/userCameOnline"
        static let userDeletedHisProfile_channel = "\(domain)/userDeletedHisProfile"
        static let userProfileFetched_channel = "\(domain)/userProfileFetched"
        static let userUnBlockedMe_channel = "\(domain)/userUnBlockedMe"
        static let userUpdatedHisProfile_channel = "\(domain)/userUpdatedHisProfile"
        static let userWentOffline_channel = "\(domain)/userWentOffline"
        static let usersIBlockedListFetched_channel = "\(domain)/usersIBlockedListFetched"
        static let usersProfilesFetched_channel = "\(domain)/usersProfilesFetched"
        static let usersWhoBlockedMeListFetched_channel = "\(domain)/usersWhoBlockedMeListFetched"
        static let onConnected_channel = "\(domain)/onConnected"
        static let onDisconnected_channel = "\(domain)/onDisconnected"
        static let onConnectionNotAuthorized_channel = "\(domain)/onConnectionNotAuthorized"
    //    static let connectionFailed_channel = "\(domain)/connectionFailed"
        static let connectionSuccess_channel = "\(domain)/connectionSuccess"
        static let onWebChatPasswordChanged_channel = "\(domain)/onWebChatPasswordChanged"
        static let setTypingStatus_channel = "\(domain)/setTypingStatus"
        static let onChatTypingStatus_channel = "\(domain)/onChatTypingStatus"
        static let onGroupTypingStatus_channel = "\(domain)/onGroupTypingStatus"
        static let onFailure_channel = "\(domain)/onFailure"
        static let onProgressChanged_channel = "\(domain)/onProgressChanged"
        static let onSuccess_channel = "\(domain)/onSuccess"
        static let onMessageDeleteForEveryOne_channel = "\(domain)/onMessageDeleteForEveryOne"
        static let onConnectionFailed_channel = "\(domain)/onConnectionFailed"

        static let getAvailableFeatures_channel = "\(domain)/onAvailableFeaturesUpdated"
        
    
    static let contactSyncEnable = "contactSyncEnable"
    
    static let voipToken = "voipToken"
    static let isLoggedIn = "isLoggedIn"
    static let isProfileSaved = "isProfileSaved"
    static let tag = "#MirrorFly"
    static let callTag = "#MirrorFlyCall"
    
    static let licenseKey = "licenseKey"
    static let containerID = "containerID"
    
    static let googleToken = "googleToken"
}
enum CallStatus : String {
    case calling = "Calling";
    case ringing = "Ringing";
    case attended = "Attended";
    case connecting = "Connecting";
    case connected = "Connected";
    case disconnected = "Disconnected"
    case reconnecting = "Reconnecting";
    case reconnected = "Reconnected";
    case tryagain = "Unavailable, Try again later"
    case onHold = "Call on Hold"
}

enum FlyMessageType : String {
    case TEXT = "TEXT";
    case IMAGE = "IMAGE";
    case AUDIO = "AUDIO";
    case AUDIO_RECORDED = "AUDIO_RECORDED";
    case VIDEO = "VIDEO";
    case CONTACT = "CONTACT";
    case DOCUMENT = "DOCUMENT";
    case LOCATION = "LOCATION";
    case NOTIFICATION = "NOTIFICATION";
    
    static func fromString(_ value: String) -> FlyMessageType? {
        return FlyMessageType(rawValue: value)
    }
}
