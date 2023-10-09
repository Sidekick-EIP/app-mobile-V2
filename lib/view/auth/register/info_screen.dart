import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/view/auth/signin_screen.dart';

import '../../../config/colors.dart';
import '../../../config/text_style.dart';
import '../../../controller/auth_controller.dart';
import '../../../utils/is_valid_date.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_textfield.dart';
import 'form/skip_screen.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final authController = Get.put(AuthController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? validateData() {
    if (nameController.text.isEmpty) {
      return "Veuillez entrer votre nom.";
    }
    if (surnameController.text.isEmpty) {
      return "Veuillez entrer votre prénom.";
    }
    if (!isValidDate(birthDateController.text)) {
      return "Veuillez entrer une date de naissance valide.";
    }
    if (descriptionController.text.isEmpty) {
      return "Veuillez entrer une description.";
    }
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
                        "Remplissez votre profil",
                        style: pSemiBold20.copyWith(
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        text: "Nom",
                        textEditingController: nameController,
                        onChanged: (value) {
                          authController.updateLastname(value);
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        text: "Prénom",
                        textEditingController: surnameController,
                        onChanged: (value) {
                          authController.updateFirstname(value);
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        text: "Date de naissance",
                        textEditingController: birthDateController,
                        onChanged: (value) {
                          authController.updateBirthDate(value);
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        text: "Description",
                        textEditingController: descriptionController,
                        onChanged: (value) {
                          authController.updateDescription(value);
                        },
                        minLines: 5,
                        maxLines: 10,
                        height: 100,
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        title: "Compléter mon profil",
                        width: Get.width,
                        onTap: () {
                          String? errorMessage = validateData();
                          if (errorMessage == null) {
                            Get.to(() => const SkipScreen(),
                                transition: Transition.rightToLeft);
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
              Get.to(
                () => const SignInScreen(),
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
