import 'package:flutter/material.dart';
import 'package:tracking_app/features/profile/presentation/widgets/radio_circle.dart';
import '../../../../app/core/ui_helper/color/colors.dart';
import '../../../../app/core/ui_helper/style/font_style.dart';

class LanguageTile extends StatelessWidget {
  final String title;
  final Locale value;
  final Locale groupValue;
  final ValueChanged<Locale> onChanged;

  const LanguageTile({super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.pink : Colors.grey.shade200,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: selected
                    ? AppStyles.black14bold.copyWith(color: AppColors.pink)
                    : AppStyles.black14Medium,
              ),
            ),
            RadioCircle(selected: selected),
          ],
        ),
      ),
    );
  }
}
