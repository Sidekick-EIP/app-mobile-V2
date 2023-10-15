import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/colors.dart';
import '../../../config/text_style.dart';
import '../../../controller/user_controller.dart';

class TrainingListView extends StatefulWidget {
  const TrainingListView({Key? key}) : super(key: key);

  @override
  TrainingListViewState createState() => TrainingListViewState();
}

class TrainingListViewState extends State<TrainingListView> {
  final userController = Get.find<UserController>();

  String getTrainingTitle(String trainingLevel) {
    switch (trainingLevel) {
      case "BEGINNER":
        return "Débutant";
      case "IRREGULAR_TRAINING":
        return "Entrainement irrégulier";
      case "INTERMEDIATE":
        return "Intermédiaire";
      default:
        return "Avancé";
    }
  }

  String getTrainingDescription(String trainingLevel) {
    switch (trainingLevel) {
      case "BEGINNER":
        return "Je veux commencer à m'entraîner";
      case "IRREGULAR_TRAINING":
        return "Je m'entraîne de temps en temps";
      case "INTERMEDIATE":
        return "Je m'entraîne 2 - 4 fois par semaine";
      default:
        return "Je m'entraîne 5 - 7 fois par semaine";
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
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTrainingTitle(userController.user.value.level.value),
                    style: pSemiBold18.copyWith(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    getTrainingDescription(
                        userController.user.value.level.value),
                    style: pRegular14.copyWith(
                      fontSize: 13,
                      color: ConstColors.lightBlackColor,
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
