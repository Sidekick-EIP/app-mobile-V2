import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidekick_app/utils/http_request.dart';
import 'package:sidekick_app/view/auth/register/info_screen.dart';
import 'package:sidekick_app/view/auth/reset_password_screen.dart';
import 'package:sidekick_app/view/auth/register/signup_screen.dart';

import '../../config/colors.dart';
import '../../config/images.dart';
import '../../config/text_style.dart';
import '../../utils/is_valid_email.dart';
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

  @override
  void initState() {
    super.initState();
    loadLoginInfo();
  }

  Future<void> loadLoginInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String email = prefs.getString('email') ?? '';
    final String password = prefs.getString('password') ?? '';

    setState(() {
      emailController.text = email;
      passwordController.text = password;
    });
  }

  String apiUrl = dotenv.env['API_BACK_URL'] ?? "";
  final TokenStorage tokenStorage = TokenStorage();

  Future<bool> checkUserInfos() async {
    final response = await HttpRequest.mainGet("/user_infos/");

    return response.statusCode == 200;
  }

  Future<void> signIn() async {
    if (!isValidEmail(emailController.text)) {
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

    try {
      Map<String, String> headers = {
        "Content-Type": "application/x-www-form-urlencoded",
      };
      final response = await HttpRequest.mainPost(
        "/auth/login",
        {
          "email": emailController.text,
          "password": passwordController.text,
        },
        headers: headers,
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        await tokenStorage.storeAccessToken(decodedResponse['access_token']);
        await tokenStorage.storeRefreshToken(decodedResponse['refresh_token']);

        bool hasValidInfos = await checkUserInfos();
        if (hasValidInfos) {
          Get.offAll(
            () => const TabScreen(),
            transition: Transition.rightToLeft,
          );
        } else {
          Get.offAll(
            () => const InfoScreen(),
            transition: Transition.rightToLeft,
          );
        }
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

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', emailController.text);
    await prefs.setString('password', passwordController.text);
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
              ),
            ],
          ),
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
    );
  }
}
