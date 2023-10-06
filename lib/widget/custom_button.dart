// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../config/colors.dart';
import '../config/text_style.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final double width;
  final VoidCallback onTap;
  final Color? color;
  const CustomButton({Key? key, required this.title, required this.width, required this.onTap, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 52,
        width: width,
        decoration: BoxDecoration(
          color: color ?? ConstColors.primaryColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Color(0xffF25D29).withOpacity(0.20),
            )
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: pSemiBold20.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: ConstColors.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
