import 'package:sidekick_app/config/images.dart';
import 'package:sidekick_app/enum/activities_map.dart';

import '../enum/activities.dart';

class Activity {
  final Activities activityType;
  late String activityName;
  late String iconPath;

  Activity(this.activityType) {
    activityName = sportsTranslation[activityType] ?? "";
    iconPath = activitiesIconsMap[activityType] ?? DefaultImages.a0;
  }
}
