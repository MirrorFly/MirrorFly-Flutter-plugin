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

### Customizable, Low-code Chat & Video Call Flutter Sample App For Android

MirrorFly Flutter Plugin is a robust tool designed for developers to integrate real-time communication features into mobile apps using Flutter, within 10 mins. It allows you to add over 1000+ messaging and calling functionalities, including in-app messaging, HD video calls, and voice calling, all customizable to fit your brand requirements.
The solution is well-known for its plug and play features, where you’ll need no coding experience to build the app. You’ll just pick and place the features and functionalities, saving a lot of time and effort. Plus, you can seamlessly incorporate your company logo, brand colors, and other elements into your Flutter chat app and give a branded look to your platform.

## ⚒️ Key Product Offerings

MirrorFly Flutter Chat Plugin allows you to add the following capabilities to your platform.

- 💬 [In-app Messaging](https://www.mirrorfly.com/chat-api-solution.php) - real-time chat features for private or group interactions
- 📹 [HD Video Calling](https://www.mirrorfly.com/video-call-solution.php) - High-definition video calling for face to face conversations
- 🔊 [HQ Voice Calling](https://www.mirrorfly.com/voice-call-solution.php) - Crystal-clear audio calling for voice calling experiences
- 📺 [Live Streaming](https://www.mirrorfly.com/live-streaming-sdk.php) - Broadcasting functionality to take content to millions of audience.

You can also add 1000+ real-time communication capabilities. Check out our other offerings [here](https://www.mirrorfly.com/chat-features.php).


## ☁️ Deployment Models - Self-hosted and Cloud

MirrorFly offers full freedom with the hosting options:

- **Self-hosted:** Host your Flutter client app on your own data centers, private cloud servers or third-party servers.
  [Check out our multi-tenant cloud hosting](https://www.mirrorfly.com/self-hosted-chat-solution.php)

- **Cloud:** Deploy your Flutter client platform on MirrorFly’s multi-tenant cloud servers.
  [Check out our multi-tenant cloud hosting](https://www.mirrorfly.com/multi-tenant-chat-for-saas.php)



## 📱 Mobile Client

MirrorFly offers a fully-built client SafeTalk that is available in:

<a href="https://play.google.com/store/apps/details?id=com.mirrorfly&hl=en"><img src="https://raw.githubusercontent.com/MirrorFly/MirrorFly-Flutter-Sample/master/GetItOnGooglePlay_Badge_Web_color_English.png" alt="playstore" width="140" height="auto"></a> &nbsp; [![appstore](https://raw.githubusercontent.com/MirrorFly/MirrorFly-Flutter-Sample/master/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg)](https://apps.apple.com/app/safetalk/id1442769177)

You can use this client as a messaging app, or customize, rebrand & white-label it as your chat client.



## 📺 Video Tutorial

If you’d like to learn the full integration steps as a video, [Watch here](https://www.mirrorfly.com/docs/chat/flutter-plugin/quick-start/)

## Steps To Build A Chat App With Flutter Plugin

### Prerequisites

#### The requirements for Android

- Android Lollipop 5.0 (API Level 21) or above
- Java 7 or higher
- Gradle 4.1.0 or higher
- targetSdkVersion,compileSdk 34 or above.

#### The minimum requirements for iOS

- iOS 13.0 or later

#### The minimum requirements for Mirrorfly Plugin for Flutter are:

- Dart 2.19.1 or above
- Flutter 2.0.0 or higher

## Getting Started

The first step in building a Flutter app with MirrorFly is to obtain a License Key. This key is necessary to authenticate the SDK with the server.

To get this License Key,

- [Contact our experts](https://www.mirrorfly.com/contact-sales.php)
- Get the solution and License Key

## Create Android dependency

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

## Create iOS dependency

- Check and Add the following code at end of your `ios/Podfile`

```
post_install do |installer|
  installer.aggregate_targets.each do |target|
           target.xcconfigs.each do |variant, xcconfig|
           xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
           IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
           end
       end

  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'No'
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = 'arm64'

      shell_script_path = "Pods/Target Support Files/#{target.name}/#{target.name}-frameworks.sh"
            if File::exist?(shell_script_path)
              shell_script_input_lines = File.readlines(shell_script_path)
              shell_script_output_lines = shell_script_input_lines.map { |line| line.sub("source=\"$(readlink \"${source}\")\"", "source=\"$(readlink -f \"${source}\")\"") }
              File.open(shell_script_path, 'w') do |f|
                shell_script_output_lines.each do |line|
                  f.write line
                end
              end
            end
     end
  end
end
```

- Now, enable the below mentioned capabilities into your project by opening `ios` folder
  using `Xcode`.

```
Goto Project -> Target -> Signing & Capabilities -> Click `+ Capability` at the top left corner -> Search for `App groups` and add the `App group capability`
```

> **Note**: The App Group Must be same as `iOSContainerId` given during the SDK Initialization. [See Initialization Step 1](#Sending-your-first-message).

![Screenshot](https://www.mirrorfly.com/docs/assets/images/AppGroups-c9933d95df192665e1389f19ece4fd94.png)

### Create Flutter dependency

- Add following dependency in `pubspec.yaml`.

```yaml
dependencies:
  mirrorfly_plugin: ^1.0.9
```

- Run `flutter pub get` command in your project directory. You can access all classes and methods with the following import statement:

```
import 'package:mirrorfly_plugin/mirrorfly.dart';
```

### Initialize the MirrorFly Plugin

To initialize the plugin, add the following code to your `main.dart` file inside the `main` function, before calling `runApp()`.

```
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Mirrorfly.initializeSDK(
      licenseKey: 'your license key',
      iOSContainerID: 'your app group id',
      chatHistoryEnable: false, // true to enable chat history, default is false
      enablePrivateStorage: false, // true to enable private storage, default is false
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

### Step 2: Login

Use the below method to login a user in sandbox Live mode.

```
Mirrorfly.login(userIdentifier,flyCallback: (FlyResponse response) {
    // you will get the user registration response
    if (response.isSuccess && response.hasData) {
        var userData = registerModelFromJson(response.data); //message

    } else {
      // Register user failed print throwable to find the exception details.
        if (response.exception?.code == "403") {
          //admin blocked the user
        } else if (response.exception?.code  == "405") {
          //maximum device limit reached
        }
    }
});
```

### Important Note

- **Login Method Usage**:  
  Do not call the `login` method more than once in the application unless you explicitly log out the session.

- **FCM Token (Optional)**:  
  During login, the `login` method can accept an optional `FCM_TOKEN` parameter and pass it across. The connection will be established automatically upon completing the login process. For new users, the `login` method will also handle registration.

- **Update Profile After Registration**:  
  After registering, make sure to update the profile of the registered user. Refer to the [Update Profile](https://www.mirrorfly.com/docs/chat/flutter-plugin/v1/user/set-update-user-profile-data/) documentation.

- **Re-login Requirement**:  
  Re-login is required if the [`onLoggedOut`](https://www.mirrorfly.com/docs/chat/flutter-plugin/v1/event_listeners/connection-event-listeners/#event-listener-for-logged-out-updates) event is triggered.

- **Backup Restrictions**:  
  If your app contains sensitive data, it is recommended to disallow app backups. When `android:allowBackup="true"`, it becomes possible to modify or read the app's content even on non-rooted devices.

- **Session Management Caution**:
  - If `FORCE_REGISTER` is set to `false` and the maximum number of multi-sessions has been reached, registration will fail with a 405 exception.
  - To proceed, you must either set `FORCE_REGISTER` to `true` or log out one of the existing sessions.

## Send a One-to-One Message

Use the below method to send a text message to other user,

> **Note**: To generate a unique user jid by `username`, you must call the below method

### To get JID of User

```
var userJid = await Mirrorfly.getJid(username: username);
```

### To get Group JID

```
var groupJid = await Mirrorfly.getGroupJid(groupId: groupID);
```

### To send a Message
```
Mirrorfly.sendMessage(messageParams: MessageParams.Text(toJid: "",
    replyMessageId: "",textMessageParams: TextMessageParams(messageText: "Hi")), flyCallback: (response){
    if(response.isSuccess){
        var chatMessage = sendMessageModelFromJson(response.data);
        print('Message sent successfully');
     } else {
       print('Failed to send message: ${response.errorMessage}');
     }
});
```

## Receive a One-to-One Message

The listeners will only be triggered when a new message is received from another user. For more details, please refer to the [callback listeners](https://www.mirrorfly.com/docs/chat/flutter-plugin/v1/event_listeners/message-event-listeners/)

```
Mirrorfly.onMessageReceived.listen(result){
    // you will get the new messages
    var chatMessage = sendMessageModelFromJson(result)
}
```

## Call Feature

> **Note**: To enable the Call Feature in iOS, need to enable VOIP as shown below.

![Screenshot](https://www.mirrorfly.com/docs/assets/images/capabilities-voip2-1760b4b8264b2f928df4d6fb5d933b62.png)

## To make a Video Call

```
Mirrorfly.makeVideoCall(toUserJid: userJID,flyCallBack: (FlyResponse response) {
    if (response.isSuccess) {

    } else {

    }
});
```

## To make a Voice Call

```
Mirrorfly.makeVoiceCall(toUserJid: userJID,flyCallBack: (FlyResponse response) {
    if (response.isSuccess) {

    } else {

    }
});
```

> **Note**: Provide Microphone and Camera permission and usage description in the iOS plist and Android Manifest file of your project.

## To make a Group Voice Call

```
Mirrorfly.makeGroupVoiceCall(groupJid: GROUP_ID, toUserJidList: USER_LIST,flyCallBack: (FlyResponse response) {
    if (response.isSuccess) {

    } else {

    }
});
```

## To make a Group Video Call

```
Mirrorfly.makeGroupVideoCall(groupJid: GROUP_ID, toUserJidList: USER_LIST,flyCallBack: (FlyResponse response) {
    if (response.isSuccess) {

    } else {

    }
});
```

### Try the sample app

The fastest way to test Mirrorfly Plugin for Flutter is to build your chat app on top of our sample app. To create a project for the sample app, download the app from our GitHub repository. The link is down below.

- https://github.com/MirrorFly/MirrorFly-Flutter-Sample

## 🤝Getting Help

If you need any further help with our Flutter Chat Plugin, check out our resources

- [Flutter API](https://www.mirrorfly.com/flutter-chat-sdk.php)
- [Flutter Tutorial](https://www.mirrorfly.com/tutorials/build-chat-app-using-flutter.php)
- [Flutter docs](https://www.mirrorfly.com/docs/chat/flutter-plugin/v1/quick-start/)
- [Developer Portal](https://www.mirrorfly.com/docs/)

If you need any help in resolving any issues or have questions, Drop a mail to [integration@contus.in](mailto:integration@contus.in).

## 📚 Learn More

- [Developer Documentation](https://www.mirrorfly.com/docs/)
- [Product Tutorials](https://www.mirrorfly.com/tutorials/)
- [Dart Documentation](https://pub.dev/packages/mirrorfly_plugin)
- [Pubdev Documentation](https://pub.dev/packages/mirrorfly_plugin)
- [Npmjs Documentation](https://www.npmjs.com/~contus)
- [On-premise Deployment](https://www.mirrorfly.com/on-premises-chat-server.php)
- [See who's using MirrorFly](https://www.mirrorfly.com/chat-use-cases.php)

## 🧑‍💻 Hire Experts

Need a tech team to develop your enterprise app in Flutter? [Hire experienced professionals](https://www.mirrorfly.com/hire-video-chat-developer.php) who will handle everything from concept to launch, delivering a high-quality app that’s expertly crafted and ready to go.

## ⏱️ Round-the-clock Support

If you need assistance with our solution, don’t hesitate to [reach out to our experts](https://www.mirrorfly.com/contact-sales.php), available 24/7 to help you.

## 💼 Become a Part of our amazing team

We're always on the lookout for talented developers, support specialists, and product managers. Visit our [careers page](https://www.contus.com/careers.php) to explore current opportunities.

## 🗞️ Get the Latest Updates

- [Blog](https://www.mirrorfly.com/blog/)
- [Facebook](https://www.facebook.com/MirrorFlyofficial/)
- [Twitter](https://twitter.com/mirrorflyteam)
- [LinkedIn](https://www.linkedin.com/showcase/mirrorfly-official/)
- [Youtube](https://www.youtube.com/@mirrorflyofficial)
- [Instagram](https://www.instagram.com/mirrorflyofficial/)
