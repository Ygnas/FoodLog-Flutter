import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:food_log/config.dart";
import "package:food_log/src/models/user.dart";
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  late User user;

  UserProvider() {
    user = User();
  }

  Future<void> loadToken() async {
    const storage = FlutterSecureStorage();
    final storedToken = await storage.read(key: 'jwtToken');

    user.token = storedToken ?? "";
    notifyListeners();
  }

  Future<http.Response> login(String email, String password) async {
    final url = Uri.http(AppConfig.ipAddress, '/users/login');
    final body = json.encode({'email': email, 'password': password});
    final response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      await saveToken(response.body);
    }
    return response;
  }

  Future<void> logout() async {
    const storage = FlutterSecureStorage();
    user = User();
    await storage.delete(key: "jwtToken");
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    const storage = FlutterSecureStorage();
    user.token = token;
    await storage.write(key: "jwtToken", value: token);
    notifyListeners();
  }

  Future<http.Response> register(String username, String email, String password,
      String repeatPassword) async {
    final url = Uri.http(AppConfig.ipAddress, '/users/register');

    final body =
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
}