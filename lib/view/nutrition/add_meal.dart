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
import 'package:sidekick_app/main.dart';
import 'package:sidekick_app/models/nutrition.dart';
import 'package:sidekick_app/view/nutrition/add_meal.dart';
import 'package:sidekick_app/view/nutrition/edit_meal.dart';

enum SampleItem { itemOne, itemTwo }

class AddMeal extends StatefulWidget {
  const AddMeal({Key? key}) : super(key: key);

  @override
  State<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
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

  final homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.08),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: width * 0.11,
                  height: height * 0.05,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    border: Border.all(
                      color: const Color.fromARGB(255, 200, 200, 200),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.01),
          FutureBuilder<Nutrition>(
            future: futureNutrition,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return DisplayNutritionPage(width: width, height: height, nutritionData: snapshot.data!);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(child: CircularProgressIndicator());
            },
          )
        ],
      ),
    );
  }
}

class DisplayNutritionPage extends StatelessWidget {
  const DisplayNutritionPage({super.key, required this.width, required this.height, required this.nutritionData});

  final double width;
  final double height;
  final Nutrition nutritionData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          Column(
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              const SearchWidget(),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    SizedBox(width: width * 0.05),
                  ],
                ),
              ),
              TodaysMeals(width: width, height: height, nutritionData: nutritionData),
            ],
          ),
        ],
      ),
    );
  }
}

class TodaysMeals extends StatelessWidget {
  const TodaysMeals({
    super.key,
    required this.width,
    required this.height,
    required this.nutritionData,
  });

  final double width;
  final double height;
  final Nutrition nutritionData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height * 0.05,
        ),
        SizedBox(
            width: width,
            height: height * 0.7,
            child: Column(
              children: [
                MealPeriodCard(
                  width: width,
                  height: height,
                  color: Colors.green,
                  colorAccent: Colors.greenAccent,
                  mealName: "Salade de pates au riz cantonais et a la sauce",
                  emojiImg: "🥗",
                  nutritionData: nutritionData,
                  period: "breakfast",
                ),
                SizedBox(
                  height: height * 0.01,
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
      required this.mealName,
      required this.emojiImg,
      required this.nutritionData,
      required this.period});

  final double width;
  final double height;
  final Color color;
  final Color colorAccent;
  final String mealName;
  final String emojiImg;
  final Nutrition nutritionData;
  final String period;

  @override
  State<MealPeriodCard> createState() => _MealPeriodCardState();
}

class _MealPeriodCardState extends State<MealPeriodCard> {
  SampleItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const EditMeal(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.6, color: const Color.fromARGB(66, 128, 128, 128)),
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        width: widget.width * 0.9,
        height: widget.height * 0.21,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  width: widget.width * 0.66,
                  height: widget.height * 0.1,
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: widget.width * 0.55,
                            height: widget.height * 0.05,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.mealName,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widget.width * 0.55,
                            height: widget.height * 0.02,
                            child: const Text(
                              "390 kcal ° 200 g",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MacrosWidgetCard(
                  width: widget.width,
                  height: widget.height,
                  grams: "40 g",
                  macros: "Glucides",
                  barColor: const Color.fromARGB(255, 98, 7, 255),
                ),
                MacrosWidgetCard(
                  width: widget.width,
                  height: widget.height,
                  grams: "50 g",
                  macros: "Proteines",
                  barColor: Colors.red,
                ),
                MacrosWidgetCard(
                  width: widget.width,
                  height: widget.height,
                  grams: "25 g",
                  macros: "Lipides",
                  barColor: Colors.amber,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MacrosWidgetCard extends StatelessWidget {
  const MacrosWidgetCard({
    super.key,
    required this.width,
    required this.height,
    required this.grams,
    required this.macros,
    required this.barColor,
  });

  final double width;
  final double height;
  final String grams;
  final String macros;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: width * 0.22,
          height: height * 0.1,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.04,
                    height: height * 0.09,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RotatedBox(
                          quarterTurns: -1,
                          child: LinearPercentIndicator(
                            width: height * 0.09,
                            animation: true,
                            lineHeight: 10,
                            animationDuration: 1000,
                            percent: 0.8,
                            barRadius: const Radius.circular(20),
                            curve: Curves.bounceOut,
                            progressColor: barColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: width * 0.16,
                height: height * 0.07,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width * 0.16,
                      height: height * 0.025,
                      child: Text(
                        grams,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.16,
                      height: height * 0.03,
                      child: Text(
                        macros,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
  }
}
