import 'package:flutter/material.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:food_log/src/widgets/login_form.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(),
      body: LoginForm(
          formKey: formKey,
          userProvider: userProvider,
          emailController: emailController,
          passwordController: passwordController),
    );
  }
}
