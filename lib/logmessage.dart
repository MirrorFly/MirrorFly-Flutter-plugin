import 'package:flutter/foundation.dart';

import 'fly_chat_method_channel.dart';

class LogMessage{
  static void i(String tag,dynamic message){
    if (MethodChannelFlyChatFlutter.enableDebugLog) {
      // print("MirrorFly : $tag ==> $msg");
      final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
      pattern
          .allMatches(message.toString())
          .forEach((match) => debugPrint("MirrorFly : $tag==> ${match.group(0)}"));
    }
  }
  static void d(String tag,dynamic message){
    if (MethodChannelFlyChatFlutter.enableDebugLog) {
      // print("MirrorFly : $tag ==> $msg");
      final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
      pattern
          .allMatches(message.toString())
          .forEach((match) => debugPrint("MirrorFly : $tag==> ${match.group(0)}"));
    }
  }

  static void e(String tag,dynamic message){
    if (MethodChannelFlyChatFlutter.enableDebugLog) {
      // print("MirrorFly : $tag ==> $msg");
      final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
      pattern
          .allMatches(message.toString())
          .forEach((match) => debugPrint("MirrorFly : $tag==> ${match.group(0)}"));
    }
  }

}