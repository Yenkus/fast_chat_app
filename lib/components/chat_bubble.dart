import 'package:fast_chat_app/services/chat_services/chat_service.dart';
import 'package:fast_chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;
  final Alignment alignment;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.alignment,
    required this.messageId,
    required this.userId,
  });

  // show options
  void _showOption(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            // report message button
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text("Report"),
              onTap: () {
                Navigator.pop(context);
                _reportContent(context, messageId, userId);
              },
            ),

            // block user button
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text("Block"),
              onTap: () {
                Navigator.pop(context);
                _blockUser(context, userId);
              },
            ),

            // cancel button
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text("Cancel"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  // report message
  void _reportContent(BuildContext context, String messageId, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Report Message"),
              content:
                  const Text("Are you sure you want to report this message?"),
              actions: [
                // cancel button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                // report button
                TextButton(
                  onPressed: () {
                    ChatService().reportUser(messageId, userId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Message Reported")));
                  },
                  child: const Text("Report"),
                ),
              ],
            ));
  }

  // block user
  void _blockUser(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Block user"),
              content: const Text("Are you sure you want to block this user?"),
              actions: [
                // cancel button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                // block button
                TextButton(
                  onPressed: () {
                    // perform block
                    ChatService().blockUser(userId);
                    // dismiss dialog
                    Navigator.pop(context);
                    // dismiss page
                    Navigator.pop(context);
                    // let user know of result
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User Blocked!")));
                  },
                  child: const Text("Block"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {}
      },
      child: Container(
        // alignment: alignment,
        decoration: BoxDecoration(
          color: isCurrentUser
              ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500)
              : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Text(
          message,
          style: TextStyle(
            color: isCurrentUser
                ? Colors.black
                : (isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
