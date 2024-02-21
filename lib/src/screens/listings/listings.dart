import 'package:flutter/material.dart';
import 'package:food_log/src/models/listing.dart';
import 'package:food_log/src/widgets/comments.dart';
import 'package:food_log/src/widgets/like_commnet.dart';

class ListingScreen extends StatelessWidget {
  final Listing listing;
  const ListingScreen({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listing'),
      ),
      body: SingleChildScrollView(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  LikeComment(
                    data: listing.likes.length,
                    dataName: '',
                    icon: Icons.thumb_up_off_alt_outlined,
                  ),
                  const SizedBox(width: 16.0),
                  LikeComment(
                    data: listing.comments.length,
                    dataName: 'comments',
                    icon: Icons.mode_comment_outlined,
                  ),
                ],
              ),
            ),
            listing.comments.isNotEmpty
                ? Comments(listing: listing)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
