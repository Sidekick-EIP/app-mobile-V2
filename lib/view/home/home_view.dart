import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/controller/home_controller.dart';
import 'package:sidekick_app/controller/user_controller.dart';
import 'package:sidekick_app/utils/token_storage.dart';

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
    userController.fetchUserFromBack();
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
              child: const Text("Add exclamation")
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
