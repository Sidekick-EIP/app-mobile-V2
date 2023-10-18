import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/view/profile/profile_view.dart';

import '../../config/colors.dart';
import '../../config/images.dart';
import '../../config/text_style.dart';
import '../../controller/user_controller.dart';
import '../../enum/activities.dart';
import '../../enum/activities_map.dart';
import '../../utils/calculate_age.dart';

class SidekickView extends StatefulWidget {
  const SidekickView({Key? key}) : super(key: key);

  @override
  State<SidekickView> createState() => _SidekickViewState();
}

class _SidekickViewState extends State<SidekickView> {
  final userController = Get.find<UserController>();
  List<String> activityList = [];

  String getGoalText(String goal) {
    switch (goal) {
      case "LOSE_WEIGHT":
        return "Perdre du poids";
      case "STAY_IN_SHAPE":
        return "Rester en forme";
      case "GAIN_MUSCLE_MASS":
        return "Prendre du volume musculaire";
      default:
        return "Se muscler";
    }
  }

  String getGoalImage(String goal) {
    switch (goal) {
      case "LOSE_WEIGHT":
        return DefaultImages.goal1;
      case "STAY_IN_SHAPE":
        return DefaultImages.goal2;
      case "GAIN_MUSCLE_MASS":
        return DefaultImages.goal3;
      default:
        return DefaultImages.goal4;
    }
  }

  String getTrainingTitle(String trainingLevel) {
    switch (trainingLevel) {
      case "BEGINNER":
        return "Débutant";
      case "IRREGULAR_TRAINING":
        return "Entrainement irrégulier";
      case "INTERMEDIATE":
        return "Intermédiaire";
      default:
        return "Avancé";
    }
  }

  String getTrainingDescription(String trainingLevel) {
    switch (trainingLevel) {
      case "BEGINNER":
        return "Je veux commencer à m'entraîner";
      case "IRREGULAR_TRAINING":
        return "Je m'entraîne de temps en temps";
      case "INTERMEDIATE":
        return "Je m'entraîne 2 - 4 fois par semaine";
      default:
        return "Je m'entraîne 5 - 7 fois par semaine";
    }
  }

  List<String> getTranslations() {
    return userController.partner.value.activities
        .map((activity) => Activities.values.firstWhere(
            (e) => e.toString().split('.').last == activity.value,
            orElse: () => throw Exception('Activity not found: $activity')))
        .where((e) => sportsTranslation.containsKey(e))
        .map((e) => sportsTranslation[e]!)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    activityList = getTranslations();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mon sidekick",
                  style: pSemiBold18.copyWith(),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: ConstColors.blackColor,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Obx(
                          () => Container(
                            height: 87,
                            width: 87,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    userController.partner.value.avatar.value),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Obx(
                          () => Text(
                            "${userController.partner.value.firstname} ${userController.partner.value.lastname}",
                            style: pSemiBold18.copyWith(
                              fontSize: 19.27,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Obx(
                            () => card(
                                userController.partner.value.gender.value ==
                                        "MALE"
                                    ? DefaultImages.m1
                                    : DefaultImages.p1,
                                "${userController.partner.value.size} cm"),
                          ),
                          const SizedBox(width: 16),
                          Obx(
                            () => card(DefaultImages.p3,
                                "${calculateAge(userController.partner.value.birthDate.value)} ans"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Description",
                        style: pSemiBold18.copyWith(
                          fontSize: 19.25,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 156,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          color: ConstColors.secondaryColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            userController.partner.value.description.value,
                            style: pSemiBold18.copyWith(
                              fontSize: 13,
                              color: ConstColors.lightBlackColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Mes objectifs",
                        style: pSemiBold18.copyWith(
                          fontSize: 19.25,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                          height: 84,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.7),
                            border: Border.all(
                              color: const Color(0xffE5E9EF),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Row(
                              children: [
                                Image.asset(getGoalImage(
                                    userController.partner.value.goal.value)),
                                const SizedBox(width: 15),
                                Text(
                                  getGoalText(
                                      userController.partner.value.goal.value),
                                  style: pSemiBold18.copyWith(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 84,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.7),
                          border: Border.all(
                            color: const Color(0xffE5E9EF),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getTrainingTitle(
                                    userController.partner.value.level.value),
                                style: pSemiBold18.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                getTrainingDescription(
                                    userController.partner.value.level.value),
                                style: pRegular14.copyWith(
                                  fontSize: 13,
                                  color: ConstColors.lightBlackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Mes activités",
                        style: pSemiBold18.copyWith(
                          fontSize: 19.25,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            activityList.length <= 9 ? activityList.length : 9,
                        itemBuilder: (BuildContext context, int index) {
                          return categoryCard(
                              DefaultImages.a0, activityList[index]);
                        },
                      )
                    ],
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

Widget categoryCard(String image, String text) {
  return Expanded(
    child: Container(
      height: 77,
      width: 77,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.7),
        border: Border.all(
          color: const Color(0xffE5E9EF),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 23,
            width: 23,
            child: Image.asset(
              image,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: pSemiBold18.copyWith(
              fontSize: 13.47,
            ),
          ),
        ],
      ),
    ),
  );
}
