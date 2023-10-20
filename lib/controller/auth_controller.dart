import 'package:get/get.dart';

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

  RxString height = RxString("178");
  RxString weight = RxString("80");
  RxString goalWeight = RxString("75");
}
