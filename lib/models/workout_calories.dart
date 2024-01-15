class WorkoutCalories {
  final int burnedCalories;

  WorkoutCalories({required this.burnedCalories});

  static WorkoutCalories fromJSON(Map<String, dynamic> json) {
    return WorkoutCalories(burnedCalories: json["burnedCalories"] ?? 0);
  }

  @override
  String toString() {
    return 'Burned Calories: $burnedCalories';
  }
}
