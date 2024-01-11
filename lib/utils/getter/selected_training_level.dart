import '../../enum/training_level.dart';

TrainingLevel getSelectedTrainingLevel(List<bool> trainingList) {
  for (int i = 0; i < trainingList.length; i++) {
    if (trainingList[i]) return TrainingLevel.values[i];
  }
  return TrainingLevel.BEGINNER; // default value
}
