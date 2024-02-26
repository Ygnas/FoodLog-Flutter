import 'package:flutter/material.dart';
import 'package:food_log/src/models/listing.dart';
import 'package:food_log/src/providers/listing_provider.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:food_log/src/widgets/comments.dart';
import 'package:food_log/src/widgets/like_comment.dart';
import 'package:food_log/src/widgets/write_comment.dart';
import 'package:provider/provider.dart';

class ListingScreen extends StatefulWidget {
  final Listing listing;
  const ListingScreen({super.key, required this.listing});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    final userProvider = context.read<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listing'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: Text(widget.listing.title),
                    subtitle: Text(widget.listing.description),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: InteractiveViewer(
                        child: widget.listing.image.isNotEmpty
                            ? FadeInImage(
                                placeholder:
                                    const AssetImage("assets/food.png"),
                                image: NetworkImage(widget.listing.image),
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
                          data: widget.listing.likes.length,
                          dataName: '',
                          icon: Icons.thumb_up_off_alt_outlined,
                        ),
                        const SizedBox(width: 16.0),
                        LikeComment(
                          data: widget.listing.comments.length,
                          dataName: 'comments',
                          icon: Icons.mode_comment_outlined,
                        ),
                      ],
                    ),
                  ),
                  widget.listing.comments.isNotEmpty
                      ? Comments(listing: widget.listing)
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: WriteComment(
                commentController: commentController,
                onPressed: () async {
                  String commentText = commentController.text;
                  final email = userProvider.user.email;
                  if (commentText.isNotEmpty) {
                    final comment = Comment(
                      email: email,
                      comment: commentText,
                    );
                    setState(() {
                      widget.listing.comments.add(comment);
                    });
                    await commentListing(
                        widget.listing.id!, widget.listing.email!, comment);
                    commentController.clear();
                  }
                }),
          ),
        ],
      ),
    );
  }
}
