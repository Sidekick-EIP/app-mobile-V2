import 'package:intl/intl.dart';

bool isValidDate(String dateString) {
  try {
    // Define the format
    DateFormat format = DateFormat("dd/MM/yyyy");

    // Parse the date using the format
    DateTime inputDate = format.parseStrict(
        dateString); // parseStrict ensures that the input matches the format exactly
    DateTime currentDate = DateTime.now();

    // Check if the date is before today
    if (inputDate.isBefore(currentDate)) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
