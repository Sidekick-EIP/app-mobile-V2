import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sidekick_app/view/profile/edit/editable_field_screen.dart';
import 'package:sidekick_app/view/profile/profile_view.dart';

import '../../config/colors.dart';
import '../../config/text_style.dart';
import '../../controller/user_controller.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: ConstColors.blackColor,
          ),
        ),
        title: Text(
          "Informations du compte",
          style: pSemiBold20.copyWith(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 0, top: 0),
            child: IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: ConstColors.primaryColor),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
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
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: ConstColors.secondaryColor,
                    borderRadius: BorderRadius.circular(23.1),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xffEAF0F6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 30, bottom: 30),
                    child: Column(
                      children: [
                        row(
                          "Nom",
                          "",
                          () {
                            Get.to(
                              () => EditableFieldScreen(
                                  title: "Modifier votre nom",
                                  fieldLabel:
                                      userController.user.value.lastname.value,
                                  fieldObservable:
                                      userController.user.value.lastname),
                              transition: Transition.rightToLeft,
                            );
                          },
                          Row(
                            children: [
                              Obx(
                                () => Text(
                                  "${userController.user.value.lastname}" "  ",
                                  style: pRegular14.copyWith(
                                    fontSize: 15.41,
                                    color: ConstColors.lightBlackColor,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          color: Color(0xffF1F4F8),
                        ),
                        const SizedBox(height: 10),
                        row(
                          "Prénom",
                          "",
                          () {
                            Get.to(
                              () => EditableFieldScreen(
                                  title: "Modifier votre prénom",
                                  fieldLabel:
                                      userController.user.value.firstname.value,
                                  fieldObservable:
                                      userController.user.value.firstname),
                              transition: Transition.rightToLeft,
                            );
                          },
                          Row(
                            children: [
                              Obx(
                                () => Text(
                                  "${userController.user.value.firstname}" "  ",
                                  style: pRegular14.copyWith(
                                    fontSize: 15.41,
                                    color: ConstColors.lightBlackColor,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          color: Color(0xffF1F4F8),
                        ),
                        const SizedBox(height: 10),
                        row(
                          "Poids",
                          "",
                          () {
                            Get.to(
                              () => EditableFieldScreen(
                                title: "Modifier votre poids",
                                fieldLabel: userController
                                    .user.value.weight.value
                                    .toString(),
                                fieldObservable:
                                    userController.user.value.weight,
                                suffixText: "kg",
                              ),
                              transition: Transition.rightToLeft,
                            );
                          },
                          Row(
                            children: [
                              Obx(
                                () => Text(
                                  "${userController.user.value.weight} kg" "  ",
                                  style: pRegular14.copyWith(
                                    fontSize: 15.41,
                                    color: ConstColors.lightBlackColor,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          color: Color(0xffF1F4F8),
                        ),
                        const SizedBox(height: 10),
                        row(
                          "Poids ciblé",
                          "",
                          () {
                            Get.to(
                              () => EditableFieldScreen(
                                  title: "Modifier votre poids ciblé",
                                  fieldLabel: userController
                                      .user.value.goalWeight.value
                                      .toString(),
                                  fieldObservable:
                                      userController.user.value.goalWeight,
                                  suffixText: "kg"),
                              transition: Transition.rightToLeft,
                            );
                          },
                          Row(
                            children: [
                              Obx(
                                () => Text(
                                  "${userController.user.value.goalWeight} kg"
                                  "  ",
                                  style: pRegular14.copyWith(
                                    fontSize: 15.41,
                                    color: ConstColors.lightBlackColor,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          color: Color(0xffF1F4F8),
                        ),
                        const SizedBox(height: 10),
                        row(
                          "Taille",
                          "",
                          () {
                            Get.to(
                              () => EditableFieldScreen(
                                  title: "Modifier votre taille",
                                  fieldLabel: userController
                                      .user.value.size.value
                                      .toString(),
                                  fieldObservable:
                                      userController.user.value.size,
                                  suffixText: "cm"),
                              transition: Transition.rightToLeft,
                            );
                          },
                          Row(
                            children: [
                              Obx(
                                () => Text(
                                  "${userController.user.value.size} cm" "  ",
                                  style: pRegular14.copyWith(
                                    fontSize: 15.41,
                                    color: ConstColors.lightBlackColor,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          color: Color(0xffF1F4F8),
                        ),
                        const SizedBox(height: 10),
                        row(
                          "Date de naissance",
                          "",
                          () {
                            Get.to(
                              () => EditableFieldScreen(
                                  title: "Modifier votre date de naissance",
                                  fieldLabel: DateFormat('dd/MM/yyyy').format(
                                      userController
                                          .user.value.birthDate.value),
                                  fieldObservable:
                                      userController.user.value.birthDate),
                              transition: Transition.rightToLeft,
                            );
                          },
                          Row(
                            children: [
                              Obx(
                                () => Text(
                                  "${DateFormat('dd/MM/yyyy').format(userController.user.value.birthDate.value)}   ",
                                  style: pRegular14.copyWith(
                                    fontSize: 15.41,
                                    color: ConstColors.lightBlackColor,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          color: Color(0xffF1F4F8),
                        ),
                        const SizedBox(height: 10),
                        row(
                          "Email",
                          "",
                          () {
                            Get.to(
                              () => EditableFieldScreen(
                                  title: "Modifier votre email",
                                  fieldLabel:
                                      userController.user.value.email.value,
                                  fieldObservable:
                                      userController.user.value.email),
                              transition: Transition.rightToLeft,
                            );
                          },
                          Obx(
                            () => Text(
                              userController.user.value.email.value,
                              style: pRegular14.copyWith(
                                fontSize: 15.41,
                                color: ConstColors.lightBlackColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
