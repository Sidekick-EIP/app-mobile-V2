import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/colors.dart';
import '../../../config/text_style.dart';
import '../../../controller/user_controller.dart';

class TrainingEditView extends StatefulWidget {
  const TrainingEditView({Key? key}) : super(key: key);

  @override
  TrainingEditViewState createState() => TrainingEditViewState();
}

class TrainingEditViewState extends State<TrainingEditView> {
  final userController = Get.find<UserController>();
  List<bool> trainingList = [];

  List<bool> translateTrainingToBooleanList(String goal) {
    switch (goal) {
      case "BEGINNER":
        return [true, false, false, false];
      case "IRREGULAR_TRAINING":
        return [false, true, false, false];
      case "INTERMEDIATE":
        return [false, false, true, false];
      case "ADVANCED":
        return [false, false, false, true];
      default:
        return [false, false, false, false];
    }
  }

  @override
  void initState() {
    super.initState();
    userController.trainingList =
        translateTrainingToBooleanList(userController.user.value.level.value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Center(
          child: Text(
            "Sélectionnez votre niveau\nd'entraînement",
            style: pSemiBold20.copyWith(
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
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
                  for (var i = 0; i < userController.trainingList.length; i++) {
                    if (i == index) {
                      userController.trainingList[i] = true;
                    } else {
                      userController.trainingList[i] = false;
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
                      color: userController.trainingList[index] == true
                          ? const Color(0xffF25D29)
                          : const Color(0xffE5E9EF),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          index == 0
                              ? "Débutant"
                              : index == 1
                                  ? "Entrainement irrégulier"
                                  : index == 2
                                      ? "Intermédiaire"
                                      : "Avancé",
                          style: pSemiBold18.copyWith(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          index == 0
                              ? "Je veux commencer à m'entraîner"
                              : index == 1
                                  ? "Je m'entraîne de temps en temps"
                                  : index == 2
                                      ? "Je m'entraîne 2 - 4 fois par semaine"
                                      : "Je m'entraîne 5 - 7 fois par semaine",
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
            );
          },
        ),
      ],
    );
  }
}
