import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';
import '../../controller/home_controller.dart';
import '../../utils/token_storage.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final homeController = Get.put(HomeController());
  final userController = Get.put(UserController(), permanent: true);
  final TokenStorage tokenStorage = TokenStorage();

  _loadTokens() async {
    var token = await tokenStorage.getAccessToken() ?? "";
  }

  @override
  void initState() {
    _loadTokens();
    super.initState();
  }

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
                userController.addExclamation();
              },
              child: Text("Add exclamation")
            ),
            ElevatedButton(
                onPressed: () {
                  userController.registerUserIntoStorage();
                },
                child: Text("Store user")
            ),
            ElevatedButton(
                onPressed: () {
                  userController.clearUserFromStorage();
                },
                child: Text("Clear user")
            ),
          ],
        ),
      ),
    );
  }
}
