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

class EditMeal extends StatefulWidget {
  const EditMeal({Key? key}) : super(key: key);

  @override
  State<EditMeal> createState() => _EditMealState();
}

class _EditMealState extends State<EditMeal> {
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
                      Navigator.pop(context);
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
              Column(
                children: [
                  SizedBox(
                    width: width * 0.7,
                    height: height * 0.34,
                    child: const Column(
                      children: [
                        Image(
                          image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              MealNameWidget(width: width, height: height),
              MacrosCard(
                width: width,
                height: height,
                macrosName: "Glucides",
                image: "🥗",
                macrosValue: "20g",
                progressColor: const Color.fromARGB(255, 98, 7, 255),
              ),
              MacrosCard(
                width: width,
                height: height,
                macrosName: "Proteines",
                image: "🍳",
                macrosValue: "30g",
                progressColor: Colors.red,
              ),
              MacrosCard(
                width: width,
                height: height,
                macrosName: "Lipides",
                image: "🍙",
                macrosValue: "50g",
                progressColor: Colors.amber,
              ),
              WeightValues(width: width, height: height),
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
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
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
                  child: const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Slice of pineapple",
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.15,
                  height: height * 0.06,
                  child: const Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "100g",
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
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
                  width: width * 0.75,
                  height: height * 0.6,
                  child: const Text(
                    "Valeurs nutritionelles",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  width: width * 0.15,
                  height: height * 0.06,
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "457 Kcal",
                      style: TextStyle(color: Colors.grey),
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
  });

  final double width;
  final double height;
  final String macrosName;
  final String image;
  final String macrosValue;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
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
                  child: Text(
                    image,
                    style: const TextStyle(fontSize: 25),
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
                      macrosValue,
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
                      percent: 0.8,
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

class WeightValues extends StatelessWidget {
  const WeightValues({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height * 0.15,
        child: Column(
          children: [
            SizedBox(
              height: height * .13,
              width: width * .95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: const Color.fromARGB(255, 230, 230, 230),
                      ),
                      width: width * .43,
                      height: height * .07,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: width * .1,
                            height: height * .057,
                            child: IconButton(
                              padding: const EdgeInsets.only(bottom: 13),
                              color: const Color.fromARGB(255, 0, 0, 0),
                              icon: const Icon(
                                Icons.minimize,
                              ),
                              onPressed: () => {
                                // if (widget.showResult.quantity > 10)
                                //   {
                                //     setState(() => {widget.showResult.quantity -= 10}),
                                //     widget.quantityUpdater(widget.showResult.quantity)
                                //   }
                              },
                            ),
                          ),
                          SizedBox(
                            width: width * .12,
                            child: Text(
                              "100 g",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 0, 0), fontSize: width * .04),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: width * .1,
                            height: height * .057,
                            child: IconButton(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              icon: const Icon(
                                Icons.add,
                              ),
                              onPressed: () => {
                                // if (widget.showResult.quantity < 990)
                                //   {
                                //     setState(() => {widget.showResult.quantity += 10}),
                                //     widget.quantityUpdater(widget.showResult.quantity)
                                //   }
                              },
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    width: width * .4,
                    height: height * .07,
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
                        // widget.callback(widget.showResult.kcalories, widget.showResult.quantity, widget.index);

                        var snackBar = const SnackBar(
                          content: Text(" modifié"),
                        );

                        // widget.showResult.kcalories * widget.showResult.quantity;
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Appliquer',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * .05, color: const Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * .02),
          ],
        ));
  }
}
