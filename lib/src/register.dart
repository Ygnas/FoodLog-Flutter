import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_log/config.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Scaffold(
        appBar: AppBar(),
        body: Form(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Register', style: TextStyle(fontSize: 20)),
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
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.account_box_outlined),
                                  labelText: 'Username',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(8.0)),
                              TextFormField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email_outlined),
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(8.0)),
                              TextFormField(
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
                                    register(
                                            usernameController.text,
                                            emailController.text,
                                            passwordController.text,
                                            confirmPasswordController.text)
                                        .then((response) {
                                      if (response.statusCode == 200) {
                                        context.go("/login");
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    response.body.toString())));
                                      }
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
        )));
  }
}

Future<http.Response> register(String username, String email, String password,
    String repeatPassword) async {
  var url = Uri.http(AppConfig.ipAddress, '/users/register');

  if (username.isEmpty ||
      email.isEmpty ||
      password.isEmpty ||
      repeatPassword.isEmpty) {
    return http.Response('All fields are required', 400);
  }

  if (!isEmail(email)) {
    return http.Response('Invalid email', 400);
  }

  if (!passwordsMatch(password, repeatPassword)) {
    return http.Response('Passwords do not match', 400);
  }

  var body =
      json.encode({'name': username, 'email': email, 'password': password});
  return await http.post(url, body: body);
}

bool passwordsMatch(String password1, String password2) {
  return password1 == password2;
}

bool isEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}
