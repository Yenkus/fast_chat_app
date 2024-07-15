import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final Alignment alignment;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: alignment,
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Text(
        message,
        style: TextStyle(
          color: isCurrentUser ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
