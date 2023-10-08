import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/colors.dart';
import '../config/text_style.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final TextEditingController textEditingController;
  final bool isPassword;
  final int? minLines;
  final int? maxLines;
  final double? height;

  const CustomTextField({
    Key? key,
    required this.text,
    required this.textEditingController,
    this.isPassword = false,
    this.minLines,
    this.maxLines,
    this.height,
  }) : super(key: key);

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 52, // Use the specified height or default to 52
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        color: const Color(0xffF8FAFC),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: TextFormField(
          controller: widget.textEditingController,
          obscureText: widget.isPassword ? _obscureText : false,
          style: pSemiBold18.copyWith(
            fontSize: 13,
          ),
          minLines: widget.isPassword ? 1 : widget.minLines,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.text,
            hintStyle: pRegular14.copyWith(
              fontSize: 13,
              color: ConstColors.lightBlackColor,
            ),
            suffixIcon: widget.isPassword
                ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
            )
                : null,
          ),
        ),
      ),
    );
  }
}