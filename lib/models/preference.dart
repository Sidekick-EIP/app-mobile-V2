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

  Preference.fromJson(Map<String, bool> json) {
    isDarkMode = RxBool(json['darkMode'] as bool);
    notifications = RxBool(json['notifications'] as bool);
    sounds = RxBool(json['sounds'] as bool);
  }

  Map<String, dynamic> toJson() => {
    'darkMode': isDarkMode.value,
    'notifications': notifications.value,
    'sounds': sounds.value,
  };
}
