import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/controller/user_controller.dart';

import '../../../config/images.dart';
import '../../../config/text_style.dart';
import '../../../enum/activities.dart';
import '../../../enum/activities_map.dart';

class ActivityListView extends StatefulWidget {
  const ActivityListView({Key? key}) : super(key: key);

  @override
  ActivityListViewState createState() => ActivityListViewState();
}

class ActivityListViewState extends State<ActivityListView> {
  final userController = Get.find<UserController>();
  List<String> activityList = [];

  List<String> getTranslations() {
    return userController.user.value.activities
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Text(
          "Mes activités",
          style: pSemiBold20.copyWith(
            fontSize: 25,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ListView.builder(
          itemCount: activityList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                setState(() {
                  activityList[index] = activityList[index];
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
                      color: const Color(0xffE5E9EF),
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
                              DefaultImages.a0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          activityList[index],
                          // get the sport from the list
                          style: pSemiBold18.copyWith(
                            fontSize: 15,
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
