import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String userName;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.userName,
  });

  String getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0];
    return parts[0][0] + parts[1][0];
  }

  Color getRandomBackgroundColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.brown,
    ];
    final index = name.hashCode % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor:
      imageUrl == null ? getRandomBackgroundColor(userName) : null,
      backgroundImage:
      imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(
        getInitials(userName).toUpperCase(),
        style: TextStyle(
          fontSize: 50 / 2,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      )
          : null,
    );
  }
}
