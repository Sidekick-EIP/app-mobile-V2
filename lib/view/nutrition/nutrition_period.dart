import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/controller/home_controller.dart';
import 'package:sidekick_app/controller/nutrition_controller.dart';
import 'package:sidekick_app/controller/user_controller.dart';
import 'package:sidekick_app/models/nutrition.dart';

class NutritionPeriod extends StatefulWidget {
  const NutritionPeriod({Key? key}) : super(key: key);

  @override
  State<NutritionPeriod> createState() => _NutritionViewState();
}

class _NutritionViewState extends State<NutritionPeriod> {
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
            padding: const EdgeInsets.only(left: 0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: width * 0.22,
                  height: height * 0.04,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 198, 198, 198),
                    borderRadius: BorderRadius.circular(24),
                  ),
                )
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
              const CategoryWidget(),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [],
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        children: [],
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
                MealPeriodCard(
                  width: width,
                  height: height,
                  color: Colors.green,
                  colorAccent: Colors.greenAccent,
                  mealPeriodName: "Petit déjeuner   ",
                  emojiImg: "🍳",
                  nutritionData: nutritionData,
                  period: "breakfast",
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                MealPeriodCard(
                  width: width,
                  height: height,
                  color: Colors.orange,
                  colorAccent: const Color.fromARGB(255, 255, 203, 136),
                  mealPeriodName: "Déjeuner   ",
                  emojiImg: "🍝",
                  nutritionData: nutritionData,
                  period: "lunch",
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                MealPeriodCard(
                  width: width,
                  height: height,
                  color: Colors.blue,
                  colorAccent: const Color.fromARGB(255, 159, 194, 255),
                  mealPeriodName: "Dinner   ",
                  emojiImg: "🥗",
                  nutritionData: nutritionData,
                  period: "dinner",
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                MealPeriodCard(
                  width: width,
                  height: height,
                  color: Colors.red,
                  colorAccent: const Color.fromARGB(255, 255, 147, 147),
                  mealPeriodName: "Snacks   ",
                  emojiImg: "🥪",
                  nutritionData: nutritionData,
                  period: "snacks",
                ),
              ],
            ))
      ],
    );
  }
}

class MealPeriodCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 231, 231, 231),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      width: width * 0.85,
      height: height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: width * 0.15,
            height: height * 0.07,
            decoration: BoxDecoration(
              color: colorAccent,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: Text(
                emojiImg,
                style: const TextStyle(fontSize: 35),
              ),
            ),
          ),
          SizedBox(
            width: width * 0.5,
            height: height * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      mealPeriodName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "300 Cal",
                      // nutritionData.meals[period].calories,
                      style: TextStyle(
                          color: color,
                          height: 0.9,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          background: Paint()
                            ..strokeWidth = 12.0
                            ..color = colorAccent
                            ..style = PaintingStyle.stroke
                            ..strokeJoin = StrokeJoin.round),
                    )
                  ],
                ),
                Text(
                  "${nutritionData.meals[period]?.length.toString()} aliments ont été ajouté",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(
            width: width * 0.1,
            height: height * 0.1,
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

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  int selectedCategoryIndex = 0;

  // Define your category names
  List<String> categories = ['Category 1', 'Category 2', 'Category 3', 'Category 4'];

  // Store the previous selected index for the animation
  int previousCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(categories.length, (index) {
        return InkWell(
          onTap: () {
            setState(() {
              previousCategoryIndex = selectedCategoryIndex;
              selectedCategoryIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12.0),
            color: index == selectedCategoryIndex ? Colors.blue : Colors.grey,
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
