import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sidekick_app/config/colors.dart';
import 'package:sidekick_app/config/text_style.dart';
import 'package:sidekick_app/controller/home_controller.dart';
import 'package:sidekick_app/models/workout.dart';
import "package:collection/collection.dart";
import 'package:sidekick_app/utils/token_storage.dart';

class TrainingView extends StatefulWidget {
  const TrainingView({Key? key}) : super(key: key);

  @override
  State<TrainingView> createState() => _TrainingViewState();
}

class _TrainingViewState extends State<TrainingView> {
  final homeController = Get.put(HomeController());
  final TokenStorage tokenStorage = TokenStorage();
  List<List<Workout>> workouts = [];

  Future<List<List<Workout>>> getAllWorkouts() async {
    String? accessToken = await tokenStorage.getAccessToken();
    final String apiUrl = "${dotenv.env['API_BACK_URL']}/workouts/";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      List<Workout> workouts = List<Workout>.from(body.map((e) => Workout.fromJSON(e)));
      workouts.sort((a, b) {
        return DateTime.parse(b.date).compareTo(DateTime.parse(a.date));
      });
      var groupByDate = groupBy(workouts, (obj) => obj.date.substring(0, 10));
      return groupByDate.values.toList();
    } else {
    throw Exception('Failed to get workouts');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<List<List<Workout>>> workoutsLate = getAllWorkouts();
    workoutsLate.then((value) {
      workouts = value;
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Mes entrainements",
          style: pSemiBold18.copyWith(
            fontSize: 15.41,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        height: 38.53,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: ConstColors.secondaryColor,
                          borderRadius: BorderRadius.circular(15.41),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff000000).withOpacity(0.04),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ConstColors.primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(15.41),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Historique",
                                        style: pSemiBold18.copyWith(
                                          fontSize: 11.56,
                                          color: ConstColors.secondaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FutureBuilder(
                        future: workoutsLate,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox(
                              height: 1700,
                              child: 
                              ListView.builder(
                                padding: const EdgeInsets.all(5),
                                itemCount: workouts.length,
                                itemBuilder: (context, x) {
                                  return Column(children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat('dd MMM y').format(DateTime.parse(workouts[x][0].date)),
                                          style: pRegular14.copyWith(
                                            fontSize: 11.55,
                                            color: ConstColors.lightBlackColor,
                                          ),
                                        ),
                                        Text(
                                          workouts[x].length == 1 ? "${workouts[x].length} workout" : "${workouts[x].length} workouts",
                                          style: pRegular14.copyWith(
                                            fontSize: 11.55,
                                            color: ConstColors.lightBlackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: 95 * (workouts[x].length + 0.0),
                                      child: ListView.builder(
                                        shrinkWrap: false,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: workouts[x].length,
                                        itemBuilder: (context, y) {
                                          return InkWell(
                                            onTap: () {
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 20),
                                              child: workoutCard(
                                                workouts[x][y].name,
                                                "${workouts[x][y].duration} min",
                                                workouts[x][y].thumbnail,
                                                DateTime.parse(workouts[x][y].date).isBefore(DateTime.now())
                                              ),
                                            ),
                                          );
                                        }
                                      ),
                                    )
                                  ]);
                                }
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text(
                                  "Aucun exercice n'a été enregistré pour le moment"),
                            );
                          }
                        }
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget workoutCard(String text1, String text2, String image, bool passed) {
  return Container(
    height: 76.97,
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(7.7),
      color: ConstColors.secondaryColor,
      boxShadow: const [
        BoxShadow(
          color: Color(0xffEAF0F6),
        )
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 61,
            width: 90,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  image,
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: pSemiBold18.copyWith(
                  fontSize: 15.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                text2,
                style: pRegular14.copyWith(
                  fontSize: 13.49,
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: CircleAvatar(
              radius: 9,
              backgroundColor: passed ? ConstColors.primaryColor : Colors.transparent,
              child: const Icon(
                Icons.check,
                color: ConstColors.secondaryColor,
                size: 10,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
