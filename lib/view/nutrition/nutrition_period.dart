import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sidekick_app/controller/nutrition_controller.dart';
import 'package:sidekick_app/controller/user_controller.dart';
import 'package:sidekick_app/models/nutrition.dart';

class NutritionPeriod extends StatefulWidget {
  const NutritionPeriod({Key? key}) : super(key: key);

  @override
  NutritionPeriodState createState() => NutritionPeriodState();
}

class NutritionPeriodState extends State<NutritionPeriod> {
  late Future<Nutrition> futureNutrition;
  final userController = Get.find<UserController>();
  final nutritionController = Get.put(NutritionController(), permanent: true);
  String getDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toIso8601String();

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
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back()),
        backgroundColor: Colors.transparent,
        elevation: 0.0, // Remove shadow
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.08),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: size.width * 0.22,
                height: size.height * 0.04,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 198, 198, 198),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<Nutrition>(
            future: futureNutrition,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return DisplayNutritionPage(
                  size: size,
                  nutritionData: snapshot.data!,
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

class DisplayNutritionPage extends StatelessWidget {
  const DisplayNutritionPage({
    required this.size,
    required this.nutritionData,
  });

  final Size size;
  final Nutrition nutritionData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          const CategoryWidget(),
          TodaysMeals(size: size, nutritionData: nutritionData),
        ],
      ),
    );
  }
}

class TodaysMeals extends StatelessWidget {
  const TodaysMeals({
    required this.size,
    required this.nutritionData,
  });

  final Size size;
  final Nutrition nutritionData;

  @override
  Widget build(BuildContext context) {
    final mealPeriods = [
      {
        "name": "Petit déjeuner",
        "emoji": "🍳",
        "period": "breakfast",
        "color": Colors.green,
        "colorAccent": Colors.greenAccent
      },
      {
        "name": "Déjeuner",
        "emoji": "🍝",
        "period": "lunch",
        "color": Colors.orange,
        "colorAccent": const Color.fromARGB(255, 255, 203, 136)
      },
      {
        "name": "Dinner",
        "emoji": "🥗",
        "period": "dinner",
        "color": Colors.blue,
        "colorAccent": const Color.fromARGB(255, 159, 194, 255)
      },
      {
        "name": "Snacks",
        "emoji": "🥪",
        "period": "snacks",
        "color": Colors.red,
        "colorAccent": const Color.fromARGB(255, 255, 147, 147)
      },
    ];

    return Column(
      children: [
        SizedBox(
          width: size.width * 0.85,
          height: size.height * 0.06,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Repas du jour",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text("Voir tous les repas >",
                  style: TextStyle(color: Colors.purple)),
            ],
          ),
        ),
        SizedBox(
          width: size.width,
          height: size.height * 0.5,
          child: Column(
            children: mealPeriods.map((meal) {
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: MealPeriodCard(
                  size: size,
                  color: meal["color"] as Color,
                  colorAccent: meal["colorAccent"] as Color,
                  mealPeriodName: meal["name"] as String,
                  emojiImg: meal["emoji"] as String,
                  nutritionData: nutritionData,
                  period: meal["period"] as String,
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}

class MealPeriodCard extends StatelessWidget {
  const MealPeriodCard({
    required this.size,
    required this.color,
    required this.colorAccent,
    required this.mealPeriodName,
    required this.emojiImg,
    required this.nutritionData,
    required this.period,
  });

  final Size size;
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
      width: size.width * 0.85,
      height: size.height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: size.width * 0.15,
            height: size.height * 0.07,
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
            width: size.width * 0.5,
            height: size.height * 0.1,
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
                      "300 Cal", // Replace this with actual data if available
                      style: TextStyle(
                        color: color,
                        height: 0.9,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        background: Paint()
                          ..strokeWidth = 12.0
                          ..color = colorAccent
                          ..style = PaintingStyle.stroke
                          ..strokeJoin = StrokeJoin.round,
                      ),
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
          const Icon(Icons.chevron_right, size: 30.0),
        ],
      ),
    );
  }
}

class CategoryWidget extends StatefulWidget {
  const CategoryWidget();

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  int selectedCategoryIndex = 0;
  List<String> categories = [
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4'
  ];
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
