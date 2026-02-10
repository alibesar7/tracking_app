import 'package:flutter/material.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/app/core/ui_helper/style/font_style.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.itemName,
    required this.icon,
    this.onTap,
    this.trailing,
  });

  final String itemName;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grey),
      title: Text(itemName, style: AppStyles.font12Black),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
