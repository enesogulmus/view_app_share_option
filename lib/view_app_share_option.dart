import 'view_app_share_option_platform_interface.dart';

class ViewAppShareOption {
  static final ViewAppShareOption _instance = ViewAppShareOption._internal();
  factory ViewAppShareOption() => _instance;
  ViewAppShareOption._internal();

  Future<String?> getSharedFile() {
    return ViewAppShareOptionPlatform.instance.getSharedFile();
  }

  Stream<void> get onFileShared {
    return ViewAppShareOptionPlatform.instance.onFileShared;
  }
}
