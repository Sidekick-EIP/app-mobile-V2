import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/colors.dart';
import '../../config/text_style.dart';
import '../../widget/custom_button.dart';

class FilterView extends StatefulWidget {
  const FilterView({Key? key}) : super(key: key);

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: const BoxDecoration(
        color: ConstColors.secondaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mon sidekick",
                  style: pSemiBold18.copyWith(),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: ConstColors.blackColor,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Category",
                        style: pSemiBold18.copyWith(
                          fontSize: 16.36,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          card(
                            "Stretch",
                            const Color(0xffE5E9EF),
                            Colors.transparent,
                            ConstColors.lightBlackColor,
                          ),
                          const SizedBox(width: 14),
                          card(
                            "Legs",
                            const Color(0xffE5E9EF),
                            ConstColors.primaryColor,
                            ConstColors.secondaryColor,
                          ),
                          const SizedBox(width: 14),
                          card(
                            "Arms",
                            const Color(0xffE5E9EF),
                            Colors.transparent,
                            ConstColors.lightBlackColor,
                          ),
                          const SizedBox(width: 14),
                          card(
                            "Yoga",
                            const Color(0xffE5E9EF),
                            Colors.transparent,
                            ConstColors.lightBlackColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          card(
                            "Boxing",
                            const Color(0xffE5E9EF),
                            Colors.transparent,
                            ConstColors.lightBlackColor,
                          ),
                          const SizedBox(width: 14),
                          card(
                            "Running",
                            const Color(0xffE5E9EF),
                            Colors.transparent,
                            ConstColors.lightBlackColor,
                          ),
                          const SizedBox(width: 14),
                          card(
                            "Personal",
                            const Color(0xffE5E9EF),
                            Colors.transparent,
                            ConstColors.lightBlackColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Price",
                        style: pSemiBold18.copyWith(
                          fontSize: 16.36,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          card(
                            "Free",
                            const Color(0xffE5E9EF),
                            ConstColors.primaryColor,
                            ConstColors.secondaryColor,
                          ),
                          const SizedBox(width: 14),
                          card(
                            "Premium",
                            const Color(0xffE5E9EF),
                            Colors.transparent,
                            ConstColors.lightBlackColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Level",
                        style: pSemiBold18.copyWith(
                          fontSize: 16.36,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          card(
                            "Beginner",
                            const Color(0xffE5E9EF),
                            ConstColors.primaryColor,
                            ConstColors.secondaryColor,
                          ),
                          const SizedBox(width: 14),
                          card(
                            "Medium",
                            const Color(0xffE5E9EF),
                            Colors.transparent,
                            ConstColors.lightBlackColor,
                          ),
                          const SizedBox(width: 14),
                          card(
                            "Advanced",
                            const Color(0xffE5E9EF),
                            Colors.transparent,
                            ConstColors.lightBlackColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Duration",
                        style: pSemiBold18.copyWith(
                          fontSize: 16.36,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          card(
                            "15-20 min",
                            const Color(0xffE5E9EF),
                            ConstColors.primaryColor,
                            ConstColors.secondaryColor,
                          ),
                          const SizedBox(width: 14),
                          card(
                            "20-30 min",
                            const Color(0xffE5E9EF),
                            Colors.transparent,
                            ConstColors.lightBlackColor,
                          ),
                          const SizedBox(width: 14),
                          card(
                            "30-40 min",
                            const Color(0xffE5E9EF),
                            Colors.transparent,
                            ConstColors.lightBlackColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Equipment",
                        style: pSemiBold18.copyWith(
                          fontSize: 16.36,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          card(
                            "Kettlebell",
                            const Color(0xffE5E9EF),
                            Colors.transparent,
                            ConstColors.lightBlackColor,
                          ),
                          const SizedBox(width: 14),
                          card(
                            "Kettlebell",
                            const Color(0xffE5E9EF),
                            Colors.transparent,
                            ConstColors.lightBlackColor,
                          ),
                          const SizedBox(width: 14),
                          card(
                            "Kettlebell",
                            const Color(0xffE5E9EF),
                            Colors.transparent,
                            ConstColors.lightBlackColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: ConstColors.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Center(
                                child: Text(
                                  "Reset",
                                  style: pSemiBold20.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: ConstColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButton(
                              title: "Apply",
                              width: Get.width,
                              onTap: () {},
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget card(String text, Color borderColor, Color bgColor, Color textColor) {
    return Container(
      height: 38.51,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: borderColor,
        ),
        color: bgColor,
        borderRadius: BorderRadius.circular(19.26),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Center(
          child: Text(
            text,
            style: pSemiBold18.copyWith(
              fontSize: 11.55,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
