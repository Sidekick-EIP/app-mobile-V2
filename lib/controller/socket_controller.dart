import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/controller/messages_controller.dart';
import 'package:sidekick_app/controller/user_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'home_controller.dart';

class SocketController extends GetxController {
  final socket = Rx<io.Socket?>(null);

  void initSocket(String userId) {
      socket.value = io.io(dotenv.env['API_BACK_URL']!, <String, dynamic>{
        'autoConnect': false,
        'transports': ['websocket'],
        'auth': {'token': userId},
        'forceNew': true,
      });
  }

  void connectToSocket() {
    socket.value?.connect();
  }

  bool isConnected() {
    return socket.value != null ? socket.value!.connected : false;
  }

  void setOnMessage() {
    socket.value?.on('message', (data) {
      final messageController = Get.put(MessageController());
      final userController = Get.put(UserController());
      final homeController = Get.put(HomeController());

      messageController.addMessage(data, userController.user.value.sidekickId!.value, userController.partner.value.avatar.value);
      if (homeController.flag.value == 1) {
        messageController.seeMessage();
      }
    });

    socket.value?.on('seen', (data) {
      final messageController = Get.put(MessageController());
      messageController.setAllMessagesSeen();
    });
  }

  void setOnMatching() {
    socket.value?.on('match', (data) {
      if (kDebugMode) {
        print('Partenaire trouvé!');
      }
    });
  }

  void emitMessage(String text) {
    socket.value?.emit('message', text);
  }

  void emitWriting(bool value) {
    socket.value?.emit("writing", value);
  }

  void emitSeen() {
    socket.value?.emit('seen', {});
  }

  void disconnectFromSocket() {
    socket.value?.disconnect();
    socket.value?.dispose();
    socket.value?.destroy();
  }
}