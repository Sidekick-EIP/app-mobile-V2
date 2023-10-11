import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/utils/user_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../utils/token_storage.dart';

class UserController extends GetxController {
  final UserStorage _userStorage = UserStorage();

  Rx<User> user = User(
    avatar:
        RxString('https://www.vincenthie.com/images/gallery/large/Iron-Man-Portrait.jpg'),
    userId: RxString('ID'),
    email: RxString('iron.man@gmail.com'),
    isDarkMode: RxBool(false),
    firstname: RxString('Tony'),
    lastname: RxString('Stark'),
    size: RxInt(185),
    weight: RxInt(76),
    goalWeight: RxInt(82),
    gender: RxString('MALE'),
    description: RxString('Bonjour !'),
    level: RxString('ADVANCED'),
    activities: ["SOCCER", "TENNIS"],
    goal: RxString('STAY_IN_SHAPE'),
    birthDate: Rx<DateTime>(
      DateTime.parse("1990-05-12")
    ),
  ).obs;

  RxBool isLoading = false.obs;

  void addExclamation() {
    user.update((val) {
      val!.firstname.value += '!';
    });
  }

  // If you plan to implement this method, handle potential errors with try-catch.
  void fetchUserFromBack() async {
    isLoading.value = true;
    String apiUrl = dotenv.env['API_BACK_URL'] ?? "";
    final TokenStorage tokenStorage = TokenStorage();
    String? accessToken = await tokenStorage.getAccessToken();

    if (accessToken == null) {
      isLoading.value = false;
      return;
    }

    final response = await http.get(
      Uri.parse('$apiUrl/user_infos/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      user.value = User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      final String? refreshToken = await tokenStorage.getRefreshToken();
      // Handle refreshing the token here
      // If refreshed, then try fetching the user info again.
    } else {
      // Handle other error scenarios.
    }

    isLoading.value = false;
  }


  void registerUserIntoStorage() {
    _userStorage.storeUser(user.value);
  }

  void clearUserFromStorage() {
    _userStorage.deleteUser();
  }

  @override
  void onReady() async {
    super.onReady();

    try {
      isLoading.value = true;
      var userStr = await _userStorage.getUser() ?? "";

      if (userStr.isNotEmpty) {
        user.value = User.fromJson(jsonDecode(userStr));
      } else {
        // TODO request from back
        await Future.delayed(const Duration(seconds: 2));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user: $e");
      }
    } finally {
      isLoading.value = false;
    }

    if (kDebugMode) {
      print('on ready!!');
    }
  }
}
