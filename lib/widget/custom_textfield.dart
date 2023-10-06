import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/colors.dart';
import '../config/text_style.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final TextEditingController textEditingController;
  const CustomTextField(
      {Key? key, required this.text, required this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        color: const Color(0xffF8FAFC),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: TextFormField(
          controller: textEditingController,
          style: pSemiBold18.copyWith(
            fontSize: 13,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: text,
            hintStyle: pRegular14.copyWith(
              fontSize: 13,
              color: ConstColors.lightBlackColor,
            ),
          ),
        ),
      ),
    );
  }
}
