import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/colors.dart';
import '../../../config/text_style.dart';
import '../../../controller/user_controller.dart';
import '../../../enum/activities.dart';
import '../../../models/activity.dart';

class ActivityEditView extends StatefulWidget {
  const ActivityEditView({Key? key}) : super(key: key);

  @override
  ActivityEditViewState createState() => ActivityEditViewState();
}

class ActivityEditViewState extends State<ActivityEditView> {
  final userController = Get.find<UserController>();
  List<Activity> activityList = [];

  List<Activity> getActivities() {
    return Activities.values.map((e) => Activity(e)).toList();
  }

  List<bool> getActivityStatusBasedOnEnum() {
    List<bool> results = [];

    for (var activityEnum in Activities.values) {
      String enumString = activityEnum.toString().split('.').last;
      if (userController.user.value.activities.toString().contains(enumString)) {
        results.add(true);
      } else {
        results.add(false);
      }
    }

    return results;
  }

  @override
  void initState() {
    super.initState();
    activityList = getActivities();
    userController.activityList = getActivityStatusBasedOnEnum();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Text(
          "Modifier mes activités",
          style: pSemiBold20.copyWith(
            fontSize: 25,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ListView.builder(
          itemCount: userController.activityList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                setState(() {
                  userController.activityList[index] =
                      !userController.activityList[index];
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
                      color: userController.activityList[index] == true
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
                            color: const Color(0xffEFF7FF),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              activityList[index].iconPath,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          activityList[index].activityName, // get the sport from the list
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
                            color: userController.activityList[index] == true
                                ? const Color(0xffF25D29)
                                : Colors.transparent,
                            border: Border.all(
                              color: userController.activityList[index] == true
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
