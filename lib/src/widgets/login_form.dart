import 'package:flutter/material.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.userProvider,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final UserProvider userProvider;
  final TextEditingController emailController;
  final TextEditingController passwordController;

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
                    child: Text('Welcome', style: TextStyle(fontSize: 20)),
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
                              ElevatedButton(
                                onPressed: () async {
                                  final email = emailController.text;
                                  final password = passwordController.text;
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }
                                  userProvider
                                      .login(email, password)
                                      .then((response) {
                                    response.statusCode == 200
                                        ? context.go('/', extra: true)
                                        : ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Invalid email or password')));
                                  });
                                },
                                child: const Text('Login'),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Don\'t have an account?'),
                                  TextButton(
                                    onPressed: () async {
                                      context.push("/register");
                                    },
                                    child: const Text('Register'),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}
