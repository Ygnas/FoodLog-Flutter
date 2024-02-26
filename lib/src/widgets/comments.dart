import 'package:flutter/material.dart';
import 'package:food_log/src/models/listing.dart';

class Comments extends StatelessWidget {
  const Comments({
    super.key,
    required this.listing,
  });

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listing.comments.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey[300],
          thickness: 1.0,
          height: 1.0,
        );
      },
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(listing.comments[index].comment),
        );
      },
    );
  }
}
