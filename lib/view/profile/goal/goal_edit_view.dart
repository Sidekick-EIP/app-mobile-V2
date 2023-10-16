import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/images.dart';
import '../../../config/text_style.dart';
import '../../../controller/user_controller.dart';

class GoalEditView extends StatefulWidget {
  const GoalEditView({Key? key}) : super(key: key);

  @override
  GoalEditViewState createState() => GoalEditViewState();
}

class GoalEditViewState extends State<GoalEditView> {
  final userController = Get.find<UserController>();
  List<bool> goalList = [];

  List<bool> translateGoalToBooleanList(String goal) {
    switch (goal) {
      case "LOSE_WEIGHT":
        return [true, false, false, false];
      case "STAY_IN_SHAPE":
        return [false, true, false, false];
      case "GAIN_MUSCLE_MASS":
        return [false, false, true, false];
      case "BUILD_MUSCLE":
        return [false, false, false, true];
      default:
        return [false, false, false, false];
    }
  }

  @override
  void initState() {
    super.initState();
    userController.goalList = translateGoalToBooleanList(userController.user.value.goal.value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Text(
          "Choisir son objectif",
          style: pSemiBold20.copyWith(
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 30),
        ListView.builder(
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                setState(() {
                  for (var i = 0;
                  i < userController.goalList.length;
                  i++) {
                    if (i == index) {
                      userController.goalList[i] = true;
                    } else {
                      userController.goalList[i] = false;
                    }
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  height: 84,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.7),
                    border: Border.all(
                      color: userController.goalList[index] == true
                          ? const Color(0xffF25D29)
                          : const Color(0xffE5E9EF),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      children: [
                        Image.asset(
                          index == 0
                              ? DefaultImages.goal1
                              : index == 1
                              ? DefaultImages.goal2
                              : index == 2
                              ? DefaultImages.goal3
                              : DefaultImages.goal4,
                        ),
                        const SizedBox(width: 15),
                        Text(
                          index == 0
                              ? "Perdre du poids"
                              : index == 1
                              ? "Rester en forme"
                              : index == 2
                              ? "Prendre du volume musculaire"
                              : "Se muscler",
                          style: pSemiBold18.copyWith(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}