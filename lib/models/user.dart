class User {
  String avatar;
  final String userId;
  final String? sidekickId;
  final String email;
  final bool isDarkMode;
  String firstname;
  String lastname;
  int size;
  int weight;
  int goalWeight;
  String gender;
  String description;
  String level;
  List<String> activities;
  String goal;
  final String birthDate;

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
    avatar = path;
  }

  User copy({
    String? avatar,
    String? userId,
    String? sidekickId,
    String? email,
    bool? isDarkMode,
    String? firstname,
    String? lastname,
    int? size,
    int? weight,
    int? goalWeight,
    String? gender,
    String? description,
    String? level,
    List<String>? activities,
    String? goal,
    String? birthDate,
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
      avatar: json['avatar'] ?? "",  // default to an empty string if null
      userId: json['userId'] ?? "",
      sidekickId: json['sidekick_id'],
      email: json['email'] ?? "",
      isDarkMode: json['isDarkMode'] ?? false, // default to false if null
      firstname: json['firstname'] ?? "",
      lastname: json['lastname'] ?? "",
      size: json['size'] as int? ?? 0,  // default to 0 if null
      weight: json['weight'] as int? ?? 0,
      goalWeight: json['goal_weight'] as int? ?? 0,
      gender: json['gender'] ?? "",
      description: json['description'] ?? "",
      level: json['level'] ?? "",
      activities: List<String>.from(json['activities'] ?? []),  // default to an empty list if null
      goal: json['goal'] ?? "",
      birthDate: json['birth_date'] ?? "",
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
