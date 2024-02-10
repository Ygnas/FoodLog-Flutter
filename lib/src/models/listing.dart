import 'package:flutter/material.dart';

enum ListingType { dinner, snack, breakfast, lunch }

class Listing extends ChangeNotifier {
  String id;
  String title;
  String description;
  String image;
  bool shared;
  ListingType type;
  DateTime? createdAt;
  DateTime? updatedAt;

  Listing(
      {this.title = "",
      this.description = "",
      this.image = "",
      this.id = "",
      this.shared = false,
      this.type = ListingType.dinner,
      this.createdAt,
      this.updatedAt});

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      id: json['id'],
      shared: json['shared'],
      type: _stringToType(json['type']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static ListingType _stringToType(String type) {
    switch (type) {
      case "dinner":
        return ListingType.dinner;
      case "snack":
        return ListingType.snack;
      case "breakfast":
        return ListingType.breakfast;
      case "lunch":
        return ListingType.lunch;
      default:
        return ListingType.dinner;
    }
  }
}
