import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mirrorfly_plugin/builder.dart';
import 'package:mirrorfly_plugin/fly_chat_method_channel.dart';
import 'package:mirrorfly_plugin/internal_models/available_features_model.dart';
import 'package:mirrorfly_plugin/internal_models/call_logs_model.dart';
import 'package:mirrorfly_plugin/internal_models/chat_messages_model.dart';
import 'package:mirrorfly_plugin/internal_models/message_delivered_status_model.dart';
import 'package:mirrorfly_plugin/internal_models/profile_detail_model.dart';
import 'package:mirrorfly_plugin/internal_models/user_profile_update.dart';
import 'package:mirrorfly_plugin/internal_models/recent_chat_model.dart';
import 'package:mirrorfly_plugin/internal_models/register_user_model.dart';
import 'package:mirrorfly_plugin/internal_models/get_user_profile_model.dart';

void main() {
  MethodChannelFlyChatFlutter platform = MethodChannelFlyChatFlutter();
  const MethodChannel channel = MethodChannel('contus.mirrorfly/flyChat');
  final List<MethodCall> log = <MethodCall>[];

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        log.add(methodCall);
        return '42';
      },
    );
  });

  tearDown(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('init', () async {
    await platform.init(ChatBuilder(
        domainBaseUrl: 'domainBaseUrl',
        licenseKey: 'licenseKey',
        iOSContainerID: ''));
  });
}
