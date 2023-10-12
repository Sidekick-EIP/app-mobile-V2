import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sidekick_app/config/colors.dart';
import 'package:sidekick_app/config/text_style.dart';
import 'package:sidekick_app/controller/nutrition_controller.dart';
import 'package:sidekick_app/controller/user_controller.dart';
import 'package:sidekick_app/models/nutrition.dart';
import 'package:sidekick_app/view/nutrition/nutrition_period.dart';

import '../../config/images.dart';

class NutritionView extends StatefulWidget {
  const NutritionView({Key? key}) : super(key: key);

  @override
  State<NutritionView> createState() => _NutritionViewState();
}

class _NutritionViewState extends State<NutritionView> {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Nutrition",
                style: pSemiBold20.copyWith(
                  fontSize: 24,
                ),
              ),
              Container(
                height: 38.5,
                width: 38.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.7),
                  border: Border.all(
                    color: const Color(0xffE5E9EF),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    DefaultImages.filter,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.01),
        SizedBox(
          height: height * 0.12,
          width: Get.width,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 20),
            itemCount: 8,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: width,
                height: height,
                child: CalendarTimeline(
                  initialDate: DateTime(
                      DateTime.parse(getDate).year,
                      DateTime.parse(getDate).month,
                      DateTime.parse(getDate).day),
                  firstDate: DateTime(2020, 1, 15),
                  lastDate: DateTime(2025, 11, 20),
                  onDateSelected: (date) => updateDate(date.toIso8601String()),
                  leftMargin: 20,
                  monthColor: Colors.blueGrey,
                  dayColor: ConstColors.lightBlackColor,
                  activeDayColor: ConstColors.secondaryColor,
                  activeBackgroundDayColor: ConstColors.primaryColor,
                  dotsColor: const Color(0xFF333A47),
                  locale: 'fr',
                  dayNameColor: ConstColors.secondaryColor,
                ),
              );
            },
          ),
        ),
        SizedBox(height: height * 0.01),
        FutureBuilder<Nutrition>(
          future: futureNutrition,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DisplayNutritionPage(
                  width: width, height: height, nutritionData: snapshot.data!);
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

class DisplayNutritionPage extends StatelessWidget {
  const DisplayNutritionPage({
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
    return Expanded(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          _buildCircularIndicators(),
          _buildRemainingAndBurntCalories(),
          const SizedBox(height: 15),
          TodaysMeals(
              width: width, height: height, nutritionData: nutritionData),
        ],
      ),
    );
  }

  Padding _buildCircularIndicators() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: height * 0.01),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: ConstColors.secondaryColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            _buildCarbsProteinFatIndicators(),
            const SizedBox(width: 10),
            _buildMacronutrientData(),
          ],
        ),
      ),
    );
  }

  Expanded _buildCarbsProteinFatIndicators() {
    return Expanded(
      flex: 5,
      child: CircularPercentIndicator(
        radius: 85,
        lineWidth: 12,
        animation: true,
        percent: nutritionData.carbs / 200,
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: const Color.fromARGB(255, 98, 7, 255),
        backgroundColor:
            const Color.fromARGB(255, 207, 207, 207).withOpacity(0.2),
        center: CircularPercentIndicator(
          radius: 65,
          lineWidth: 12,
          animation: true,
          percent: nutritionData.protein / 129,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Colors.red,
          backgroundColor:
              const Color.fromARGB(255, 207, 207, 207).withOpacity(0.2),
          center: CircularPercentIndicator(
            radius: 45,
            lineWidth: 12,
            animation: true,
            percent: nutritionData.fat / 50,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.amber,
            backgroundColor:
                const Color.fromARGB(255, 207, 207, 207).withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Expanded _buildMacronutrientData() {
    return Expanded(
      flex: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMacronutrientItem("Glucides", nutritionData.carbs, "200 g",
              const Color.fromARGB(255, 98, 7, 255)),
          _buildMacronutrientItem(
              "Proteines", nutritionData.protein, "129 g", Colors.red),
          _buildMacronutrientItem(
              "Lipides", nutritionData.fat, "50 g", Colors.amber),
        ],
      ),
    );
  }

  Column _buildMacronutrientItem(
      String name, int value, String totalValue, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          "$value / $totalValue",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Padding _buildRemainingAndBurntCalories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          _buildCaloriesContainer("Restantes", (2100 - nutritionData.calories),
              const Color.fromARGB(255, 2, 164, 44), "🍽️"),
          const SizedBox(width: 15),
          _buildCaloriesContainer(
              "Brulées", 300, const Color.fromARGB(255, 241, 56, 42), "🔥"),
        ],
      ),
    );
  }

  Expanded _buildCaloriesContainer(
      String title, int calories, Color color, String emoji) {
    return Expanded(
      child: Container(
        height: height * 0.26,
        decoration: BoxDecoration(
          color: ConstColors.secondaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: pSemiBold18.copyWith(
                    fontSize: 16,
                  ),
                ),
                Container(
                  width: width * 0.1,
                  height: height * 0.045,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 60,
              lineWidth: 12,
              animation: true,
              percent: calories / 2100,
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: color,
              backgroundColor: color.withOpacity(0.2),
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    calories.toString(),
                    style: pSemiBold20.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "KCal",
                    style: pRegular14.copyWith(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
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
    required this.nutritionData,
  });

  final double width;
  final double height;
  final Nutrition nutritionData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        _buildMealsList(),
      ],
    );
  }

  SizedBox _buildHeader(BuildContext context) {
    return SizedBox(
      width: width * 0.85,
      height: height * 0.06,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Repas du jour",
            style: pSemiBold20.copyWith(
              fontSize: 18,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NutritionPeriod(),
                ),
              );
            },
            child: Text(
              "Voir tous les repas",
              style: pRegular14.copyWith(
                fontSize: 12,
                color: ConstColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildMealsList() {
    final mealsData = [
      {
        "colorAccent": const Color.fromARGB(255, 63, 134, 101),
        "mealPeriodName": "Petit déjeuner",
        "emojiImg": "🍳",
        "period": "breakfast",
      },
      {
        "colorAccent": const Color.fromARGB(255, 238, 185, 126),
        "mealPeriodName": "Déjeuner",
        "emojiImg": "🍝",
        "period": "lunch",
      },
      {
        "colorAccent": const Color.fromARGB(255, 92, 125, 173),
        "mealPeriodName": "Diner",
        "emojiImg": "🥗",
        "period": "dinners",
      },
      {
        "colorAccent": const Color.fromARGB(255, 201, 112, 112),
        "mealPeriodName": "Snacks",
        "emojiImg": "🥪",
        "period": "snacks",
      },
    ];

    return SizedBox(
      width: width,
      height: height * 0.5,
      child: Column(
        children: mealsData.map((meal) {
          return Padding(
            padding: EdgeInsets.only(bottom: height * 0.01),
            child: MealPeriodCard(
              width: width,
              height: height,
              color: ConstColors.secondaryColor,
              colorAccent: meal["colorAccent"] as Color,
              mealPeriodName: meal["mealPeriodName"] as String,
              emojiImg: meal["emojiImg"] as String,
              nutritionData: nutritionData,
              period: meal["period"] as String,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class MealPeriodCard extends StatelessWidget {
  const MealPeriodCard({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
    required this.colorAccent,
    required this.mealPeriodName,
    required this.emojiImg,
    required this.nutritionData,
    required this.period,
  }) : super(key: key);

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
        color: ConstColors.secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      width: width * 0.85,
      height: height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEmojiContainer(),
          _buildMealDetails(),
          _buildCaloriesAndIcon(),
        ],
      ),
    );
  }

  Widget _buildEmojiContainer() {
    return Container(
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
    );
  }

  Widget _buildMealDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mealPeriodName,
          style: pSemiBold18.copyWith(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "${nutritionData.meals[period]?["meals"]?.length.toString()} aliments ont été ajouté",
          style: pRegular14.copyWith(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCaloriesAndIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${nutritionData.meals[period]!["calories"].toString()} Cal",
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
        ),
        const SizedBox(width: 15),
        const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xffA9B2BA),
          size: 16,
        ),
      ],
    );
  }
}
