class Exercise {
  final int id;
  final String name;
  final String description;
  final String thumbnail;
  final String video;
  final String muscleGroup;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.video,
    required this.muscleGroup
  });

  static Exercise fromJSON(Map<String, dynamic> json) {
    return Exercise(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      thumbnail: json["thumbnail"] ?? "",
      video: json["video"] ?? "",
      muscleGroup: json["muscle_group"] ?? "",
    );
  }
}