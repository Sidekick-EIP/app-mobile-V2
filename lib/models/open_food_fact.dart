class ResultSearch {
  final String name;
  final String brand;
  final double kcalories;
  final double proteines;
  final double carbohydrates;
  final double lipides;
  int quantity;
  final String urlImage;
  final String nutriscore;

  ResultSearch({
    this.name = "",
    this.brand = "",
    this.kcalories = -1,
    this.proteines = -1,
    this.carbohydrates = -1,
    this.lipides = -1,
    this.quantity = 100,
    this.urlImage =
        "https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns=",
    this.nutriscore = "",
  });

  factory ResultSearch.fromJSON(Map<String, dynamic> json) {
    var kcal = json["nutriments"]["energy-kcal_100g"];
    var prt = json["nutriments"]["proteins_100g"];
    var carbs = json["nutriments"]["carbohydrates_100g"];
    var lpd = json["nutriments"]["fat_100g"];

    return ResultSearch(
        name: json["product_name"] ?? "Und3f1nd",
        brand: json["brands"] ?? "Und3f1ndBrand",
        kcalories: kcal != null ? double.parse(kcal.toString()) : -1,
        proteines: prt != null ? double.parse(prt.toString()) : -1,
        carbohydrates: carbs != null ? double.parse(carbs.toString()) : -1.0,
        lipides: lpd != null ? double.parse(lpd.toString()) : -1.0,
        urlImage: json["image_front_url"] ??
            "https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns=",
        nutriscore: json["nutrition_grades"] ?? "Und3f1ndScore");
  }
}
