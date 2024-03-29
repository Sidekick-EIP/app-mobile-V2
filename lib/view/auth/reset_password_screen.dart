import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/utils/http_request.dart';
import 'package:sidekick_app/view/auth/password_webview.dart';
import 'package:sidekick_app/view/auth/register/signup_screen.dart';

import '../../config/colors.dart';
import '../../config/images.dart';
import '../../config/text_style.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_textfield.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final emailPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> forgotPassword() async {
    if (!_validateEmail(emailPasswordController.text)) {
      Get.snackbar("Erreur", "Email non valide",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() {
      isLoading = true; // Commence le chargement
    });

    final response = await HttpRequest.mainPost(
        "/auth/forgotPassword", {"email": emailPasswordController.text},
        headers: {"Content-Type": "application/x-www-form-urlencoded"});

    if (response.statusCode == 201) {
      Get.snackbar("Succès", "Un email de réinitialisation a été envoyé",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyWebview()));
    } else {
      Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      String errorMessage = decodedResponse['error'] ?? "Erreur inconnue";
      Get.snackbar("Erreur", errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  bool _validateEmail(String email) {
    RegExp regex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: ConstColors.secondaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ConstColors.blackColor),
          onPressed: () => Get.back(),
        ),
      ),
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
                      Image.asset(
                        DefaultImages.sidekickLogo,
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Réinitialiser le mot de passe",
                        style: pSemiBold20.copyWith(
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        text: "Email",
                        textEditingController: emailPasswordController,
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        title: isLoading ? "Chargement..." : "Envoyer",
                        width: Get.width,
                        onTap: isLoading
                            ? () {}
                            : () {
                                forgotPassword();
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
                () => const SignUpScreen(),
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
