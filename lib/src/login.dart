import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_log/config.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
                  child: Text('Login', style: TextStyle(fontSize: 20)),
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
                            ElevatedButton(
                              onPressed: () async {
                                final email = emailController.text;
                                final password = passwordController.text;
                                login(email, password).then((response) {
                                  if (response.statusCode == 200) {
                                    saveToken(response.body);
                                    context.go("/");
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Invalid email or password')));
                                  }
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
                                    context.go("/register");
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
      )),
    );
  }
}

Future<http.Response> login(String email, String password) async {
  var url = Uri.http(AppConfig.ipAddress, '/users/login');
  var body = json.encode({'email': email, 'password': password});
  return await http.post(url, body: body);
}

Future<void> saveToken(String token) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: "jwtToken", value: token);
}
