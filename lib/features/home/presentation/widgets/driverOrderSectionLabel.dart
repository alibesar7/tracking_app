import 'package:flutter/material.dart';

class DriverOrderSectionLabel extends StatelessWidget {
  final String text;
  const DriverOrderSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Text(
      text,
      style: TextStyle(fontSize: width * 0.035, color: Colors.grey),
    );
  }
}
