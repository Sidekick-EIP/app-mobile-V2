import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/utils/http_request.dart';

import '../../../../config/colors.dart';
import '../../../../config/text_style.dart';
import '../../../../widget/custom_button.dart';
import '../../../../widget/custom_textfield.dart';

class ReportSidekickScreen extends StatefulWidget {
  const ReportSidekickScreen({Key? key}) : super(key: key);

  @override
  State<ReportSidekickScreen> createState() => _ReportSidekickScreenState();
}

class _ReportSidekickScreenState extends State<ReportSidekickScreen> {
  final TextEditingController controller = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.secondaryColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: ConstColors.blackColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Signaler le sidekick",
                          style: pSemiBold20.copyWith(
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Détaillez le motif du signalement",
                        style: pSemiBold18.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        minLines: 5,
                        maxLines: 10,
                        height: 156,
                        text: "Motif",
                        textEditingController: controller,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          value = value;
                        },
                      ),
                      const SizedBox(height: 30),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 35),
            child: CustomButton(
              title: "Valider",
              width: Get.width,
              onTap: () async {
                if (controller.text.isEmpty) {
                  setState(() {
                    errorMessage = "Veuillez entrer un motif";
                  });
                } else {
                  final response = await HttpRequest.mainPost("/reports/", {
                    "reason": controller.text,
                  }, headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                  });
                  if (response.statusCode == 201) {
                    Get.snackbar('Succès', 'Sidekick signalé',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 1));
                    Get.back();
                  } else if (response.statusCode) {
                    Get.snackbar('Erreur', "Vous n'avez pas de sidekick",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2));
                  } else {
                    Get.snackbar('Erreur', 'Le signalement a échoué',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 1));
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
