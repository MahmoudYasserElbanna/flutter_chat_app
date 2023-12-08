import 'package:flutter/material.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/models/messages.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({Key? key, required this.message}) : super(key: key);
  final Message? message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(28),
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        margin: const EdgeInsets.all(4),
        child: Text(
          message!.message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class ChatBubbleFromFriend extends StatelessWidget {
  const ChatBubbleFromFriend({Key? key, required this.message})
      : super(key: key);
  final Message? message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF006D84),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28),
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        margin: const EdgeInsets.all(4),
        child: Text(
          message!.message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
