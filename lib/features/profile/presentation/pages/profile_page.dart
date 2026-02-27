import 'package:flutter/material.dart';
import 'package:tracking_app/app/core/router/route_names.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteNames.trackOrder);
          },
          child: const Text("Track Order"),
        ),
      ),
    );
  }
}
