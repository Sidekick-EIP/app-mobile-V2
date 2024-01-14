import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/controller/socket_controller.dart';
import 'package:sidekick_app/utils/user_storage.dart';
import 'package:sidekick_app/view/auth/signin_screen.dart';

import '../utils/token_storage.dart';

class HomeController extends GetxController {
  final storage = const FlutterSecureStorage();

  RxInt flag = 0.obs;
  RxInt homeFlag = 0.obs;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> logout() async {
    TokenStorage tokenStorage = TokenStorage();
    UserStorage userStorage = UserStorage();
    SocketController socketController = Get.put(SocketController(), permanent: true);

    socketController.disconnectFromSocket();
    tokenStorage.deleteAccessToken();
    tokenStorage.deleteRefreshToken();
    userStorage.deleteUser();
    Get.offAll(() => const SignInScreen());
  }
}
