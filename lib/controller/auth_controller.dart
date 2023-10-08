import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool isContinue = false.obs;
  RxInt skip = 1.obs;
  List<bool> genderList = [true, false, false].obs;
  List<bool> goalList = [true, false, false, false].obs;
  List<bool> trainingList = [true, false, false, false].obs;
  List<bool> activityList = List<bool>.filled(30, false).obs;

  RxString height = RxString("168");
  RxString weight = RxString("55");
  RxString goalWeight = RxString("60");
}
