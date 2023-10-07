import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/colors.dart';
import '../../config/images.dart';
import '../../config/text_style.dart';
import '../../controller/onboarding_controller.dart';
import '../../widget/custom_button.dart';
import '../auth/signin_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final onboardingController = Get.put(OnBoardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.primaryColor,
      body: Column(
        children: [
          GetX<OnBoardingController>(
            init: onboardingController,
            builder: (onboardingController) => Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: onboardingController.flag.value == 0
                    ? Get.height / 2
                    : Get.height / 1.8,
                decoration: BoxDecoration(
                  color: ConstColors.primaryColor,
                  image: DecorationImage(
                    image: AssetImage(
                      onboardingController.flag.value == 0
                          ? DefaultImages.ob0
                          : onboardingController.flag.value == 1
                              ? DefaultImages.ob2
                              : DefaultImages.ob5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: Get.width,
              decoration: const BoxDecoration(
                color: ConstColors.secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(child: SizedBox()),
                  GetX<OnBoardingController>(
                    init: onboardingController,
                    builder: (onboardingController) => Text(
                      onboardingController.flag.value == 0
                          ? "Bienvenue sur Sidekick"
                          : onboardingController.flag.value == 1
                              ? "Connectez-vous avec\nun partenaire"
                              : "Restez motivé et suivez\nvos progrès à deux",
                      style: pSemiBold20.copyWith(
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GetX<OnBoardingController>(
                    init: onboardingController,
                    builder: (onboardingController) => Text(
                      onboardingController.flag.value == 0
                          ? "Connectez-vous avec un partenaire pour atteindre ensemble vos objectifs sportifs et alimentaires !"
                          : onboardingController.flag.value == 1
                              ? "Créez des duos dynamiques : Sidekick vous jumelle\navec quelqu'un partageant vos ambitions."
                              : "Restez motivé et suivez vos progrès à deux,\npour une expérience sportive et alimentaire enrichissante !",
                      style: pRegular14.copyWith(
                        fontSize: 15,
                        color: ConstColors.lightBlackColor,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  GetX<OnBoardingController>(
                    init: onboardingController,
                    builder: (onboardingController) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 3.5,
                          backgroundColor: onboardingController.flag.value == 0
                              ? ConstColors.primaryColor
                              : const Color(0xffDAE0E8),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 3.5,
                          backgroundColor: onboardingController.flag.value == 1
                              ? ConstColors.primaryColor
                              : const Color(0xffDAE0E8),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 3.5,
                          backgroundColor: onboardingController.flag.value == 2
                              ? ConstColors.primaryColor
                              : const Color(0xffDAE0E8),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: GetX<OnBoardingController>(
                      init: onboardingController,
                      builder: (onboardingController) => CustomButton(
                        title: onboardingController.flag.value == 0
                            ? "Commencer"
                            : "Suivant",
                        width: Get.width,
                        onTap: () {
                          onboardingController.flag.value =
                              onboardingController.flag.value + 1;
                          if (onboardingController.flag.value == 3) {
                            Get.to(
                              () => const SignInScreen(),
                              transition: Transition.rightToLeft,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  onboardingController.flag.value == 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Vous avez déjà un compte ?   ",
                                style: pRegular14.copyWith(
                                  fontSize: 13,
                                  color: ConstColors.lightBlackColor,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(
                                    () => const SignInScreen(),
                                    transition: Transition.rightToLeft,
                                  );
                                },
                                child: Text(
                                  "Connexion",
                                  style: pRegular14.copyWith(
                                    fontSize: 13,
                                    color: ConstColors.primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
