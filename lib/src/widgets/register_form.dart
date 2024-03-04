import 'package:flutter/material.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:go_router/go_router.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.userProvider,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final UserProvider userProvider;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Create New Account',
                        style: TextStyle(fontSize: 20)),
                  )
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a username';
                                  }
                                  return null;
                                },
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.account_circle_outlined),
                                  labelText: 'Username',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(8.0)),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an email';
                                  }
                                  if (!userProvider.isEmail(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                controller: emailController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email_outlined),
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(8.0)),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  return null;
                                },
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock_open_outlined),
                                  labelText: 'Password',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(8.0)),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please repeat the password';
                                  }
                                  if (value != passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                controller: confirmPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock_open_outlined),
                                  labelText: 'Repeat Password',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }
                                    userProvider
                                        .register(
                                            usernameController.text,
                                            emailController.text,
                                            passwordController.text,
                                            confirmPasswordController.text)
                                        .then((response) {
                                      response.statusCode == 200
                                          ? context.go("/login")
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Something went wrong. Please try again.")));
                                    });
                                  },
                                  child: const Text('Register'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ));
  }
}
