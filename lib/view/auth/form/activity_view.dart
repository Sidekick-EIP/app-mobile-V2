import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/colors.dart';
import '../../../config/images.dart';
import '../../../config/text_style.dart';
import '../../../controller/auth_controller.dart';

enum Activities {
  RUNNING,
  CYCLING,
  SWIMMING,
  WEIGHTLIFTING,
  YOGA,
  PILATES,
  MARTIAL_ARTS,
  DANCING,
  HIKING,
  ROCK_CLIMBING,
  TENNIS,
  BASKETBALL,
  SOCCER,
  VOLLEYBALL,
  BASEBALL,
  SKIING,
  SNOWBOARDING,
  SURFING,
  GOLF,
  ROWING,
  CROSSFIT,
  GYMNASTICS,
  TRIATHLON,
  RUGBY,
  BOXING,
  SKATING,
  SQUASH,
  BADMINTON,
  HORSE_RIDING,
  TABLE_TENNIS,
}

Map<Activities, String> sportsTranslation = {
  Activities.RUNNING: 'Course à pied',
  Activities.CYCLING: 'Cyclisme',
  Activities.SWIMMING: 'Natation',
  Activities.WEIGHTLIFTING: 'Musculation',
  Activities.YOGA: 'Yoga',
  Activities.PILATES: 'Pilates',
  Activities.MARTIAL_ARTS: 'Arts martiaux',
  Activities.DANCING: 'Danse',
  Activities.HIKING: 'Randonnée',
  Activities.ROCK_CLIMBING: 'Escalade',
  Activities.TENNIS: 'Tennis',
  Activities.BASKETBALL: 'Basketball',
  Activities.SOCCER: 'Football',
  Activities.VOLLEYBALL: 'Volleyball',
  Activities.BASEBALL: 'Baseball',
  Activities.SKIING: 'Ski',
  Activities.SNOWBOARDING: 'Snowboard',
  Activities.SURFING: 'Surf',
  Activities.GOLF: 'Golf',
  Activities.ROWING: 'Aviron',
  Activities.CROSSFIT: 'Crossfit',
  Activities.GYMNASTICS: 'Gymnastique',
  Activities.TRIATHLON: 'Triathlon',
  Activities.RUGBY: 'Rugby',
  Activities.BOXING: 'Boxe',
  Activities.SKATING: 'Patinage',
  Activities.SQUASH: 'Squash',
  Activities.BADMINTON: 'Badminton',
  Activities.HORSE_RIDING: 'Équitation',
  Activities.TABLE_TENNIS: 'Tennis de table',
};

class ActivityView extends StatefulWidget {
  final AuthController authController;

  const ActivityView({Key? key, required this.authController})
      : super(key: key);

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  List<String> sportsList = sportsTranslation.values.toList();

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
          itemCount: sportsList.length,
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
                          sportsList[index],  // get the sport from the list
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
