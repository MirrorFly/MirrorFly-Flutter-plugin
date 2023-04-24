import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mirrorfly_plugin/builder.dart';
import 'package:mirrorfly_plugin/fly_chat_method_channel.dart';

void main() {
  MethodChannelFlyChatFlutter platform = MethodChannelFlyChatFlutter();
  const MethodChannel channel = MethodChannel('contus.mirrorfly/flyChat');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('init', () async {
    await platform.init(ChatBuilder(domainBaseUrl: 'domainBaseUrl', licenseKey: 'licenseKey', iOSContainerID: ''));
  });
}
