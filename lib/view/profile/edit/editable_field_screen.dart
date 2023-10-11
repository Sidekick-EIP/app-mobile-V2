import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/colors.dart';
import '../../../config/text_style.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_textfield.dart';

class EditableFieldScreen extends StatefulWidget {
  final String title;
  final String fieldLabel;
  final Rx<dynamic> fieldObservable;
  final String suffixText;

  const EditableFieldScreen({
    Key? key,
    required this.title,
    required this.fieldLabel,
    required this.fieldObservable,
    this.suffixText = "",
  }) : super(key: key);

  @override
  State<EditableFieldScreen> createState() => _EditableFieldScreenState();
}

class _EditableFieldScreenState extends State<EditableFieldScreen> {
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;
  dynamic initialValue;

  String? errorMessage;

  bool isValid() {
    String value = controller.text;
    DateTime? parsedDate;

    setState(() {
      errorMessage = null;
    });

    if (widget.fieldObservable is RxString && (value.isEmpty)) {
      setState(() {
        errorMessage = "Ce champ ne peut pas être vide.";
      });
      return false;
    }

    if (widget.fieldObservable is RxInt) {
      int intValue = int.parse(value);
      if (widget.title.contains("poids") && (intValue < 20 || intValue > 250)) {
        setState(() {
          errorMessage = "Le poids doit être compris entre 20 et 250 kg.";
        });
        return false;
      }

      if (widget.title.contains("taille") &&
          (intValue < 100 || intValue > 250)) {
        setState(() {
          errorMessage = "La taille doit être comprise entre 100 et 250 cm.";
        });
        return false;
      }
    }

    if (widget.fieldObservable is Rx<DateTime>) {
      parsedDate = tryParseDate(value);
      if (parsedDate == null) {
        setState(() {
          errorMessage = "Entrez la date au format dd/MM/yyyy.";
        });
        return false;
      }

      if (parsedDate.isAfter(DateTime.now())) {
        setState(() {
          errorMessage = "La date doit être antérieure à aujourd'hui.";
        });
        return false;
      }
    }

    return true;
  }

  DateTime? tryParseDate(String date) {
    try {
      return DateFormat('dd/MM/yyyy').parse(date);
    } catch (e) {
      return null;
    }
  }

  bool isNumeric(String value) {
    return int.tryParse(value) != null;
  }

  bool isValidDate(String date) {
    try {
      DateFormat('dd/MM/yyyy').parse(date);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    initialValue = widget.fieldObservable.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.secondaryColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            widget.fieldObservable.value = initialValue;
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: ConstColors.blackColor,
          ),
        ),
      ),
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
                        widget.title,
                        style: pSemiBold20.copyWith(
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        text: widget.fieldLabel,
                        textEditingController: controller,
                        keyboardType: widget.fieldObservable is RxInt
                            ? TextInputType.number
                            : TextInputType.text,
                        onChanged: (value) {
                          if (widget.fieldObservable is RxInt) {
                            int? parsedValue = int.tryParse(value);
                            if (parsedValue != null) {
                              widget.fieldObservable.value = parsedValue;
                            }
                          } else {
                            widget.fieldObservable.value = value;
                          }
                        },
                        suffixText: widget.suffixText ?? "",
                      ),
                      const SizedBox(height: 30),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 35),
            child: CustomButton(
              title: "Valider",
              width: Get.width,
              onTap: () {
                if (isValid()) {
                  Get.back();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
