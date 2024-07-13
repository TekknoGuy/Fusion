import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fusion/services/device_service.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _jwtKey = 'jwt';
  static const _refreshTokenKey = 'refreshToken';
  static const _apiUrl = 'http://10.0.0.50:3000';

  static Future<bool> login(String username, String password) async {
    final deviceService = getDeviceService();
    final deviceId = await deviceService.getDeviceId();

    final response = await http.post(Uri.parse('$_apiUrl/rpc/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'email': username, 'pass': password, 'device_id': deviceId}));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      await _storage.write(key: _jwtKey, value: responseData['access_token']);
      await _storage.write(
          key: _refreshTokenKey, value: responseData['refresh_token']);

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> refreshJwt() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    final deviceService = getDeviceService();
    final deviceId = deviceService.getDeviceId();

    if (refreshToken == null) {
      // No Refresh Token Found
      return false;
    }

    final response = await http.post(Uri.parse('$_apiUrl/rpc/refresh'),
        body: jsonEncode({'refreshToken': refreshToken, 'deviceId': deviceId}),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      await _storage.write(key: _jwtKey, value: responseData['token']);
      return true;
    } else {
      return false;
    }
  }

  static Future<String?> getJwt() async {
    final jwt = await _storage.read(key: _jwtKey);
    // Check if JWT is expired and refresh it if needed
    if (jwt == null || _isJwtExpired(jwt)) {
      final refreshed = await refreshJwt();
      if (refreshed) {
        return await _storage.read(key: _jwtKey);
      } else {
        return null;
      }
    }
    return jwt;
  }

  static bool _isJwtExpired(String jwt) {
    final payload = jwt.split('.')[1];
    final decoded =
        jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(payload))));
    final exp = decoded['exp'];
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expiryDate);
  }

  static Future<void> logout() async {
    await _storage.delete(key: _jwtKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
