import 'package:flutter/material.dart';
import 'package:food_log/src/models/listing.dart';

class ListingScreen extends StatelessWidget {
  final Listing listing;
  const ListingScreen({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listing'),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              title: Text(listing.title),
              subtitle: Text(listing.description),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: InteractiveViewer(
                  child: listing.image.isNotEmpty
                      ? FadeInImage(
                          placeholder: const AssetImage("assets/food.png"),
                          image: NetworkImage(listing.image),
                        )
                      : const SizedBox(
                          width: 120,
                          child: Icon(
                            Icons.image,
                            size: 120.0,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
