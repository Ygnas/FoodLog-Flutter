import "dart:convert";
import "dart:io";

import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:food_log/config.dart";
import "package:food_log/src/models/listing.dart";
import 'package:http/http.dart' as http;

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
