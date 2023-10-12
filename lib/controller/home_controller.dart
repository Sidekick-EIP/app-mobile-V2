import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/view/auth/signin_screen.dart';

class HomeController extends GetxController {
  final storage = const FlutterSecureStorage();

  RxInt flag = 0.obs;
  RxInt homeFlag = 0.obs;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> logout() async {
    await storage.delete(key: 'authToken');
    Get.offAll(() => const SignInScreen());
  }
}
