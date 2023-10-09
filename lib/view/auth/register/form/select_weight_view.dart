import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../config/colors.dart';
import '../../../../config/text_style.dart';
import '../../../../controller/auth_controller.dart';
import '../../../../utils/get_regex_string.dart';


class SelectWeightView extends StatelessWidget {
  final AuthController authController;
  const SelectWeightView({Key? key, required this.authController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Text(
          "Sélectionnez son poids",
          style: pSemiBold20.copyWith(
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          height: 38,
          width: Get.width / 1.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            color: const Color(0xffF1F4F8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(13),
                boxShadow: null,
              ),
              child: Center(
                child: Text(
                  "Kilogramme",
                  style: pSemiBold20.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ConstColors.lightBlackColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 61,
              width: 93,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.7),
                border: Border.all(
                  color: const Color(0xffE5E9EF),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 23, right: 16, top: 3),
                child: TextFormField(
                  style: pSemiBold20.copyWith(fontSize: 25),
                  controller: TextEditingController(text: authController.weight.value),
                  onChanged: (value) {
                    authController.weight(value);
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(getRegexString())),
                    TextInputFormatter.withFunction(
                          (oldValue, newValue) => newValue.copyWith(
                        text: newValue.text.replaceAll('.', ','),
                      ),
                    ),
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              "kg",
              style: pRegular14.copyWith(
                fontSize: 15,
              ),
            ),
          ],
        )
      ],
    );
  }
}
