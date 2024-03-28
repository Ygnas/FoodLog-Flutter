import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:food_log/config.dart";
import "package:food_log/src/models/user.dart";
import "package:food_log/src/providers/listing_provider.dart";
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  late User user;

  UserProvider() {
    user = User();
  }

  Future<void> loadToken() async {
    const storage = FlutterSecureStorage();
    final storedToken = await storage.read(key: 'jwtToken');
    final storedName = await storage.read(key: 'name');
    final storedEmail = await storage.read(key: 'email');

    user.token = storedToken ?? "";
    user.name = storedName ?? "";
    user.email = storedEmail ?? "";
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
    await storage.delete(key: "name");
    await storage.delete(key: "email");
    await deleteToken();
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    const storage = FlutterSecureStorage();

    user.token = token;
    final userClaims = getClaims();
    user.name = userClaims['name'];
    user.email = userClaims['email'];

    await storage.write(key: "name", value: user.name);
    await storage.write(key: "email", value: user.email);
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

  Map<String, dynamic> getClaims() {
    final parts = user.token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }
    final payload = parts[1];
    final String normalized = base64Url.normalize(payload);
    final String resp = utf8.decode(base64Url.decode(normalized));
    final Map<String, dynamic> claims = json.decode(resp);
    return claims;
  }

  Future<http.Response> deleteAccount() async {
    const storage = FlutterSecureStorage();
    final claims = getClaims();
    final token = await storage.read(key: 'jwtToken');
    final email = base64Encode(utf8.encode(claims['email']));
    final url = Uri.http(AppConfig.ipAddress, '/users/delete/$email');
    final response = await http.delete(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    return response;
  }
}
