import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sidekick_app/view/auth/reset_password_screen.dart';
import 'package:sidekick_app/view/auth/signup_screen.dart';

import '../../config/colors.dart';
import '../../config/images.dart';
import '../../config/text_style.dart';
import '../../utils/token_storage.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_textfield.dart';
import '../tab_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  final TokenStorage tokenStorage = TokenStorage();

  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  Future<void> signIn() async {
    if (!_isValidEmail(emailController.text)) {
      Get.snackbar("Erreur", "Entrez un email valide.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (passwordController.text.isEmpty) {
      Get.snackbar("Erreur", "Entrez un mot de passe.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() {
      isLoading = true;
    });

    String apiUrl = dotenv.env['API_BACK_URL'] ?? "";

    try {
      final response = await http.post(
        Uri.parse("$apiUrl/auth/login"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "email": emailController.text,
          "password": passwordController.text,
        },
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        await tokenStorage.storeAccessToken(decodedResponse['access_token']);
        await tokenStorage.storeRefreshToken(decodedResponse['refresh_token']);

        Get.offAll(
          () => const TabScreen(),
          transition: Transition.rightToLeft,
        );
      } else {
        Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        String errorMessage = decodedResponse['error'] ?? "Erreur inconnue";
        Get.snackbar("Erreur", errorMessage,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (error) {
      Get.snackbar("Erreur", "Une erreur s'est produite lors de la connexion.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                        "Connexion",
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
                      const SizedBox(height: 30),
                      CustomButton(
                        title: "Connexion",
                        width: Get.width,
                        onTap: () async {
                          await signIn();
                        },
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Get.to(
                            () => const ResetPasswordScreen(),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Text(
                          "Mot de passe oublié ?",
                          style: pSemiBold18.copyWith(
                            fontSize: 11,
                            color: ConstColors.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      color: ConstColors.secondaryColor,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
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
