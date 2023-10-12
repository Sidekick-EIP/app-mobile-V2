import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sidekick_app/config/colors.dart';
import 'package:sidekick_app/config/images.dart';
import 'package:sidekick_app/config/text_style.dart';
import 'package:sidekick_app/controller/home_controller.dart';

class NutritionView extends StatefulWidget {
  const NutritionView({Key? key}) : super(key: key);

  @override
  State<NutritionView> createState() => _NutritionViewState();
}

class _NutritionViewState extends State<NutritionView> {
  final homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + 20),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Nutrition",
                style: pSemiBold20.copyWith(
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 69.36,
          width: Get.width,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 20),
            itemCount: 8,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GetX<HomeController>(
                init: homeController,
                builder: (homeController) => InkWell(
                  onTap: () {
                    for (var i = 0; i < homeController.activityList.length; i++) {
                      if (i == index) {
                        homeController.activityList[i] = true;
                      } else {
                        homeController.activityList[i] = false;
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                      height: 69.36,
                      width: 61.65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.71),
                        color: homeController.activityList[index] == true ? ConstColors.primaryColor : ConstColors.secondaryColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xffEAF0F6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            index == 0
                                ? "12"
                                : index == 1
                                    ? "13"
                                    : index == 2
                                        ? "14"
                                        : index == 3
                                            ? "15"
                                            : index == 4
                                                ? "16"
                                                : index == 5
                                                    ? "17"
                                                    : index == 6
                                                        ? "18"
                                                        : "19",
                            style: pSemiBold18.copyWith(
                              fontSize: 19.27,
                              color: homeController.activityList[index] == true ? ConstColors.secondaryColor : ConstColors.blackColor,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "Nov",
                            style: pSemiBold18.copyWith(
                              fontSize: 11.56,
                              color: homeController.activityList[index] == true ? ConstColors.secondaryColor : ConstColors.lightBlackColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.05,
                      top: height * 0.01,
                      right: width * 0.05,
                      bottom: height * 0.01,
                    ),
                    child: Container(
                      height: 220,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 225, 225, 225),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  top: 0,
                                  child: CircularPercentIndicator(
                                    radius: 97,
                                    lineWidth: 8,
                                    animation: true,
                                    percent: 0.3,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: const Color.fromARGB(255, 243, 123, 3),
                                    backgroundColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
                                    center: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(255, 109, 188, 70),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color.fromARGB(255, 211, 211, 211),
                                          ),
                                          child: const Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Disponibles"),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "test",
                                                  style: TextStyle(fontSize: 26),
                                                ),
                                              ),
                                              Text("kcal")
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: width * 0.01),
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Glucides",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 98, 7, 255),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                        child: LinearPercentIndicator(
                                          padding: EdgeInsets.zero,
                                          backgroundColor: Colors.white.withOpacity(0.2),
                                          progressColor: Colors.white,
                                          percent: 0.3,
                                        ),
                                      ),
                                      const Text(
                                        "test",
                                        // / 329g
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Proteines",
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                        child: LinearPercentIndicator(padding: EdgeInsets.zero, backgroundColor: Colors.white.withOpacity(0.2), progressColor: Colors.white, percent: 0.3),
                                      ),
                                      const Text(
                                        "test",
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Lipides",
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                        child: LinearPercentIndicator(padding: EdgeInsets.zero, backgroundColor: Colors.white.withOpacity(0.2), progressColor: Colors.white, percent: 0.3),
                                      ),
                                      const Text(
                                        "test",
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              graph(
                                "Ingérées",
                                DefaultImages.i1,
                                DefaultImages.graph1,
                                const Color(0xffEFF7FF),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            children: [
                              graph(
                                "Calories",
                                DefaultImages.i4,
                                DefaultImages.graph1,
                                const Color(0xffFFEFDD),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        SizedBox(width: width * 0.05),
                      ],
                    ),
                  ),
                  TodaysMeals(width: width, height: height),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget graph(String text1, String image, String graph, Color color) {
    return Container(
      height: 161.83,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 234, 234, 234),
        borderRadius: BorderRadius.circular(7.71),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffEAF0F6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text1,
                  style: pSemiBold18.copyWith(
                    fontSize: 13.49,
                  ),
                ),
                Container(
                  height: 30.82,
                  width: 30.82,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(7.71),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.asset(
                      image,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 110.04,
              width: 110.04,
              child: Image.asset(
                graph,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodaysMeals extends StatelessWidget {
  const TodaysMeals({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: width * 0.85,
          height: height * 0.06,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Repas du jour",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                "Voir tous les repas >",
                style: TextStyle(color: Colors.purple),
              ),
            ],
          ),
        ),
        SizedBox(
            width: width,
            height: height * 0.5,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: width * 0.85,
                  height: height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: width * 0.15,
                        height: height * 0.1,
                        color: Colors.amber,
                      ),
                      Container(
                        width: width * 0.5,
                        height: height * 0.1,
                        color: Colors.pink,
                      ),
                      Container(
                        width: width * 0.1,
                        height: height * 0.1,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 244, 235, 54),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: width * 0.85,
                  height: height * 0.1,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 67, 244, 54),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: width * 0.85,
                  height: height * 0.1,
                ),
              ],
            ))
      ],
    );
  }
}
