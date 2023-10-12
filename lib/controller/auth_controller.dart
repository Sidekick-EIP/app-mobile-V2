import 'package:get/get.dart';

import '../enum/activities.dart';
import '../enum/gender.dart';
import '../enum/goal.dart';
import '../enum/training_level.dart';

class AuthController extends GetxController {
  RxInt skip = 1.obs;
  List<bool> genderList = [true, false, false].obs;
  List<bool> goalList = [true, false, false, false].obs;
  List<bool> trainingList = [true, false, false, false].obs;
  List<bool> activityList = List<bool>.filled(30, false).obs;

  RxString lastname = RxString("");
  RxString firstname = RxString("");
  RxString birthDate = RxString("");
  RxString description = RxString("");

  void updateLastname(String value) {
    lastname.value = value;
  }

  void updateFirstname(String value) {
    firstname.value = value;
  }

  void updateBirthDate(String value) {
    birthDate.value = value;
  }

  void updateDescription(String value) {
    description.value = value;
  }

  RxString height = RxString("168");
  RxString weight = RxString("55");
  RxString goalWeight = RxString("60");

  Gender get selectedGender {
    for (int i = 0; i < genderList.length; i++) {
      if (genderList[i]) return Gender.values[i];
    }
    return Gender.PREFER_NOT_TO_SAY;  // default value
  }

  Goal get selectedGoal {
    for (int i = 0; i < goalList.length; i++) {
      if (goalList[i]) return Goal.values[i];
    }
    return Goal.STAY_IN_SHAPE;  // default value
  }

  TrainingLevel get selectedTrainingLevel {
    for (int i = 0; i < trainingList.length; i++) {
      if (trainingList[i]) return TrainingLevel.values[i];
    }
    return TrainingLevel.BEGINNER;  // default value
  }

  List<Activities> get selectedActivities {
    List<Activities> activities = [];
    for (int i = 0; i < activityList.length; i++) {
      if (activityList[i]) activities.add(Activities.values[i]);
    }
    return activities;
  }

}
