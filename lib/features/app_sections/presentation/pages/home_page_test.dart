import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';

class HomePageTest extends StatelessWidget {
  const HomePageTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              context.go(RouteNames.trackOrder);
            },
            child: const Text("Track Order"),
          ),
        ],
      ),
    );
  }
}
