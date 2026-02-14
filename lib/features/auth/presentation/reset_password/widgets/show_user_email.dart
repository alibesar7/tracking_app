import 'package:flutter/material.dart';

Widget ShowUserEmail(BuildContext context, String email) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        const Icon(Icons.email_outlined),
        const SizedBox(width: 12),
        Expanded(child: Text(email)),
      ],
    ),
  );
}
