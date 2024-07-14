import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fusion/services/device_service.dart';
import 'package:fusion/models/auth_result.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _jwtKey = 'jwt';
  static const _refreshTokenKey = 'refreshToken';
  static const _apiUrl = 'http://10.0.0.50:3000';

  static Future<AuthResult> login(String username, String password) async {
    final deviceService = getDeviceService();
    final deviceId = await deviceService.getDeviceId();

    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/rpc/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': username, 'pass': password, 'device_id': deviceId}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await _storage.write(key: _jwtKey, value: responseData['access_token']);
        await _storage.write(key: _refreshTokenKey, value: responseData['refresh_token']);
        return AuthResult(success: true, message: 'Login Successful');
      } else {
        return AuthResult(success: false, message: 'Login failed with status: ${response.statusCode}');
      }
    } catch (e) {
      return AuthResult(success: false, message: 'Failed to connect to the server');
    }
  }

  static Future<AuthResult> refreshJwt() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    final deviceService = getDeviceService();
    final deviceId = await deviceService.getDeviceId();

    if (refreshToken == null) {
      return AuthResult(success: false, message: 'No refresh token found');
    }

    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/rpc/refresh'),
        body: jsonEncode({'refreshToken': refreshToken, 'deviceId': deviceId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await _storage.write(key: _jwtKey, value: responseData['token']);
        return AuthResult(success: true);
      } else {
        return AuthResult(success: false, message: 'Token refresh failed with status: ${response.statusCode}');
      }
    } catch (e) {
      return AuthResult(success: false, message: 'Failed to connect to the server');
    }
  }

  static Future<bool> hasValidRefreshToken() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    return refreshToken != null;
  }

  static Future<String?> getJwt() async {
    final jwt = await _storage.read(key: _jwtKey);
    if (jwt == null || _isJwtExpired(jwt)) {
      final result = await refreshJwt();
      if (result.success) {
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

  static Future<AuthResult> logout() async {
    await _storage.delete(key: _jwtKey);
    await _storage.delete(key: _refreshTokenKey);
    return AuthResult(success: true, message: 'Logged out successfully');
  }
}
