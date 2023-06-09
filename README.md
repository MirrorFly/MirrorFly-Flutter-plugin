# [Mirrofly](https://www.mirrorfly.com) Plugin for Flutter

[![Platform](https://img.shields.io/badge/platform-flutter-blue)](https://flutter.dev/)
[![Language](https://img.shields.io/badge/language-dart-blue)](https://dart.dev/)

## Table of contents

1. [Introduction](#Introduction)
1. [Requirements](#requirements)
1. [Sending your first message](#sending-your-first-message)
1. [Getting help](#getting-help)

## Introduction

Make an easy and efficient way with CONTUS TECH Mirrorfly Plugin for Flutter - simply integrate the real-time chat features and functionalities into a client's app.

## Requirements

The minimum requirements for Mirrorfly Plugin for Flutter are:

- Visual Studio Code or Android Studio
- Dart 2.19.1 or above
- Flutter 2.0.0 or higher

### Step 1: Let's integrate Plugin for Flutter

Our Mirrorfly Plugin lets you initialize and configure the chat easily. With the server-side, Our solution ensures the most reliable infra-management services for the chat within the app. Furthermore, we will let you know how to install the chat Plugin in your app for a better in-app chat experience.

### Plugin License Key
Follow the below steps to get your license key:

1. Sign up into [MirrorFly Console page](https://console.mirrorfly.com/register) for free MirrorFly account, If you already have a MirrorFly account, sign into your account
2. Once you’re in! You get access to your MirrorFly account ‘Overview page’ where you can find a license key for further integration process
3. Copy the license key from the ‘Application info’ section


### Step 2: Install packages

Installing the Mirrorfly Plugin is a simple process. Follow the steps mentioned below.

- Add the following to your root `build.gradle` file in your Android folder.

```gradle
   allprojects {
    repositories {
        google()
        mavenCentral()
        jcenter()
        maven {
            url "https://repo.mirrorfly.com/snapshot/"
        }
    }
  }
```
- Add the following dependencies in the `app/build.gradle` file.

```gradle
android {
   packagingOptions {
    exclude 'META-INF/AL2.0'
    exclude 'META-INF/DEPENDENCIES'
    exclude 'META-INF/LICENSE'
    exclude 'META-INF/LICENSE.txt'
    exclude 'META-INF/license.txt'
    exclude 'META-INF/NOTICE'
    exclude 'META-INF/NOTICE.txt'
    exclude 'META-INF/notice.txt'
    exclude 'META-INF/ASL2.0'
    exclude 'META-INF/LGPL2.1'
    exclude("META-INF/*.kotlin_module")
  }
}
```
- Add following dependency in `pubspec.yaml`.

```yaml
dependencies:
  mirrorfly_plugin: ^0.0.3
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

In order to use the features of Mirrorfly Plugin for Flutter, you should initiate the `MirrorflyPlugin` instance through user authentication with Mirrorfly server. This instance communicates and interacts with the server based on an authenticated user account, allowing the client app to use the Mirrorfly Plugin's features.

Here are the steps to sending your first message using the Mirrorfly Plugin:

### Step 1: Initialize the Mirrorfly Plugin

To initialize the plugin, place the below code in your `main.dart` file inside `main` function before `runApp()`.

```dart
 void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Mirrorfly.init(
      baseUrl: 'https://api-preprod-sandbox.mirrorfly.com/api/v1/',
      licenseKey: 'your license key',
      iOSContainerID: 'your app group id');
  runApp(const MyApp());
}
```

### Step 2: Registration

Use the below method to register a user in sandbox Live mode.

> **Info** Unless you log out the session, make a note that should never call the registration method more than once in an application

> **Note**: While registration, the below `registerUser` method will accept the `FCM_TOKEN` as an optional param and pass it across. `The connection will be established automatically upon completion of registration and not required for seperate login`.

```dart
Mirrorfly.registerUser(userIdentifier).then((value) {
  // you will get the user registration response
  var userData = registerModelFromJson(value);
}).catchError((error) {
  // Register user failed print throwable to find the exception details.
  debugPrint(error.message);
});
```
## Send a One-to-One Message

Use the below method to send a text message to other user,

> **Note**: To generate a unique user jid by `username`, you must call the below method

```dart
var userJid = await Mirrorfly.getJid(username);
```

```dart
Mirrorfly.sendTextMessage(message, jid).then((value) {
  // you will get the message sent success response
  var chatMessage = sendMessageModelFromJson(value);
});
```
## Receive a One-to-One Message

Here the listeners would be called only when a new message is received from other user. To get more details please visit this [callback listeners](https://www.mirrorfly.com/docs/chat/flutter_plugin/callback-listeners)

```dart
Mirrorfly.onMessageReceived.listen(result){
  // you will get the new messages
  var chatMessage = sendMessageModelFromJson(result)
}
```

### Try the sample app

The fastest way to test Mirrorfly Plugin for Flutter is to build your chat app on top of our sample app. To create a project for the sample app, download the app from our GitHub repository. The link is down below.

- https://github.com/MirrorFly/MirrorFly-Flutter-Sample

## Getting Help

Check out the Official Mirrorfly [Flutter docs](https://www.mirrorfly.com/docs/chat/flutter_plugin/quick-start)

<br />
