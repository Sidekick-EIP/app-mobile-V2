//ignore_for_file: constant_identifier_names
enum Period { BREAKFAST, LUNCH, DINNER, SNACKS }

class Nutrition {
  late int calories;
  late int carbs;
  late int protein;
  late int fat;
  late Map<String, Map<String, dynamic>> meals;

  Nutrition(this.calories, this.carbs, this.protein, this.fat, this.meals);

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      json['calories'],
      json['carbs'],
      json['protein'],
      json['fat'],
      {
        'breakfast': {
          "meals": (json['meals']['breakfast']["meals"] as List<dynamic>)
              .map((e) => Food.fromJson(e))
              .toList(),
          "calories": json['meals']['breakfast']["calories"]
        },
        'lunch': {
          "meals": (json['meals']['lunch']["meals"] as List<dynamic>)
              .map((e) => Food.fromJson(e))
              .toList(),
          "calories": json['meals']['lunch']["calories"]
        },
        'dinners': {
          "meals": (json['meals']['dinners']["meals"] as List<dynamic>)
              .map((e) => Food.fromJson(e))
              .toList(),
          "calories": json['meals']['dinners']["calories"]
        },
        'snacks': {
          "meals": (json['meals']['snacks']["meals"] as List<dynamic>)
              .map((e) => Food.fromJson(e))
              .toList(),
          "calories": json['meals']['snacks']["calories"]
        },
      },
    );
  }
}

class Food {
  late int id;
  late String name;
  late String picture;
  late int protein;
  late int carbs;
  late int fat;
  late int weight;
  late int calories;
  late Period period;
  late String date;

  Food({
    required this.id,
    required this.name,
    required this.picture,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.weight,
    required this.calories,
    required this.period,
    required this.date,
  });

  static Period stringToPeriod(String period) {
    switch (period) {
      case 'BREAKFAST':
        return Period.BREAKFAST;
      case 'LUNCH':
        return Period.LUNCH;
      case 'DINNER':
        return Period.DINNER;
      case 'SNACKS':
        return Period.SNACKS;
      default:
        throw ArgumentError('Invalid period: $period');
    }
  }

  Food.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        picture = json["picture"],
        protein = json["protein"],
        carbs = json["carbs"],
        fat = json["fat"],
        weight = json["weight"],
        calories = json["calories"],
        period = stringToPeriod(json["period"]),
        date = json["date"];
}
