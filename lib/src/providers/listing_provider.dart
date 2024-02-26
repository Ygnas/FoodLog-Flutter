import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:food_log/config.dart";
import "package:food_log/src/models/listing.dart";
import 'package:http/http.dart' as http;

class ListingProvider extends ChangeNotifier {
  late List<Listing> listings;

  ListingProvider() {
    listings = [];
  }

  Future<List<Listing>> loadListings() async {
    listings = await getListing();
    notifyListeners();
    return listings;
  }

  Future<List<Listing>> loadAllListings() async {
    listings = await getAllListings();
    notifyListeners();
    return listings;
  }

  Future<http.Response> likeListing(String id, String email) async {
    final response = await likeListing(id, email);
    return response;
  }
}

String _token = "";

Future<void> fetchToken() async {
  if (_token.isEmpty) {
    const storage = FlutterSecureStorage();
    _token = await storage.read(key: 'jwtToken') ?? "";
  }
}

Future<void> deleteToken() async {
  _token = "";
}

Future<List<Listing>> getListing() async {
  List<Listing> listings = [];
  await fetchToken();
  if (_token.isEmpty) {
    return listings;
  }
  final url = Uri.http(AppConfig.ipAddress, "/listings");
  final response = await http.get(
    url,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    },
  );
  if (response.statusCode == 200 && response.body != "null") {
    final List<dynamic> data = json.decode(response.body);
    listings = data.map((e) => Listing.fromJson(e)).toList();
  }
  return listings;
}

Future<List<Listing>> getAllListings() async {
  List<Listing> listings = [];
  await fetchToken();
  if (_token.isEmpty) {
    return listings;
  }
  final url = Uri.http(AppConfig.ipAddress, "/all-listings");
  final response = await http.get(
    url,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    },
  );
  if (response.statusCode == 200 && response.body != "null") {
    final List<dynamic> data = json.decode(response.body);
    listings = data.map((e) => Listing.fromJson(e)).toList();
  }
  return listings;
}

Future<http.Response> addListing(Listing listing) async {
  await fetchToken();
  if (_token.isEmpty) {
    return http.Response("Unauthorized", 401);
  }
  final url = Uri.http(AppConfig.ipAddress, "/listings");
  final response = await http.post(
    url,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    },
    body: json.encode(listing.toJson()),
  );
  return response;
}

Future<http.Response> deleteListing(String id) async {
  await fetchToken();
  if (_token.isEmpty) {
    return http.Response("Unauthorized", 401);
  }
  final url = Uri.http(AppConfig.ipAddress, "/listings/$id");
  final response = await http.delete(
    url,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    },
  );
  return response;
}

Future<http.Response> updateListing(Listing listing) async {
  await fetchToken();
  if (_token.isEmpty) {
    return http.Response("Unauthorized", 401);
  }
  final url = Uri.http(AppConfig.ipAddress, "/listings/${listing.id}");
  final response = await http.put(
    url,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    },
    body: json.encode(listing.toJson()),
  );
  return response;
}

Future<http.Response> likeListing(String id, String email) async {
  await fetchToken();
  if (_token.isEmpty) {
    return http.Response("Unauthorized", 401);
  }
  final url = Uri.http(AppConfig.ipAddress, "/listings/$id/$email/like");
  final response = await http.post(
    url,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    },
  );
  return response;
}

Future<http.Response> commentListing(
    String id, String email, Comment comment) async {
  await fetchToken();
  if (_token.isEmpty) {
    return http.Response("Unauthorized", 401);
  }
  final url = Uri.http(AppConfig.ipAddress, "/listings/$id/$email/comment");

  final sendComment = json.encode(comment.toJson());
  final response = await http.post(
    url,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    },
    body: sendComment,
  );
  return response;
}
