import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../config/colors.dart';
import '../config/images.dart';
import '../config/text_style.dart';

class CustomCard extends StatelessWidget {
  final String text1;
  final String text2;
  final String image;
  const CustomCard(
      {Key? key, required this.text1, required this.text2, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 77,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.7),
          border: Border.all(
            color: const Color(0xffE5E9EF),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Container(
                height: 61,
                width: 61,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      image,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text1,
                    style: pSemiBold18.copyWith(
                      fontSize: 15.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    text2,
                    style: pRegular14.copyWith(
                      fontSize: 13.47,
                      color: ConstColors.lightBlackColor,
                    ),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: SizedBox(
                  height: 19.25,
                  width: 19.25,
                  child: SvgPicture.asset(
                    DefaultImages.error,
                    fit: BoxFit.fill,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
