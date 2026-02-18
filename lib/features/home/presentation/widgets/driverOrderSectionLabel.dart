import 'package:flutter/material.dart';

class DriverOrderSectionLabel extends StatelessWidget {
  final String text;
  const DriverOrderSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 14, color: Colors.grey));
  }
}
