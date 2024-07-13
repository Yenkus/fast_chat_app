import 'package:fast_chat_app/components/my_drawer.dart';
import 'package:fast_chat_app/components/my_drawer_tile.dart';
import 'package:fast_chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const MyDrawer(),
    );
  }
}
