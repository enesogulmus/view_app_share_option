import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'view_app_share_option_method_channel.dart';

abstract class ViewAppShareOptionPlatform extends PlatformInterface {
  /// Constructs a ViewAppShareOptionPlatform.
  ViewAppShareOptionPlatform() : super(token: _token);

  static final Object _token = Object();

  static ViewAppShareOptionPlatform _instance = MethodChannelViewAppShareOption();

  /// The default instance of [ViewAppShareOptionPlatform] to use.
  ///
  /// Defaults to [MethodChannelViewAppShareOption].
  static ViewAppShareOptionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ViewAppShareOptionPlatform] when
  /// they register themselves.
  static set instance(ViewAppShareOptionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getSharedFile() {
    throw UnimplementedError('getSharedFile() has not been implemented.');
  }

  Stream<void> get onFileShared {
    throw UnimplementedError('onFileShared has not been implemented.');
  }
}
