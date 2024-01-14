class Workout {
  final int id;
  final int burnedCalories;
  final int duration;
  final String date;
  final String name;
  final String description;
  final String thumbnail;
  final String video;
  final String muscleGroup;

  Workout(
      {required this.id,
      required this.burnedCalories,
      required this.duration,
      required this.date,
      required this.name,
      required this.description,
      required this.thumbnail,
      required this.video,
      required this.muscleGroup});

  static Workout fromJSON(Map<String, dynamic> json) {
    return Workout(
      id: json["id"] ?? 0,
      burnedCalories: json["burnedCalories"] ?? 0,
      duration: json["duration"] ?? 0,
      date: json["date"] ?? "",
      name: json["exercise"]["name"] ?? "",
      description: json["exercise"]["description"] ?? "",
      thumbnail: json["exercise"]["thumbnail"] ?? "",
      video: json["exercise"]["video"] ?? "",
      muscleGroup: json["exercise"]["muscle_group"] ?? "",
    );
  }
}
