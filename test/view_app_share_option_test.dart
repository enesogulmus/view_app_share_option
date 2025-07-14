import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:view_app_share_option/view_app_share_option_platform_interface.dart';
import 'package:view_app_share_option/view_app_share_option_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockViewAppShareOptionPlatform
    with MockPlatformInterfaceMixin
    implements ViewAppShareOptionPlatform {
  final StreamController<String> _fileSharedController = StreamController<String>.broadcast();

  /// Mock implementation: emits file paths when shared.
  @override
  Stream<String> get onFileShared => _fileSharedController.stream;

  @override
  Future<String?> getSharedFile() async => '/tmp/shared/file.pdf';

  // Helper to add events to the stream in tests.
  void emitSharedFile(String filePath) {
    _fileSharedController.add(filePath);
  }

  void dispose() {
    _fileSharedController.close();
  }
}

void main() {
  final ViewAppShareOptionPlatform initialPlatform = ViewAppShareOptionPlatform.instance;

  test('$MethodChannelViewAppShareOption is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelViewAppShareOption>());
  });

  test('getSharedFile', () async {
    final fakePlatform = MockViewAppShareOptionPlatform();
    ViewAppShareOptionPlatform.instance = fakePlatform;

    final path = await ViewAppShareOptionPlatform.instance.getSharedFile();
    expect(path, '/tmp/shared/file.pdf');
    fakePlatform.dispose();
  });

  test('onFileShared stream emits events', () async {
    final fakePlatform = MockViewAppShareOptionPlatform();
    ViewAppShareOptionPlatform.instance = fakePlatform;

    final events = <void>[];
    final sub = ViewAppShareOptionPlatform.instance.onFileShared.listen(events.add);

    fakePlatform.emitSharedFile('/tmp/shared/foo.txt');
    fakePlatform.emitSharedFile('/tmp/shared/bar.txt');

    // Wait for events to propagate.
    await Future.delayed(Duration(milliseconds: 10));

    expect(events, ['/tmp/shared/foo.txt', '/tmp/shared/bar.txt']);
    await sub.cancel();
    fakePlatform.dispose();
  });
}