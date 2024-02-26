import 'package:flutter/material.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Icon(
              Icons.account_circle_rounded,
              size: 100,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Name: ${userProvider.user.name}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            'Email: ${userProvider.user.email}',
            style: const TextStyle(fontSize: 20),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              userProvider.logout();
              context.go('/login');
            },
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
