int calculateAge(DateTime birthDate) {
  final currentDate = DateTime.now();
  return currentDate.year - birthDate.year;
}
