import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/config/text_style.dart';
import 'package:sidekick_app/utils/getter/selected_training_level.dart';
import 'package:sidekick_app/view/profile/training/training_edit_view.dart';
import 'package:sidekick_app/view/profile/training/training_list_view.dart';

import '../../../config/colors.dart';
import '../../../controller/user_controller.dart';
import '../../../widget/custom_button.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({Key? key}) : super(key: key);

  @override
  State<TrainingScreen> createState() => TrainingScreenState();
}

class TrainingScreenState extends State<TrainingScreen> {
  final userController = Get.find<UserController>();
  bool isEditMode = false;
  late String initialValue;

  String enumToString(Object? o) => o.toString().split('.').last;

  @override
  void initState() {
    super.initState();
    initialValue = userController.user.value.goal.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            if (!isEditMode) {
              Get.back();
            } else {
              userController.user.value.goal.value = initialValue;
              setState(() {
                isEditMode = !isEditMode;
              });
            }
          },
          child: const Icon(
            Icons.arrow_back,
            color: ConstColors.blackColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 0),
            child: !isEditMode
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        isEditMode = !isEditMode;
                      });
                    },
                    child: Text("Éditer",
                        style: pSemiBold20.copyWith(
                            fontSize: 15.39, color: ConstColors.primaryColor)),
                  )
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: isEditMode
                    ? const TrainingEditView()
                    : const TrainingListView(),
              ),
              const SizedBox(height: 100),
            ],
          ),
          if (isEditMode)
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
              child: CustomButton(
                title: "Enregistrer",
                width: Get.width,
                onTap: () async {
                  userController.user.value.level.value = enumToString(
                      getSelectedTrainingLevel(userController.trainingList));
                  try {
                    await userController.updateUserProfile();
                    Get.snackbar('Succès', 'Profil mis à jour avec succès!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 1));
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                    Get.snackbar(
                        'Erreur', 'Erreur lors de la mise à jour du profil.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  }
                  setState(() {
                    isEditMode = !isEditMode;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
