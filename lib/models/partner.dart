import 'package:get/get.dart';

class Partner {
  RxString avatar;
  RxString firstname;
  RxString lastname;
  RxInt size;
  RxString gender;
  RxString description;
  RxString level;
  List<RxString> activities;
  RxString goal;
  Rx<DateTime> birthDate;
  RxString location;

  Partner(
      {required this.avatar,
      required this.firstname,
      required this.lastname,
      required this.size,
      required this.gender,
      required this.description,
      required this.level,
      required this.activities,
      required this.goal,
      required this.birthDate,
      required this.location});

  static Partner fromJson(Map<String, dynamic> json) {
    return Partner(
      avatar: RxString(json['avatar'] ?? ""),
      firstname: RxString(json['firstname'] ?? ""),
      lastname: RxString(json['lastname'] ?? ""),
      size: RxInt(json['size'] ?? 0),
      gender: RxString(json['gender'] ?? ""),
      description: RxString(json['bio'] ?? ""),
      goal: RxString(json['goal'] ?? ""),
      level: RxString(json['level'] ?? ""),
      activities: (json['activities'] as List<dynamic>?)
              ?.map((activity) => RxString(activity))
              .toList() ??
          [],
      birthDate: Rx<DateTime>(json['birth_date'] != null
          ? DateTime.parse(json['birth_date'])
          : DateTime.now()),
      location: RxString(json['location'] ?? ""),
    );
  }

  //TODO To complete
  Map<String, dynamic> toJson() => {
        'avatar': avatar.value,
        'firstname': firstname.value,
        'lastname': lastname.value,
        'bio': description.value,
        'level': level.value
      };
}
