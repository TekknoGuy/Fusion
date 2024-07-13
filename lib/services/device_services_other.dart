import 'dart:io';

import 'package:fusion/services/device_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class DeviceServiceImpl implements DeviceService {
  static const _uuid = Uuid();

  @override
  Future<String> getDeviceId() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/device_id.txt');

    if (!await file.exists()) {
      final deviceId = _uuid.v4();
      await file.writeAsString(deviceId);
      return deviceId;
    } else {
      return await file.readAsString();
    }
  }
}