import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sidekick_app/controller/openfoodfact_controller.dart';
import 'package:sidekick_app/models/openFoodFact.dart';
import 'package:sidekick_app/view/nutrition/edit_meal.dart';
import 'package:sidekick_app/view/nutrition/detail_meal.dart';

import '../../main.dart';

// typedef CallBackTypeInt = void Function(int a);
// typedef CallBackType = void Function(ResultSearch newAliment);

class AddMeal extends StatefulWidget {
  // final CallBackType callback;

  const AddMeal({Key? key}) : super(key: key);

  @override
  State<AddMeal> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddMeal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0, // Remove shadow
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: const SingleChildScrollView(
            child: Column(children: [
              TopBar(),
            ]),
          ),
        ),
      ),
    );
  }
}

class TopBar extends StatefulWidget {
  // final CallBackType callback;

  const TopBar({
    Key? key,
    // required this.callback
  }) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  TextEditingController searchController = TextEditingController();
  final query = ValueNotifier<String>("riz");
  final isLoading = ValueNotifier<bool>(false);
  final isHealthy = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SearchWidget(
          width: width,
          query: query,
          isLoading: isLoading,
          getMeal: (value) async {
            isLoading.value = true;
            await getMeal(query.value);
            isLoading.value = false;
            setState(() {});
          },
        ),
        ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (context, value, _) {
            return ValueListenableBuilder(
              valueListenable: query,
              builder: (context, value, _) {
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: width * .15,
                        ),
                        // const Text("Afficher que les aliments sains"),
                        // ValueListenableBuilder(
                        //   valueListenable: isHealthy,
                        //   builder: (context, value, _) {
                        //     return Switch(
                        //       value: isHealthy.value,
                        //       onChanged: (val) {
                        //         isHealthy.value = !isHealthy.value;
                        //         getIt<MealEditorBlock>().isHealthy = isHealthy.value;
                        //       },
                        //     );
                        //   },
                        // )
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
        SizedBox(
          height: height * 0.01,
        ),
        ShowSearchAPIResult(
          // callback: widget.callback,
          searchQuery: query.value,
        ),
      ],
    );
  }
}

class ShowSearchAPIResult extends StatefulWidget {
  const ShowSearchAPIResult(
      {Key? key,
      // required this.callback,
      required this.searchQuery})
      : super(key: key);

  final String searchQuery;
  // final CallBackType callback;

  @override
  State<ShowSearchAPIResult> createState() => _ShowSearchAPIResultState();
}

class _ShowSearchAPIResultState extends State<ShowSearchAPIResult> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder<dynamic>(
      future: getMeal(widget.searchQuery),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<ResultSearch> showResult = snapshot.data as List<ResultSearch>;
            removeEmptyResult(showResult);

            return SizedBox(
              width: 400,
              height: 800,
              child: (ListView.builder(
                itemCount: showResult.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      MealPeriodCard(
                        width: width,
                        height: height,
                        color: Colors.green,
                        colorAccent: const Color.fromARGB(255, 255, 255, 255),
                        mealName: showResult[index].name,
                        emojiImg: showResult[index].urlImage,
                        showResult: showResult[index],
                      ),
                      const SizedBox(height: 10)
                    ],
                  );
                },
              )),
            );
          }
          if (snapshot.hasError) {
            return (const Text("Error"));
          }
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return (const Text("NoData"));
        }
      },
    );
  }
}

class SearchWidget extends StatefulWidget {
  final double width;
  final ValueNotifier<String> query;
  final ValueNotifier<bool> isLoading;
  final Function(String) getMeal;

  const SearchWidget({
    Key? key,
    required this.width,
    required this.query,
    required this.isLoading,
    required this.getMeal,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController searchController = TextEditingController();

  void onSearch(String value) async {
    widget.isLoading.value = true;
    await widget.getMeal(value);
    widget.isLoading.value = false;
  }

  void onTextChanged(String value) {
    widget.query.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: CustomSearchBar(
        controller: searchController,
        onSearch: onSearch,
        onTextChanged: onTextChanged,
        width: widget.width,
      ),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final Function(String) onTextChanged;
  final String hintText;
  final double width;

  const CustomSearchBar({
    Key? key,
    required this.controller,
    required this.onSearch,
    required this.onTextChanged,
    this.hintText = 'Chercher un aliment...',
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color.fromARGB(66, 128, 128, 128),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onTextChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                icon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
              ),
              onSubmitted: onSearch,
            ),
          ),
        ],
      ),
    );
  }
}

class MealPeriodCard extends StatefulWidget {
  MealPeriodCard({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.colorAccent,
    required this.mealName,
    required this.emojiImg,
    required this.showResult,
  });

  final double width;
  final double height;
  final Color color;
  final Color colorAccent;
  final String mealName;
  final String emojiImg;
  ResultSearch showResult;

  @override
  State<MealPeriodCard> createState() => _MealPeriodCardState();
}

class _MealPeriodCardState extends State<MealPeriodCard> {
  // SampleItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    double totalMacros = widget.showResult.carbohydrates + widget.showResult.proteines + widget.showResult.lipides;
    return InkWell(
      onTap: () {
        Get.to(
          () =>  detailMeal(showResult: widget.showResult),
          transition: Transition.rightToLeft,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color.fromARGB(66, 128, 128, 128),
          ),
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        width: widget.width * 0.9,
        height: widget.height * 0.21,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: widget.width * 0.15,
                  height: widget.height * 0.07,
                  decoration: BoxDecoration(
                    color: widget.colorAccent,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: Image.network(
                      widget.emojiImg,
                    ),
                  ),
                ),
                SizedBox(
                  width: widget.width * 0.66,
                  height: widget.height * 0.1,
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: widget.width * 0.55,
                            height: widget.height * 0.05,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.mealName,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widget.width * 0.55,
                            height: widget.height * 0.02,
                            child: Text(
                              "${widget.showResult.kcalories} kcal ° ${widget.showResult.quantity} g",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MacrosWidgetCard(
                  width: widget.width,
                  height: widget.height,
                  grams: "${widget.showResult.carbohydrates.toString()} g",
                  macros: "Glucides",
                  barColor: const Color.fromARGB(255, 98, 7, 255),
                  percent: widget.showResult.carbohydrates / totalMacros,
                ),
                MacrosWidgetCard(
                  width: widget.width,
                  height: widget.height,
                  grams: "${widget.showResult.proteines.toString()} g",
                  macros: "Proteines",
                  barColor: Colors.red,
                  percent: widget.showResult.proteines / totalMacros,
                ),
                MacrosWidgetCard(
                  width: widget.width,
                  height: widget.height,
                  grams: "${widget.showResult.lipides.toString()} g",
                  macros: "Lipides",
                  barColor: Colors.amber,
                  percent: widget.showResult.lipides / totalMacros,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MacrosWidgetCard extends StatelessWidget {
  const MacrosWidgetCard({
    super.key,
    required this.width,
    required this.height,
    required this.grams,
    required this.macros,
    required this.barColor,
    required this.percent,
  });

  final double width;
  final double height;
  final String grams;
  final String macros;
  final Color barColor;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: width * 0.22,
          height: height * 0.1,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.04,
                    height: height * 0.09,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RotatedBox(
                          quarterTurns: -1,
                          child: LinearPercentIndicator(
                            width: height * 0.09,
                            animation: true,
                            lineHeight: 10,
                            animationDuration: 1000,
                            percent: percent,
                            barRadius: const Radius.circular(20),
                            curve: Curves.bounceOut,
                            progressColor: barColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: width * 0.16,
                height: height * 0.07,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width * 0.16,
                      height: height * 0.025,
                      child: Text(
                        grams,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.16,
                      height: height * 0.03,
                      child: Text(
                        macros,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
