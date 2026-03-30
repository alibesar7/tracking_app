import 'package:flutter/material.dart';

class NotificationWithBadgeWidget extends StatelessWidget {
  const NotificationWithBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: const Text(
              '3',
              style: TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
