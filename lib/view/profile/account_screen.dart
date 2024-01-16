import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sidekick_app/config/images.dart';
import 'package:sidekick_app/view/profile/edit/editable_field_screen.dart';
import 'package:sidekick_app/view/profile/profile_view.dart';
import 'package:sidekick_app/utils/http_request.dart';

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

  Future<void> _chooseAndUploadPicture() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(
                    'Galerie',
                    style: pSemiBold18.copyWith(
                      fontSize: 15.41,
                      color: ConstColors.lightBlackColor,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _pickAndUploadImage(ImageSource.gallery);
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(
                  'Caméra',
                  style: pSemiBold18.copyWith(
                    fontSize: 15.41,
                    color: ConstColors.lightBlackColor,
                  ),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickAndUploadImage(ImageSource.camera);
                },
              ),
            ],
          );
        });
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      final File file = File(image.path);
      final response = await HttpRequest.mainMultiplePartPost(
        '/user_infos/avatar',
        file.path,
      );

      if (response.statusCode == 201) {
        String responseBody = await utf8.decodeStream(response.stream);
        Map<String, dynamic> decodedResponse = jsonDecode(responseBody);
        userController.user.value.avatar.value = decodedResponse['avatar'];
        setState(() {});
        Get.snackbar('Succès', 'Image de profil mise à jour avec succès!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 1));
      } else {
        if (kDebugMode) {
          print('Error uploading image: ${response.reasonPhrase}');
        }
      }
    }
  }

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
          "Informations",
          style: pSemiBold20.copyWith(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 0),
            child: GestureDetector(
              onTap: () async {
                try {
                  await userController.updateUserProfile();
                  Get.snackbar('Succès', 'Profil mis à jour avec succès!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 1));
                } catch (e) {
                  if (kDebugMode) {
                    print(e);
                  }
                  Get.snackbar(
                      'Erreur', 'Erreur lors de la mise à jour du profil.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                }
              },
              child: SvgPicture.asset(
                DefaultImages.share,
                colorFilter: const ColorFilter.mode(
                    ConstColors.primaryColor, BlendMode.srcIn),
                height: 30, // you can set height and width as needed
                width: 30,
              ),
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
                  child: GestureDetector(
                    onTap: _chooseAndUploadPicture,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
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
                        Container(
                          decoration: const BoxDecoration(
                            color: ConstColors.secondaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: SvgPicture.asset(DefaultImages.editPicker,
                                height: 24,
                                width: 24,
                                colorFilter: const ColorFilter.mode(
                                    ConstColors.primaryColor, BlendMode.srcIn)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                          fieldLabel:
                              userController.user.value.weight.value.toString(),
                          fieldObservable: userController.user.value.weight,
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
                            fieldLabel:
                                userController.user.value.size.value.toString(),
                            fieldObservable: userController.user.value.size,
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
                                userController.user.value.birthDate.value),
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
                    "Description",
                    "",
                    () {
                      Get.to(
                        () => EditableFieldScreen(
                            title: "Modifier votre description",
                            fieldLabel:
                                userController.user.value.description.value,
                            fieldObservable:
                                userController.user.value.description,
                            minLines: 5,
                            maxLines: 10,
                            height: 156),
                        transition: Transition.rightToLeft,
                      );
                    },
                    Row(
                      children: [
                        Obx(
                          () => SizedBox(
                            width: Get.width * 0.6,
                            child: Text(
                              "${userController.user.value.description}"
                              "  ",
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                              textAlign: TextAlign.right,
                              style: pRegular14.copyWith(
                                fontSize: 15.41,
                                color: ConstColors.lightBlackColor,
                              ),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
