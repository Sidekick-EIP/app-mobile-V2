import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/images.dart';
import '../../../../config/text_style.dart';
import '../../../../controller/auth_controller.dart';

class GenderView extends StatefulWidget {
  final AuthController authController;
  const GenderView({Key? key, required this.authController}) : super(key: key);

  @override
  State<GenderView> createState() => _GenderViewState();
}

class _GenderViewState extends State<GenderView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Text(
          "Choisir le genre",
          style: pSemiBold20.copyWith(
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 30),
        ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                setState(() {
                  for (var i = 0;
                      i < widget.authController.genderList.length;
                      i++) {
                    if (i == index) {
                      widget.authController.genderList[i] = true;
                    } else {
                      widget.authController.genderList[i] = false;
                    }
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  height: 84,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.7),
                    border: Border.all(
                      color: widget.authController.genderList[index] == true
                          ? const Color(0xffF25D29)
                          : const Color(0xffE5E9EF),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      children: [
                        Image.asset(
                          index == 0
                              ? DefaultImages.g1
                              : index == 1
                                  ? DefaultImages.g2
                                  : DefaultImages.g3,
                        ),
                        const SizedBox(width: 15),
                        Text(
                          index == 0
                              ? "Femme"
                              : index == 1
                                  ? "Homme"
                                  : "Non binaire",
                          style: pSemiBold18.copyWith(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
