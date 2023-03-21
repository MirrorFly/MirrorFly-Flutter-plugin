import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fly_chat/fly_chat_method_channel.dart';

void main() {
  MethodChannelFlyChatFlutter platform = MethodChannelFlyChatFlutter();
  const MethodChannel channel = MethodChannel('contus.mirrorfly/sdkCall');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
