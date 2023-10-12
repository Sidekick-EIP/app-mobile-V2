import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  static const _keyAccess = 'access_token';
  static const _keyRefresh = 'refresh_token';

  Future<void> storeAccessToken(String token) async {
    await storage.write(key: _keyAccess, value: token);
  }

  Future<void> storeRefreshToken(String token) async {
    await storage.write(key: _keyRefresh, value: token);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: _keyAccess);
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: _keyRefresh);
  }

  Future<void> deleteAccessToken() async {
    await storage.delete(key: _keyAccess);
  }

  Future<void> deleteRefreshToken() async {
    await storage.delete(key: _keyRefresh);
  }
}
