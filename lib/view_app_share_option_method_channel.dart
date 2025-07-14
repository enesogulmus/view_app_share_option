import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'view_app_share_option_platform_interface.dart';

/// An implementation of [ViewAppShareOptionPlatform] that uses method channels.
class MethodChannelViewAppShareOption extends ViewAppShareOptionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('view_app_share_option');

  StreamController<void>? _onFileSharedController;

  MethodChannelViewAppShareOption() {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'onFileShared') {
        _onFileSharedController?.add(null);
      }
    });
  }

  @override
  Stream<void> get onFileShared {
    _onFileSharedController ??= StreamController<void>.broadcast();
    return _onFileSharedController!.stream;
  }

  @override
  Future<String?> getSharedFile() async {
    final String? path = await methodChannel.invokeMethod<String>('getSharedFile');
    return path;
  }
}
