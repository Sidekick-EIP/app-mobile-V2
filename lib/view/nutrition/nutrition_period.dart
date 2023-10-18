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

class NutritionPeriod extends StatefulWidget {
  const NutritionPeriod({
    Key? key,
    required this.date,
    required this.callbackPeriod,
    required this.nutritionData,
  }) : super(key: key);

  final String date;
  final Function callbackPeriod;
  final Nutrition nutritionData;
  @override
  State<NutritionPeriod> createState() => _NutritionPeriodState();
}

class _NutritionPeriodState extends State<NutritionPeriod> {
  late Future<Nutrition> futureNutrition;

  String period = "breakfast";
  int getId = 0;

  final nutritionController = Get.put(NutritionController(), permanent: true);

  @override
  void initState() {
    super.initState();
    futureNutrition = nutritionController.fetchNutrition("${widget.date}Z");
  }

  void updatePeriod(String newPeriod) {
    setState(() {
      period = newPeriod;
    });
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
                      // widget.callbackPeriod(widget.nutritionData);
                      Navigator.pop(context);
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddMeal(),
                      ),
                    );
                  },
                  child: Container(
                    width: width * 0.22,
                    height: height * 0.05,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 198, 198, 198),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.add,
                          size: 28.0,
                        ),
                        Icon(
                          Icons.wysiwyg,
                          size: 28.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.01),
          SizedBox(
            height: height * 0.03,
          ),
          CategoryWidget(
            period: period,
            updatePeriod: updatePeriod,
          ),
          SizedBox(height: height * 0.01),
          FutureBuilder<Nutrition>(
            future: futureNutrition,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return MealViewBuilder(
                  width: width,
                  height: height,
                  nutritionData: snapshot.data!,
                  period: period,
                  callbackPeriod: widget.callbackPeriod,
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

class CategoryWidget extends StatefulWidget {
  CategoryWidget({super.key, required this.period, required this.updatePeriod});

  late String period;
  final Function(String) updatePeriod;

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  int selectedCategoryIndex = 0;

  List<String> categories = ['Petit déjeuner', 'Déjeuner', 'Dinner', 'Snacks'];
  List<String> setCategories = ['breakfast', 'lunch', 'dinners', 'snacks'];
  int previousCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(categories.length, (index) {
        return InkWell(
          onTap: () {
            setState(() {
              previousCategoryIndex = selectedCategoryIndex;
              selectedCategoryIndex = index;
              // widget.updatePeriod(setCategories[index]);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12.0),
            color: index == selectedCategoryIndex ? const Color.fromRGBO(242, 93, 41, 1) : Colors.grey,
            child: Text(
              categories[index],
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class MealViewBuilder extends StatefulWidget {
  MealViewBuilder({
    super.key,
    required this.width,
    required this.height,
    required this.nutritionData,
    required this.period,
    required this.callbackPeriod,
  });

  final double width;
  final double height;
  late Nutrition nutritionData;
  final String period;
  final Function callbackPeriod;

  @override
  State<MealViewBuilder> createState() => _MealViewBuilderState();
}

class _MealViewBuilderState extends State<MealViewBuilder> {
  callback(Nutrition meals) {
    setState(() {
      widget.nutritionData = meals;
      print(widget.nutritionData.calories);
      print(meals.calories);
      widget.callbackPeriod(widget.nutritionData);
      print(widget.nutritionData.meals[widget.period]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height * 0.75,
      width: widget.width,
      child: ListView.builder(
          itemCount: widget.nutritionData.meals[widget.period]!["meals"].length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(
                    width: widget.width,
                    height: widget.height * 0.22,
                    child: Column(
                      children: [
                        MealPeriodCard(
                          width: widget.width,
                          height: widget.height,
                          color: Colors.green,
                          colorAccent: Colors.greenAccent,
                          food: widget.nutritionData.meals[widget.period]!["meals"][index],
                          period: "breakfast",
                          callback: callback,
                          nutritionData: widget.nutritionData,
                        ),
                        Container(
                          height: widget.height * 0.01,
                        ),
                      ],
                    ))
              ],
            );
          }),
    );
  }
}

class MealPeriodCard extends StatefulWidget {
  const MealPeriodCard({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.colorAccent,
    required this.food,
    required this.period,
    required this.callback,
    required this.nutritionData,
  });

  final double width;
  final double height;
  final Color color;
  final Color colorAccent;
  final Food food;
  final String period;
  final Function callback;
  final Nutrition nutritionData;

  @override
  State<MealPeriodCard> createState() => _MealPeriodCardState();
}

class _MealPeriodCardState extends State<MealPeriodCard> {
  SampleItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    var kcalSplit = (widget.food.calories * (widget.food.weight / 100)).toString().split('.');

    int totalMacros = widget.food.carbs + widget.food.protein + widget.food.fat;
    return Container(
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
                  child: Image(
                    image: NetworkImage(widget.food.picture),
                    width: widget.width * 0.1,
                    height: widget.height * 0.1,
                  ),
                ),
              ),
              SizedBox(
                width: widget.width * 0.55,
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
                              widget.food.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: widget.width * 0.55,
                          height: widget.height * 0.02,
                          child: Text(
                            "${kcalSplit[0]} kcal • ${widget.food.weight} g",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: widget.width * 0.11,
                height: widget.height * 0.05,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 205, 205, 205),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Modifier',
                      child: Text('Modifier'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Supprimer',
                      child: Text('Supprimer'),
                    ),
                  ],
                  onSelected: (String choice) {
                    if (choice == 'Modifier') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditMeal(
                            food: widget.food,
                            callback: widget.callback,
                            nutritionData: widget.nutritionData,
                          ),
                        ),
                      );
                    } else if (choice == 'Supprimer') {
                      print('Delete chosen');
                    }
                  },
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
                grams: (widget.food.carbs * (widget.food.weight / 100)).toString(),
                macros: "Glucides",
                barColor: const Color.fromARGB(255, 98, 7, 255),
                percent: widget.food.carbs / totalMacros,
              ),
              MacrosWidgetCard(
                width: widget.width,
                height: widget.height,
                grams: (widget.food.protein * (widget.food.weight / 100)).toString(),
                macros: "Proteines",
                barColor: Colors.red,
                percent: widget.food.protein / totalMacros,
              ),
              MacrosWidgetCard(
                width: widget.width,
                height: widget.height,
                grams: (widget.food.fat * (widget.food.weight / 100)).toString(),
                macros: "Lipides",
                barColor: Colors.amber,
                percent: widget.food.fat / totalMacros,
              ),
            ],
          )
        ],
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
    required this.percent,
  });

  final double width;
  final double height;
  final String grams;
  final String macros;
  final Color barColor;
  final double percent;

  @override
  Widget build(BuildContext context) {
    var macrosGramsSplit = grams.split('.');

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
                            percent: percent,
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
                        "${macrosGramsSplit[0]} g",
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
