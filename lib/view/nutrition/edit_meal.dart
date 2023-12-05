import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sidekick_app/config/images.dart';
import 'package:sidekick_app/controller/nutrition_controller.dart';
import 'package:sidekick_app/controller/user_controller.dart';
import 'package:sidekick_app/models/nutrition.dart';

class EditMeal extends StatefulWidget {
  const EditMeal({
    super.key,
    required this.food,
    required this.callback,
    required this.nutritionData,
  });

  final Food food;
  final Function callback;
  final Nutrition nutritionData;

  @override
  State<EditMeal> createState() => _EditMealState();
}

class _EditMealState extends State<EditMeal> {
  late Future<Nutrition> futureNutrition;
  final userController = Get.find<UserController>();

  final nutritionController = Get.put(NutritionController(), permanent: true);
  String getDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 0, 0)
      .toIso8601String();

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.08),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      Get.back;
                      // Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  width: width * 0.7,
                  height: height * 0.05,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Détail",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
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
                return DisplayNutritionPage(
                  width: width,
                  height: height,
                  food: widget.food,
                  callback: widget.callback,
                  nutritionData: widget.nutritionData,
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
  const DisplayNutritionPage({
    super.key,
    required this.width,
    required this.height,
    required this.food,
    required this.callback,
    required this.nutritionData,
  });

  final double width;
  final double height;
  final Food food;
  final Function callback;
  final Nutrition nutritionData;

  @override
  State<DisplayNutritionPage> createState() => _DisplayNutritionPageState();
}

class _DisplayNutritionPageState extends State<DisplayNutritionPage> {
  void updateWeight(int weight) {
    setState(() {
      widget.food.weight = weight;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalMacros = widget.food.carbs + widget.food.protein + widget.food.fat;
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
                            image: NetworkImage(widget.food.picture),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              MealNameWidget(
                  width: widget.width,
                  height: widget.height,
                  food: widget.food),
              MacrosCard(
                width: widget.width,
                height: widget.height,
                macrosName: "Glucides",
                image: DefaultImages.carbs,
                macrosValue:
                    "${(widget.food.carbs * (widget.food.weight / 100)).toString()}g",
                progressColor: const Color.fromARGB(255, 98, 7, 255),
                percent: widget.food.carbs / totalMacros,
              ),
              MacrosCard(
                width: widget.width,
                height: widget.height,
                macrosName: "Proteines",
                image: DefaultImages.proteins,
                macrosValue:
                    "${(widget.food.protein * (widget.food.weight / 100)).toString()}g",
                progressColor: Colors.red,
                percent: widget.food.protein / totalMacros,
              ),
              MacrosCard(
                width: widget.width,
                height: widget.height,
                macrosName: "Lipides",
                image: DefaultImages.fat,
                macrosValue:
                    "${(widget.food.fat * (widget.food.weight / 100)).toString()}g",
                progressColor: Colors.amber,
                percent: widget.food.fat / totalMacros,
              ),
              WeightValues(
                width: widget.width,
                height: widget.height,
                foodWeight: widget.food.weight,
                updateWeight: updateWeight,
                callback: widget.callback,
                nutritionData: widget.nutritionData,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MealNameWidget extends StatelessWidget {
  const MealNameWidget({
    super.key,
    required this.width,
    required this.height,
    required this.food,
  });

  final double width;
  final double height;
  final Food food;

  @override
  Widget build(BuildContext context) {
    var kcalSplit = (food.calories * (food.weight / 100)).toString().split('.');

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
                      food.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.15,
                  height: height * 0.06,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "${food.weight.toString()}g",
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 18),
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
                  border: Border.all(
                      width: 1.6,
                      color: const Color.fromARGB(66, 128, 128, 128)),
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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "${macrosSplit[0]}g",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color.fromARGB(255, 120, 120, 120)),
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
  const WeightValues({
    super.key,
    required this.width,
    required this.height,
    required this.foodWeight,
    required this.updateWeight,
    required this.callback,
    required this.nutritionData,
  });

  final double width;
  final double height;
  final int foodWeight;
  final Function(int) updateWeight;
  final Function callback;
  final Nutrition nutritionData;

  @override
  State<WeightValues> createState() => _WeightValuesState();
}

class _WeightValuesState extends State<WeightValues> {
  late int foodWeight;

  @override
  void initState() {
    super.initState();
    foodWeight = widget.foodWeight;
  }

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
                                if (widget.foodWeight > 10)
                                  {
                                    setState(() {
                                      foodWeight -= 10;
                                      widget.updateWeight(foodWeight);
                                    }),
                                  }
                              },
                            ),
                          ),
                          SizedBox(
                            width: widget.width * .12,
                            child: Text(
                              "${widget.foodWeight.toString()} g",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: widget.width * .04),
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
                                if (widget.foodWeight < 990)
                                  {
                                    setState(() {
                                      foodWeight += 10;
                                      widget.updateWeight(foodWeight);
                                    }),
                                  }
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
                        widget.callback(widget.nutritionData);
                        // widget.callback(widget.showResult.kcalories, widget.showResult.quantity, widget.index);

                        // widget.showResult.kcalories * widget.showResult.quantity;

                        var snackBar = const SnackBar(
                          content: Text("Repas modifié"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Get.back();
                      },
                      child: Text(
                        'Appliquer',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: widget.width * .05,
                            color: const Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: widget.height * .02),
          ],
        ));
  }
}
