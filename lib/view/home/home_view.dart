import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/controller/home_controller.dart';
import 'package:sidekick_app/controller/user_controller.dart';

import '../../controller/preference_controller.dart';
import '../../config/colors.dart';
import '../../config/images.dart';
import '../../config/text_style.dart';
import '../../widget/search_field.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final homeController = Get.put(HomeController());
  final userController = Get.put(UserController(), permanent: true);
  final preferenceController = Get.put(PreferenceController(), permanent: true);

  @override
  void initState() {
    super.initState();
    preferenceController.fetchPreferenceFromBack();
    userController.fetchUserFromBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<HomeController>(
        init: HomeController(),
        builder: (builder) {
          if (userController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
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
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            SizedBox(
                              height: 207.89,
                              width: Get.width,
                              child: Image.asset(
                                DefaultImages.banner,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Catégorie",
                              style: pSemiBold18.copyWith(
                                fontSize: 19.25,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                homeController.homeFlag.value = 1;
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
                        Row(
                          children: [
                            categoryCard(DefaultImages.h7, "Cardio"),
                            const SizedBox(width: 14),
                            categoryCard(DefaultImages.h8, "Yoga"),
                            const SizedBox(width: 14),
                            categoryCard(DefaultImages.h9, "Stretch"),
                            const SizedBox(width: 14),
                            categoryCard(DefaultImages.h10, "Gym"),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Entraînements pour vous",
                              style: pSemiBold18.copyWith(
                                fontSize: 19.25,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                homeController.homeFlag.value = 4;
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
                          height: 207.89,
                          width: Get.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: SizedBox(
                                  height: 207.89,
                                  width: 230.99,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            height: 153.99,
                                            width: 230.99,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  index == 1
                                                      ? DefaultImages.h2
                                                      : DefaultImages.h1,
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 20, right: 20),
                                            child: Icon(
                                              Icons.favorite,
                                              color: ConstColors.secondaryColor,
                                            ),
                                          )
                                        ],
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Text(
                                        index == 1
                                            ? "Full body stretching"
                                            : "Bas du corps",
                                        style: pSemiBold18.copyWith(
                                          fontSize: 15.4,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            "Débutant",
                                            style: pSemiBold18.copyWith(
                                              fontSize: 11.55,
                                              color: ConstColors.primaryColor,
                                            ),
                                          ),
                                          Text(
                                            "  •  42 min",
                                            style: pSemiBold18.copyWith(
                                              fontSize: 11.55,
                                              color:
                                                  ConstColors.lightBlackColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
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
                ],
              ),
            );
          }
        },
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
