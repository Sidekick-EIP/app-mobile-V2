bool isValidDate(String dateString) {
  try {
    DateTime inputDate = DateTime.parse(dateString);
    DateTime currentDate = DateTime.now();

    // Check if inputDate is before the current date.
    if (inputDate.isBefore(currentDate)) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
