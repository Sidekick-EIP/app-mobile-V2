import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sidekick_app/config/colors.dart';
import 'package:sidekick_app/config/images.dart';
import 'package:sidekick_app/config/text_style.dart';
import 'package:sidekick_app/controller/home_controller.dart';
import 'package:sidekick_app/controller/nutrition_controller.dart';
import 'package:sidekick_app/controller/user_controller.dart';
import 'package:sidekick_app/main.dart';
import 'package:sidekick_app/models/nutrition.dart';
import 'package:sidekick_app/models/open_food_fact.dart';

class detailMeal extends StatefulWidget {
  detailMeal({
    super.key,
    required this.showResult,
  });
  ResultSearch showResult;

  @override
  State<detailMeal> createState() => _detailMealState();
}

class _detailMealState extends State<detailMeal> {
  late Future<Nutrition> futureNutrition;
  final userController = Get.find<UserController>();

  final nutritionController = Get.put(NutritionController(), permanent: true);
  String getDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0).toIso8601String();

  @override
  void initState() {
    super.initState();
    futureNutrition = nutritionController.fetchNutrition("${getDate}Z");
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<Nutrition>(
            future: futureNutrition,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return DisplayNutritionPage(
                  width: width,
                  height: height,
                  showResult: widget.showResult,
                );
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

class DisplayNutritionPage extends StatefulWidget {
  DisplayNutritionPage({
    super.key,
    required this.width,
    required this.height,
    required this.showResult,
  });

  final double width;
  final double height;
  ResultSearch showResult;

  @override
  State<DisplayNutritionPage> createState() => _DisplayNutritionPageState();
}

class _DisplayNutritionPageState extends State<DisplayNutritionPage> {
  void updateWeight(int weight) {
    setState(() {
      widget.showResult.quantity = weight;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalMacros = widget.showResult.carbohydrates.toInt() + widget.showResult.proteines.toInt() + widget.showResult.lipides.toInt();
    return Expanded(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          Column(
            children: [
              SizedBox(
                height: widget.height * 0.03,
              ),
              Column(
                children: [
                  SizedBox(
                    width: widget.width * 0.7,
                    height: widget.height * 0.34,
                    child: Column(
                      children: [
                        SizedBox(
                          width: widget.width * 0.7,
                          height: widget.height * 0.34,
                          child: Image(
                            image: NetworkImage(widget.showResult.urlImage),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              MealNameWidget(width: widget.width, height: widget.height, showResult: widget.showResult),
              MacrosCard(
                width: widget.width,
                height: widget.height,
                macrosName: "Glucides",
                image: DefaultImages.carbs,
                macrosValue: "${(widget.showResult.carbohydrates * (widget.showResult.quantity / 100)).toString()}g",
                progressColor: const Color.fromARGB(255, 98, 7, 255),
                percent: widget.showResult.carbohydrates / totalMacros,
              ),
              MacrosCard(
                width: widget.width,
                height: widget.height,
                macrosName: "Proteines",
                image: DefaultImages.proteins,
                macrosValue: "${(widget.showResult.proteines * (widget.showResult.quantity / 100)).toString()}g",
                progressColor: Colors.red,
                percent: widget.showResult.proteines / totalMacros,
              ),
              MacrosCard(
                width: widget.width,
                height: widget.height,
                macrosName: "Lipides",
                image: DefaultImages.fat,
                macrosValue: "${(widget.showResult.lipides * (widget.showResult.quantity / 100)).toString()}g",
                progressColor: Colors.amber,
                percent: widget.showResult.lipides / totalMacros,
              ),
              WeightValues(
                width: widget.width,
                height: widget.height,
                foodWeight: widget.showResult.quantity,
                updateWeight: updateWeight,
                showResult: widget.showResult,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MealNameWidget extends StatelessWidget {
  MealNameWidget({
    super.key,
    required this.width,
    required this.height,
    required this.showResult,
  });

  final double width;
  final double height;
  ResultSearch showResult;

  @override
  Widget build(BuildContext context) {
    var kcalSplit = (showResult.kcalories * (showResult.quantity / 100)).toString().split('.');

    return SizedBox(
      width: width,
      height: height * 0.1,
      child: Column(
        children: [
          SizedBox(
            width: width,
            height: height * 0.06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.75,
                  height: height * 0.6,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      showResult.name,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.15,
                  height: height * 0.06,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "${showResult.quantity.toString()}g",
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: width,
            height: height * 0.04,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.72,
                  height: height * 0.6,
                  child: const Text(
                    "Valeurs nutritionelles",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  width: width * 0.18,
                  height: height * 0.06,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "${kcalSplit[0]} Kcal",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MacrosCard extends StatelessWidget {
  const MacrosCard({
    super.key,
    required this.width,
    required this.height,
    required this.macrosName,
    required this.image,
    required this.macrosValue,
    required this.progressColor,
    required this.percent,
  });

  final double width;
  final double height;
  final String macrosName;
  final String image;
  final String macrosValue;
  final Color progressColor;
  final double percent;

  @override
  Widget build(BuildContext context) {
    var macrosSplit = macrosValue.split('.');

    return SizedBox(
      width: width,
      height: height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: width * 0.15,
            height: height * 0.09,
            child: Center(
              child: Container(
                width: width * 0.12,
                height: height * 0.055,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.6, color: const Color.fromARGB(66, 128, 128, 128)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    image,
                    width: width * 0.08,
                    height: height * 0.04,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                width: width * 0.73,
                height: height * 0.04,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      macrosName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "${macrosSplit[0]}g",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color.fromARGB(255, 120, 120, 120)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: width * 0.78,
                height: height * 0.04,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LinearPercentIndicator(
                      width: width * 0.78,
                      animation: true,
                      lineHeight: 7,
                      animationDuration: 1000,
                      percent: percent,
                      barRadius: const Radius.circular(20),
                      curve: Curves.bounceOut,
                      progressColor: progressColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WeightValues extends StatefulWidget {
  WeightValues({
    super.key,
    required this.width,
    required this.height,
    required this.foodWeight,
    required this.updateWeight,
    required this.showResult,
  });

  final double width;
  final double height;
  late int foodWeight;
  final Function(int) updateWeight;
  ResultSearch showResult;

  @override
  State<WeightValues> createState() => _WeightValuesState();
}

class _WeightValuesState extends State<WeightValues> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height * 0.15,
      child: Column(
        children: [
          SizedBox(
            height: widget.height * .13,
            width: widget.width * .95,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: const Color.fromARGB(255, 230, 230, 230),
                    ),
                    width: widget.width * .43,
                    height: widget.height * .07,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: widget.width * .1,
                          height: widget.height * .057,
                          child: IconButton(
                            padding: const EdgeInsets.only(bottom: 13),
                            color: const Color.fromARGB(255, 0, 0, 0),
                            icon: const Icon(
                              Icons.minimize,
                            ),
                            onPressed: () => {
                              if (widget.foodWeight > 10) {setState(() => widget.foodWeight -= 10), widget.updateWeight(widget.foodWeight)}
                            },
                          ),
                        ),
                        SizedBox(
                          width: widget.width * .12,
                          child: Text(
                            "${widget.foodWeight.toString()} g",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 0, 0), fontSize: widget.width * .04),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: widget.width * .1,
                          height: widget.height * .057,
                          child: IconButton(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            icon: const Icon(
                              Icons.add,
                            ),
                            onPressed: () => {
                              if (widget.foodWeight < 990) {setState(() => widget.foodWeight += 10), widget.updateWeight(widget.foodWeight)}
                            },
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  width: widget.width * .4,
                  height: widget.height * .07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(241, 137, 90, 1),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                      ),
                    ),
                    onPressed: () {
                      postNewMeal(widget.showResult, context);
                      var snackBar = const SnackBar(
                        content: Text("Aliment ajouté"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Get.back();
                      Get.back();
                    },
                    child: Text(
                      'Ajouter',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.width * .05, color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: widget.height * .02),
        ],
      ),
    );
  }
}
