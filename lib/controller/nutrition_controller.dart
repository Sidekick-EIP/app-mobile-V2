import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sidekick_app/models/nutrition.dart';
import '../utils/token_storage.dart';

class NutritionController {
  final TokenStorage tokenStorage = TokenStorage();
  String apiUrl = dotenv.env['API_BACK_URL'] ?? "";
  RxBool isLoading = false.obs;

  Future<Nutrition> fetchNutrition(String date) async {
    isLoading.value = true;
    String? accessToken = await tokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse('$apiUrl/nutrition/findByDay/?day=$date'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      Nutrition nutrition = Nutrition.fromJson(body);

      isLoading.value = false;
      return nutrition;
    } else {
      throw Exception('Failed to load nutrition');
    }
  }
}
