import 'package:sidekick_app/main.dart';
import 'package:sidekick_app/models/open_food_fact.dart';
import 'package:sidekick_app/view/nutrition/openfoodfactApi.dart';

List<ResultSearch> removeEmptyResult(List<ResultSearch> showResult) {
  if (showResult.isNotEmpty) {
    List<ResultSearch> finalShowResult = showResult;
    finalShowResult.removeWhere((element) => element.name == "Und3f1nd");
    finalShowResult.removeWhere((element) => element.nutriscore == "Und3f1ndScore");
    finalShowResult.removeWhere((element) => element.brand == "Und3f1ndBrand");

    finalShowResult.removeWhere((element) => element.kcalories == -1 || element.proteines == -1 || element.carbohydrates == -1 || element.lipides == -1);

    // if (getIt<MealEditorBlock>().isHealthy) {
    //   finalShowResult.removeWhere((element) => element.nutriscore == "d" || element.nutriscore == "e");
    // }
    return finalShowResult;
  }
  return [];
}

Future<List<ResultSearch>> getMeal(String query) async {
  Map<String, String> filterParameter = {"action": "process", "search_terms": query, "sort_by": "unique_scans_n", "page_size": "30", "json": "1"};
  var response = await getIt<ApiClient>().get(
    endpoint: "search.pl",
    queryParams: filterParameter,
  );
  if (response.statusCode == 200) {
    var products = response.body["products"] as List;
    if (products.isNotEmpty) {
      var list = products.map((e) => ResultSearch.fromJSON(e)).toList();
      return list;
    } else {
      return [];
    }
  } else {
    throw ("can't fetch search ingredient");
  }
}

Map<String, String> getQueryParameter(String filter) {
  switch (filter) {
    case "Sans huile de palme":
      return {"ingredients_from_palm_oil": "without"};
    case "Aliments sans sucres":
      return {"nutriment_0": "sugars", "nutriment_compare_0": "lt", "nutriment_value_0": "10"};
    case "Aliments faible en gras":
      return {"nutriment_0": "fat", "nutriment_compare_0": "lt", "nutriment_value_0": "10"};

    default:
      return {};
  }
}
