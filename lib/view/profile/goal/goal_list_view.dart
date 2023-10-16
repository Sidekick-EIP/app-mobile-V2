import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../config/images.dart';
import '../../../config/text_style.dart';
import '../../../controller/user_controller.dart';

class GoalListView extends StatefulWidget {
  const GoalListView({Key? key}) : super(key: key);

  @override
  GoalListViewState createState() => GoalListViewState();
}

class GoalListViewState extends State<GoalListView> {
  final userController = Get.find<UserController>();

  String getGoalText(String goal) {
    switch (goal) {
      case "LOSE_WEIGHT":
        return "Perdre du poids";
      case "STAY_IN_SHAPE":
        return "Rester en forme";
      case "GAIN_MUSCLE_MASS":
        return "Prendre du volume musculaire";
      default:
        return "Se muscler";
    }
  }

  String getGoalImage(String goal) {
    switch (goal) {
      case "LOSE_WEIGHT":
        return DefaultImages.goal1;
      case "STAY_IN_SHAPE":
        return DefaultImages.goal2;
      case "GAIN_MUSCLE_MASS":
        return DefaultImages.goal3;
      default:
        return DefaultImages.goal4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Text(
          "Mon objectif",
          style: pSemiBold20.copyWith(
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Container(
            height: 84,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.7),
              border: Border.all(
                color: const Color(0xffE5E9EF),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Row(
                children: [
                  Image.asset(getGoalImage(userController.user.value.goal.value)),
                  const SizedBox(width: 15),
                  Text(
                    getGoalText(userController.user.value.goal.value),
                    style: pSemiBold18.copyWith(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}