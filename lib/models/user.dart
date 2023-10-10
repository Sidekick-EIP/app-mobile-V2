class User {
  late String avatar;
  final String userId;
  final String? sidekickId;
  final String email;
  final bool isDarkMode;
  late String firstname;
  late String lastname;
  late int size;
  late int weight;
  late int goalWeight;
  late String gender;
  late String description;
  late String level;
  late List<dynamic> activities;
  late String goal;
  final String birthDate;

  User(
      {required this.avatar,
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
        required this.birthDate});

  void changePathUser(String path) {
    avatar = path;
  }

  User copy(
      {String? avatar,
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
        String? birthDate}) =>
      User(
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
          birthDate: birthDate ?? this.birthDate);

  static User fromJson(Map<String, dynamic> json) => User(
      avatar: json['avatar'],
      userId: json['userId'],
      sidekickId: json['sidekick_id'],
      email: json['email'],
      isDarkMode: json['isDarkMode'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      size: json['size'],
      weight: json['weight'],
      goalWeight: json['goal_weight'],
      gender: json['gender'],
      description: json['description'],
      level: json['level'],
      activities: json['activities'],
      goal: json['goal'],
      birthDate: json['birth_date']);

  Map<String, dynamic> toJson() => {
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
    'birth_date': birthDate
  };
}
