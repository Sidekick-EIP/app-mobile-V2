import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/colors.dart';
import '../../../../config/text_style.dart';
import '../../../../controller/auth_controller.dart';

class TraningLevelView extends StatefulWidget {
  final AuthController authController;
  const TraningLevelView({Key? key, required this.authController})
      : super(key: key);

  @override
  State<TraningLevelView> createState() => _TraningLevelViewState();
}

class _TraningLevelViewState extends State<TraningLevelView> {
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
                  for (var i = 0;
                      i < widget.authController.trainingList.length;
                      i++) {
                    if (i == index) {
                      widget.authController.trainingList[i] = true;
                    } else {
                      widget.authController.trainingList[i] = false;
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
                      color: widget.authController.trainingList[index] == true
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
