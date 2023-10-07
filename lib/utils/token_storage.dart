import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> storeAccessToken(String token) async {
    await storage.write(key: 'accessToken', value: token);
  }

  Future<void> storeRefreshToken(String token) async {
    await storage.write(key: 'refreshToken', value: token);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refreshToken');
  }

  Future<void> deleteAccessToken() async {
    await storage.delete(key: 'accessToken');
  }

  Future<void> deleteRefreshToken() async {
    await storage.delete(key: 'refreshToken');
  }
}
