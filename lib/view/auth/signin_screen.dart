import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/view/auth/signup_screen.dart';

import '../../config/colors.dart';
import '../../config/images.dart';
import '../../config/text_style.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_textfield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.secondaryColor,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Text(
                        "Connexion",
                        style: pSemiBold20.copyWith(
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        text: "Email",
                        textEditingController: TextEditingController(),
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        text: "Mot de passe",
                        textEditingController: TextEditingController(),
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        title: "Connexion",
                        width: Get.width,
                        onTap: () {
                          Get.offAll(
                            const SignInScreen(),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Mot de passe oublié ?",
                        style: pSemiBold18.copyWith(
                          fontSize: 11,
                          color: ConstColors.lightBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(
                const SignUpScreen(),
                transition: Transition.rightToLeft,
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Vous n'avez pas de compte ?  ",
                    style: pRegular14.copyWith(
                      fontSize: 13,
                      color: ConstColors.lightBlackColor,
                    ),
                  ),
                  Text(
                    "Inscrivez-vous",
                    style: pRegular14.copyWith(
                      fontSize: 13,
                      color: ConstColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
