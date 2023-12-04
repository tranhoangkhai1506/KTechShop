import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/screens/chatbot_screen/chat_mesage_type.dart';
import 'package:ktechshop/screens/chatbot_screen/chat_mesage_widget.dart';
import 'package:ktechshop/screens/custom_bottom_bar/custom_bottom_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

Future<String> generateResponse(String prompt) async {
  const apiKey = ""; // Tạo Key ở platform.openai rồi thêm vào.
  var url = Uri.https("api.openai.com", "/v1/completions");
  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey"
    },
    body: json.encode({
      "model": "text-davinci-003",
      "prompt": prompt,
      "temperature": 1,
      "max_tokens": 4000,
      "top_p": 1,
      "frequency_penalty": 0.0,
      "presence_penalty": 0.0
    }),
  );

  Map<String, dynamic> newresponse = jsonDecode(response.body);
  return newresponse['choices'][0]['text'];
}

class _ChatScreenState extends State<ChatScreen> {
  PageController pageController = PageController(viewportFraction: 0.8);
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late bool isLoading;

  final List<String> pageTexts = [
    'Suggest some high-end laptops for office use?',
    'Suggest some gaming laptops in the price range of 20 to 25 million?',
    'Suggest some good mechanical keyboard models?',
    'Suggest some good headphone models?',
    'Suggest for me laptop to work?',
  ];

  @override
  void initState() {
    super.initState();
    isLoading = false;
    pageController.dispose();
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ChatBot Tư Vấn",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF444654),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () async {
            Routes.instance.push(
              widget: CustomBottomBar(),
              context: context,
            );
          },
        ),
      ),
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  var message = _messages[index];
                  return ChatMessageWidget(
                    text: message.text,
                    chatMessageType: message.chatMessageType,
                  );
                },
              ),
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 70,
              child: PageView.builder(
                controller: pageController,
                itemCount: pageTexts.length,
                itemBuilder: (context, position) {
                  return TextButton(
                    onPressed: () {
                      _textController.text = pageTexts[position];
                      setState(() {
                        _messages.add(
                          ChatMessage(
                            text: _textController.text,
                            chatMessageType: ChatMessageType.user,
                          ),
                        );
                        isLoading = true;
                      });
                      var input = _textController.text;
                      _textController.clear();
                      Future.delayed(const Duration(milliseconds: 50))
                          .then((_) => _scrollDown());
                      generateResponse(input).then((value) {
                        setState(() {
                          isLoading = false;
                          _messages.add(
                            ChatMessage(
                                text: value,
                                chatMessageType: ChatMessageType.bot),
                          );
                        });
                      });
                      _textController.clear();
                      _textController.clear();
                      Future.delayed(const Duration(milliseconds: 50))
                          .then((_) => _scrollDown());
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            pageTexts[position],
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(color: Colors.white),
                      controller: _textController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xFF444654),
                        filled: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isLoading,
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFF444654),
                          borderRadius: BorderRadius.circular(5.0)),
                      margin: const EdgeInsets.only(left: 5.0),
                      child: IconButton(
                        icon:
                            const Icon(Icons.send_rounded, color: Colors.green),
                        onPressed: () async {
                          setState(() {
                            _messages.add(
                              ChatMessage(
                                text: _textController.text,
                                chatMessageType: ChatMessageType.user,
                              ),
                            );
                            isLoading = true;
                          });
                          var input = _textController.text;
                          _textController.clear();
                          Future.delayed(const Duration(milliseconds: 50))
                              .then((_) => _scrollDown());
                          generateResponse(input).then((value) {
                            setState(() {
                              isLoading = false;
                              _messages.add(
                                ChatMessage(
                                    text: value,
                                    chatMessageType: ChatMessageType.bot),
                              );
                            });
                          });
                          _textController.clear();
                          Future.delayed(const Duration(milliseconds: 50))
                              .then((_) => _scrollDown());
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
