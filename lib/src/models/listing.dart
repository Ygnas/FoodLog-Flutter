import 'package:flutter/material.dart';

class Listing extends ChangeNotifier {
  String title;
  String description;
  String image;
  String id;

  Listing(
      {this.title = "", this.description = "", this.image = "", this.id = ""});

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      id: json['id'],
    );
  }
}
