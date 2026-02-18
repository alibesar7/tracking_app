import 'package:flutter/material.dart';

class DriverOrderButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isPrimary;

  const DriverOrderButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFFE91E63) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: isPrimary ? null : Border.all(color: const Color(0xFFE91E63)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary ? Colors.white : const Color(0xFFE91E63),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
