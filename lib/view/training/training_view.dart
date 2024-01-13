import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sidekick_app/config/colors.dart';
import 'package:sidekick_app/config/text_style.dart';
import 'package:sidekick_app/controller/workout_controller.dart';
import 'package:sidekick_app/view/training/add_training_view.dart';

import '../../config/images.dart';

class TrainingView extends StatefulWidget {
  const TrainingView({Key? key}) : super(key: key);

  @override
  State<TrainingView> createState() => _TrainingViewState();
}

String getMuscleGroupe(String muscle) {
  switch (muscle) {
    case "CHEST":
      return "poitrine";
    case "BACK":
      return "dos";
    case "CARDIO":
      return "cardio";
    case "CALF":
      return "mollets";
    case "BICEPS":
      return "biceps";
    case "LEGS":
      return "jambes";
    case "TRICEPS":
      return "triceps";
    case "SHOULDERS":
      return "épaules";
    case "GLUTES":
      return "fessier";
    case "ABS":
      return "abdos";
    default:
      return muscle;
  }
}

String getMuscleGroupeReverse(String muscle) {
  switch (muscle) {
    case "poitrine":
      return "Chest";
    case "dos":
      return "BACK";
    case "cardio":
      return "CARDIO";
    case "mollets":
      return "CALF";
    case "biceps":
      return "BICEPS";
    case "jambes":
      return "LEGS";
    case "triceps":
      return "TRICEPS";
    case "épaules":
      return "SHOULDERS";
    case "fessier":
      return "GLUTES";
    case "abdos":
      return "ABS";
    default:
      return muscle;
  }
}

class _TrainingViewState extends State<TrainingView> {
  final workoutController = Get.find<WorkoutController>();

  var page = 0;
  var selectedExercise = -1;
  final allWorkouts = [
    "dos",
    "cardio",
    "épaules",
    "biceps",
    "triceps",
    "mollet",
    "jambes",
    "fessier",
    "abdos"
  ];

  @override
  void initState() {
    super.initState();
    workoutController.getAllWorkouts();
    workoutController.getAllExercices();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 5),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.transparent,
          title: Text(
            "Mes entrainements",
            style: pSemiBold20.copyWith(
              fontSize: 24,
            ),
          ),
        ),
        body: GetX<WorkoutController>(builder: (_) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                              setState(() {
                                page = 0;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: page == 0
                                    ? ConstColors.primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(15.41),
                              ),
                              child: Center(
                                child: Text(
                                  "Recap",
                                  style: pSemiBold18.copyWith(
                                    fontSize: 11.56,
                                    color: page == 0
                                        ? ConstColors.secondaryColor
                                        : ConstColors.blackColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                page = 1;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: page == 1
                                    ? ConstColors.primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(15.41),
                              ),
                              child: Center(
                                child: Text(
                                  "Exercices",
                                  style: pSemiBold18.copyWith(
                                    fontSize: 11.56,
                                    color: page == 1
                                        ? ConstColors.secondaryColor
                                        : ConstColors.blackColor,
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
                page == 1
                    ? Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        height: 50,
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
                          padding: const EdgeInsets.all(4),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedExercise = -1;
                                      workoutController.getAllExercices();
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: selectedExercise == -1
                                          ? ConstColors.lightBlackColor
                                          : Colors.transparent,
                                      borderRadius:
                                          BorderRadius.circular(15.41),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Center(
                                        child: Text(
                                          "tout",
                                          style: pSemiBold18.copyWith(
                                              fontSize: 11.56,
                                              color: selectedExercise == -1
                                                  ? ConstColors.secondaryColor
                                                  : ConstColors.blackColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              for (final (index, item) in allWorkouts.indexed)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedExercise = index;
                                        workoutController.getSpecificExercises(
                                            getMuscleGroupeReverse(item));
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: selectedExercise == index
                                            ? ConstColors.lightBlackColor
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(15.41),
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Center(
                                          child: Text(
                                            item,
                                            style: pSemiBold18.copyWith(
                                                fontSize: 11.56,
                                                color: selectedExercise == index
                                                    ? ConstColors.secondaryColor
                                                    : ConstColors.blackColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(height: 20),
                page == 0
                    ? workoutController.workout.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(DefaultImages.noExerice),
                              const SizedBox(height: 30),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  'Vous n\'avez pas encore d\'exercice dans votre historique.',
                                  textAlign: TextAlign.center,
                                  style: pRegular14.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : (workoutController.workout == []
                            ? const CircularProgressIndicator(
                                color: ConstColors.primaryColor)
                            : Expanded(
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(5),
                                    itemCount: workoutController.workout.length,
                                    itemBuilder: (context, x) {
                                      return Column(children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              DateFormat('dd MMM y').format(
                                                  DateTime.parse(
                                                      workoutController
                                                          .workout[x][0].date)),
                                              style: pRegular14.copyWith(
                                                fontSize: 11.55,
                                                color:
                                                    ConstColors.lightBlackColor,
                                              ),
                                            ),
                                            Text(
                                              workoutController
                                                          .workout[x].length ==
                                                      1
                                                  ? "${workoutController.workout[x].length} workout"
                                                  : "${workoutController.workout[x].length} workouts",
                                              style: pRegular14.copyWith(
                                                fontSize: 11.55,
                                                color:
                                                    ConstColors.lightBlackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          height: (95 *
                                                  (workoutController
                                                      .workout[x].length))
                                              .toDouble(),
                                          child: ListView.builder(
                                              shrinkWrap: false,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: workoutController
                                                  .workout[x].length,
                                              itemBuilder: (context, y) {
                                                return InkWell(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(30),
                                                          topRight: Radius.circular(30),
                                                        ),
                                                      ),
                                                      builder: (v) => FractionallySizedBox(
                                                        heightFactor: 0.9,
                                                        child: AddTraining(
                                                          name: workoutController.workout[x][y].name,
                                                          id: workoutController.workout[x][y].id,
                                                          thumbnail: workoutController.workout[x][y].thumbnail,
                                                          video: workoutController.workout[x][y].video,
                                                          muscle:workoutController.workout[x][y].muscleGroup,
                                                          calories: workoutController.workout[x][y].burnedCalories,
                                                          date: workoutController.workout[x][y].date
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: workoutCard(
                                                        workoutController
                                                            .workout[x][y].name,
                                                        "${workoutController.workout[x][y].duration} sec",
                                                        workoutController
                                                            .workout[x][y]
                                                            .thumbnail,
                                                        DateTime.parse(
                                                                workoutController
                                                                    .workout[x]
                                                                        [y]
                                                                    .date)
                                                            .isBefore(DateTime
                                                                .now())),
                                                  ),
                                                );
                                              }),
                                        )
                                      ]);
                                    }),
                              ))
                    : (workoutController.exercise == []
                        ? const CircularProgressIndicator(
                            color: ConstColors.primaryColor)
                        : Expanded(
                            child: ListView.builder(
                                padding: const EdgeInsets.all(5),
                                itemCount: workoutController.exercise.length,
                                itemBuilder: (context, elem) {
                                  return Column(children: [
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                            ),
                                          ),
                                          builder: (v) => FractionallySizedBox(
                                            heightFactor: 0.9,
                                            child: AddTraining(
                                              name: workoutController.exercise[elem].name,
                                              id: workoutController.exercise[elem].id,
                                              thumbnail: workoutController.exercise[elem].thumbnail,
                                              video: workoutController.exercise[elem].video,
                                              muscle: workoutController.exercise[elem].muscleGroup,
                                              calories: 0,
                                              date: ""
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: workoutCard(
                                            workoutController
                                                .exercise[elem].name,
                                            getMuscleGroupe(workoutController
                                                .exercise[elem].muscleGroup),
                                            workoutController
                                                .exercise[elem].thumbnail,
                                            false),
                                      ),
                                    )
                                  ]);
                                }),
                          )),
              ],
            ),
          );
        }),
      ),
    );
  }
}

Widget workoutCard(String text1, String text2, String image, bool passed) {
  return Container(
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Expanded(
            child: Column(
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
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            radius: 9,
            backgroundColor:
                passed ? ConstColors.primaryColor : Colors.transparent,
            child: const Icon(
              Icons.check,
              color: ConstColors.secondaryColor,
              size: 10,
            ),
          ),
        ],
      ),
    ),
  );
}
