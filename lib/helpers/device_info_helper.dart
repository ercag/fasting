import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoHelper {
  static Future<String?> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    switch (Platform.operatingSystem) {
      case "android":
        AndroidDeviceInfo android = await deviceInfo.androidInfo;
        return Future.value(android.androidId);
      case "ios":
        IosDeviceInfo ios = await deviceInfo.iosInfo;
        return ios.identifierForVendor;
      default:
    }
  }
}
