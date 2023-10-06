import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/view/auth/signin_screen.dart';

import '../../../config/images.dart';
import '../../../config/text_style.dart';
import '../../../widget/custom_button.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              Column(
                children: [
                  const SizedBox(height: 60),
                  Text(
                    "We create your\ntraining plan",
                    style: pSemiBold20.copyWith(
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          DefaultImages.planGraph,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text(
                    "We create a workout according\nto demographic profile, activity\nlevel and interests",
                    style: pRegular14.copyWith(
                      fontSize: 15,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: CustomButton(
              title: "Start Training",
              width: Get.width,
              onTap: () {
                Get.offAll(
                  const SignInScreen(),
                  transition: Transition.rightToLeft,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
