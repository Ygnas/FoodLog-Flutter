import 'package:flutter/material.dart';

enum ListingType { dinner, snack, breakfast, lunch }

class Comment {
  String comment;
  DateTime createdAt;
  String email;

  Comment({
    required this.comment,
    required this.createdAt,
    required this.email,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
      email: json['email'],
    );
  }
}

class Listing extends ChangeNotifier {
  String id;
  String title;
  String description;
  String image;
  bool shared;
  ListingType type;
  List<String> likes;
  List<Comment> comments;
  DateTime? createdAt;
  DateTime? updatedAt;

  Listing(
      {this.title = "",
      this.description = "",
      this.image = "",
      this.id = "",
      this.shared = false,
      this.type = ListingType.dinner,
      this.likes = const [],
      this.comments = const [],
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
      likes: _parseLikes(json['likes']),
      comments: _parseComments(json['comments']),
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

  static List<String> _parseLikes(List<dynamic> likesJson) {
    List<String> likes = [];
    for (var like in likesJson) {
      likes.add(like['email']);
    }
    return likes;
  }

  static List<Comment> _parseComments(List<dynamic> commentsJson) {
    return commentsJson
        .map<Comment>((commentJson) => Comment.fromJson(commentJson))
        .toList();
  }
}
