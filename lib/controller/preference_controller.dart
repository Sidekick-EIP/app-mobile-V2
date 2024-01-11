import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/utils/http_request.dart';

import '../models/preference.dart';
import '../utils/token_storage.dart';

class PreferenceController extends GetxController {
  String apiUrl = dotenv.env['API_BACK_URL'] ?? "";
  final TokenStorage tokenStorage = TokenStorage();

  Rx<Preference> preference = Preference(
    isDarkMode: RxBool(false),
    notifications: RxBool(false),
    sounds: RxBool(false),
  ).obs;

  Future<bool> fetchPreferenceFromBack() async {
    final response = await HttpRequest.mainGet('/preferences/');

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      preference.value.isDarkMode.value = body['darkMode'];
      preference.value.notifications.value = body['notifications'];
      preference.value.sounds.value = body['sounds'];
      return true;
    } else if (response.statusCode == 500) {
      if (kDebugMode) {
        print("Error 500 from server");
      }
      return false;
    }
    return false;
  }

  Future<void> updatePreference() async {
    String? accessToken = await tokenStorage.getAccessToken();

    if (accessToken == null) {
      return;
    }

    Map<String, bool> body = {
      "darkMode": preference.value.isDarkMode.value,
      "sounds": preference.value.sounds.value,
      "notifications": preference.value.notifications.value,
    };

    final response =
        await HttpRequest.mainPost("/preferences/", jsonEncode(body));

    if (response.statusCode == 201) {
      if (kDebugMode) {
        print("Preference updated");
      }
    } else if (response.statusCode == 500) {
      if (kDebugMode) {
        print("Error 500 from server");
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();
    try {
      await fetchPreferenceFromBack();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
