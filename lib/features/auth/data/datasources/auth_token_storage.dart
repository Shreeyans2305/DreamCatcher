import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/auth_user.dart';

/// Abstract storage interface for authentication tokens and cached user sessions.
abstract class AuthTokenStorage {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<AuthUser?> getCachedUser();
  Future<void> saveUser(AuthUser user);
  Future<void> clear();
  Future<bool> hasValidSession();
}

/// Production implementation backed by FlutterSecureStorage for encrypted storage at rest.
class SecureAuthTokenStorage implements AuthTokenStorage {
  static const String _tokenKey = 'dc_auth_token_secure';
  static const String _userKey = 'dc_auth_user_secure';

  final FlutterSecureStorage _storage;

  SecureAuthTokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
            );

  @override
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<AuthUser?> getCachedUser() async {
    try {
      final jsonStr = await _storage.read(key: _userKey);
      if (jsonStr == null || jsonStr.isEmpty) return null;
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AuthUser.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveUser(AuthUser user) async {
    await saveToken(user.token);
    final jsonStr = jsonEncode(user.toJson());
    await _storage.write(key: _userKey, value: jsonStr);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }

  @override
  Future<bool> hasValidSession() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

/// In-memory implementation used for fast, isolated widget and unit testing.
class InMemoryAuthTokenStorage implements AuthTokenStorage {
  String? _token;
  AuthUser? _user;

  InMemoryAuthTokenStorage({String? initialToken, AuthUser? initialUser})
      : _token = initialToken,
        _user = initialUser;

  @override
  Future<String?> getToken() async => _token;

  @override
  Future<void> saveToken(String token) async {
    _token = token;
  }

  @override
  Future<AuthUser?> getCachedUser() async => _user;

  @override
  Future<void> saveUser(AuthUser user) async {
    _token = user.token;
    _user = user;
  }

  @override
  Future<void> clear() async {
    _token = null;
    _user = null;
  }

  @override
  Future<bool> hasValidSession() async => _token != null && _token!.isNotEmpty;
}
