import 'package:flutter/material.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';

Widget customMarker(String text, Icon icon) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.pink,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(backgroundColor: AppColors.white, radius: 16, child: icon),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
