import 'package:flutter/material.dart';
import 'package:location/location.dart';

enum ListingType { breakfast, lunch, dinner, snack }

class Comment {
  String comment;
  DateTime? createdAt;
  String email;

  Comment({
    required this.comment,
    this.createdAt,
    required this.email,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'comment': comment,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    };
  }
}

class Listing extends ChangeNotifier {
  String? id;
  String title;
  String description;
  String image;
  bool shared;
  ListingType type;
  List<String> likes;
  List<Comment> comments;
  LocationData? location;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;

  Listing(
      {this.title = "",
      this.description = "",
      this.image = "",
      this.id,
      this.shared = false,
      this.type = ListingType.dinner,
      this.likes = const [],
      this.comments = const [],
      this.email,
      this.location,
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
      likes: json['likes'] != null ? _parseLikes(json['likes']) : [],
      comments:
          json['comments'] != null ? _parseComments(json['comments']) : [],
      email: json['user_email'],
      location: _parseLocation(json['location']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'id': id,
      'shared': shared,
      'type': _typeToString(type),
      'likes': _likesToJson(),
      'comments': _commentsToJson(),
      'user_email': email,
      'location': _locationToJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
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

  static String _typeToString(ListingType type) {
    switch (type) {
      case ListingType.dinner:
        return "dinner";
      case ListingType.snack:
        return "snack";
      case ListingType.breakfast:
        return "breakfast";
      case ListingType.lunch:
        return "lunch";
      default:
        return "dinner";
    }
  }

  static LocationData? _parseLocation(Map<String, dynamic>? locationJson) {
    if (locationJson != null && locationJson.isNotEmpty) {
      return LocationData.fromMap({
        'latitude': locationJson['latitude'].toDouble(),
        'longitude': locationJson['longitude'].toDouble(),
      });
    }
    return null;
  }

  Map<String, dynamic>? _locationToJson() {
    if (location != null) {
      return {
        'latitude': location!.latitude,
        'longitude': location!.longitude,
      };
    }
    return null;
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

  List<Map<String, dynamic>> _likesToJson() {
    return likes.map((like) => {'email': like}).toList();
  }

  List<Map<String, dynamic>> _commentsToJson() {
    return comments.map((comment) => comment.toJson()).toList();
  }
}
