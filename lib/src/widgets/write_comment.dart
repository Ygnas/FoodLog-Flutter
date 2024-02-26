import 'package:flutter/material.dart';

class WriteComment extends StatelessWidget {
  final Function()? onPressed;
  const WriteComment({
    super.key,
    required this.commentController,
    this.onPressed,
  });

  final TextEditingController commentController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40.0,
            child: TextField(
              controller: commentController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Comment',
              ),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        IconButton(
          onPressed: () async {
            String comment = commentController.text;
            if (comment.isNotEmpty) {
              onPressed!();
            }
          },
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}
