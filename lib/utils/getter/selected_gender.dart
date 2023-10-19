import '../../enum/gender.dart';

Gender getSelectedGender(List<bool> genderList) {
  for (int i = 0; i < genderList.length; i++) {
    if (genderList[i]) return Gender.values[i];
  }
  return Gender.PREFER_NOT_TO_SAY; // default value
}