import 'device_services_other.dart' if (dart.library.html) 'device_services_web.dart';

abstract class DeviceService {
  Future<String> getDeviceId();
}

DeviceService getDeviceService() {
  return DeviceServiceImpl();
}


/*
class DeviceInfoService {
  static Future<String> getDeviceIdentifier() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model ?? 'IOS';
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // You can use device_info_plus to get some form of identifier,
      // but it is not always unique, so you might want to combine it with other information
      var desktopInfo = await deviceInfo.deviceInfo;
      return '${desktopInfo.data['name']}_${desktopInfo.data['systemId']}';
    } else if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      return webBrowserInfo.userAgent ?? 'WEB';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
*/