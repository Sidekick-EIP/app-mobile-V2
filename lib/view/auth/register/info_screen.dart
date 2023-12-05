import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sidekick_app/view/auth/signin_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import '../../../config/colors.dart';
import '../../../config/text_style.dart';
import '../../../controller/auth_controller.dart';
import '../../../utils/is_valid_date.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_textfield.dart';
import 'form/skip_screen.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final authController = Get.put(AuthController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  String? validateData() {
    if (nameController.text.isEmpty) {
      return "Veuillez entrer votre nom.";
    }
    if (surnameController.text.isEmpty) {
      return "Veuillez entrer votre prénom.";
    }
    if (!isValidDate(birthDateController.text)) {
      return "Veuillez entrer une date de naissance valide.";
    }
    if (descriptionController.text.isEmpty) {
      return "Veuillez entrer une description.";
    }
    if (cityController.text.isEmpty) {
      return "Veuillez entrer une ville.";
    }
    return null;
  }

  Future<List<String>> getFrenchCities(String query) async {
    const String username = 'sidekick';
    var url = Uri.parse(
        'http://api.geonames.org/searchJSON?formatted=true&q=$query&country=FR&maxRows=10&lang=fr&username=$username&style=full');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> geonames = data['geonames'];
      List<String> cities =
          geonames.map<String>((json) => json['name']).toList();
      if (cities.isEmpty) {
        cities.add("Aucune ville trouvée");
      }
      return cities;
    } else {
      throw Exception('Failed to load cities');
    }
  }

  void _showCupertinoDatePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              birthDateController.text =
                  DateFormat('dd/MM/yyyy').format(newDate).toString();
            },
            minimumYear: 1900,
            maximumYear: DateTime.now().year,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.secondaryColor,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Text(
                        "Remplissez votre profil",
                        style: pSemiBold20.copyWith(
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        text: "Nom",
                        textEditingController: nameController,
                        onChanged: (value) {
                          authController.updateLastname(value);
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        text: "Prénom",
                        textEditingController: surnameController,
                        onChanged: (value) {
                          authController.updateFirstname(value);
                        },
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: _showCupertinoDatePicker,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            text: "Date de naissance",
                            textEditingController: birthDateController,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        text: "Description",
                        textEditingController: descriptionController,
                        onChanged: (value) {
                          authController.updateDescription(value);
                        },
                        minLines: 5,
                        maxLines: 10,
                        height: 100,
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 52,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          color: const Color(0xffF8FAFC),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: cityController,
                              style: pSemiBold18.copyWith(
                                fontSize: 13,
                              ),
                              decoration: InputDecoration(
                                hintText: "Ville",
                                border: InputBorder.none,
                                hintStyle: pRegular14.copyWith(
                                  fontSize: 13,
                                  color: ConstColors.lightBlackColor,
                                ),
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              return await getFrenchCities(pattern);
                            },
                            itemBuilder: (context, suggestion) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(23),
                                  color: ConstColors.secondaryColor,
                                ),
                                child: ListTile(
                                  title: Text(
                                    suggestion,
                                    style: pRegular14.copyWith(
                                      fontSize: 13,
                                      color: ConstColors.lightBlackColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              cityController.text = suggestion;
                              authController.updateCity(suggestion);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        title: "Compléter mon profil",
                        width: Get.width,
                        onTap: () {
                          String? errorMessage = validateData();
                          if (errorMessage == null) {
                            Get.to(() => const SkipScreen(),
                                transition: Transition.rightToLeft);
                          } else {
                            Get.snackbar("Erreur", errorMessage,
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(
                () => const SignInScreen(),
                transition: Transition.rightToLeft,
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Vous avez déjà un compte ?  ",
                    style: pRegular14.copyWith(
                      fontSize: 13,
                      color: ConstColors.lightBlackColor,
                    ),
                  ),
                  Text(
                    "Connexion",
                    style: pRegular14.copyWith(
                      fontSize: 13,
                      color: ConstColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
