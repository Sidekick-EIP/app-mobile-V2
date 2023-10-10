class Partner {
  //TEMP Wait for back route to be updated
  late String avatar;
  final String firstname;
  final String lastname;
  final String username;
  final String description;
  late String level;

  Partner(
      {required this.avatar,
        required this.firstname,
        required this.lastname,
        required this.username,
        required this.description,
        required this.level});

  Partner copy(
      {String? firstname,
        String? avatar,
        String? lastname,
        String? username,
        String? description,
        String? level}) =>
      Partner(
          avatar: avatar ?? this.avatar,
          firstname: firstname ?? this.firstname,
          lastname: lastname ?? this.lastname,
          username: username ?? this.username,
          description: description ?? this.description,
          level: level ?? this.level);

  static Partner fromJson(Map<String, dynamic> json) => Partner(
      avatar: json['avatar'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      description: json['bio'],
      level: json['level']);

  Map<String, dynamic> toJson() => {
    'avatar': avatar,
    'firstname': firstname,
    'lastname': lastname,
    'username': username,
    'bio': description,
    'level': level
  };
}
