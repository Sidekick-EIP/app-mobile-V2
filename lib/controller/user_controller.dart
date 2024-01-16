import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/controller/socket_controller.dart';
import 'package:sidekick_app/models/partner.dart';
import 'package:sidekick_app/models/user.dart';
import 'package:sidekick_app/utils/token_storage.dart';
import 'package:sidekick_app/utils/http_request.dart';
import 'package:sidekick_app/utils/user_storage.dart';

class UserController extends GetxController {
  final UserStorage _userStorage = UserStorage();
  final TokenStorage tokenStorage = TokenStorage();
  RxBool isLoading = false.obs;
  RxBool isSidekickLoading = false.obs;

  List<bool> activityList = List<bool>.filled(30, false).obs;
  List<bool> goalList = List<bool>.filled(4, false).obs;
  List<bool> trainingList = List<bool>.filled(30, false).obs;

  Rx<User> user = User(
    avatar: RxString(
        'https://www.vincenthie.com/images/gallery/large/Iron-Man-Portrait.jpg'),
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
    activities:
        ["SOCCER", "TENNIS"].map((activities) => RxString(activities)).toList(),
    goal: RxString('STAY_IN_SHAPE'),
    birthDate: Rx<DateTime>(DateTime.parse("1990-05-12")),
    location: RxString('Paris'),
  ).obs;

  Rx<Partner> partner = Partner(
    avatar: RxString(
        'https://www.vincenthie.com/images/gallery/large/Iron-Man-Portrait.jpg'),
    firstname: RxString('John'),
    lastname: RxString('Doe'),
    size: RxInt(185),
    gender: RxString('MALE'),
    description: RxString('Bonjour !'),
    level: RxString('ADVANCED'),
    activities:
        ["SOCCER", "TENNIS"].map((activities) => RxString(activities)).toList(),
    goal: RxString('STAY_IN_SHAPE'),
    birthDate: Rx<DateTime>(DateTime.parse("1990-05-12")),
    location: RxString('Paris'),
  ).obs;

  Future<bool> fetchUserFromBack() async {
    final response = await HttpRequest.mainGet('/user_infos/');

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      user.value = User.fromJson(body);
      return true;
    } else if (response.statusCode == 500) {
      if (kDebugMode) {
        print("Error 500 from server");
      }
      return false;
    }
    return false;
  }

  Future<bool> fetchSidekickFromBack() async {
    final response = await HttpRequest.mainGet('/user_infos/sidekick');

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      partner.value = Partner.fromJson(body);
      isSidekickLoading.value = true;
      return true;
    } else if (response.statusCode == 404) {
      isSidekickLoading.value = false;
      if (kDebugMode) {
        print("The user doesn't have a sidekick.");
      }
      return false;
    } else {
      isSidekickLoading.value = false;
      if (kDebugMode) {
        print("Error 500 from server");
      }
      return false;
    }
  }

  Future<void> updateUserProfile() async {
    isLoading.value = true;

    String? accessToken = await tokenStorage.getAccessToken();

    if (accessToken == null) {
      isLoading.value = false;
      return;
    }

    Map<String, dynamic> body = {
      "birth_date": user.value.birthDate.value.toIso8601String(),
      "firstname": user.value.firstname.value,
      "lastname": user.value.lastname.value,
      "size": user.value.size.value,
      "goal_weight": user.value.goalWeight.value,
      "weight": user.value.weight.value,
      "gender": user.value.gender.value,
      "description": user.value.description.value,
      "goal": user.value.goal.value,
      "level": user.value.level.value,
      "activities":
          user.value.activities.map((activity) => activity.value).toList(),
      "location": user.value.location.value,
    };

    final response =
        await HttpRequest.mainPut("/user_infos/update", jsonEncode(body));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      user.value = User.fromJson(body);
    } else {
      if (kDebugMode) {
        print('Failed to update profile: ${response.statusCode}');
      }
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

      // Fetch user data
      await fetchUserFromBack();

      if (user.value.sidekickId != null) {
        await fetchSidekickFromBack();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    final socketController = Get.put(SocketController(), permanent: true);
    socketController.disconnectFromSocket();
    super.onClose();
  }
}
