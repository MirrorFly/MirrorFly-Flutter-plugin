## [1.0.0] Chat History Feature
* Chat history feature is Available now
* Profile model class changed as ProfileDetails
* output response changed as json encoded String.
* FlyCallback added for following methods 
  1) initializeSDK, 
  2) registerUser,
  3) getRecentChatListHistory,
  4) getRecentChatListHistoryByTopic,
  5) loadMessages,loadNextMessages,
  6) loadPreviousMessages,
  7) getUserProfile,
  8) updateMyProfile,
  9) updateMyProfileImage,
  10) getUserList
  11) getRegisteredUsers
* Error codes added.

## [0.0.13] Group Call Feature
* Group Call Feature is Available now
* You can Invite Participant during the call
* Optimisation in Plugin Initialisation
* Call Logs feature is Available now
* One to One Call Bug Fixes
* Plugin supports multi-device login.

## [0.0.12] One to One Call Feature
* Enable VOIP in iOS Capability Background Modes to get the VOIP token to register for Call Feature in iOS.
* Enable FCM Notification for Call Feature in Android.
* iOS SDK Optimisation.

## [0.0.12-beta] Topic Based Chat
* create Topic to initiate topic based chat
* get topic details from using getTopics
* get Recent chat list using getRecentChatListHistoryByTopic
* get Messages by topic using initializeMessageList with topic ID

## [0.0.11] Push Notification
* handleReceivedMessage method added to get chat message from FCM Notification for Android Only
* for iOS Need to add Notification Extension Service
* add this line in your extension service MirrorFlyNotification().handleNotification(notificationRequest: request, contentHandler: contentHandler, containerID: "xxx", licenseKey: "xxxx")
* authToken Deprecated instead of use refreshAndGetAuthToken

## [0.0.10] Code Optimization
* Minified Enabled True Support Added
* Release Build Bug Fix
* Profile Update Supports External URL


## [0.0.10-beta] Chat History

* Chat History enable option
* get chats from server synced with local db
* get message from server synced with local db
* maven url changes for android
* Mirrorfly Android SDK updated to `7.6.2`

## [0.0.9-beta] Chat History

* Chat History enable option 
* get chats from server synced with local db
* get message from server synced with local db
* maven url changes for android
* Mirrorfly Android SDK updated to `7.6.2`

## [0.0.9] developer preview

* iTunes Publish Issue Fixed

## [0.0.8] developer preview

* Developer preview.

## [0.0.7] developer preview

* Developer preview.

## [0.0.6] developer preview

* Developer preview.

## [0.0.5] developer preview

* Developer preview.

## [0.0.4] developer preview

* Developer preview.

## [0.0.3] developer preview

* Developer preview.

## [0.0.2] developer preview

* Developer preview.
