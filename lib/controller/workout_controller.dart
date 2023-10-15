import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/models/exercise.dart';
import 'package:sidekick_app/models/workout.dart';
import 'package:sidekick_app/utils/token_storage.dart';
import 'package:http/http.dart' as http;

class WorkoutController extends GetxController {
  final TokenStorage tokenStorage = TokenStorage();
  String apiUrl = dotenv.env['API_BACK_URL'] ?? "";
  RxBool isLoading = false.obs;

  RxList workout = [].obs;
  RxList exercise = [].obs;

  Future<void> getAllWorkouts() async {
    String? accessToken = await tokenStorage.getAccessToken();
    final String apiUrl = "${dotenv.env['API_BACK_URL']}/workouts/";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer $accessToken"},
    );

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
    String? accessToken = await tokenStorage.getAccessToken();
    final String apiUrl = "${dotenv.env['API_BACK_URL']}/exercises-library/";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      List<Exercise> exercises = List<Exercise>.from(body.map((e) => Exercise.fromJSON(e)));
      exercise.value = exercises;
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
