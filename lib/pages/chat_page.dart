import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_chat_app/components/chat_bubble.dart';
import 'package:fast_chat_app/components/my_text_field.dart';
import 'package:fast_chat_app/services/auth/auth_service.dart';
import 'package:fast_chat_app/services/chat_services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  // text editing controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  // send message
  void sendMessage() async {
    // if there is something inside the textfield
    if (_messageController.text.isNotEmpty) {
      // send message
      await _chatService.sendMessage(receiverID, _messageController.text);

      // clear the controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          // display all messages
          Expanded(child: _buildMessageList()),

          // user input
          _buildUserInput(),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(receiverID, senderID),
        builder: (context, snapshot) {
          // errors
          if (snapshot.hasError) {
            return const Text("Error");
          }

          // loading..
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          // return message
          return ListView(
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  // void testSomething() {
  //   final senderID = _authService.getCurrentUser()!.uid;
  //   StreamBuilder(
  //       stream: _chatService.getMessages(receiverID, senderID), builder: (context, snapshot) {
  //         return ListView(children: snapshot.data!.docs.map((doc) => Text(doc.data()!["message"])).toList());
  //       });
  // }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;

    // align message to the right if sender is the current user, otherwise left
    Alignment alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
            alignment: alignment),
      ],
    );
  }

  // build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Row(children: [
        // textfield should take up most of the space
        Expanded(
          child: MyTextField(
              textEditingController: _messageController,
              hintText: "Type a message"),
        ),

        // send button
        Container(
          decoration:
              const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          margin: const EdgeInsets.only(left: 25),
          child: IconButton(
            onPressed: () => sendMessage(),
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}
