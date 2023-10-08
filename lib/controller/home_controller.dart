import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt flag = 0.obs;
  RxInt homeFlag = 0.obs;
  List<bool> activityList =
      [true, false, false, false, false, false, false, false].obs;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<bool> exerciesList = [true, false, false, false].obs;
  List<bool> trainingList = [true, false, false, false].obs;
}
