import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:fly_chat/fly_chat.dart';
import 'package:fly_chat_example/app/data/session_management.dart';
import 'package:fly_chat_example/app/routes/app_pages.dart';
import 'package:get/get.dart';
// import 'package:notification_incoming_call/notification_incoming_call.dart';
import 'package:uuid/uuid.dart';
import '../common/constants.dart';
import 'package:flutter/material.dart';

class PushNotifications {
  PushNotifications._();
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const uuid = Uuid();
  static dynamic currentUuid;
  static var textEvents = "";
  static void init(){
    notificationPermission();
    getToken();
    initInfo();
    FirebaseMessaging.onMessage.listen(onMessage);
    //showNotification(RemoteMessage());
    //listenerEvent();
  }
  static void getToken(){
    FirebaseMessaging.instance.getToken().then((value) {
      if(value!=null) {
        mirrorFlyLog("firebase_token", value);
        SessionManagement.setToken(value);
        FlyChat.updateFcmToken(value);
      }
    }).catchError((er){
      mirrorFlyLog("FirebaseMessaging", er.toString());
    });
  }
  static void initInfo(){
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialize = const DarwinInitializationSettings();
    var initalizationSettings = InitializationSettings(android: androidInitialize,iOS: iosInitialize);
    flutterLocalNotificationsPlugin.initialize(initalizationSettings,onDidReceiveNotificationResponse: (NotificationResponse response){
      mirrorFlyLog("notificationresposne", response.payload.toString());
      try {
        if (response.payload != null && response.payload!.isNotEmpty) {
          //on notification click
        }
      }catch(e){
        mirrorFlyLog("error", e.toString());
        return;
      }
    });
  }
  // It is assumed that all messages contain a data field with the key 'type'
  static Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      debugPrint("initialmessage : ${initialMessage.data}");
      // Get.toNamed(AppPages.call);
      //onMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((message){
      debugPrint("onMessageOpenedApp: $message");
      // Get.toNamed(AppPages.call);
    });
  }

  static Future<void> onMessage(RemoteMessage message) async {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      debugPrint('Message also contained a notification: ${message.notification}');
    }
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    // if (notification != null) {
    showNotification(message);
    /*var channel = AndroidNotificationChannel("id", "name",description: "");
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription : channel.description,
              icon: android.smallIcon,
              // other properties...
            ),
          ));*/
    // }
  }

  static void notificationPermission() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings currentsettings = await messaging.getNotificationSettings();
    var permission = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
    debugPrint("permission :"+permission.toString());
  }

  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page

  }

  static void showNotification(RemoteMessage remoteMessage) async {
    /*var data = {};
    data["message_id"]="40e6e723-b4fc-469f-a072-0afe1d797a47";
    data["message_time"]="1669639607745126";
    data["to_jid"]="9638527410@xmpp-uikit-dev.contus.us";
    data["user_jid"]="919894940560@xmpp-uikit-dev.contus.us";
    data["message_content"]="Text";
    data["push_from"]="MirrorFly";
    data["type"]="text";
    data["title"]="Text";
    data["sent_from"]="919894940560@xmpp-uikit-dev.contus.us";
    data["chat_type"]="chat";
    var notificationData = data;*/
    var notificationData = remoteMessage.data;
    debugPrint("data ${remoteMessage.data}");
    //notificationData['click_action']='FLUTTER_NOTIFICATION_CLICK';
    if(notificationData.isNotEmpty) {
      //makeFakeCallInComing();
      FlyChat.handleReceivedMessage(notificationData).then((value) async {
        mirrorFlyLog("notification message", value.toString());
        var data = json.decode(value.toString());
        var groupJid = data["groupJid"].toString();
        var titleContent = data["titleContent"].toString();
        var chatMessage = data["chatMessage"].toString();
        var cancel = data["cancel"].toString();
        var message = chatMessage;//remoteMessage.notification;
        if(message!=null) {
          var channel = AndroidNotificationChannel("id", "name", description: "");
          var bigtextstyleinfo = BigTextStyleInformation(
              chatMessage.toString(), htmlFormatBigText: true,
              contentTitle: titleContent,
              htmlFormatContentTitle: true);
          var androidnotificationdetails = AndroidNotificationDetails(
              channel.id, channel.name, channelDescription: channel.description,
              importance: Importance.high,
              styleInformation: bigtextstyleinfo,
              priority: Priority.high,
              playSound: true);
          var notificationDetails = NotificationDetails(
              android: androidnotificationdetails,
              iOS: const DarwinNotificationDetails());
          await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
              ?.createNotificationChannel(
              channel);
          await flutterLocalNotificationsPlugin.show(
              0, titleContent, chatMessage, notificationDetails,
              payload: "chatpage");
        }
      });
    }
  }

  /*static Future<void> makeFakeCallInComing() async {
    //await Future.delayed(const Duration(seconds: 7), () async {
      currentUuid = uuid.v4();
      var params = <String, dynamic>{
        'id': currentUuid,
        'nameCaller': 'Hien Nguyen',
        'appName': 'Callkit',
        'avatar': 'https://i.pravatar.cc/100',
        'handle': '0123456789',
        'type': 0,
        'duration': 30000,
        'extra': <String, dynamic>{'userId': '1a2b3c4d'},
        'headers': <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
        'android': <String, dynamic>{
          'isCustomNotification': true,
          'isShowLogo': false,
          // 'ringtonePath': 'ringtone_default',
          'backgroundColor': '#0955fa',
          'background': 'https://i.pravatar.cc/500',
          'actionColor': '#4CAF50'
        },
        'ios': <String, dynamic>{
          'iconName': 'AppIcon40x40',
          'handleType': '',
          'supportsVideo': true,
          'maximumCallGroups': 2,
          'maximumCallsPerCallGroup': 1,
          'audioSessionMode': 'default',
          'audioSessionActive': true,
          'audioSessionPreferredSampleRate': 44100.0,
          'audioSessionPreferredIOBufferDuration': 0.005,
          'supportsDTMF': true,
          'supportsHolding': true,
          'supportsGrouping': false,
          'supportsUngrouping': false,
          'ringtonePath': 'Ringtone.caf'
        }
      };
      await NotificationIncomingCall.showCallkitIncoming(params);
      listenerEvent();
    //});
  }

  Future<void> endCurrentCall() async {
    var params = <String, dynamic>{'id': currentUuid};
    await NotificationIncomingCall.endCall(params);
  }*/

  /*Future<void> startOutGoingCall() async {
    currentUuid = uuid.v4();
    var params = <String, dynamic>{
      'id': currentUuid,
      'nameCaller': 'Hien Nguyen',
      'handle': '0123456789',
      'type': 1,
      'extra': <String, dynamic>{'userId': '1a2b3c4d'},
      'ios': <String, dynamic>{'handleType': 'number'}
    }; //number/email
    await NotificationIncomingCall.startCall(params);
  }*/

  /*Future<void> activeCalls() async {
    var calls = await NotificationIncomingCall.activeCalls();
    debugPrint(calls);
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  static Future<void> listenerEvent() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      NotificationIncomingCall.onEvent.listen((event) async {
        debugPrint("event : $event");
        //if (!mounted) return;
        switch (event!.name) {
          case CallEvent.ACTION_CALL_INCOMING:
          //  received an incoming call
            break;
          case CallEvent.ACTION_CALL_START:
          //  started an outgoing call
          //  show screen calling in Flutter
            break;
          *//*case CallEvent.ACTION_CONTENT_CLICK:
            SessionManagement.onInit().then((value) => SessionManagement.setCall(true));
          //  accepted an incoming call
          //  show screen calling in Flutter
            break;*//*
          case CallEvent.ACTION_CALL_ACCEPT:
            //SessionManagement.onInit().then((value) => SessionManagement.setCall(true));
            await FlutterOverlayWindow.showOverlay();
          //  accepted an incoming call
          //  show screen calling in Flutter
            break;
          case CallEvent.ACTION_CALL_DECLINE:
          //  declined an incoming call
            break;
          case CallEvent.ACTION_CALL_ENDED:
          //  ended an incoming/outgoing call
            break;
          case CallEvent.ACTION_CALL_TIMEOUT:
          //  missed an incoming call
            break;
          case CallEvent.ACTION_CALL_CALLBACK:
          //  only Android - click action `Call back` from missed call notification
            break;
          case CallEvent.ACTION_CALL_TOGGLE_HOLD:
          //  only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_MUTE:
          //  only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_DMTF:
          //  only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_GROUP:
          //  only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_AUDIO_SESSION:
          //  only iOS
            break;
        }
        //setState(() {
          textEvents += "${event.toString()}\n";
        //});
      });
    } on Exception {}
  }*/
}
// import 'dart:convert';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:fly_chat/flysdk.dart';
// import 'package:fly_chat_example/app/data/session_management.dart';
//
// import '../common/constants.dart';
//
// class PushNotifications {
//   PushNotifications._();
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   static void init(){
//     notificationPermission();
//     getToken();
//     initInfo();
//     FirebaseMessaging.onMessage.listen(onMessage);
//     //showNotification(RemoteMessage());
//   }
//   static void getToken(){
//     FirebaseMessaging.instance.getToken().then((value) {
//       if(value!=null) {
//         mirrorFlyLog("firebase_token", value);
//         SessionManagement.setToken(value);
//       }
//     }).catchError((er){
//       mirrorFlyLog("FirebaseMessaging error", er.toString());
//     });
//   }
//   static void initInfo(){
//     var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitialize = const DarwinInitializationSettings();
//
//     var initalizationSettings = InitializationSettings(android: androidInitialize,iOS: iosInitialize);
//     flutterLocalNotificationsPlugin.initialize(initalizationSettings,onDidReceiveNotificationResponse: (NotificationResponse response){
//       mirrorFlyLog("notification response", response.payload.toString());
//       try {
//         if (response.payload != null && response.payload!.isNotEmpty) {
//           //on notification click
//         }
//       }catch(e){
//         mirrorFlyLog("error", e.toString());
//         return;
//       }
//     });
//   }
//   // It is assumed that all messages contain a data field with the key 'type'
//   static Future<void> setupInteractedMessage() async {
//     // Get any messages which caused the application to open from
//     // a terminated state.
//     RemoteMessage? initialMessage =
//     await FirebaseMessaging.instance.getInitialMessage();
//
//     // If the message also contains a data property with a "type" of "chat",
//     // navigate to a chat screen
//     if (initialMessage != null) {
//       onMessage(initialMessage);
//     }
//
//     // Also handle any interaction when the app is in the background via a
//     // Stream listener
//     FirebaseMessaging.onMessageOpenedApp.listen(onMessage);
//   }
//
//   static Future<void> onMessage(RemoteMessage message) async {
//     debugPrint('Got a message whilst in the foreground!');
//     debugPrint('Message data: ${message.data}');
//
//     if (message.notification != null) {
//       debugPrint('Message also contained a notification: ${message.notification?.title}/${message.notification?.body}');
//     }
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//
//     // If `onMessage` is triggered with a notification, construct our own
//     // local notification to show to users using the created channel.
//     // if (notification != null) {
//       showNotification(message);
//       /*var channel = AndroidNotificationChannel("id", "name",description: "");
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);
//       flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelDescription : channel.description,
//               icon: android.smallIcon,
//               // other properties...
//             ),
//           ));*/
//     // }
//   }
//
//   static void notificationPermission() async{
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     NotificationSettings currentsettings = await messaging.getNotificationSettings();
//    var permission = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       debugPrint('User granted permission');
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       debugPrint('User granted provisional permission');
//     } else {
//       debugPrint('User declined or has not accepted permission');
//     }
//     debugPrint("permission :$permission");
//   }
//
//   static void onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) async {
//     // display a dialog with the notification details, tap ok to go to another page
//
//   }
//
//   static void showNotification(RemoteMessage remoteMessage) async {
//     /*var data = {};
//     data["message_id"]="40e6e723-b4fc-469f-a072-0afe1d797a47";
//     data["message_time"]="1669639607745126";
//     data["to_jid"]="9638527410@xmpp-uikit-dev.contus.us";
//     data["user_jid"]="919894940560@xmpp-uikit-dev.contus.us";
//     data["message_content"]="Text";
//     data["push_from"]="MirrorFly";
//     data["type"]="text";
//     data["title"]="Text";
//     data["sent_from"]="919894940560@xmpp-uikit-dev.contus.us";
//     data["chat_type"]="chat";
//     var notificationData = data;*/
//
//     var notificationData = remoteMessage.data;
//     if(notificationData.isNotEmpty) {
//       debugPrint('Calling Handle Message');
//       FlyChat.handleReceivedMessage(notificationData).then((value){
//         mirrorFlyLog("notification message", value.toString());
//         var data = json.decode(value.toString());
//         var groupJid = data["groupJid"].toString();
//         var titleContent = data["titleContent"].toString();
//         var chatMessage = data["chatMessage"].toString();
//         var cancel = data["cancel"].toString();
//       });
//       /*var message = remoteMessage.notification;
//       if(message!=null) {
//         var channel = AndroidNotificationChannel("id", "name", description: "");
//         var bigtextstyleinfo = BigTextStyleInformation(
//             message.body.toString(), htmlFormatBigText: true,
//             contentTitle: message.title,
//             htmlFormatContentTitle: true);
//         var androidnotificationdetails = AndroidNotificationDetails(
//             channel.id, channel.name, channelDescription: channel.description,
//             importance: Importance.high,
//             styleInformation: bigtextstyleinfo,
//             priority: Priority.high,
//             playSound: true);
//         var notificationDetails = NotificationDetails(
//             android: androidnotificationdetails,
//             iOS: const DarwinNotificationDetails());
//         await flutterLocalNotificationsPlugin
//             .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//             ?.createNotificationChannel(
//             channel);
//         await flutterLocalNotificationsPlugin.show(
//             0, message.title, message.body, notificationDetails,
//             payload: "chatpage");
//       }*/
//     }else{
//       debugPrint("Not Calling the SDK Notification method bcz data is empty");
//     }
//   }
// }
