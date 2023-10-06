import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/colors.dart';
import '../../../config/images.dart';
import '../../../config/text_style.dart';
import '../../../controller/auth_controller.dart';

class ActivityView extends StatefulWidget {
  final AuthController authController;
  const ActivityView({Key? key, required this.authController})
      : super(key: key);

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Text(
          "Choisissez les activités qui vous intéressent",
          style: pSemiBold20.copyWith(
            fontSize: 25,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                setState(() {
                  widget.authController.activityList[index] =
                      !widget.authController.activityList[index];
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  height: 84,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.7),
                    border: Border.all(
                      color: widget.authController.activityList[index] == true
                          ? const Color(0xffF25D29)
                          : const Color(0xffE5E9EF),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    child: Row(
                      children: [
                        Container(
                          height: 53,
                          width: 53,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: index == 0 || index == 3
                                ? const Color(0xffFFEAEA)
                                : index == 2
                                    ? const Color(0xffEFF7FF)
                                    : ConstColors.secondaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              index == 0
                                  ? DefaultImages.a1
                                  : index == 1
                                      ? DefaultImages.a2
                                      : index == 2
                                          ? DefaultImages.a3
                                          : index == 3
                                              ? DefaultImages.a4
                                              : DefaultImages.a5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          index == 0
                              ? "Cardio"
                              : index == 1
                                  ? "Power training"
                                  : index == 2
                                      ? "Stretch"
                                      : index == 3
                                          ? "Dancing"
                                          : "Yoga",
                          style: pSemiBold18.copyWith(
                            fontSize: 15,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Container(
                          height: 19,
                          width: 19,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.authController.activityList[index] ==
                                    true
                                ? const Color(0xffF25D29)
                                : Colors.transparent,
                            border: Border.all(
                              color:
                                  widget.authController.activityList[index] ==
                                          true
                                      ? const Color(0xffF25D29)
                                      : const Color(0xffDAE0E8),
                            ),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: ConstColors.secondaryColor,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
