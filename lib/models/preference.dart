import 'package:get/get.dart';

class Preference {
  late RxBool isDarkMode;
  late RxBool notifications;
  late RxBool sounds;

  Preference({
    required this.isDarkMode,
    required this.notifications,
    required this.sounds,
  });

  Preference.fromJson(Map<String, dynamic> json) {
    isDarkMode = RxBool(json['darkMode'] ?? false);
    notifications = RxBool(json['notifications'] ?? false);
    sounds = RxBool(json['sounds'] ?? false);
  }

  Map<String, dynamic> toJson() => {
    'darkMode': isDarkMode.value,
    'notifications': notifications.value,
    'sounds': sounds.value,
  };
}