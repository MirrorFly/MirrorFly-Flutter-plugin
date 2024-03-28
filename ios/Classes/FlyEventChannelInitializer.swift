//
//  FlyEventChannelConstants.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 16/06/23.
//

import Foundation
import Flutter



class FlyEventChannelInitializer {
    static let callEventChannels: [(channelName: String, streamHandler: NSObjectProtocol & FlutterStreamHandler)] = [
        (channelName: Constants.onLocalVideoTrackAddedChannel, streamHandler: OnLocalVideoTrackAddedStreamHandler()),
        (channelName: Constants.onRemoteVideoTrackAddedChannel, streamHandler: OnRemoteVideoTrackAddedStreamHandler()),
        (channelName: Constants.onTrackAddedChannel, streamHandler: OnTrackAddedStreamHandler()),
        (channelName: Constants.onCallStatusUpdateChannel, streamHandler: OnCallStatusUpdatedStreamHandler()),
        (channelName: Constants.onCallActionChannel, streamHandler: OnCallActionStreamHandler()),
        (channelName: Constants.onMuteStatusUpdatedChannel, streamHandler: OnMuteStatusUpdatedStreamHandler()),
        (channelName: Constants.onUserSpeakingChannel, streamHandler: OnUserSpeakingStreamHandler()),
        (channelName: Constants.onUserStoppedSpeakingChannel, streamHandler: OnUserStoppedSpeakingStreamHandler()),
        (channelName: Constants.onMissedCallChannel, streamHandler: OnMissedCallStreamHandler()),
        (channelName: Constants.onCallLogUpdateChannel, streamHandler: OnCallLogUpdateStreamHandler()),
        (channelName: Constants.onCallLogDeletedChannel, streamHandler: OnCallLogDeletedStreamHandler()),
        (channelName: Constants.clearAllCallLogChannel, streamHandler: ClearAllCallLogChannelStreamHandler()),
    ]
    var sinkValues: [String: String] = [:]
    
    func initializeEventChannels(registrar: FlutterPluginRegistrar) {
        for (channelName, streamHandler) in FlyEventChannelInitializer.callEventChannels {
                let handler: (NSObjectProtocol & FlutterStreamHandler)? = streamHandler
            
                FlutterEventChannel(name: channelName, binaryMessenger: registrar.messenger()).setStreamHandler(handler)
            }
        }
    
    func updateSinkValue(forChannel channelName: String, value: Any?) {
        print("\(Constants.callTag) updateSinkValue \(channelName) value \(String(describing: value)) ---> end of update sink")
        guard let streamHandler = FlyEventChannelInitializer.callEventChannels.first(where: { $0.channelName == channelName })?.streamHandler else {
                print("#MirrorflyCall else condition")
               return
           }
           
           if let provider = streamHandler as? FlyEventSinkProvider {
               provider.setEventSinkValue(value)
           }
       }
}

protocol FlyEventSinkProvider {
    func setEventSinkValue(_ value: Any?)
}


class FlyChatEventChannelInitializer {
    
    static let chatEventChannels: [(channelName: String, streamHandler: NSObjectProtocol & FlutterStreamHandler)] = [
        (channelName: Constants.onContactSyncComplete_channel, streamHandler: OnContactSyncCompleteStreamHandler()),
        (channelName: Constants.getAvailableFeatures_channel, streamHandler: OnGetAvailableFeaturesStreamHandler()),
        (channelName: Constants.showUpdateCancelNotificationChannel, streamHandler: ShowOrUpdateOrCancelNotificationStreamHandler()),
        (channelName: Constants.onConnectionFailed_channel, streamHandler: OnConnectionFailedStreamHandler()),
        (channelName: Constants.userCameOnline_channel, streamHandler: UserCameOnlineStreamHandler()),
        (channelName: Constants.userWentOffline_channel, streamHandler: UserWentOfflineStreamHandler()),
        (channelName: Constants.userProfileFetched_channel, streamHandler: UserProfileFetchedStreamHandler()),
        (channelName: Constants.myProfileUpdated_channel, streamHandler: MyProfileUpdatedStreamHandler()),
        (channelName: Constants.usersProfilesFetched_channel, streamHandler: UsersProfilesFetchedStreamHandler()),
        (channelName: Constants.blockedThisUser_channel, streamHandler: BlockedThisUserStreamHandler()),
        (channelName: Constants.unblockedThisUser_channel, streamHandler: UnblockedThisUserStreamHandler()),
        (channelName: Constants.usersIBlockedListFetched_channel, streamHandler: UsersIBlockedListFetchedStreamHandler()),
        (channelName: Constants.usersWhoBlockedMeListFetched_channel, streamHandler: UsersWhoBlockedMeListFetchedStreamHandler()),
        (channelName: Constants.userUpdatedHisProfile_channel, streamHandler: UserUpdatedHisProfileStreamHandler()),
        (channelName: Constants.userBlockedMe_channel, streamHandler: UserBlockedMeStreamHandler()),
        (channelName: Constants.userUnBlockedMe_channel, streamHandler: UserUnBlockedMeStreamHandler()),
        (channelName: Constants.userDeletedHisProfile_channel, streamHandler: UserDeletedHisProfileStreamHandler()),
        (channelName: Constants.setTypingStatus_channel, streamHandler: OnsetTypingStatusStreamHandler()),
        (channelName: Constants.onMessageReceivedChannel, streamHandler: MessageReceivedStreamHandler()),
        (channelName: Constants.onMessageStatusUpdatedChannel, streamHandler: MessageStatusUpdatedStreamHandler()),
        (channelName: Constants.onMediaStatusUpdatedChannel, streamHandler: MediaStatusUpdatedStreamHandler()),
        (channelName: Constants.onUploadDownloadProgressChangedChannel, streamHandler: UploadDownloadProgressChangedStreamHandler()),
        (channelName: Constants.onAdminBlockedUser_channel, streamHandler: OnAdminBlockedUserStreamHandler()),
        (channelName: Constants.onAdminBlockedOtherUser_channel, streamHandler: OnAdminBlockedOtherUserStreamHandler()),
        (channelName: Constants.onNewMemberAddedToGroup_channel, streamHandler: NewMemberAddedToGroupStreamHandler()),
        (channelName: Constants.onMemberRemovedFromGroup_channel, streamHandler: MemberRemovedFromGroupStreamHandler()),
        (channelName: Constants.onGroupProfileFetched_channel, streamHandler: GroupProfileFetchedStreamHandler()),
        (channelName: Constants.onGroupProfileUpdated_channel, streamHandler: GroupProfileUpdatedStreamHandler()),
        (channelName: Constants.onMemberMadeAsAdmin_channel, streamHandler: MemberMadeAsAdminStreamHandler()),
        (channelName: Constants.onMemberRemovedAsAdmin_channel, streamHandler: MemberRemovedAsAdminStreamHandler()),
        (channelName: Constants.onGroupDeletedLocally_channel, streamHandler: GroupDeletedLocallyStreamHandler()),
        (channelName: Constants.onLeftFromGroup_channel, streamHandler: LeftFromGroupStreamHandler()),
        (channelName: Constants.onNewGroupCreated_channel, streamHandler: NewGroupCreatedStreamHandler()),
        (channelName: Constants.onFetchingGroupMembersCompleted_channel, streamHandler: FetchingGroupMembersCompletedStreamHandler()),
        (channelName: Constants.onGroupNotificationMessage_channel, streamHandler: GroupNotificationMessageStreamHandler()),
        (channelName: Constants.onLoggedOut_channel, streamHandler: OnLoggedOutStreamHandler()),
        (channelName: Constants.onConnected_channel, streamHandler: OnConnectedStreamHandler()),
        (channelName: Constants.onDisconnected_channel, streamHandler: OnDisconnectedStreamHandler()),
        (channelName: Constants.onConnectionNotAuthorized_channel, streamHandler: OnConnectionNotAuthorizedStreamHandler()),
        (channelName: Constants.onMessageEdited_channel, streamHandler: MessageEditedStreamHandler()),
    ]
    var sinkValues: [String: String] = [:]
    
    func initializeChatEventChannels(registrar: FlutterPluginRegistrar) {
        for (channelName, streamHandler) in FlyChatEventChannelInitializer.chatEventChannels {
                let handler: (NSObjectProtocol & FlutterStreamHandler)? = streamHandler
            
                FlutterEventChannel(name: channelName, binaryMessenger: registrar.messenger()).setStreamHandler(handler)
            }
        }
    
    func updateSinkValue(forChannel channelName: String, value: Any?) {
        print("\(Constants.tag) updateSinkValue \(channelName) value \(String(describing: value)) ---> end of update sink")
        guard let streamHandler = FlyChatEventChannelInitializer.chatEventChannels.first(where: { $0.channelName == channelName })?.streamHandler else {
                print("#Mirrorfly Chat else condition")
               return
           }
           
           if let provider = streamHandler as? FlyEventSinkProvider {
//               print("\(Constants.tag) updateSinkValue provider \(provider)")
               provider.setEventSinkValue(value)
           }
       }
}

