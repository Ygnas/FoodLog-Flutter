import 'package:flutter/material.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:food_log/src/widgets/register_form.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    final formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(),
        body: RegisterForm(
            formKey: formKey,
            usernameController: usernameController,
            userProvider: userProvider,
            emailController: emailController,
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController));
  }
}
