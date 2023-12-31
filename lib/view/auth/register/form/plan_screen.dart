import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/config/colors.dart';
import 'package:sidekick_app/controller/auth_controller.dart';
import 'package:sidekick_app/utils/getter/selected_activities.dart';
import 'package:sidekick_app/utils/getter/selected_training_level.dart';
import 'package:sidekick_app/utils/http_request.dart';
import 'package:sidekick_app/view/auth/register/info_screen.dart';

import '../../../../config/text_style.dart';
import '../../../../config/images.dart';
import '../../../../utils/getter/selected_goal.dart';
import '../../../../utils/token_storage.dart';
import '../../../../widget/custom_button.dart';
import '../../../tab_screen.dart';
import '../../../../utils/getter/selected_gender.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final storage = const FlutterSecureStorage();
  final authController = Get.find<AuthController>();

  Future<void> postUserInfos() async {
    final TokenStorage tokenStorage = TokenStorage();
    String? accessToken = await tokenStorage.getAccessToken();

    if (accessToken == null) {
      if (kDebugMode) {
        print('Access token not found.');
      }
      return;
    }

    if (!validateInputs()) return;

    DateFormat format = DateFormat("dd/MM/yyyy");
    DateTime parsedBirthDate;

    try {
      parsedBirthDate = format.parse(authController.birthDate.value);
    } catch (e) {
      if (kDebugMode) {
        print("Error parsing date: $e");
      }
      return;
    }

    String formattedBirthDate = parsedBirthDate.toUtc().toIso8601String();

    var body = {
      "birth_date": formattedBirthDate,
      "firstname": authController.firstname.value,
      "lastname": authController.lastname.value,
      "size": int.parse(authController.height.value),
      "goal_weight": int.parse(authController.goalWeight.value),
      "weight": int.parse(authController.weight.value),
      "gender": enumToString(getSelectedGender(authController.genderList)),
      "description": authController.description.value,
      "goal": enumToString(getSelectedGoal(authController.goalList)),
      "level":
          enumToString(getSelectedTrainingLevel(authController.trainingList)),
      "activities": getSelectedActivities(authController.activityList)
          .map((activity) => enumToString(activity))
          .toList(),
      "location": authController.city.value,
    };

    try {
      final response = await HttpRequest.mainPost(
        "/user_infos/",
        jsonEncode(body),
      );

      if (response.statusCode == 201) {
        Get.snackbar(
          "Succès",
          "Utilisateur créé avec succès.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => const TabScreen(), transition: Transition.rightToLeft);
      } else {
        showErrorSnackbar();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      showErrorSnackbar();
    }
  }

  bool validateInputs() {
    if (authController.firstname.value.isEmpty ||
        authController.lastname.value.isEmpty ||
        authController.birthDate.value.isEmpty ||
        authController.description.value.isEmpty ||
        authController.height.value.isEmpty ||
        authController.weight.value.isEmpty ||
        authController.goalWeight.value.isEmpty) {
      Get.snackbar("Erreur",
          "Veuillez compléter toutes les informations de votre profil.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  String enumToString(Object? o) => o.toString().split('.').last;

  void showErrorSnackbar() {
    Get.snackbar(
      "Erreur",
      "Erreur lors de la publication des informations de l'utilisateur.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: ConstColors.secondaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: ConstColors.blackColor,
          onPressed: () => Get.offAll(() => const InfoScreen(),
              transition: Transition.leftToRight),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              Column(
                children: [
                  const SizedBox(height: 60),
                  Text(
                    "Profil complété",
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
                          DefaultImages.ps1,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text(
                    "Nous allons vous associer avec un sidekick\nde votre niveau pour vous aider à\natteindre votre objectif.",
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
            padding: const EdgeInsets.only(bottom: 35, left: 20, right: 20),
            child: CustomButton(
              title: "Finaliser mon inscription",
              width: Get.width,
              onTap: () async {
                await postUserInfos();
              },
            ),
          )
        ],
      ),
    );
  }
}
