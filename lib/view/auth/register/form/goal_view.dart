import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/images.dart';
import '../../../../config/text_style.dart';
import '../../../../controller/auth_controller.dart';

class GoalView extends StatefulWidget {
  final AuthController authController;
  const GoalView({Key? key, required this.authController}) : super(key: key);

  @override
  State<GoalView> createState() => _GoalViewState();
}

class _GoalViewState extends State<GoalView> {
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
                      i < widget.authController.goalList.length;
                      i++) {
                    if (i == index) {
                      widget.authController.goalList[i] = true;
                    } else {
                      widget.authController.goalList[i] = false;
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
                      color: widget.authController.goalList[index] == true
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
