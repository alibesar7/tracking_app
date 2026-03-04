import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

class DriverHeader extends StatelessWidget {
  final String driverName;

  const DriverHeader({super.key, required this.driverName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.pink.withOpacity(0.1),
          child: const Icon(Icons.person, color: AppColors.pink),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.welcomeBack.tr(),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              driverName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
