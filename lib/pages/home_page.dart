import 'package:fast_chat_app/components/my_drawer.dart';
import 'package:fast_chat_app/components/my_drawer_tile.dart';
import 'package:fast_chat_app/components/user_tile.dart';
import 'package:fast_chat_app/pages/chat_page.dart';
import 'package:fast_chat_app/services/auth/auth_service.dart';
import 'package:fast_chat_app/services/chat_services/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // get chat and auth services
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatService.getUserStream(),
        builder: (context, snapshot) {
          // error
          if (snapshot.hasError) {
            return const Text("Error");
          }

          // loading...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          // return list view
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  // build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all users except current user
    return UserTile(
      text: userData['email'],
      onTap: () {
        // tapped on a user -> go to chat page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverEmail: userData['email'],
              receiverID: userData['uid'],
            ),
          ),
        );
      },
    );
  }
}
