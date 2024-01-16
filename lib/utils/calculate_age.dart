int calculateAge(DateTime birthDate) {
  final currentDate = DateTime.now();

  int age = currentDate.year - birthDate.year;

  if (birthDate.month > currentDate.month ||
      (birthDate.month == currentDate.month && birthDate.day > currentDate.day)) {
    age--;
  }

  return age;
}
