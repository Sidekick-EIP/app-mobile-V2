import 'package:flutter/material.dart';
import 'package:sidekick_app/view/profile/profile_view.dart';

import '../../config/colors.dart';
import '../../config/images.dart';
import '../../config/text_style.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: ConstColors.blackColor,
          ),
        ),
        title: Text(
          "Informations du compte",
          style: pSemiBold20.copyWith(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 0, top: 0),
            child: IconButton(
              icon: const Icon(Icons.add_circle_outline, color: ConstColors.primaryColor),
              onPressed: () {
              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    height: 77,
                    width: 77,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(DefaultImages.p2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: ConstColors.secondaryColor,
                    borderRadius: BorderRadius.circular(23.1),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xffEAF0F6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 30, bottom: 30),
                    child: Column(
                      children: [
                        row(
                          "Name",
                          "",
                          () {},
                          Row(
                            children: [
                              Text(
                                "Deborah Moore   ",
                                style: pRegular14.copyWith(
                                  fontSize: 15.41,
                                  color: ConstColors.lightBlackColor,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          color: Color(0xffF1F4F8),
                        ),
                        const SizedBox(height: 10),
                        row(
                          "Weight",
                          "",
                          () {},
                          Row(
                            children: [
                              Text(
                                "52.7 kg   ",
                                style: pRegular14.copyWith(
                                  fontSize: 15.41,
                                  color: ConstColors.lightBlackColor,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          color: Color(0xffF1F4F8),
                        ),
                        const SizedBox(height: 10),
                        row(
                          "Date of Birth",
                          "",
                          () {},
                          Row(
                            children: [
                              Text(
                                "Nov 30, 1990   ",
                                style: pRegular14.copyWith(
                                  fontSize: 15.41,
                                  color: ConstColors.lightBlackColor,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffA9B2BA),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          color: Color(0xffF1F4F8),
                        ),
                        const SizedBox(height: 10),
                        row(
                          "Email",
                          "",
                          () {},
                          Text(
                            "deborah.moore@email.com",
                            style: pRegular14.copyWith(
                              fontSize: 15.41,
                              color: ConstColors.lightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
