import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sidekick_app/config/colors.dart';
import 'package:sidekick_app/config/text_style.dart';

import 'package:sidekick_app/controller/nutrition_controller.dart';
import 'package:sidekick_app/main.dart';
import 'package:sidekick_app/models/nutrition.dart';
import 'package:sidekick_app/view/nutrition/add_meal.dart';
import 'package:sidekick_app/view/nutrition/edit_meal.dart';

enum SampleItem { itemOne, itemTwo }

class NutritionPeriod extends StatefulWidget {
  NutritionPeriod({
    Key? key,
    required this.date,
    required this.callbackPeriod,
    required this.nutritionData,
    required this.period,
    required this.updateNutritionCallback,
  }) : super(key: key);

  final String date;
  final Function callbackPeriod;
  final Nutrition nutritionData;
  String period;
  final Function updateNutritionCallback;

  @override
  State<NutritionPeriod> createState() => _NutritionPeriodState();
}

class _NutritionPeriodState extends State<NutritionPeriod> {
  late Future<Nutrition> futureNutrition;

  int getId = 0;

  final nutritionController = Get.put(NutritionController(), permanent: true);

  @override
  void initState() {
    super.initState();
    futureNutrition = nutritionController.fetchNutrition("${widget.date}Z");
  }

  void updateNutritionData() {
    setState(() {
      futureNutrition = nutritionController.fetchNutrition("${widget.date}Z");
    });
  }

  void updatePeriod(String newPeriod) {
    setState(() {
      widget.period = newPeriod;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: ConstColors.blackColor,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: () {
              Get.to(
                () => AddMeal(
                  updateNutritionCallback: widget.updateNutritionCallback,
                  updateNutritionData: updateNutritionData,
                ),
                transition: Transition.rightToLeft,
              );
            },
            child: Container(
              width: width * 0.13,
              height: height * 0.05,
              decoration: BoxDecoration(
                color: ConstColors.primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 28.0,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: width * 0.03,
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [],
            ),
          ),
          SizedBox(height: height * 0.01),
          SizedBox(
            height: height * 0.03,
          ),
          CategoryWidget(
            period: widget.period,
            updatePeriod: updatePeriod,
            width: width,
            height: height,
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
                  period: widget.period,
                  callbackPeriod: widget.callbackPeriod,
                  updateNutritionCallback: widget.updateNutritionCallback,
                  updateNutritionData: updateNutritionData,
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(child: CircularProgressIndicator(color: ConstColors.primaryColor));
            },
          )
        ],
      ),
    );
  }
}

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({
    super.key,
    required this.period,
    required this.updatePeriod,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;
  final String period;
  final Function(String) updatePeriod;

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  late int selectedCategoryIndex;
  List<String> categories = ['Petit déjeuner', 'Déjeuner', 'Dîner', 'Collation'];
  List<String> setCategories = ['breakfast', 'lunch', 'dinners', 'snacks'];

  @override
  void initState() {
    super.initState();
    setSelectedCategoryIndex();
  }

  void setSelectedCategoryIndex() {
    switch (widget.period) {
      case "breakfast":
        selectedCategoryIndex = 0;
        break;
      case "lunch":
        selectedCategoryIndex = 1;
        break;
      case "dinners":
        selectedCategoryIndex = 2;
        break;
      case "snacks":
        selectedCategoryIndex = 3;
        break;
      default:
        selectedCategoryIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.width * 0.96,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(15.41),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(categories.length, (index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedCategoryIndex = index;
                  widget.updatePeriod(setCategories[index]);
                  getIt<MealEditorBlock>().setPeriod(setCategories[index]);
                });
              },
              child: Container(
                width: widget.width * 0.24,
                height: widget.height * 0.04,
                decoration: BoxDecoration(
                  color: selectedCategoryIndex == index ? ConstColors.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(15.41),
                ),
                child: Center(
                  child: Text(
                    categories[index],
                    style: pRegular14.copyWith(
                      fontSize: 12,
                      color: selectedCategoryIndex == index ? ConstColors.secondaryColor : ConstColors.blackColor,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class MealViewBuilder extends StatefulWidget {
  const MealViewBuilder({
    super.key,
    required this.width,
    required this.height,
    required this.nutritionData,
    required this.period,
    required this.callbackPeriod,
    required this.updateNutritionCallback,
    required this.updateNutritionData,
  });

  final double width;
  final double height;
  final Nutrition nutritionData;
  final String period;
  final Function callbackPeriod;
  final Function updateNutritionCallback;
  final Function updateNutritionData;

  @override
  State<MealViewBuilder> createState() => _MealViewBuilderState();
}

class _MealViewBuilderState extends State<MealViewBuilder> {
  late Nutrition nutritionData;

  @override
  void initState() {
    super.initState();
    nutritionData = widget.nutritionData;
  }

  callback(Nutrition meals) {
    setState(() {
      nutritionData = meals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.nutritionData.meals[widget.period]!["meals"].length == 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: widget.width,
                height: widget.height * 0.4,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Aucun aliment pour ce repas...",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: widget.width * widget.height * 0.00005),
                      ),
                      SizedBox(
                        height: widget.height * 0.05,
                      ),
                      const Text(
                        "🍴",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 70),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : SizedBox(
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
                                food: widget.nutritionData.meals[widget.period]!["meals"][index],
                                period: "breakfast",
                                callback: callback,
                                nutritionData: widget.nutritionData,
                                updateNutritionCallback: widget.updateNutritionCallback,
                                updateNutritionData: widget.updateNutritionData,
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
    required this.food,
    required this.period,
    required this.callback,
    required this.nutritionData,
    required this.updateNutritionCallback,
    required this.updateNutritionData,
  });

  final double width;
  final double height;
  final Color color;
  final Food food;
  final String period;
  final Function callback;
  final Nutrition nutritionData;
  final Function updateNutritionCallback;
  final Function updateNutritionData;

  @override
  State<MealPeriodCard> createState() => _MealPeriodCardState();
}

class _MealPeriodCardState extends State<MealPeriodCard> {
  SampleItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    int totalMacros = widget.food.carbs + widget.food.protein + widget.food.fat;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: const Color.fromARGB(66, 128, 128, 128),
        ),
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
              SizedBox(
                width: widget.width * 0.15,
                height: widget.height * 0.07,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image(
                      image: NetworkImage(widget.food.picture),
                      width: widget.width * 0.15,
                      height: widget.height * 0.15,
                    ),
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
                            "${widget.food.calories} kcal • ${widget.food.weight} g",
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
                  color: Colors.white,
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
                  onSelected: (String choice) async {
                    if (choice == 'Modifier') {
                      Get.to(
                        EditMeal(
                          food: widget.food,
                          callback: widget.callback,
                          nutritionData: widget.nutritionData,
                          updateNutritionCallback: widget.updateNutritionCallback,
                          updateNutritionData: widget.updateNutritionData,
                        ),
                        transition: Transition.rightToLeft,
                      );
                      setState(() {});
                      await widget.updateNutritionCallback();
                      await widget.updateNutritionData();
                    } else if (choice == 'Supprimer') {
                      await getIt<MealEditorBlock>().deleteMeal(widget.food.id, context);
                      await widget.updateNutritionCallback();
                      await widget.updateNutritionData();
                      setState(() {});
                      Get.snackbar('Succès', 'Aliment supprimé avec succès !',
                          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white, duration: const Duration(seconds: 1));
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
