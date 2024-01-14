import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/models/exercise.dart';
import 'package:sidekick_app/models/workout.dart';
import 'package:sidekick_app/models/workout_calories.dart';
import 'package:sidekick_app/utils/http_request.dart';
import 'package:sidekick_app/utils/token_storage.dart';

class WorkoutController extends GetxController {
  final TokenStorage tokenStorage = TokenStorage();
  String apiUrl = dotenv.env['API_BACK_URL'] ?? "";
  RxBool isLoading = false.obs;

  RxList workout = [].obs;
  RxList exercise = [].obs;
  RxList calories = [].obs;

  Future<void> getAllWorkouts() async {
    final response = await HttpRequest.mainGet("/workouts");

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      List<Workout> workouts = List<Workout>.from(body.map((e) => Workout.fromJSON(e)));
      workouts.sort((a, b) {
        return DateTime.parse(b.date).compareTo(DateTime.parse(a.date));
      });
      var groupByDate = groupBy(workouts, (obj) => obj.date.substring(0, 10));
      workout.value = groupByDate.values.toList();
    } else {
      throw Exception('Failed to get workouts');
    }
  }

  Future<void> getAllExercices() async {
    final response = await HttpRequest.mainGet("/exercises-library/");

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      List<Exercise> exercises = List<Exercise>.from(body.map((e) => Exercise.fromJSON(e)));
      exercise.value = exercises;
    } else {
      throw Exception('Failed to get exercises');
    }
  }

  Future<void> getSpecificExercises(String exo) async {
    final response = await HttpRequest.mainGet("/exercises-library/muscle/?muscle=$exo");

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      List<Exercise> exercises = List<Exercise>.from(body.map((e) => Exercise.fromJSON(e)));
      exercise.value = exercises;
    } else {
      throw Exception('Failed to get exercises');
    }
  }

  Future<void> addExercise(body) async {
    try {
      final response = await HttpRequest.mainPost("/workouts/add", jsonEncode(body));

      if (response.statusCode == 201) {
        Get.snackbar(
          "Succès",
          "Exercice ajouté avec succès.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        getAllWorkouts();
      } else {
        Get.snackbar(
          "Erreur",
          "Erreur lors de l'ajout d'un exercice au calendrier.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar(
        "Erreur",
        "Erreur lors de l'ajout d'un exercice au calendrier.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  int getTotalCaloriesBurned() {
    return calories.fold(0, (total, calorie) => total + (calorie as WorkoutCalories).burnedCalories);
  }

  Future<void> getWorkoutCalories() async {
    final response = await HttpRequest.mainGet("/workouts/calories/");

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      WorkoutCalories exerciseCalories = WorkoutCalories.fromJSON(body);
      calories.value = [exerciseCalories];
    } else {
      throw Exception('Failed to get workouts');
    }
  }

  @override
  void onReady() async {
    super.onReady();

    try {
      isLoading.value = true;
      await getAllExercices();
      await getAllWorkouts();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching workouts: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
