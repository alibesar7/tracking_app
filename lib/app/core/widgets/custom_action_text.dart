import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:flutter/material.dart';

class CustomActionText extends StatelessWidget {
  final String text;
  final VoidCallback onTapAction;
  final bool isEnabled;

  const CustomActionText({
    super.key,
    required this.text,
    required this.onTapAction,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTapAction : null,
      child: Text(
        text,
        style: (Theme.of(context).textTheme.bodyMedium)?.copyWith(
          color: isEnabled ? AppColors.pink : Colors.grey,
          decoration: TextDecoration.underline,
          decorationColor: isEnabled ? AppColors.pink : Colors.grey,
        ),
      ),
    );
  }
}
