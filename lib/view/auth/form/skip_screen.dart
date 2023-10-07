import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/view/auth/form/plan_screen.dart';
import 'package:sidekick_app/view/auth/form/select_goal_weight_view.dart';
import 'package:sidekick_app/view/auth/form/select_height_view.dart';
import 'package:sidekick_app/view/auth/form/select_weight_view.dart';
import 'package:sidekick_app/view/auth/form/training_view.dart';

import '../../../config/colors.dart';
import '../../../config/text_style.dart';
import '../../../controller/auth_controller.dart';
import '../../../widget/custom_button.dart';
import 'activity_view.dart';
import 'gender_view.dart';
import 'goal_view.dart';

class SkipScreen extends StatefulWidget {
  const SkipScreen({Key? key}) : super(key: key);

  @override
  State<SkipScreen> createState() => _SkipScreenState();
}

class _SkipScreenState extends State<SkipScreen> {
  final authController = Get.put(AuthController());

  String? errorMessage;

  @override
  void initState() {
    authController.skip.value = 1;
    super.initState();
  }

  void goToNextStep() {
    errorMessage = checkForErrorsAtCurrentStep(authController.skip.value);
    if (errorMessage == null) {
      authController.skip.value++;
    } else {
      setState(() {}); // pour reconstruire et afficher l'erreur
    }
  }

  String? checkForErrorsAtCurrentStep(int step) {
    switch (step) {
      case 1:
        // Vérifiez les erreurs pour GenderView
        // Exemple : if (authController.gender == null) return "Veuillez choisir un genre.";
        break;
      case 2:
        // Vérifiez les erreurs pour GoalView
        break;
      case 3:
        // Vérifiez les erreurs pour SelectHeightView
        break;
      // Ajoutez des vérifications pour chaque étape.
      default:
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.secondaryColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: ConstColors.blackColor,
          ),
        ),
        title: GetX<AuthController>(
          init: authController,
          builder: (authController) => Text(
            "Etape ${authController.skip.value} sur 7",
            style: pSemiBold18.copyWith(
              fontSize: 15,
              color: ConstColors.primaryColor,
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: GetX<AuthController>(
                  init: authController,
                  builder: (authController) => authController.skip.value == 1
                      ? GenderView(
                          authController: authController,
                        )
                      : authController.skip.value == 2
                          ? GoalView(
                              authController: authController,
                            )
                          : authController.skip.value == 3
                              ? SelectHeightView(
                                  authController: authController,
                                )
                              : authController.skip.value == 4
                                  ? SelectWeightView(
                                      authController: authController,
                                    )
                                  : authController.skip.value == 5
                                      ? SelectWeightGoalView(
                                          authController: authController,
                                        )
                                      : authController.skip.value == 6
                                          ? TraningLevelView(
                                              authController: authController,
                                            )
                                          : ActivityView(
                                              authController: authController,
                                            ),
                ),
              ),
              const SizedBox(height: 100),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
          GetX<AuthController>(
            init: authController,
            builder: (authController) => Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
              child: CustomButton(
                title: authController.skip.value < 7
                    ? "Suivant"
                    : "Terminer l'inscription",
                width: Get.width,
                onTap: authController.skip.value < 7
                    ? goToNextStep
                    : () {
                        Get.offAll(
                          const PlanScreen(),
                          transition: Transition.rightToLeft,
                        );
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
