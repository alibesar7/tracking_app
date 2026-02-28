import 'package:flutter/material.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: AppColors.blackColor),
      ),
    );
  }
}
