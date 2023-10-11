import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';

class MessageView extends StatefulWidget {
  const MessageView({Key? key}) : super(key: key);

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 300),
        child: Column(
          children: [
            Center(
              child: Obx(() => Text(
                  "Welcome ${userController.user.value.firstname}"
              )),
            ),
            ElevatedButton(onPressed: () {
              userController.addExclamation();
            }, child: const Text("Increment"))
          ],
        ),
      ),
    );
  }
}
