import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../config/colors.dart';
import '../config/images.dart';
import '../config/text_style.dart';

class SearchField extends StatelessWidget {
  final String text;
  final TextEditingController textEditingController;
  const SearchField(
      {Key? key, required this.text, required this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.7),
        border: Border.all(
          color: const Color(0xffDAE0E8),
          width: 1.5,
        ),
      ),
      child: TextFormField(
        controller: textEditingController,
        style: pSemiBold18.copyWith(
          fontSize: 13,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 17),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SvgPicture.asset(
              DefaultImages.search,
            ),
          ),
          border: InputBorder.none,
          hintText: text,
          hintStyle: pRegular14.copyWith(
            fontSize: 12,
            color: ConstColors.lightBlackColor,
          ),
        ),
      ),
    );
  }
}
