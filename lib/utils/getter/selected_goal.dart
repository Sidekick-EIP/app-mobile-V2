import '../../enum/goal.dart';

Goal getSelectedGoal(List<bool> goalList) {
  for (int i = 0; i < goalList.length; i++) {
    if (goalList[i]) return Goal.values[i];
  }
  return Goal.STAY_IN_SHAPE; // default value
}