import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';

class StepsController extends GetxController {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  final RxString _status = '?'.obs;
  RxInt steps = 0.obs;

  void onStepCount(StepCount event) {
    steps.value = event.steps;
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    _status.value = event.status;
  }

  void onPedestrianStatusError(error) {
    _status.value = 'Pedestrian Status not available';
    if (kDebugMode) {
      print(_status);
    }
  }

  void onStepCountError(error) {
    steps.value = 0;
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }
}