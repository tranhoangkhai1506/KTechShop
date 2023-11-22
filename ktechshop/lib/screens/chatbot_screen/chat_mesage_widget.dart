import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ktechshop/screens/chatbot_screen/chat_mesage_type.dart';

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;

  const ChatMessageWidget(
      {super.key, required this.text, required this.chatMessageType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: chatMessageType == ChatMessageType.bot
          ? const Color(0xFF444654)
          : const Color(0xFF343541),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chatMessageType == ChatMessageType.bot
              ? Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Image.asset('assets/images/openaiLogo.png', scale: 1.5,),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: const CircleAvatar(
                    backgroundColor: Color(0xFF444654),
                    child: Icon(
                      CupertinoIcons.person_alt,
                    ),
                  ),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(16)),
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
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
