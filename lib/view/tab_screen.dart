// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/view/message/message_view.dart';
import 'package:sidekick_app/view/nutrition/nutrition_view.dart';
import 'package:sidekick_app/view/profile/profile_view.dart';
import 'package:sidekick_app/view/training/training_view.dart';

import '../config/colors.dart';
import '../config/images.dart';
import '../config/text_style.dart';
import '../controller/home_controller.dart';
import 'home/home_view.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    homeController.flag.value = 0;
    homeController.homeFlag.value = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeController.scaffoldKey,
      bottomNavigationBar: Container(
        height: 60 + MediaQuery.of(context).padding.bottom,
        width: Get.width,
        decoration: const BoxDecoration(
          color: ConstColors.secondaryColor,
          boxShadow: [
            BoxShadow(
              color: Color(0xffF2F6F9),
              offset: Offset(0, -1.92491),
            ),
          ],
        ),
        child: GetX<HomeController>(
          init: homeController,
          builder: (homeController) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              card(
                DefaultImages.home,
                "Accueil",
                homeController.flag.value == 0 ? ConstColors.primaryColor : const Color(0xff9299A3),
                homeController.flag.value == 0 ? ConstColors.primaryColor : const Color(0xff9299A3),
                () {
                  homeController.flag.value = 0;
                },
              ),
              card(
                DefaultImages.message,
                "Message",
                homeController.flag.value == 1 ? ConstColors.primaryColor : const Color(0xff9299A3),
                homeController.flag.value == 1 ? ConstColors.primaryColor : const Color(0xff9299A3),
                () {
                  homeController.flag.value = 1;
                },
              ),
              card(
                DefaultImages.training,
                "Entrainement",
                homeController.flag.value == 2 ? ConstColors.primaryColor : const Color(0xff9299A3),
                homeController.flag.value == 2 ? ConstColors.primaryColor : const Color(0xff9299A3),
                () {
                  homeController.flag.value = 2;
                },
              ),
              card(
                DefaultImages.nutrition,
                "Nutrition",
                homeController.flag.value == 3 ? ConstColors.primaryColor : const Color(0xff9299A3),
                homeController.flag.value == 3 ? ConstColors.primaryColor : const Color(0xff9299A3),
                () {
                  homeController.flag.value = 3;
                },
              ),
              card(
                DefaultImages.user,
                "Profile",
                homeController.flag.value == 4 ? ConstColors.primaryColor : const Color(0xff9299A3),
                homeController.flag.value == 4 ? ConstColors.primaryColor : const Color(0xff9299A3),
                () {
                  homeController.flag.value = 4;
                },
              )
            ],
          ),
        ),
      ),
      body: GetX<HomeController>(
          init: homeController,
          builder: (homeController) => homeController.flag.value == 0
              ? const HomeView()
              : homeController.flag.value == 1
                  ? const MessageView()
                  : homeController.flag.value == 2
                      ? const TrainingView()
                      : homeController.flag.value == 3
                          ? const NutritionView()
                          : const ProfileView()),
    );
  }

  Widget card(String image, String text, Color imageColor, Color textColor, VoidCallback onTap) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: width * 0.06, // environ 6% de la largeur de l'écran
            width: width * 0.06, // environ 6% de la largeur de l'écran
            child: SvgPicture.asset(
              image,
              fit: BoxFit.fill,
              color: imageColor,
            ),
          ),
          SizedBox(height: height * 0.01),
          // environ 1% de la hauteur de l'écran
          Text(
            text,
            style: pSemiBold18.copyWith(
              fontSize: width * 0.03, // environ 3% de la largeur de l'écran
              color: textColor,
            ),
          )
        ],
      ),
    );
  }
}
