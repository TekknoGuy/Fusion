import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'device_service.dart';

class DeviceServiceImpl implements DeviceService {
  static const _uuid = Uuid();

  @override
  Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');

    if (deviceId == null) {
      // deviceId = _uuid.v4();
      // toDo: -- THIS IS JUST FOR DEVELOPMENT --
      deviceId = "b881022f-7b33-41a3-bb51-5a71a7f11e01";
      await prefs.setString('device_id', deviceId);
    }

    return deviceId;
  }
}