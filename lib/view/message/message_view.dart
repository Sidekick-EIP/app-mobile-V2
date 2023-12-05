import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:sidekick_app/config/colors.dart';
import 'package:sidekick_app/controller/messages_controller.dart';

import '../../config/images.dart';
import '../../config/text_style.dart';
import '../../controller/socket_controller.dart';
import '../../controller/user_controller.dart';
import '../profile/sidekick_view.dart';

class MessageView extends StatefulWidget {
  const MessageView({Key? key}) : super(key: key);

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final userController = Get.put(UserController());
  final messageController = Get.put(MessageController());
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
    final userController = Get.find<UserController>();

    socketController.emitMessage(message.text);
    socketController.emitWriting(false);
    messageController.addMessage(
        message.text,
        userController.user.value.userId.value,
        userController.user.value.avatar.value);
  }

  @override
  Widget build(BuildContext context) {
    return !userController.isSidekickLoading.value
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(DefaultImages.hourGlass,
                  width: 200, height: 200),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  'Recherche en cours... Vous recevrez une notification lorsque le partenaire parfait sera trouvé',
                  textAlign: TextAlign.center,
                  style: pRegular14.copyWith(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          builder: (v) => const FractionallySizedBox(
                            heightFactor: 0.9,
                            child: SidekickView(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            userController.partner.value.avatar.value),
                        radius: 15,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      userController.partner.value.firstname.value,
                      style: pSemiBold20.copyWith(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: Get.height -
                    (MediaQuery.of(context).padding.top + 20 + 30 + 10) -
                    100,
                width: Get.width,
                child: GetX<MessageController>(builder: (_) {
                  return Chat(
                    theme: DefaultChatTheme(
                      primaryColor: ConstColors.primaryColor,
                      inputBackgroundColor: ConstColors.secondaryColor,
                      inputTextColor: ConstColors.blackColor,
                      inputBorderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      inputContainerDecoration: BoxDecoration(
                        color: const Color.fromRGBO(245, 245, 247, 1.0),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        border:
                            Border.all(color: Colors.transparent, width: 2.0),
                      ),
                    ),
                    messages:
                        userController.user.value.userId.toString() == 'ID'
                            ? []
                            : messageController.messages,
                    onEndReachedThreshold: 1,
                    onSendPressed: _handleSendPressed,
                    showUserAvatars: true,
                    user:
                        types.User(id: userController.user.value.userId.value),
                    inputOptions:
                        InputOptions(onTextChanged: _handleTextChanged),
                    scrollPhysics: const BouncingScrollPhysics(),
                  );
                }),
              ),
            ],
          );
  }
}
