import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:view_app_share_option/view_app_share_option_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelViewAppShareOption platform = MethodChannelViewAppShareOption();
  const MethodChannel channel = MethodChannel('view_app_share_option');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'getSharedFile') {
          return '/tmp/shared/file.pdf';
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getSharedFile returns correct path', () async {
    final path = await platform.getSharedFile();
    expect(path, '/tmp/shared/file.pdf');
  });
}