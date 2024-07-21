import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:fusion/constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:option_result/option_result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fusion/services/device_service.dart';
import 'package:jose/jose.dart';

/// Authentication Service
class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _refreshTokenKey = 'refreshToken';

  static Option<String> _accessToken = const None();

  static Option get accessToken => _accessToken;

  static bool get isLoggedIn => _accessToken.isNone() ? false : true;

  static Future<Result<void, String>> login(
      String username, String password) async {
    final deviceService = getDeviceService();
    final deviceId = await deviceService.getDeviceId();

    await logout(); // Assure any existing tokens are removed

    try {
      final response = await http.post(
        Uri.parse('$apiBaseURL/rpc/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'email': username, 'pass': password, 'device_id': deviceId}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final areTokensValid = await _validateTokenResponse(jsonResponse);

        if (areTokensValid.isErr()) {
          return Err(areTokensValid.unwrapErr());
        }

        return const Ok(null);
      } else {
        return Err('Login failed with status ${response.statusCode}');
      }
    } catch (e) {
      return kDebugMode
          ? Err(e.toString())
          : const Err("error connecting to $apiBaseURL");
    }
  }

  /// Trade a refreshToken for an accessToken + new refreshToken
  ///
  ///
  static Future<Result<void, String>> refreshAccessToken() async {
    final storedRefreshToken = await _storage.read(key: _refreshTokenKey);

    if (storedRefreshToken == null) {
      return const Err('refreshToken not found');
    }

    final refreshToken = await _isTokenValid(storedRefreshToken);

    if (refreshToken.isErr()) {
      return Err('refreshToken ${refreshToken.unwrapErr()}');
    }

    try {
      final response = await http.post(
        Uri.parse('$apiBaseURL/rpc/exchange_refresh_token'),
        body: jsonEncode({'refreshtoken': refreshToken}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final areTokensValid = await _validateTokenResponse(jsonResponse);

        if (areTokensValid.isErr()) {
          await logout();
          return Err(areTokensValid.unwrapErr());
        }

        return const Ok(null);
      } else {
        return Err('token refresh failed with status: ${response.statusCode}');
      }
    } catch (e) {
      return kDebugMode
          ? Err(e.toString())
          : const Err('failed to connect to $apiBaseURL');
    }
  }

  /// Will return Token or Error message
  ///
  /// should only be called to validate new tokens upon arrival or as a
  /// sanity check before a refresh token gets sent out
  static Future<Result<String, String>> _isTokenValid(String jwt) async {
    try {
      final publicKey = JsonWebKey.fromPem(publicKeyPEM);
      final JsonWebKeyStore keyStore = JsonWebKeyStore()..addKey(publicKey);

      final token = JsonWebToken.unverified(jwt);

      if (await token.verify(keyStore)) {
        final claims = token.claims.toJson();
        final expiryDate =
            DateTime.fromMillisecondsSinceEpoch(claims['exp'] * 1000);

        return DateTime.now().isAfter(expiryDate)
            ? const Err('expired')
            : Ok(jwt);
      } else {
        return const Err('signature invalid');
      }
    } catch (e) {
      return kDebugMode ? Err(e.toString()) : const Err('validation error');
    }
  }

  static Future<Result<void, String>> _validateTokenResponse(
      dynamic jsonResponse) async {
    final accessToken = await _isTokenValid(jsonResponse['access_token']);
    final refreshToken = await _isTokenValid(jsonResponse['refresh_token']);

    if (accessToken.isErr()) {
      return Err('accessToken ${accessToken.unwrapErr()}');
    }

    if (refreshToken.isErr()) {
      return Err('refreshToken ${refreshToken.unwrapErr()}');
    }

    _accessToken = Some(accessToken.unwrap());
    await _storage.write(key: _refreshTokenKey, value: refreshToken.unwrap());

    return const Ok(null);
  }

  /// Logout current user and delete tokens
  static Future logout() async {
    await _storage.delete(key: _refreshTokenKey);
    _accessToken = const None();
    return;
  }
}
