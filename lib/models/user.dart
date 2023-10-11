import 'package:get/get.dart';

class User {
  RxString avatar;
  final RxString userId;
  final RxString? sidekickId;
  final RxString email;
  final RxBool isDarkMode;
  RxString firstname;
  RxString lastname;
  RxInt size;
  RxInt weight;
  RxInt goalWeight;
  RxString gender;
  RxString description;
  RxString level;
  List<String> activities;
  RxString goal;
  final Rx<DateTime> birthDate;

  User({
    required this.avatar,
    required this.userId,
    this.sidekickId,
    required this.email,
    required this.isDarkMode,
    required this.firstname,
    required this.lastname,
    required this.size,
    required this.weight,
    required this.goalWeight,
    required this.gender,
    required this.description,
    required this.level,
    required this.activities,
    required this.goal,
    required this.birthDate,
  });

  void changeAvatarPath(String path) {
    avatar = path.obs;
  }

  User copy({
    RxString? avatar,
    RxString? userId,
    RxString? sidekickId,
    RxString? email,
    RxBool? isDarkMode,
    RxString? firstname,
    RxString? lastname,
    RxInt? size,
    RxInt? weight,
    RxInt? goalWeight,
    RxString? gender,
    RxString? description,
    RxString? level,
    List<String>? activities,
    RxString? goal,
    Rx<DateTime>? birthDate,
  }) {
    return User(
      avatar: avatar ?? this.avatar,
      userId: userId ?? this.userId,
      sidekickId: sidekickId ?? this.sidekickId,
      email: email ?? this.email,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      size: size ?? this.size,
      weight: weight ?? this.weight,
      goalWeight: goalWeight ?? this.goalWeight,
      gender: gender ?? this.gender,
      description: description ?? this.description,
      level: level ?? this.level,
      activities: activities ?? this.activities,
      goal: goal ?? this.goal,
      birthDate: birthDate ?? this.birthDate,
    );
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      avatar: RxString(json['avatar'] ?? ""),
      userId: RxString(json['userId'] ?? ""),
      sidekickId:
          json['sidekick_id'] != null ? RxString(json['sidekick_id']) : null,
      email: RxString(json['email'] ?? ""),
      isDarkMode: RxBool(json['isDarkMode'] ?? false),
      firstname: RxString(json['firstname'] ?? ""),
      lastname: RxString(json['lastname'] ?? ""),
      size: RxInt(json['size'] ?? 0),
      weight: RxInt(json['weight'] ?? 0),
      goalWeight: RxInt(json['goal_weight'] ?? 0),
      gender: RxString(json['gender'] ?? ""),
      description: RxString(json['description'] ?? ""),
      level: RxString(json['level'] ?? ""),
      activities: List<String>.from(json['activities'] ?? []),
      goal: RxString(json['goal'] ?? ""),
      birthDate: Rx<DateTime>(json['birth_date'] != null ? DateTime.parse(json['birth_date']) : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'userId': userId,
      'sidekick_id': sidekickId,
      'email': email,
      'isDarkMode': isDarkMode,
      'firstname': firstname,
      'lastname': lastname,
      'size': size,
      'weight': weight,
      'goal_weight': goalWeight,
      'gender': gender,
      'description': description,
      'level': level,
      'activities': activities,
      'goal': goal,
      'birth_date': birthDate,
    };
  }
}
