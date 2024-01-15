import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sidekick_app/config/colors.dart';
import 'package:sidekick_app/config/text_style.dart';
import 'package:sidekick_app/controller/nutrition_controller.dart';
import 'package:sidekick_app/controller/user_controller.dart';
import 'package:sidekick_app/controller/workout_controller.dart';
import 'package:sidekick_app/main.dart';
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

  void updateNutritionData() {
    setState(() {
      futureNutrition = nutritionController.fetchNutrition("${getDate}Z");
    });
  }

  @override
  void initState() {
    super.initState();
    futureNutrition = nutritionController.fetchNutrition("${getDate}Z");
  }

  void updateDate(String newDate) {
    setState(() {
      getDate = newDate;
      getIt<MealEditorBlock>().setSelectedDate(getDate);
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
                    monthColor: const Color.fromARGB(255, 56, 56, 56),
                    dayColor: const Color.fromARGB(255, 0, 0, 0),
                    activeDayColor: Colors.white,
                    activeBackgroundDayColor: const Color.fromRGBO(242, 93, 41, 1),
                    dotsColor: const Color(0xFF333A47),
                    locale: 'fr',
                  ));
            },
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
                nutritionData: snapshot.data!,
                date: getDate,
                updateNutritionCallback: updateNutritionData,
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator(color: ConstColors.primaryColor));
          },
        )
      ],
    );
  }
}

class DisplayNutritionPage extends StatefulWidget {
  const DisplayNutritionPage({
    super.key,
    required this.width,
    required this.height,
    required this.nutritionData,
    required this.date,
    required this.updateNutritionCallback,
  });

  final double width;
  final double height;
  final Nutrition nutritionData;
  final String date;
  final Function updateNutritionCallback;

  @override
  State<DisplayNutritionPage> createState() => _DisplayNutritionPageState();
}

class _DisplayNutritionPageState extends State<DisplayNutritionPage> {
  late Nutrition nutritionData;
  final workoutController = Get.find<WorkoutController>();

  @override
  void initState() {
    super.initState();
    workoutController.getWorkoutCalories(getIt<MealEditorBlock>().selectedDate);
    nutritionData = widget.nutritionData;
  }

  callbackPeriod(Nutrition meals) {
    setState(() {
      nutritionData = meals;
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
                    color: const Color.fromARGB(255, 255, 255, 255),
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
                                percent: widget.nutritionData.carbs > 344 ? 1 : widget.nutritionData.carbs / 344,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: const Color.fromARGB(255, 98, 7, 255),
                                backgroundColor: const Color.fromARGB(255, 207, 207, 207).withOpacity(0.2),
                                center: CircularPercentIndicator(
                                  radius: 65,
                                  lineWidth: 12,
                                  animation: true,
                                  percent: widget.nutritionData.protein > 125 ? 1 : widget.nutritionData.protein / 125,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: Colors.red,
                                  backgroundColor: const Color.fromARGB(255, 207, 207, 207).withOpacity(0.2),
                                  center: CircularPercentIndicator(
                                    radius: 45,
                                    lineWidth: 12,
                                    animation: true,
                                    percent: widget.nutritionData.fat > 69 ? 1 : widget.nutritionData.fat / 69,
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
                                    Text(
                                      "Glucides",
                                      style: pSemiBold20.copyWith(
                                        fontSize: 14,
                                        color: const Color.fromARGB(255, 98, 7, 255),
                                      ),
                                    ),
                                    Text(
                                      "${widget.nutritionData.carbs.toString()} / 344 g",
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Proteines",
                                      style: pSemiBold20.copyWith(
                                        fontSize: 14,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Text(
                                      "${widget.nutritionData.protein.toString()} / 125 g",
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Lipides",
                                      style: pSemiBold20.copyWith(
                                        fontSize: 14,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    Text(
                                      "${widget.nutritionData.fat.toString()} / 69 g",
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
              SizedBox(
                height: widget.height * 0.008,
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
                            height: widget.height * 0.22,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 5,
                                  top: 0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Restantes",
                                            style: pSemiBold18.copyWith(fontSize: 17),
                                          ),
                                          SizedBox(
                                            width: widget.width * 0.01,
                                          ),
                                          Container(
                                            width: widget.width * 0.1,
                                            height: widget.height * 0.045,
                                            decoration: const BoxDecoration(
                                              color: Colors.greenAccent,
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
                                        percent: widget.nutritionData.calories > 2100 ? 1.0 : ((widget.nutritionData.calories) / 2100),
                                        circularStrokeCap: CircularStrokeCap.round,
                                        progressColor: Colors.greenAccent,
                                        backgroundColor: const Color.fromARGB(255, 200, 200, 200).withOpacity(0.2),
                                        center: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              (2100 - widget.nutritionData.calories).toString(),
                                              style: pSemiBold20.copyWith(
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              "KCal",
                                              style: pRegular14.copyWith(fontSize: 16, color: Colors.grey),
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
                            height: widget.height * 0.22,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 5,
                                  top: 0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Brulées",
                                            style: pSemiBold18.copyWith(fontSize: 17),
                                          ),
                                          SizedBox(
                                            width: widget.width * 0.01,
                                          ),
                                          Container(
                                            width: widget.width * 0.1,
                                            height: widget.height * 0.045,
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(255, 255, 147, 147),
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
                                      Obx(() {
                                        if (workoutController.caloriesFetched.isTrue) {
                                          return CircularPercentIndicator(
                                            radius: 60,
                                            lineWidth: 12,
                                            animation: true,
                                            circularStrokeCap: CircularStrokeCap.round,
                                            progressColor: const Color.fromARGB(255, 255, 147, 147),
                                            backgroundColor: const Color.fromARGB(255, 180, 180, 180).withOpacity(0.2),
                                            center: FutureBuilder<int>(
                                              future: workoutController.getWorkoutCalories(getIt<MealEditorBlock>().selectedDate),
                                              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return const Text("Loading...");
                                                } else if (snapshot.hasError) {
                                                  return Text("Error: ${snapshot.error}");
                                                } else {
                                                  double percent = (snapshot.data ?? 0) / 1000;
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        '${snapshot.data}',
                                                        style: pSemiBold20.copyWith(fontSize: 20),
                                                      ),
                                                      Text(
                                                        "KCal",
                                                        style: pRegular14.copyWith(fontSize: 16, color: Colors.grey),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              },
                                            ),
                                            percent: workoutController.caloriesPercent,
                                          );
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      }),
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
                updateNutritionCallback: widget.updateNutritionCallback,
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
    required this.updateNutritionCallback,
  });

  final double width;
  final double height;
  final Nutrition nutritionData;
  final String date;
  final Function callbackPeriod;
  final Function updateNutritionCallback;

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
              Text(
                "Repas du jour",
                style: pSemiBold20.copyWith(fontSize: 20),
              ),
              InkWell(
                onTap: () {
                  Get.to(
                    () => NutritionPeriod(
                      date: widget.date,
                      nutritionData: widget.nutritionData,
                      callbackPeriod: widget.callbackPeriod,
                      period: "breakfast",
                      updateNutritionCallback: widget.updateNutritionCallback,
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Row(
                  children: [
                    Text(
                      "Voir tous les repas ",
                      style: pRegular14.copyWith(fontSize: 12, color: ConstColors.primaryColor),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color.fromRGBO(242, 93, 41, 1),
                      size: 14,
                    ),
                  ],
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
                    color: const Color.fromRGBO(34, 73, 34, 1),
                    colorAccent: const Color.fromARGB(255, 198, 251, 225),
                    mealPeriodName: "Petit déjeuner   ",
                    emojiImg: "🍳",
                    nutritionData: widget.nutritionData,
                    period: "breakfast",
                    date: widget.date,
                    callbackPeriod: widget.callbackPeriod,
                    updateNutritionCallback: widget.updateNutritionCallback),
                SizedBox(
                  height: widget.height * 0.01,
                ),
                MealPeriodCard(
                  width: widget.width,
                  height: widget.height,
                  color: const Color.fromRGBO(87, 87, 87, 1),
                  colorAccent: const Color.fromARGB(255, 255, 223, 182),
                  mealPeriodName: "Déjeuner   ",
                  emojiImg: "🍝",
                  nutritionData: widget.nutritionData,
                  period: "lunch",
                  date: widget.date,
                  callbackPeriod: widget.callbackPeriod,
                  updateNutritionCallback: widget.updateNutritionCallback,
                ),
                SizedBox(
                  height: widget.height * 0.01,
                ),
                MealPeriodCard(
                  width: widget.width,
                  height: widget.height,
                  color: const Color.fromRGBO(6, 50, 86, 1),
                  colorAccent: const Color.fromARGB(255, 199, 220, 255),
                  mealPeriodName: "Dîner   ",
                  emojiImg: "🥗",
                  nutritionData: widget.nutritionData,
                  period: "dinners",
                  date: widget.date,
                  callbackPeriod: widget.callbackPeriod,
                  updateNutritionCallback: widget.updateNutritionCallback,
                ),
                SizedBox(
                  height: widget.height * 0.01,
                ),
                MealPeriodCard(
                  width: widget.width,
                  height: widget.height,
                  color: const Color.fromRGBO(75, 10, 6, 1),
                  colorAccent: const Color.fromARGB(255, 255, 208, 208),
                  mealPeriodName: "Collation   ",
                  emojiImg: "🍓",
                  nutritionData: widget.nutritionData,
                  period: "snacks",
                  date: widget.date,
                  callbackPeriod: widget.callbackPeriod,
                  updateNutritionCallback: widget.updateNutritionCallback,
                ),
              ],
            ))
      ],
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
    required this.mealPeriodName,
    required this.emojiImg,
    required this.nutritionData,
    required this.period,
    required this.date,
    required this.callbackPeriod,
    required this.updateNutritionCallback,
  });

  final double width;
  final double height;
  final Color color;
  final Color colorAccent;
  final String mealPeriodName;
  final String emojiImg;
  final Nutrition nutritionData;
  final String period;
  final String date;
  final Function callbackPeriod;
  final Function updateNutritionCallback;

  @override
  State<MealPeriodCard> createState() => _MealPeriodCardState();
}

class _MealPeriodCardState extends State<MealPeriodCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
          () => NutritionPeriod(
            date: widget.date,
            nutritionData: widget.nutritionData,
            callbackPeriod: widget.callbackPeriod,
            period: widget.period,
            updateNutritionCallback: widget.updateNutritionCallback,
          ),
          transition: Transition.rightToLeft,
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        width: widget.width * 0.9,
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.mealPeriodName,
                        style: pSemiBold18.copyWith(fontSize: 16),
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
                    widget.nutritionData.meals[widget.period]?["meals"]?.length == 1
                        ? "${widget.nutritionData.meals[widget.period]?["meals"]?.length.toString()} aliment a été ajouté"
                        : widget.nutritionData.meals[widget.period]?["meals"]?.length == 0
                            ? "Aucun aliment n'a été ajouté"
                            : "${widget.nutritionData.meals[widget.period]?["meals"]?.length.toString()} aliments ont été ajouté",
                    style: pRegular14.copyWith(fontSize: 12, color: Colors.grey),
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
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xffA9B2BA),
                    size: 16,
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
