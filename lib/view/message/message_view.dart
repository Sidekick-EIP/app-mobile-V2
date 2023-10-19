import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:sidekick_app/controller/messages_controller.dart';

import '../../controller/socket_controller.dart';
import '../../controller/user_controller.dart';

class MessageView extends StatefulWidget {
  const MessageView({Key? key}) : super(key: key);

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final userController = Get.put(UserController());
  final messageController = Get.lazyPut(() => MessageController());
  final socketController = Get.put(SocketController(), permanent: true);

  void _handleTextChanged(String content) {
    final socketController = Get.put(SocketController(), permanent: true);
    if (content == "") {
      socketController.emitWriting(false);
    } else {
      socketController.emitWriting(true);
    }
  }

  void _handleSendPressed(types.PartialText message) {
    final socketController = Get.put(SocketController(), permanent: true);
    final userController = Get.put(UserController());

    socketController.emitMessage(message.text);
    socketController.emitWriting(false);
    Get.find<MessageController>().addMessage(
        message.text,
        userController.user.value.userId.value,
        userController.user.value.avatar.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetX<MessageController>(builder: (_) {
      return Chat(
        messages: userController.user.value.userId.toString() == 'ID'
            ? []
            : Get.find<MessageController>().messages.value,
        onEndReachedThreshold: 1,
        onSendPressed: _handleSendPressed,
        showUserAvatars: true,
        user: types.User(id: userController.user.value.userId.value),
        inputOptions: InputOptions(onTextChanged: _handleTextChanged),
        scrollPhysics: const BouncingScrollPhysics(),
      );
    }));
  }
}
