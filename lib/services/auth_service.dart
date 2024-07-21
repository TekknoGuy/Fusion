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
  static Option<String> _accessToken = const None();
  static const _refreshTokenKey = 'refreshToken';

  static var _isLoggedIn = false;

  static bool get isLoggedIn => _isLoggedIn;

  static Future<Result<void, String>> _processTokenResponse(
      dynamic jsonResponse) async {
    final accessToken = await _isTokenValid(jsonResponse['access_token']);
    final refreshToken = await _isTokenValid(jsonResponse['refresh_token']);

    if (accessToken.isErr()) {
      return Err('Access Token ${accessToken.unwrapErr()}');
    }

    if (refreshToken.isErr()) {
      return Err('Refresh Token ${refreshToken.unwrapErr()}');
    }

    // Tokens don't get saved until we assure they are both valid
    _accessToken = Some(accessToken.unwrap());
    await _storage.write(key: _refreshTokenKey, value: refreshToken.unwrap());
    return const Ok(null);
  }

  // Attempt to log in with a refresh token if one exists
  static Future<Result<void, String>> tokenLogin() async {
    final storedRefreshToken = await _storage.read(key: _refreshTokenKey);
    // toDo: The null check should be moved to _isTokenValid. It's possible a JSON value will be null or just not exist.
    if (storedRefreshToken == null) {
      debugPrint("no refresh token found");
      return const Err('no refresh token found');
    }
    final refreshToken = await _isTokenValid(storedRefreshToken);
    if(refreshToken.isErr()) {
      debugPrint(refreshToken.unwrapErr());
      return Err(refreshToken.unwrapErr());
    }

    debugPrint("Attempting to obtain access token");

    final result = await refreshAccessToken();
    if (result.isErr()) {
      debugPrint(result.unwrapErr());
      return Err(result.unwrapErr());
    }

    debugPrint("SUCCESS!!!!!");
    _isLoggedIn = true;
    return const Ok(null);
  }

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
        final responseData = jsonDecode(response.body);
        final areTokensValid = await _processTokenResponse(responseData);

        if (areTokensValid.isErr()) {
          return Err(areTokensValid.unwrapErr());
        }

        _isLoggedIn = true;
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

  /// Trade a refreshToken for an accessToken
  static Future<Result<void, String>> refreshAccessToken() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    final deviceService = getDeviceService();
    final deviceId = await deviceService.getDeviceId();

    if (refreshToken == null) {
      return const Err('no refresh token found');
    }

    try {
      final response = await http.post(
        Uri.parse('$apiBaseURL/rpc/exchange_refresh_token'),
        // the deviceId is already in the token!
        body: jsonEncode({'refreshToken': refreshToken}),
        // body: jsonEncode({'refreshToken': refreshToken, 'deviceId': deviceId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final areTokensValid = await _processTokenResponse(responseData);

        if (areTokensValid.isErr()) {
          logout();
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

  /// Returns true if a valid refresh token exists
  // static Future<bool> hasValidRefreshToken() async {
  //   final refreshToken = await _storage.read(key: _refreshTokenKey);
  //   return refreshToken != null;
  // }

  // toDo: nothing outside of this class needs to get a token!
  // static Future<String?> getJwt() async {
  //   final jwt = await _storage.read(key: _jwtKey);
  //   if (jwt == null || _isJwtExpired(jwt)) {
  //     final result = await refreshJwt();
  //     if (result.success) {
  //       return await _storage.read(key: _jwtKey);
  //     } else {
  //       return null;
  //     }
  //   }
  //   return jwt;
  // }

  // Will return Token or Error
  static Future<Result<String, String>> _isTokenValid(String jwt) async {
    try {
      final publicKey = JsonWebKey.fromPem(publicKeyPEM);
      final JsonWebKeyStore keyStore = JsonWebKeyStore()..addKey(publicKey);

      final token = JsonWebToken.unverified(jwt);

      // Verify token signature
      if (await token.verify(keyStore)) {
        // toDo: move _isJwtExpired to here, and use jose decoder
        return Ok(jwt);
      } else {
        return const Err('Signature Invalid');
      }
    } catch (e) {
      return kDebugMode
          ? Err(e.toString())
          : const Err("error validating token");
    }
  }

  /// Returns 'true' if the provided JWT has expired
  static bool _isJwtExpired(String jwt) {
    final payload = jwt.split('.')[1];
    final decoded =
        jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(payload))));
    final exp = decoded['exp'];
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expiryDate);
  }

  /// Logout current user and delete tokens
  static Future logout() async {
    await _storage.delete(key: _refreshTokenKey);
    _accessToken = const None();
    _isLoggedIn = false;
    return;
  }
}
