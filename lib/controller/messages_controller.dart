import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:sidekick_app/controller/socket_controller.dart';
import 'package:sidekick_app/controller/user_controller.dart';
import 'package:sidekick_app/utils/http_request.dart';
import 'package:uuid/uuid.dart';

class MessageController extends GetxController {
  RxList messages = [].obs;
  RxBool isLoading = false.obs;
  RxString cursor = ''.obs;

  String _getLastMsgId(messageJson) {
    final messageList = (jsonDecode(messageJson) as List);
    messageList.sort((a, b) => DateTime.parse(b['createdAt']).millisecondsSinceEpoch!.compareTo(DateTime.parse(a['createdAt']).millisecondsSinceEpoch!));
    return messageList[messageList.length - 1]['id'];
  }

  Future<void> fetchFurtherMessagesFromBack() async {
    final response = await HttpRequest.mainGet('/chat/v2/all/?cursor=${cursor.value}');

    if (response.statusCode == 200) {
      final userController = Get.put(UserController());
      if ((jsonDecode(response.body) as List).isEmpty) return;
      cursor.value = _getLastMsgId(response.body);
      registerFurtherMessageData(
          response.body,
          types.User(
            firstName: userController.user.value.firstname.value,
            id: userController.user.value.userId.value,
            imageUrl: userController.user.value.avatar.value,
            lastName: userController.user.value.lastname.value,
          ),
          types.User(
              firstName: userController.partner.value.firstname.value,
              id: userController.user.value.sidekickId!.value,
              lastName: userController.partner.value.lastname.value,
              imageUrl: userController.partner.value.avatar.value));
    } else if (response.statusCode == 500) {
      if (kDebugMode) {
        print("Error 500 from server");
      }
    }
  }

  Future<void> fetchMessagesFromBack() async {
    final response = await HttpRequest.mainGet('/chat/v2/all');

    if (response.statusCode == 200) {
      final userController = Get.put(UserController());
      cursor.value = _getLastMsgId(response.body);
      registerMessageData(
          response.body,
          types.User(
            firstName: userController.user.value.firstname.value,
            id: userController.user.value.userId.value,
            imageUrl: userController.user.value.avatar.value,
            lastName: userController.user.value.lastname.value,
          ),
          types.User(
              firstName: userController.partner.value.firstname.value,
              id: userController.user.value.sidekickId!.value,
              lastName: userController.partner.value.lastname.value,
              imageUrl: userController.partner.value.avatar.value));
    } else if (response.statusCode == 500) {
      if (kDebugMode) {
        print("Error 500 from server");
      }
    }
  }

  registerFurtherMessageData(messageJson, types.User user, types.User partner) {
    final messageList = (jsonDecode(messageJson) as List)
        .map((e) => types.TextMessage(
        author: e['from_id'] == user.id ? user : partner,
        createdAt: DateTime.parse(e['createdAt']).millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: e['content'],
        status: e['seen'] ? types.Status.seen : types.Status.delivered,
        showStatus: true))
        .toList();
    messageList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    messages.addAll(messageList);
  }

  registerMessageData(messageJson, types.User user, types.User partner) {
    final messageList = (jsonDecode(messageJson) as List)
        .map((e) => types.TextMessage(
            author: e['from_id'] == user.id ? user : partner,
            createdAt: DateTime.parse(e['createdAt']).millisecondsSinceEpoch,
            id: const Uuid().v4(),
            text: e['content'],
            status: e['seen'] ? types.Status.seen : types.Status.delivered,
            showStatus: true))
        .toList();
    messageList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    messages.value = messageList;
  }

  addMessage(String data, String userId, String avatar) {
    messages.insert(
        0,
        types.TextMessage(
            author: types.User(id: userId, imageUrl: avatar),
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: const Uuid().v4(),
            text: data,
            status: types.Status.delivered //TODO handle loading and error
            ));
  }

  void setAllMessagesSeen() {
    if (messages.isNotEmpty) {
      messages.value =
          messages.map((e) => e.copyWith(status: types.Status.seen)).toList();
    }
  }

  void seeMessage() {
    final userController = Get.put(UserController());
    final socketController = Get.put(SocketController());

    if (messages.isNotEmpty &&
        messages[0].author.id != userController.user.value.userId.value) {
      socketController.emitSeen();
    }
  }

  @override
  void onReady() async {
    super.onReady();
    try {
      isLoading.value = true;
      await fetchMessagesFromBack();
      seeMessage();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
