import 'dart:convert';

import 'package:get/get.dart';
import 'package:sidekick_app/utils/user_storage.dart';
import '../models/user.dart';

class UserController extends GetxController {
  var user = User(
      avatar: 'https://www.vincenthie.com/images/gallery/large/Iron-Man-Portrait.jpg',
      userId: 'ID',
      email: 'iron.man@gmail.com',
      isDarkMode: false,
      firstname: 'Tony',
      lastname: 'Stark',
      size: 185,
      weight: 76,
      goalWeight: 82,
      gender: 'MALE',
      description: 'Bonjour !',
      level: 'ADVANCED',
      activities: [
        "SOCCER",
        "TENNIS"
      ],
      goal: 'STAY_IN_SHAPE',
      birthDate: '2001-03-10T00:00:00.000Z'
  ).obs;

  var isLoading = false.obs;

  void addExclamation() {
    user.update((user) {
      user?.firstname += "!";
    });
  }

  void fetchUserFromBack() {

  }

  void registerUserIntoStorage() {
    final UserStorage userStorage = UserStorage();
    userStorage.storeUser(user.value);
  }

  void clearUserFromStorage() {
    final UserStorage userStorage = UserStorage();
    userStorage.deleteUser();
  }

  @override
  void onReady() async {
    try {
      isLoading.value = true;
      final UserStorage userStorage = UserStorage();
      var userStr = await userStorage.getUser() ?? "";

      if (userStr != "") {
        user = User.fromJson(jsonDecode(userStr)).obs;
      } else {
        // TODO request from back
        await Future.delayed(const Duration(seconds: 2));
      }
    } finally {
      isLoading.value = false;
    }

    print('on ready!!');
    super.onReady();
  }
}