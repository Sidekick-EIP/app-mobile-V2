import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/view/profile/activity/activity_screen.dart';
import 'package:sidekick_app/view/profile/training/training_screen.dart';

import '../../config/colors.dart';
import '../../config/images.dart';
import '../../config/text_style.dart';
import '../../controller/home_controller.dart';
import '../../controller/user_controller.dart';
import '../../utils/calculate_age.dart';
import '../../widget/custom_button.dart';
import '../auth/signin_screen.dart';
import 'account_screen.dart';
import 'filter_view.dart';
import 'goal/goal_screen.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final homeController = Get.put(HomeController());
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 20),
          Text(
            "Mon profil",
            style: pSemiBold20.copyWith(
              fontSize: 24,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 87,
                        width: 87,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                userController.user.value.avatar.value),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Obx(
                        () => Text(
                          "${userController.user.value.firstname} ${userController.user.value.lastname}",
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
                              userController.user.value.gender.value == "MALE"
                                  ? DefaultImages.m1
                                  : DefaultImages.p1,
                              "${userController.user.value.weight} kg"),
                        ),
                        const SizedBox(width: 16),
                        Obx(
                          () => card(
                              userController.user.value.gender.value == "MALE"
                                  ? DefaultImages.m1
                                  : DefaultImages.p1,
                              "${userController.user.value.size} cm"),
                        ),
                        const SizedBox(width: 16),
                        Obx(
                          () => card(DefaultImages.p3,
                              "${calculateAge(userController.user.value.birthDate.value)} ans"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      title: "Mon Sidekick",
                      width: Get.width,
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
                          builder: (v) => const FractionallySizedBox(
                            heightFactor: 0.9,
                            child: FilterView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: ConstColors.secondaryColor,
                        borderRadius: BorderRadius.circular(7.71),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xffEAF0F6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            row(
                              "Compte",
                              "",
                              () {
                                Get.to(
                                  () => const AccountScreen(),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(
                              color: Color(0xffA9B2BA),
                            ),
                            const SizedBox(height: 10),
                            row(
                              "Objectifs",
                              "",
                              () {
                                Get.to(
                                  () => const GoalScreen(),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(
                              color: Color(0xffA9B2BA),
                            ),
                            const SizedBox(height: 10),
                            row(
                              "Niveau d'entrainement",
                              "",
                              () {
                                Get.to(
                                  () => const TrainingScreen(),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(
                              color: Color(0xffA9B2BA),
                            ),
                            const SizedBox(height: 10),
                            row(
                              "Activités favorites",
                              "",
                              () {
                                Get.to(
                                  () => const ActivityScreen(),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(
                              color: Color(0xffA9B2BA),
                            ),
                            const SizedBox(height: 10),
                            row(
                              "Déconnexion",
                              "",
                              () {
                                homeController.logout();
                                Get.offAll(
                                  () => const SignInScreen(),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              const Icon(
                                Icons.logout_outlined,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Paramètres",
                      style: pSemiBold18.copyWith(fontSize: 15.41),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: ConstColors.secondaryColor,
                        borderRadius: BorderRadius.circular(7.71),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xffEAF0F6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            row(
                              "Préférences",
                              "",
                              () {},
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(
                              color: Color(0xffA9B2BA),
                            ),
                            const SizedBox(height: 10),
                            row(
                              "Contacts Support",
                              "",
                              () {},
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget row(String text1, String image, VoidCallback onTap, Widget widget) {
  return InkWell(
    onTap: () {
      onTap();
    },
    child: Row(
      children: [
        Text(
          "$text1  ",
          style: pRegular14.copyWith(
            fontSize: 15.41,
          ),
        ),
        image != ""
            ? SizedBox(
                height: 20,
                width: 20,
                child: Image.asset(image),
              )
            : const SizedBox(),
        const Expanded(child: SizedBox()),
        widget,
      ],
    ),
  );
}

Widget card(String image, String text) {
  return Expanded(
    child: Container(
      height: 77,
      decoration: BoxDecoration(
        color: ConstColors.secondaryColor,
        borderRadius: BorderRadius.circular(7.71),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffEAF0F6),
          ),
        ],
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
          const SizedBox(height: 10),
          Text(
            text,
            style: pSemiBold18.copyWith(
              fontSize: 13.49,
            ),
          )
        ],
      ),
    ),
  );
}
