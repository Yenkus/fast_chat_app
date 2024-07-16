import 'package:fast_chat_app/components/user_tile.dart';
import 'package:fast_chat_app/services/auth/auth_service.dart';
import 'package:fast_chat_app/services/chat_services/chat_service.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  // chat & auth service
  final _chatService = ChatService();
  final _authService = AuthService();

  // show confirm unblock box
  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Unblock User"),
              content:
                  const Text("Are you sure you want to unblock this user?"),
              actions: [
                // cancel
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                // unblockUser
                TextButton(
                  onPressed: () {
                    _chatService.unblockUser(userId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User unblocked!")));
                  },
                  child: const Text("Unblock"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    // get current user id
    String userId = _authService.getCurrentUser()!.uid;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Blocked Users"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _chatService.getBlockedUsers(userId),
          builder: (context, snapshot) {
            // if there's error
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading.."));
            }

            // loading..
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final blockedUsers = snapshot.data ?? [];

            // no users
            if (blockedUsers.isEmpty) {
              return const Center(child: Text("No blocked user"));
            }

            // load complete
            return ListView.builder(
                itemCount: blockedUsers.length,
                itemBuilder: (context, index) {
                  final user = blockedUsers[index];

                  return UserTile(
                    text: user['email'],
                    onTap: () => _showUnblockBox(context, user['uid']),
                  );
                });
          }),
    );
  }
}
