import 'package:flutter/material.dart';

import '../ui_helper/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.isEnabled,
    required this.isLoading,
    required this.text,
    required this.onPressed,
    this.color,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: color ?? Colors.grey,
          side: BorderSide(color: color ?? Colors.grey, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: isEnabled && !isLoading ? onPressed : null,
        child: isLoading
            ? CircularProgressIndicator(
                color: color ?? AppTheme.lightTheme.primaryColor,
              )
            : Text(text),
      );
    }

    return ElevatedButton(
      style: color != null
          ? ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            )
          : null,
      onPressed: isEnabled && !isLoading ? onPressed : null,
      child: isLoading
          ? CircularProgressIndicator(color: AppTheme.lightTheme.primaryColor)
          : Text(text),
    );
  }
}
