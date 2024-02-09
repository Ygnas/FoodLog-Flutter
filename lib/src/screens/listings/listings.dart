import 'package:flutter/material.dart';

class ListingScreen extends StatelessWidget {
  final String listingId;
  const ListingScreen({super.key, required this.listingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listing'),
      ),
      body: Center(
        child: Text('Listing $listingId'),
      ),
    );
  }
}
