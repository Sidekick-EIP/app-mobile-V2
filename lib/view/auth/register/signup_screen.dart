import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/utils/http_request.dart';
import 'package:sidekick_app/view/auth/register/info_screen.dart';
import 'package:sidekick_app/view/auth/signin_screen.dart';

import '../../../config/colors.dart';
import '../../../config/text_style.dart';
import '../../../utils/token_storage.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TokenStorage tokenStorage = TokenStorage();
  bool isLoading = false;

  Future<bool> registerUser(String email, String password) async {
    final response = await HttpRequest.mainPost(
      "/auth/register",
      {
        "email": email,
        "password": password,
      },
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      await tokenStorage.storeAccessToken(decodedResponse['access_token']);
      await tokenStorage.storeRefreshToken(decodedResponse['refresh_token']);
      return true;
    } else {
      return false;
    }
  }

  String? validateData() {
    if (!GetUtils.isEmail(emailController.text)) {
      return "Veuillez entrer un email valide.";
    }
    if (passwordController.text.length < 8) {
      return "Le mot de passe doit avoir au moins 8 caractères.";
    }
    if (passwordController.text != confirmPasswordController.text) {
      return "Les mots de passe ne correspondent pas.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.secondaryColor,
      body: Stack(
        children: [
          Column(
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
                            text: "Email",
                            textEditingController: emailController,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            text: "Mot de passe",
                            textEditingController: passwordController,
                            isPassword: true,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            text: "Confirmer le mot de passe",
                            textEditingController: confirmPasswordController,
                            isPassword: true,
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                            title: "Inscription",
                            width: Get.width,
                            onTap: () async {
                              String? errorMessage = validateData();
                              if (errorMessage == null) {
                                setState(() {
                                  isLoading = true;
                                });
                                bool isRegistered = await registerUser(
                                    emailController.text,
                                    passwordController.text);
                                setState(() {
                                  isLoading = false;
                                });
                                if (isRegistered) {
                                  Get.snackbar("Succès", "Inscription réussie",
                                      snackPosition: SnackPosition.BOTTOM);
                                  Get.to(
                                    () => const InfoScreen(),
                                    transition: Transition.rightToLeft,
                                  );
                                } else {
                                  Get.snackbar("Erreur", "Inscription échouée",
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                              } else {
                                Get.snackbar("Erreur", errorMessage,
                                    snackPosition: SnackPosition.BOTTOM);
                              }
                            },
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 35,
            child: InkWell(
              onTap: () {
                Get.offAll(
                  () => const SignInScreen(),
                  transition: Transition.rightToLeft,
                );
              },
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
          ),
          if (isLoading) ...[
            Positioned.fill(
              child: Container(
                color: ConstColors.secondaryColor,
                child: const Center(
                  child: CircularProgressIndicator(
                      color: ConstColors.secondaryColor),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
