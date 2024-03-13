# [Mirrofly](https://www.mirrorfly.com) Plugin for Flutter

[![Platform](https://img.shields.io/badge/platform-flutter-blue)](https://flutter.dev/)
[![Language](https://img.shields.io/badge/language-dart-blue)](https://dart.dev/)

## Table of contents

1. [Introduction](#Introduction)
2. [Requirements](#requirements)
3. [Sending your first message](#sending-your-first-message)
4. [Call_Feature](#call-feature)
5. [Getting help](#getting-help)

## Introduction

Make an easy and efficient way with CONTUS TECH Mirrorfly Plugin for Flutter - simply integrate the
real-time chat features and functionalities into a client's app.

## Requirements

The minimum requirements for Mirrorfly Plugin for Flutter are:

- Visual Studio Code or Android Studio
- Dart 2.19.1 or above
- Flutter 2.0.0 or higher

### Step 1: Let's integrate Plugin for Flutter

Our Mirrorfly Plugin lets you initialize and configure the chat easily. With the server-side, Our
solution ensures the most reliable infra-management services for the chat within the app.
Furthermore, we will let you know how to install the chat Plugin in your app for a better in-app
chat experience.

### Plugin License Key

Follow the below steps to get your license key:

1. Sign up into [MirrorFly Console page](https://console.mirrorfly.com/register) for free MirrorFly
   account, If you already have a MirrorFly account, sign into your account
2. Once you’re in! You get access to your MirrorFly account ‘Overview page’ where you can find a
   license key for further integration process
3. Copy the license key from the ‘Application info’ section

### Step 2: Install packages

Installing the Mirrorfly Plugin is a simple process. Follow the steps mentioned below.

### Android

- Add the following to your root `build.gradle` file in your Android folder.

```gradle
   allprojects {
    repositories {
        google()
        mavenCentral()
        jcenter()
        maven {
            url "https://repo.mirrorfly.com/release"
        }
    }
  }
```

### iOS

- Check and Add the following code at end of your `ios/Podfile`

```dart
post_install do |
installer|installer.pods_project.targets.each do |
target|flutter_additional_ios_build_settings
(
target)
target.build_configurations.each do |config|
config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.1'
config.build_settings['ENABLE_BITCODE'] = 'NO'
config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'No'
config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
end
end
end
```

- Now, enable the below mentioned capabilities into your project by opening `ios` folder
  using `Xcode`.

```dart
Goto Project
-
>
Target ->
Signing & Capabilities ->
Click `+
Capability`

at the

top left
corner ->
Search for `

App groups
`

and add
the `

App group
capability`
```

> **Note**: The App Group Must be same as `iOSContainerId` given during the SDK
> Initialization. [See Initialization Step 1](#Sending-your-first-message).


![Screenshot](https://www.mirrorfly.com/docs/assets/images/AppGroups-c9933d95df192665e1389f19ece4fd94.png)

### Flutter

- Add following dependency in `pubspec.yaml`.

```yaml
dependencies:
  mirrorfly_plugin: ^1.0.0
```

- Run `flutter pub get` command in your project directory.

### Step 3: Use the Mirrorfly Plugin in your App

You can use all classes and methods just with the one import statement as shown below.

```dart
import 'package:mirrorfly_plugin/mirrorfly.dart';
```

## Sending your first message

Follow the step-by-step instructions below to authenticate and send your first message.

### Authentication

In order to use the features of Mirrorfly Plugin for Flutter, you should initiate
the `MirrorflyPlugin` instance through user authentication with Mirrorfly server. This instance
communicates and interacts with the server based on an authenticated user account, allowing the
client app to use the Mirrorfly Plugin's features.

Here are the steps to sending your first message using the Mirrorfly Plugin:

### Step 1: Initialize the Mirrorfly Plugin

To initialize the plugin, place the below code in your `main.dart` file inside `main` function
before `runApp()`.

```dart
 void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Mirrorfly.initializeSDK(
      licenseKey: 'your license key',
      iOSContainerID: 'your app group id',
      flyCallback: (FlyResponse response) {
        if (response.isSuccess) {
          LogMessage.d("onSuccess", response.message);
        } else {
          LogMessage.d("onFailure", response.exception?.message.toString());
        }
        runApp(const MyApp());
      });
}
```

### Step 2: Registration

Use the below method to register a user in sandbox Live mode.

> **Info** Unless you log out the session, make a note that should never call the registration
> method more than once in an application

> **Note**: While registration, the below `registerUser` method will accept the `FCM_TOKEN` as an
> optional param and pass it
>
across. `The connection will be established automatically upon completion of registration and not required for seperate login`
> .

```dart
Mirrorfly.registerUser
(
userIdentifier,flyCallback: (FlyResponse response) {
// you will get the user registration response
if (response.isSuccess && response.hasData) {
var userData = registerModelFromJson(response.data); //message

} else {
// Register user failed print throwable to find the exception details.
if (response.exception?.code == "403") {
//admin blocked the user
} else if (response.exception?.code == "405") {
//maximum device limit reached
}
}
});
```

> **Note**: After registering, make sure to update the profile of the registered
>
user [Update Profile](https://www.mirrorfly.com/docs/chat/flutter-plugin/profile-module/#update-user-profile)
> .

> **Note**: You need to re-login when
>
the [onLoggedOut](https://www.mirrorfly.com/docs/chat/flutter-plugin/callback-listeners/#logged-out)
> event is triggered.

> **Note**: It is recommended to disallow users to backup an app if it contains sensitive data.
> Having access to backup files (i.e. when `android:allowBackup="true"`), it is possible to
> modify/read the content of an app even on a non-rooted device.

> **Caution**: If FORCE_REGISTER is false and it reached the maximum no of multi-sessions then
> registration will not succeed it will throw a 405 exception, Either FORCE_REGISTER should be true
> or
> one of the existing session need to be logged out to continue registration.

## Send a One-to-One Message

Use the below method to send a text message to other user,

> **Note**: To generate a unique user jid by `username`, you must call the below method

## To get JID of User

```dart

var userJid = await
Mirrorfly.getJid
(
username
:
username
);
```

## To get Group JID

```dart

var groupJid = await
Mirrorfly.getGroupJid
(
groupId
:
groupID
);
```

```dart
Mirrorfly.sendMessage
(
messageParams: MessageParams.text(toJid: "",
replyMessageId: "",textMessageParams: TextMessageParams(messageText: "Hi")), flyCallback: (response){
if(response.isSuccess){
print('Message sent successfully');
} else {
print('Failed to send message: ${response.errorMessage}');
}
});
```

## Receive a One-to-One Message

Here the listeners would be called only when a new message is received from other user. To get more
details please visit
this [callback listeners](https://www.mirrorfly.com/docs/chat/flutter_plugin/callback-listeners)

```dart
Mirrorfly.onMessageReceived.listen
(
result){
// you will get the new messages
var chatMessage = sendMessageModelFromJson(result)
}
```

## Call Feature

> **Note**: To enable the Call Feature in iOS, need to enable VOIP as shown below.


![Screenshot](https://www.mirrorfly.com/docs/assets/images/capabilities-voip2-1760b4b8264b2f928df4d6fb5d933b62.png)

## To make a Video Call

```dart
Mirrorfly.makeVideoCall
(
toUserJid: userJID).then((isSuccess) {

});
```

## To make a Voice Call

```dart
Mirrorfly.makeVoiceCall
(
toUserJid: userJID).then((isSuccess) {

});
```

> **Note**: Provide Microphone and Camera permission and usage description in the iOS plist and
> Android Manifest file of your project.

## To make a Group Voice Call

```dart
Mirrorfly.makeGroupVoiceCall
(
groupJid: GROUP_ID, toUserJidList: USER_LIST).then((isSuccess) {

});
```

## To make a Group Video Call

```dart
Mirrorfly.makeGroupVideoCall
(
groupJid: GROUP_ID, toUserJidList: USER_LIST).then((isSuccess) {

});
```

### Try the sample app

The fastest way to test Mirrorfly Plugin for Flutter is to build your chat app on top of our sample
app. To create a project for the sample app, download the app from our GitHub repository. The link
is down below.

- https://github.com/MirrorFly/MirrorFly-Flutter-Sample

## Getting Help

Check out the Official
Mirrorfly [Flutter docs](https://www.mirrorfly.com/docs/chat/flutter_plugin/quick-start)

<br />