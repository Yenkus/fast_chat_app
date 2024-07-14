import 'package:fast_chat_app/components/my_drawer_tile.dart';
import 'package:fast_chat_app/pages/settings_page.dart';
import 'package:fast_chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.message,
              size: 40,
            ),
          ),
          MyDrawerTile(
            icon: Icons.home,
            title: "H O M E",
            onTap: () {
              Navigator.pop(context);
            },
          ),
          MyDrawerTile(
            icon: Icons.settings,
            title: "S E T T I N G S",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
          ),
          const Spacer(),
          MyDrawerTile(
            icon: Icons.logout,
            title: "L O G O U T",
            onTap: logout,
            bottomPadding: 10,
          ),
        ],
      ),
    );
  }
}
