import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/utils/http_request.dart';
import 'package:http/http.dart' as http;

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

  Future<void> fetchPreferenceFromBack() async {
    final response = await HttpRequest.mainGet('/preferences/');

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      preference.value = Preference.fromJson(body);
    } else if (response.statusCode == 500) {
      if (kDebugMode) {
        print("Error 500 from server");
      }
    }
  }

  Future<void> updatePreference() async {
    String? accessToken = await tokenStorage.getAccessToken();

    if (accessToken == null) {
      return;
    }

    Map<String, dynamic> body = {
      "darkMode": preference.value.isDarkMode.value,
      "sounds": preference.value.sounds.value,
      "notifications": preference.value.notifications.value,
    };

    print(body);

    final response = await http.post(
      Uri.parse('$apiUrl/preferences/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

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
