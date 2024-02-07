import 'package:flutter/material.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    userProvider.loadToken();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Log'),
      ),
      body: userProvider.user.token == ""
          ? const Center(child: CircularProgressIndicator())
          : const Center(
              child: Text('Welcome to Food Log'),
            ),
    );
  }
}
