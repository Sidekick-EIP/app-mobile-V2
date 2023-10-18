import 'dart:developer';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sidekick_app/config/colors.dart';
import 'package:sidekick_app/config/text_style.dart';
import 'package:sidekick_app/controller/home_controller.dart';
import 'package:sidekick_app/controller/nutrition_controller.dart';
import 'package:sidekick_app/controller/user_controller.dart';
import 'package:sidekick_app/models/nutrition.dart';
import 'package:sidekick_app/view/nutrition/nutrition_period.dart';

class NutritionView extends StatefulWidget {
  const NutritionView({Key? key}) : super(key: key);

  @override
  State<NutritionView> createState() => _NutritionViewState();
}

class _NutritionViewState extends State<NutritionView> {
  late Future<Nutrition> futureNutrition;
  final userController = Get.find<UserController>();

  final nutritionController = Get.put(NutritionController(), permanent: true);
  String getDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0).toIso8601String();

  @override
  void initState() {
    super.initState();
    futureNutrition = nutritionController.fetchNutrition("${getDate}Z");
  }

  void updateDate(String newDate) {
    setState(() {
      getDate = newDate;
      futureNutrition = nutritionController.fetchNutrition("${getDate}Z");
    });
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bonjour ${userController.user.value.firstname}",
                style: pSemiBold20.copyWith(
                  fontSize: 12,
                ),
              ),
              Text(
                "Bon Appétit !",
                style: pSemiBold20.copyWith(
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: height * 0.15,
          width: Get.width,
          child: ListView.builder(
            itemCount: 8,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                  width: width,
                  height: height,
                  child: CalendarTimeline(
                    initialDate: DateTime(DateTime.parse(getDate).year, DateTime.parse(getDate).month, DateTime.parse(getDate).day),
                    firstDate: DateTime(2020, 1, 15),
                    lastDate: DateTime(2025, 11, 20),
                    onDateSelected: (date) => updateDate(date.toIso8601String()),
                    leftMargin: 20,
                    monthColor: Colors.blueGrey,
                    dayColor: Colors.teal[200],
                    activeDayColor: Colors.white,
                    activeBackgroundDayColor: const Color.fromRGBO(242, 93, 41, 1),
                    dotsColor: const Color(0xFF333A47),
                    locale: 'en_ISO',
                  ));
            },
          ),
        ),
        SizedBox(height: height * 0.01),
        FutureBuilder<Nutrition>(
          future: futureNutrition,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DisplayNutritionPage(width: width, height: height, nutritionData: snapshot.data!, date: getDate);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          },
        )
      ],
    );
  }
}

class DisplayNutritionPage extends StatefulWidget {
  DisplayNutritionPage({super.key, required this.width, required this.height, required this.nutritionData, required this.date});

  final double width;
  final double height;
  late Nutrition nutritionData;
  final String date;

  @override
  State<DisplayNutritionPage> createState() => _DisplayNutritionPageState();
}

class _DisplayNutritionPageState extends State<DisplayNutritionPage> {
  callbackPeriod(Nutrition meals) {
    setState(() {
      print("callbackkkk");
      widget.nutritionData = meals;
      print(widget.nutritionData.calories);
      print(meals.calories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: widget.width * 0.05, top: widget.height * 0.01, right: widget.width * 0.05, bottom: widget.height * 0.01),
                child: Container(
                  height: 220,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 243, 243, 243),
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
                                radius: 85,
                                lineWidth: 12,
                                animation: true,
                                percent: widget.nutritionData.carbs > 200 ? 1 : widget.nutritionData.carbs / 200,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: const Color.fromARGB(255, 98, 7, 255),
                                backgroundColor: const Color.fromARGB(255, 207, 207, 207).withOpacity(0.2),
                                center: CircularPercentIndicator(
                                  radius: 65,
                                  lineWidth: 12,
                                  animation: true,
                                  percent: widget.nutritionData.protein > 129 ? 1 : widget.nutritionData.protein / 129,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: Colors.red,
                                  backgroundColor: const Color.fromARGB(255, 207, 207, 207).withOpacity(0.2),
                                  center: CircularPercentIndicator(
                                    radius: 45,
                                    lineWidth: 12,
                                    animation: true,
                                    percent: widget.nutritionData.fat > 50 ? 1 : widget.nutritionData.fat / 50,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.amber,
                                    backgroundColor: const Color.fromARGB(255, 207, 207, 207).withOpacity(0.2),
                                    center: const Padding(
                                      padding: EdgeInsets.all(16.0),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: widget.width * 0.01),
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          child: Column(
                            children: [
                              SizedBox(
                                height: widget.height * 0.03,
                              ),
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
                                    Text(
                                      "${widget.nutritionData.carbs.toString()} / 200 g",
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                                    Text(
                                      "${widget.nutritionData.protein.toString()} / 129 g",
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                                    Text(
                                      "${widget.nutritionData.fat.toString()} / 50 g",
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                          Container(
                            width: widget.width,
                            height: widget.height * 0.26,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 243, 243, 243),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  top: 0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text(
                                            "Restants",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                          ),
                                          SizedBox(
                                            width: widget.width * 0.01,
                                          ),
                                          Container(
                                            width: widget.width * 0.1,
                                            height: widget.height * 0.045,
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(255, 118, 199, 140),
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "🍽️",
                                                style: TextStyle(fontSize: 25),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: widget.height * 0.02,
                                      ),
                                      CircularPercentIndicator(
                                        radius: 60,
                                        lineWidth: 12,
                                        animation: true,
                                        percent: widget.nutritionData.calories > 2100 ? 0.0 : ((2100 - widget.nutritionData.calories) / 2100),
                                        circularStrokeCap: CircularStrokeCap.round,
                                        progressColor: const Color.fromARGB(255, 0, 193, 51),
                                        backgroundColor: const Color.fromARGB(255, 200, 200, 200).withOpacity(0.2),
                                        center: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              (2100 - widget.nutritionData.calories).toString(),
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                            const Text(
                                              "KCal",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 20,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: widget.width,
                            height: widget.height * 0.26,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 243, 243, 243),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  top: 0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text(
                                            "Brulées",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                          ),
                                          SizedBox(
                                            width: widget.width * 0.01,
                                          ),
                                          Container(
                                            width: widget.width * 0.1,
                                            height: widget.height * 0.045,
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(255, 197, 116, 116),
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "🔥",
                                                style: TextStyle(fontSize: 25),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: widget.height * 0.02,
                                      ),
                                      CircularPercentIndicator(
                                        radius: 60,
                                        lineWidth: 12,
                                        animation: true,
                                        percent: 0.3,
                                        circularStrokeCap: CircularStrokeCap.round,
                                        progressColor: const Color.fromARGB(255, 241, 56, 42),
                                        backgroundColor: const Color.fromARGB(255, 180, 180, 180).withOpacity(0.2),
                                        center: const Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "300",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                            Text(
                                              "KCal",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 20,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: widget.height * 0.015,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    SizedBox(width: widget.width * 0.05),
                  ],
                ),
              ),
              TodaysMeals(
                width: widget.width,
                height: widget.height,
                nutritionData: widget.nutritionData,
                date: widget.date,
                callbackPeriod: callbackPeriod,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TodaysMeals extends StatefulWidget {
  const TodaysMeals({
    super.key,
    required this.width,
    required this.height,
    required this.nutritionData,
    required this.date,
    required this.callbackPeriod,
  });

  final double width;
  final double height;
  final Nutrition nutritionData;
  final String date;
  final Function callbackPeriod;

  @override
  State<TodaysMeals> createState() => _TodaysMealsState();
}

class _TodaysMealsState extends State<TodaysMeals> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: widget.width * 0.85,
          height: widget.height * 0.06,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Repas du jour",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NutritionPeriod(date: widget.date, callbackPeriod: widget.callbackPeriod, nutritionData: widget.nutritionData),
                    ),
                  );
                },
                child: const Text(
                  "Voir tous les repas >",
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
            width: widget.width,
            height: widget.height * 0.5,
            child: Column(
              children: [
                MealPeriodCard(
                  width: widget.width,
                  height: widget.height,
                  color: Colors.green,
                  colorAccent: Colors.greenAccent,
                  mealPeriodName: "Petit déjeuner   ",
                  emojiImg: "🍳",
                  nutritionData: widget.nutritionData,
                  period: "breakfast",
                ),
                SizedBox(
                  height: widget.height * 0.01,
                ),
                MealPeriodCard(
                  width: widget.width,
                  height: widget.height,
                  color: Colors.orange,
                  colorAccent: const Color.fromARGB(255, 255, 203, 136),
                  mealPeriodName: "Déjeuner   ",
                  emojiImg: "🍝",
                  nutritionData: widget.nutritionData,
                  period: "lunch",
                ),
                SizedBox(
                  height: widget.height * 0.01,
                ),
                MealPeriodCard(
                  width: widget.width,
                  height: widget.height,
                  color: Colors.blue,
                  colorAccent: const Color.fromARGB(255, 159, 194, 255),
                  mealPeriodName: "Dinner   ",
                  emojiImg: "🥗",
                  nutritionData: widget.nutritionData,
                  period: "dinners",
                ),
                SizedBox(
                  height: widget.height * 0.01,
                ),
                MealPeriodCard(
                  width: widget.width,
                  height: widget.height,
                  color: Colors.red,
                  colorAccent: const Color.fromARGB(255, 255, 147, 147),
                  mealPeriodName: "Snacks   ",
                  emojiImg: "🥪",
                  nutritionData: widget.nutritionData,
                  period: "snacks",
                ),
              ],
            ))
      ],
    );
  }
}

class MealPeriodCard extends StatefulWidget {
  const MealPeriodCard(
      {super.key,
      required this.width,
      required this.height,
      required this.color,
      required this.colorAccent,
      required this.mealPeriodName,
      required this.emojiImg,
      required this.nutritionData,
      required this.period});

  final double width;
  final double height;
  final Color color;
  final Color colorAccent;
  final String mealPeriodName;
  final String emojiImg;
  final Nutrition nutritionData;
  final String period;

  @override
  State<MealPeriodCard> createState() => _MealPeriodCardState();
}

class _MealPeriodCardState extends State<MealPeriodCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 231, 231, 231),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      width: widget.width * 0.85,
      height: widget.height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: widget.width * 0.15,
            height: widget.height * 0.07,
            decoration: BoxDecoration(
              color: widget.colorAccent,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: Text(
                widget.emojiImg,
                style: const TextStyle(fontSize: 35),
              ),
            ),
          ),
          SizedBox(
            width: widget.width * 0.5,
            height: widget.height * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.mealPeriodName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "${widget.nutritionData.meals[widget.period]!["calories"].toString()} Cal",
                      style: TextStyle(
                          color: widget.color,
                          height: 0.9,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          background: Paint()
                            ..strokeWidth = 12.0
                            ..color = widget.colorAccent
                            ..style = PaintingStyle.stroke
                            ..strokeJoin = StrokeJoin.round),
                    )
                  ],
                ),
                Text(
                  "${widget.nutritionData.meals[widget.period]?["meals"]?.length.toString()} aliments ont été ajouté",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(
            width: widget.width * 0.1,
            height: widget.height * 0.1,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ">",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
