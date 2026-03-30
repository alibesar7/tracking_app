import 'package:flutter/material.dart';

import '../../../../app/core/ui_helper/color/colors.dart';

class RadioCircle extends StatelessWidget {
  final bool selected;
  const RadioCircle({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.pink : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? AppColors.pink : Colors.transparent,
        ),
      ),
    );
  }
}
