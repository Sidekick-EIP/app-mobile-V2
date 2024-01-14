import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sidekick_app/models/nutrition.dart';
import 'package:sidekick_app/models/openFoodFact.dart';
import 'package:sidekick_app/providers/auth.dart';
import 'package:sidekick_app/view/nutrition/nutrition_view.dart';
import '../utils/http_request.dart';
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

//  edit meal function

Future editMeal(Food food, int id, BuildContext context) async {
  Map<String, dynamic> body = {
    "period": getIt<MealEditorBlock>().period,
    "name": food.name,
    "picture": food.picture,
    "date": getIt<MealEditorBlock>().selectedDate,
    "protein": food.protein,
    "carbs": food.carbs,
    "fat": food.fat,
    "weight": food.weight,
    "calories": food.calories
  };

  await HttpRequest.mainPut(
    '/nutrition/${id.toString()}',
    body,
    // context,
    // accessToken: Provider.of<Auth>(context, listen: false),
  );
}

class MealEditorBlock {
  late String selectedDate;
  late String period;
  late bool isHealthy;

  MealEditorBlock(this.selectedDate, this.period, this.isHealthy);

  void setPeriod(String? newPeriod) {
    if (newPeriod != null) {
      period = newPeriod;
    }
  }

  void setSelectedDate(String? newDate) {
    if (newDate != null) {
      selectedDate = newDate;
    } else {
      String dateNow = DateTime.now().toString();
      String day = DateFormat('yyyy-MM-dd').format(DateTime.parse(dateNow)).toString();
      selectedDate = day;
    }
  }

  Future<void> deleteMeal(int id, BuildContext context) async {
    final response = await HttpRequest.mainDelete(
      '/nutrition/${id.toString()}',
      // accessToken: Provider.of<Auth>(context, listen: false),
    );
    if (response.statusCode == 200) {
    } else {
      throw ("can't fetch the data of the user");
    }
  }
}

//  Add meal function

Future postNewMeal(ResultSearch ingredient, BuildContext context) async {
  var body = {
    'period': getIt<MealEditorBlock>().period,
    "name": ingredient.name,
    "picture": ingredient.urlImage,
    "date": getIt<MealEditorBlock>().selectedDate,
    "protein": ingredient.proteines,
    "carbs": ingredient.carbohydrates,
    "fat": ingredient.lipides,
    "weight": ingredient.quantity,
    "calories": ingredient.kcalories
  };
  Map<String, String> headers = const {'Content-Type': 'application/json'};

  final response = await HttpRequest.mainPost(
    '/nutrition/',
    body,
    headers: headers,
    // accessToken: Provider.of<Auth>(context, listen: false),
  );

  inspect(response);

  if (response.statusCode == 201) {
    var products = jsonDecode(response.body);
    return products["id"];
  } else {
    throw ("can't fetch the data of the user");
  }
}
