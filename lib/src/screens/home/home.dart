import 'package:flutter/material.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    userProvider.loadToken();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              userProvider.user.token.isEmpty
                  ? context.go('/login')
                  : userProvider.logout();
            },
          )
        ],
      ),
      body: userProvider.user.token == ""
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Text('Welcome to Food Log\n ${userProvider.user.token}'),
            ),
    );
  }
}
