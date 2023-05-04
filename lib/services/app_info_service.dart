import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {
  static PackageInfo? packageInfo;
  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  // initialization logic

  static initiateAppInfoService() async {
    final info = await PackageInfo.fromPlatform();
    packageInfo = info;
  }
}
