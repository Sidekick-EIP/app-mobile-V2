import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/controller/home_controller.dart';
import 'package:sidekick_app/controller/user_controller.dart';

import '../../controller/preference_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final homeController = Get.put(HomeController());
  final userController = Get.put(UserController(), permanent: true);
  final preferenceController = Get.put(PreferenceController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              homeController.logout();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 300),
        child: Column(
          children: [
            Center(
              child: GetX<HomeController>(
                init: HomeController(),
                builder: (controller) {
                  if (userController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Text(
                        "Welcome ${userController.user.value.firstname}"
                    );
                  }
                }
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  userController.registerUserIntoStorage();
                },
                child: const Text("Store user")
            ),
            ElevatedButton(
                onPressed: () {
                  userController.clearUserFromStorage();
                },
                child: const Text("Clear user")
            ),
          ],
        ),
      ),
    );
  }
}
