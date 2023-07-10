import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mirrorfly_plugin/builder.dart';
import 'package:mirrorfly_plugin/fly_chat_method_channel.dart';

void main() {
  MethodChannelFlyChatFlutter platform = MethodChannelFlyChatFlutter();
  const MethodChannel channel = MethodChannel('contus.mirrorfly/flyChat');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
          (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('init', () async {
    await platform.init(ChatBuilder(domainBaseUrl: 'domainBaseUrl', licenseKey: 'licenseKey', iOSContainerID: ''));
  });
}
