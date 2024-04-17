## [1.0.1] DNS Resolver added

* added DNS Resolver for android smack issue

## [1.0.0] Chat History Feature

* Chat history feature is now available.
* Profile model class has been changed to ProfileDetails.
* FlyCallback has been incorporated for all method responses, ensuring that the output is in the
  form of a JSON-encoded string.
* Collective event listeners are now
  available.([Learn more](https://www.mirrorfly.com/docs/chat/flutter-plugin/v1/event_listeners/connection-event-listeners/#observing-the-connection-events-collectively))
* Some methods have been deprecated and will be removed in future releases. It is recommended to
  update your code accordingly, Please consider using the suggested
  alternatives([Learn more](https://www.mirrorfly.com/docs/chat/flutter-plugin/flutter-chat-change-log/))

## [0.0.13] Group Call Feature

* Group Call Feature is Available now
* You can Invite Participant during the call
* Optimisation in Plugin Initialisation
* Call Logs feature is Available now
* One to One Call Bug Fixes
* Plugin supports multi-device login.

## [0.0.12] One to One Call Feature

* Enable VOIP in iOS Capability Background Modes to get the VOIP token to register for Call Feature
  in iOS.
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
* add this line in your extension service MirrorFlyNotification().handleNotification(
  notificationRequest: request, contentHandler: contentHandler, containerID: "xxx", licenseKey: "
  xxxx")
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
