import 'package:flutter/material.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';

void showAppSnackbar(
  BuildContext context,
  String message, {
  Color backgroundColor = AppColors.green,
  String? label,
  VoidCallback? onPressed,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message, style: Theme.of(context).textTheme.labelSmall),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        action: label != null && onPressed != null
            ? SnackBarAction(
                label: label,
                textColor: Colors.white,
                onPressed: onPressed,
              )
            : null,
      ),
    );
}
