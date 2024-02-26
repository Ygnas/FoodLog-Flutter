import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String name;
  String email;
  String token;

  User({this.name = "", this.email = "", this.token = ""});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      token: json['token'],
    );
  }
}