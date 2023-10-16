import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController extends GetxController {
  final socket = Rx<IO.Socket?>(null);

  void initSocket(String userId) {
      socket.value = IO.io(dotenv.env['API_BACK_URL']!, <String, dynamic>{
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
      print(data);
    });
  }

  void setOnMatching() {
    socket.value?.on('match', (data) {
      print('Partenaire trouvé!');
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