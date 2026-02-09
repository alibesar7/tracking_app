import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final Widget? child;
  const InfoCard({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 5),
          child: child,
        ),
      ),
    );
  }
}
