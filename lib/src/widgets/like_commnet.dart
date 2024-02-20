import 'package:flutter/material.dart';

class LikeComment extends StatelessWidget {
  final dynamic data;
  final String? dataName;
  final IconData icon;
  const LikeComment(
      {super.key, required this.data, this.dataName, required this.icon});

  final Color outlineColor = const Color.fromARGB(57, 0, 0, 0);
  final Color textColor = const Color.fromARGB(144, 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(width: 1.0, color: outlineColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 8.0),
          Text(
            '$data $dataName  ',
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );
  }
}
