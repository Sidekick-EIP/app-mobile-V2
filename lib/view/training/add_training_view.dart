import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sidekick_app/config/colors.dart';
import 'package:sidekick_app/config/text_style.dart';
import 'package:sidekick_app/controller/workout_controller.dart';
import 'package:sidekick_app/view/training/training_view.dart';
import 'package:sidekick_app/widget/custom_button.dart';
import 'package:sidekick_app/widget/custom_textfield.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher_string.dart';

class AddTraining extends StatefulWidget {
  const AddTraining({
    required this.name,
    required this.id,
    required this.thumbnail,
    required this.video,
    required this.muscle,
    required this.calories,
    required this.date,
    super.key
  });

  final String name;
  final int id;
  final String thumbnail;
  final String video;
  final String muscle;
  final int calories;
  final String date;

  @override
  State<AddTraining> createState() => _AddTrainingState();
}

class _AddTrainingState extends State<AddTraining> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final workoutController = Get.find<WorkoutController>();

  String? validateData() {
    if (dateController.text.isEmpty) {
      return "Veuillez entrer une date.";
    }
    if (durationController.text.isEmpty) {
      return "Veuillez entrer une durée.";
    }
    return null;
  }

  void _showCupertinoDatePicker() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              dateController.text =
                  DateFormat('dd/MM/yyyy').format(newDate).toString();
            },
            minimumYear: 2024,
            maximumYear: DateTime.now().year
          ),
        );
      },
    );
  }

  widgetCalories() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "${widget.calories} calories brûlées le ${DateFormat("dd/MM/yyyy").format(DateTime.parse(widget.date))}",
              style: pRegular14.copyWith(
                fontSize: 15,
                color: ConstColors.blackColor,
              ),
            ),
          ]
        ),
        const SizedBox(height: 30),

      ]
    );
  }

  _launchURL() async {
    if (Platform.isIOS) {
      if (await canLaunchUrlString(widget.video)) {
        await launchUrlString(widget.video);
      } else {
        if (await canLaunchUrlString(widget.video)) {
          await launchUrlString(widget.video);
        } else {
          throw 'Could not launch the video';
        }
      }
    } else {
      if (await canLaunchUrlString(widget.video)) {
        await launchUrlString(widget.video);
      } else {
        throw 'Could not launch the video';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: const BoxDecoration(
        color: Color(0xffF8FAFC),
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
                Expanded(
                  child: Text(
                    '${widget.name} - ${getMuscleGroupe(widget.muscle)}',
                    style: pSemiBold18.copyWith(),
                  ),
                ),
                const SizedBox(width: 15),
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
                    children: [
                      Row(
                        children: [
                          Text(
                            "Vidéo explicative",
                            style: pSemiBold20.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: ConstColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () => {
                          _launchURL()
                        },
                        child: Container(
                          height: 150,
                          width: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.thumbnail,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (widget.calories != 0)
                        widgetCalories(),
                      Row(
                        children: [
                          Text(
                            "Choisissez une date",
                            style: pSemiBold20.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: ConstColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).copyWith().size.width - 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.7),
                          border: Border.all(
                            color: const Color(0xffE5E9EF),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: _showCupertinoDatePicker,
                          child: AbsorbPointer(
                            child: CustomTextField(
                              text: "dd/mm/AAA",
                              textEditingController: dateController,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "Choisissez une durée en secondes",
                            style: pSemiBold20.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: ConstColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).copyWith().size.width - 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.7),
                          border: Border.all(
                            color: const Color(0xffE5E9EF),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: TextFormField(
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13
                            ),
                            controller: durationController,
                            onChanged: (value) {
                              durationController.text = value;
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      CustomButton(
                        title: "Ajouter au calendrier",
                        width: MediaQuery.of(context).copyWith().size.width - 100,
                        onTap: () {
                          String? errorMessage = validateData();
                          if (errorMessage == null) {
                            DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(dateController.text);
                            DateTime utcDate = DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);
                            String finalDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(utcDate);
                            var body = {
                              "exerciseId": widget.id,
                              "duration": int.parse(durationController.text),
                              "date": finalDate
                            };
                            workoutController.addExercise(body);
                          } else {
                            Get.snackbar("Erreur", errorMessage,
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        }
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30)
              ],
            ),
          )
        ]
      )
    );
  }
}
