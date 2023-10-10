import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sidekick_app/models/partner.dart';
import 'package:sidekick_app/models/user.dart';

class UserStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  static const _keyUser = 'user';
  static const _keyPartner = 'partner';

  Future<void> storeUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await storage.write(key: _keyUser, value: userJson);
  }

  Future<void> storePartner(Partner partner) async {
    final partnerJson = jsonEncode(partner);
    await storage.write(key: _keyPartner, value: partnerJson);
  }

  Future<String?> getUser() async {
    return await storage.read(key: _keyUser);
  }

  Future<String?> getPartner() async {
    return await storage.read(key: _keyPartner);
  }

  Future<void> deleteUser() async {
    await storage.delete(key: _keyUser);
  }

  Future<void> deletePartner() async {
    await storage.delete(key: _keyPartner);
  }
}
