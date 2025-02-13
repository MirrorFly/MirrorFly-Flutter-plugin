//
//  FlyChatEvents.swift
//  mirrorfly_plugin
//
//  Created by user on 23/03/23.
//

import Foundation
import Flutter


/// Chat Event Stream Handlers
public class MessageReceivedStreamHandler: EventStreamHandler { }
public class MessageStatusUpdatedStreamHandler: EventStreamHandler { }
public class MediaStatusUpdatedStreamHandler: EventStreamHandler { }
public class UploadDownloadProgressChangedStreamHandler: EventStreamHandler { }
public class ShowOrUpdateOrCancelNotificationStreamHandler: EventStreamHandler { }
public class GroupProfileFetchedStreamHandler: EventStreamHandler { }
public class NewGroupCreatedStreamHandler: EventStreamHandler { }
public class GroupProfileUpdatedStreamHandler: EventStreamHandler { }
public class NewMemberAddedToGroupStreamHandler: EventStreamHandler { }
public class MemberRemovedFromGroupStreamHandler: EventStreamHandler { }
public class FetchingGroupMembersCompletedStreamHandler: EventStreamHandler { }
public class DeleteGroupStreamHandler: EventStreamHandler { }
public class FetchingGroupListCompletedStreamHandler: EventStreamHandler { }
public class MemberMadeAsAdminStreamHandler: EventStreamHandler { }
public class MemberRemovedAsAdminStreamHandler: EventStreamHandler { }
public class UserWentOfflineStreamHandler: EventStreamHandler { }

public class MessageEditedStreamHandler: EventStreamHandler { }

public class LeftFromGroupStreamHandler: EventStreamHandler { }
public class GroupNotificationMessageStreamHandler: EventStreamHandler { }
public class GroupDeletedLocallyStreamHandler: EventStreamHandler { }
public class BlockedThisUserStreamHandler: EventStreamHandler { }
public class MyProfileUpdatedStreamHandler: EventStreamHandler { }
public class OnAdminBlockedOtherUserStreamHandler: EventStreamHandler { }
public class OnAdminBlockedUserStreamHandler: EventStreamHandler { }
public class OnContactSyncCompleteStreamHandler: EventStreamHandler { }
public class OnLoggedOutStreamHandler: EventStreamHandler { }
public class UnblockedThisUserStreamHandler: EventStreamHandler { }
public class UserBlockedMeStreamHandler: EventStreamHandler { }
public class UserCameOnlineStreamHandler: EventStreamHandler { }
public class UserDeletedHisProfileStreamHandler: EventStreamHandler { }
public class UserProfileFetchedStreamHandler: EventStreamHandler { }
public class UserUnBlockedMeStreamHandler: EventStreamHandler { }
public class UserUpdatedHisProfileStreamHandler: EventStreamHandler { }
public class UsersIBlockedListFetchedStreamHandler: EventStreamHandler { }
public class UsersProfilesFetchedStreamHandler: EventStreamHandler { }
public class UsersWhoBlockedMeListFetchedStreamHandler: EventStreamHandler { }
public class OnConnectedStreamHandler: EventStreamHandler { }
public class OnDisconnectedStreamHandler: EventStreamHandler { }
public class OnConnectionNotAuthorizedStreamHandler: EventStreamHandler { }
//public class ConnectionFailedStreamHandler: EventStreamHandler { }
//public class ConnectionSuccessStreamHandler: EventStreamHandler { }
//public class OnWebChatPasswordChangedStreamHandler: EventStreamHandler { }
//public class OnFailureStreamHandler: EventStreamHandler { }
public class OnProgressChangedStreamHandler: EventStreamHandler { }
public class OnSuccessStreamHandler: EventStreamHandler { }

public class OnMessageDeleteForEveryOneStreamHandler: EventStreamHandler { }

public class OnChatTypingStatusStreamHandler: EventStreamHandler { }
public class OnsetTypingStatusStreamHandler: EventStreamHandler { }
public class OnGroupTypingStatusStreamHandler: EventStreamHandler { }

public class OnConnectionFailedStreamHandler: EventStreamHandler { }

public class OnGetAvailableFeaturesStreamHandler: EventStreamHandler { }

public class OnBackupSuccessChannelStreamHandler: EventStreamHandler { }
public class OnBackupFailureChannelStreamHandler: EventStreamHandler { }
public class OnBackupProgressChangedChannelStreamHandler: EventStreamHandler { }
public class OnRestoreFailureChannelStreamHandler: EventStreamHandler { }
public class OnRestoreProgressChangedChannelStreamHandler: EventStreamHandler { }
public class OnRestoreSuccessChannelStreamHandler: EventStreamHandler { }

/// Call Event Stream Handlers
public class OnLocalVideoTrackAddedStreamHandler: EventStreamHandler { }
public class OnRemoteVideoTrackAddedStreamHandler: EventStreamHandler { }
public class OnTrackAddedStreamHandler: EventStreamHandler { }
public class OnCallStatusUpdatedStreamHandler: EventStreamHandler { }
public class OnCallActionStreamHandler: EventStreamHandler { }
public class OnMuteStatusUpdatedStreamHandler: EventStreamHandler { }
public class OnUserSpeakingStreamHandler: EventStreamHandler { }
public class OnUserStoppedSpeakingStreamHandler: EventStreamHandler { }
public class OnMissedCallStreamHandler: EventStreamHandler { }
public class OnCallLogUpdateStreamHandler: EventStreamHandler { }
public class OnCallLogDeletedStreamHandler: EventStreamHandler { }
public class ClearAllCallLogChannelStreamHandler: EventStreamHandler { }

/// Meet link
public class OnSubscribeSuccessChannelStreamHandler: EventStreamHandler { }
public class OnConnectedToSignalServerChannelStreamHandler: EventStreamHandler { }
public class OnErrorChannelStreamHandler: EventStreamHandler { }
public class OnUsersUpdatedChannelStreamHandler: EventStreamHandler { }
