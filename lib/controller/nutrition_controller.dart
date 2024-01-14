import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sidekick_app/main.dart';
import 'package:sidekick_app/models/nutrition.dart';
import 'package:sidekick_app/models/open_food_fact.dart';
import '../utils/http_request.dart';
import '../utils/token_storage.dart';




class NutritionController {
  final TokenStorage tokenStorage = TokenStorage();
  String apiUrl = dotenv.env['API_BACK_URL'] ?? "";
  RxBool isLoading = false.obs;

  Future<Nutrition> fetchNutrition(String date) async {
    isLoading.value = true;
    final response = await HttpRequest.mainGet("/nutrition/findByDay/?day=$date");

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
  if (getIt<MealEditorBlock>().period.toUpperCase() == "DINNERS") {
    Map<String, dynamic> body = {
      "period": "DINNER",
      "name": food.name,
      "picture": food.picture,
      "date": getIt<MealEditorBlock>().selectedDate,
      "protein": food.protein,
      "carbs": food.carbs,
      "fat": food.fat,
      "weight": food.weight,
      "calories": food.calories
    };
    String jsonBody = json.encode(body);

    await HttpRequest.mainPut(
      '/nutrition/${id.toString()}',
      jsonBody,
    );
  }

  Map<String, dynamic> body = {
    "period": getIt<MealEditorBlock>().period.toUpperCase(),
    "name": food.name,
    "picture": food.picture,
    "date": getIt<MealEditorBlock>().selectedDate,
    "protein": food.protein,
    "carbs": food.carbs,
    "fat": food.fat,
    "weight": food.weight,
    "calories": food.calories
  };

  String jsonBody = json.encode(body);

  await HttpRequest.mainPut(
    '/nutrition/${id.toString()}',
    jsonBody,
  );

  // if (response.statusCode == 201) {
  //   var products = jsonDecode(response.body);
  //   return products["id"];
  // } else {
  //   throw ("can't fetch the data of the user");
  // }
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
      DateTime parsedDate = DateTime.parse(newDate);
      DateTime midnightUtc = DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);
      String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(midnightUtc);
      selectedDate = formattedDate;
    } else {
      String dateNow = DateTime.now().toString();
      String day = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z").format(DateTime.parse(dateNow)).toString();
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
  String dateString = getIt<MealEditorBlock>().selectedDate;
  DateTime parsedDateTime = DateTime.parse(dateString);

  DateTime dateWithMidnightTime = DateTime(parsedDateTime.year, parsedDateTime.month, parsedDateTime.day);

  if (getIt<MealEditorBlock>().period.toUpperCase() == "DINNERS") {
    var body = {
      'period': getIt<MealEditorBlock>().period.toUpperCase(),
      "name": ingredient.name,
      "picture": ingredient.urlImage,
      "date": "${dateWithMidnightTime.toIso8601String()}Z",
      "protein": ingredient.proteines,
      "carbs": ingredient.carbohydrates,
      "fat": ingredient.lipides.toInt(),
      "weight": ingredient.quantity,
      "calories": ingredient.kcalories
    };
    String jsonBody = json.encode(body);

    await HttpRequest.mainPost(
      '/nutrition',
      jsonBody,
    );
  }

  var body = {
    'period': getIt<MealEditorBlock>().period.toUpperCase(),
    "name": ingredient.name,
    "picture": ingredient.urlImage,
    "date": "${dateWithMidnightTime.toIso8601String()}Z",
    "protein": ingredient.proteines,
    "carbs": ingredient.carbohydrates,
    "fat": ingredient.lipides.toInt(),
    "weight": ingredient.quantity,
    "calories": ingredient.kcalories
  };
  String jsonBody = json.encode(body);

  final response = await HttpRequest.mainPost(
    '/nutrition',
    jsonBody,
  );

  if (response.statusCode == 201) {
    var products = jsonDecode(response.body);
    return products["id"];
  } else {
    throw ("can't fetch the data of the user");
  }
}
