import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool isContinue = false.obs;
  RxInt skip = 1.obs;
  RxBool selectHeight = false.obs;
  RxBool selectWeight = false.obs;
  RxBool selectGoalWeight = false.obs;
  List<bool> genderList = [true, false, false].obs;
  List<bool> goalList = [true, false, false, false].obs;
  List<bool> trainingList = [true, false, false, false].obs;
  List<bool> activityList = [true, false, false, false, false].obs;
}