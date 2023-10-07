import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/view/auth/form/skip_screen.dart';
import 'package:sidekick_app/view/auth/reset_password_screen.dart';
import 'package:sidekick_app/view/auth/signin_screen.dart';

import '../../config/colors.dart';
import '../../config/text_style.dart';
import '../../controller/auth_controller.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final authController = Get.put(AuthController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? validateData() {
    /*if (nameController.text.isEmpty) {
      return "Veuillez entrer votre nom.";
    }
    if (surnameController.text.isEmpty) {
      return "Veuillez entrer votre prénom.";
    }
    if (!GetUtils.isEmail(emailController.text)) {
      return "Veuillez entrer un email valide.";
    }
    if (passwordController.text.length < 8) {
      return "Le mot de passe doit avoir au moins 8 caractères.";
    }
    if (passwordController.text != confirmPasswordController.text) {
      return "Les mots de passe ne correspondent pas.";
    }*/
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.secondaryColor,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Text(
                        "Inscription",
                        style: pSemiBold20.copyWith(
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        text: "Nom",
                        textEditingController: nameController,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        text: "Prénom",
                        textEditingController: surnameController,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        text: "Email",
                        textEditingController: emailController,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        text: "Mot de passe",
                        textEditingController: passwordController,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        text: "Confirmer le mot de passe",
                        textEditingController: confirmPasswordController,
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        title: "Inscription",
                        width: Get.width,
                        onTap: () {
                          String? errorMessage = validateData();
                          if (errorMessage == null) {
                            Get.to(() =>
                              const SkipScreen(),
                              transition: Transition.rightToLeft,
                            );
                          } else {
                            Get.snackbar("Erreur", errorMessage,
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() =>
                const SignInScreen(),
                transition: Transition.rightToLeft,
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Vous avez déjà un compte ?  ",
                    style: pRegular14.copyWith(
                      fontSize: 13,
                      color: ConstColors.lightBlackColor,
                    ),
                  ),
                  Text(
                    "Connexion",
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
