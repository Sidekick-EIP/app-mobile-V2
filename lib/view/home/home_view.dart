import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sidekick_app/controller/home_controller.dart';
import 'package:sidekick_app/controller/user_controller.dart';
import 'package:sidekick_app/utils/http_request.dart';

import '../../controller/preference_controller.dart';
import '../../config/colors.dart';
import '../../config/images.dart';
import '../../config/text_style.dart';
import '../../controller/workout_controller.dart';
import '../../utils/token_storage.dart';
import '../../widget/search_field.dart';
import '../auth/signin_screen.dart';
import '../../enum/activities.dart';
import '../../models/activity.dart';
import '../profile/activity/activity_screen.dart';
import 'welcome_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final homeController = Get.put(HomeController());
  final userController = Get.put(UserController(), permanent: true);
  final preferenceController = Get.put(PreferenceController(), permanent: true);
  final workoutController = Get.put(WorkoutController(), permanent: true);
  bool isLoading = false;
  final TokenStorage tokenStorage = TokenStorage();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  List<Activity> activityList = [];

  List<Activity> getActivities() {
    return userController.user.value.activities
        .map((activity) => Activity(Activities.values.firstWhere(
            (e) => e.toString().split('.').last == activity.value,
        orElse: () => throw Exception('Activity not found: $activity'))))
        .toList();
  }

  Future<void> reloadData() async {
    preferenceController.fetchPreferenceFromBack();
    userController.fetchUserFromBack();
    userController.fetchSidekickFromBack();
    activityList = getActivities();
  }

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  void fetchInitialData() async {
    final email = secureStorage.read(key: 'email').toString();
    final password = secureStorage.read(key: 'password').toString();

    bool isPreferenceFetched =
        await preferenceController.fetchPreferenceFromBack();
    bool isUserFetched = await userController.fetchUserFromBack();
    userController.fetchSidekickFromBack();
    activityList = getActivities();

    if (!isPreferenceFetched || !isUserFetched) {
      setState(() => isLoading = true);
      if (email.isNotEmpty && password.isNotEmpty) {
        bool isReLogin = await attemptReLogin(email, password);
        if (isReLogin) {
          bool isPreferenceFetched =
              await preferenceController.fetchPreferenceFromBack();
          bool isUserFetched = await userController.fetchUserFromBack();
          userController.fetchSidekickFromBack();
          if (isPreferenceFetched && isUserFetched) {
            setState(() => isLoading = false);
          } else {
            Get.offAll(() => const SignInScreen(),
                transition: Transition.rightToLeft);
          }
        } else {
          Get.offAll(() => const SignInScreen(),
              transition: Transition.rightToLeft);
        }
      } else {
        Get.offAll(() => const SignInScreen(),
            transition: Transition.rightToLeft);
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<bool> attemptReLogin(String email, String password) async {
    try {
      final response = await HttpRequest.mainPost(
        "/auth/login",
        {"email": email, "password": password},
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
      );

      if (response.statusCode == 201) {
        var decodedResponse = jsonDecode(response.body);
        await tokenStorage.storeAccessToken(decodedResponse['access_token']);
        await tokenStorage.storeRefreshToken(decodedResponse['refresh_token']);
        return true;
      } else {
        Get.snackbar("Erreur", "Échec de la reconnexion automatique",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
      return false;
    } catch (error) {
      Get.snackbar("Erreur", "Une erreur s'est produite lors de la connexion.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<HomeController>(
        init: HomeController(),
        builder: (builder) {
          if (userController.isLoading.value || isLoading) {
            return const Center(
                child:
                    CircularProgressIndicator(color: ConstColors.primaryColor));
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bonjour ${userController.user.value.firstname.value}",
                        style: pSemiBold20.copyWith(
                          fontSize: 24,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          homeController.homeFlag.value = 3;
                        },
                        child: Container(
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
                              DefaultImages.notification,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SearchField(
                    text: "Rechercher",
                    textEditingController: TextEditingController(),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    flex: 1,
                    child: RefreshIndicator(
                      onRefresh: () {
                        return reloadData();
                      },
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const ClampingScrollPhysics(),
                        children: [
                          userController.user.value.sidekickId != null ?
                          InkWell(
                            onTap: () => {
                              homeController.flag.value = 1
                            }, child: WelcomeCardWSidekick(
                              sidekickName: userController.partner.value.firstname.value,
                              imagePath: userController.partner.value.avatar.value
                            )
                          ) :
                          const WelcomeCardWOutSidekick(),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Mes activités",
                                style: pSemiBold18.copyWith(
                                  fontSize: 19.25,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(
                                        () => const ActivityScreen(),
                                    transition: Transition.rightToLeft,
                                  );
                                },
                                child: Text(
                                  "Voir tout",
                                  style: pSemiBold18.copyWith(
                                    fontSize: 14.44,
                                    color: ConstColors.lightBlackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: activityList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  children: [
                                    categoryCard(activityList[index].iconPath, activityList[index].activityName),
                                    const SizedBox(width: 10)
                                  ],
                                );
                              }
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Analyse",
                                style: pSemiBold18.copyWith(
                                  fontSize: 19.25,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                graph(
                                  "Nb. de pas",
                                  "Pas",
                                  DefaultImages.i1,
                                  8357,
                                  const Color(0xffEFF7FF),
                                    MediaQuery.of(context).size.width,
                                    MediaQuery.of(context).size.height
                                ),
                                const SizedBox(width: 15),
                                graph(
                                  "Calories",
                                  "kCal",
                                  DefaultImages.i4,
                                  300,
                                  const Color(0xffFFEFDD),
                                    MediaQuery.of(context).size.width,
                                    MediaQuery.of(context).size.height
                                ),
                              ],
                            )
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Exercices",
                                style: pSemiBold18.copyWith(
                                  fontSize: 19.25,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  homeController.homeFlag.value = 2;
                                },
                                child: Text(
                                  "Voir tout",
                                  style: pSemiBold18.copyWith(
                                    fontSize: 14.44,
                                    color: ConstColors.lightBlackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: 4,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Container(
                                  height: 77,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.7),
                                    border: Border.all(
                                      color: const Color(0xffE5E9EF),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 61,
                                          width: 61,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                index == 0
                                                    ? DefaultImages.h3
                                                    : index == 1
                                                        ? DefaultImages.h4
                                                        : index == 2
                                                            ? DefaultImages.h5
                                                            : DefaultImages.h6,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              index == 0
                                                  ? "Front and Back Lunge"
                                                  : index == 1
                                                      ? "Side Plank"
                                                      : index == 1
                                                          ? "Arm circles"
                                                          : "Sumo Squat",
                                              style: pSemiBold18.copyWith(
                                                fontSize: 15.4,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "0:30",
                                              style: pRegular14.copyWith(
                                                fontSize: 13.47,
                                                color:
                                                    ConstColors.lightBlackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Expanded(child: SizedBox()),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 14),
                                          child: SizedBox(
                                            height: 19.25,
                                            width: 19.25,
                                            child: SvgPicture.asset(
                                              DefaultImages.error,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

Widget graph(String title, String subtitle, String image, int number, Color color, double width, double height) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(7.7),
      border: Border.all(
        color: const Color(0xffE5E9EF),
        width: 1.5,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: pSemiBold18.copyWith(fontSize: 17),
              ),
              SizedBox(
                width: width * 0.01,
              ),
              Container(
                width: width * 0.1,
                height: height * 0.045,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Image.asset(
                    image,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ),
          CircularPercentIndicator(
            radius: 60,
            lineWidth: 12,
            animation: true,
            percent: number / 10000,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: const Color.fromARGB(255, 241, 56, 42),
            backgroundColor: const Color.fromARGB(255, 180, 180, 180).withOpacity(0.2),
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  number.toString(),
                  style: pSemiBold20.copyWith(
                    fontSize: 20,
                  ),
                ),
                Text(
                  subtitle,
                  style: pRegular14.copyWith(fontSize: 16, color: Colors.grey),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget categoryCard(String image, String text) {
  return Container(
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
          textAlign: TextAlign.center,
          style: pSemiBold18.copyWith(
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
