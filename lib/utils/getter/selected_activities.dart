import '../../enum/activities.dart';

List<Activities> getSelectedActivities(List<bool> activityList) {
  List<Activities> activities = [];
  for (int i = 0; i < activityList.length; i++) {
    if (activityList[i]) activities.add(Activities.values[i]);
  }
  return activities;
}
