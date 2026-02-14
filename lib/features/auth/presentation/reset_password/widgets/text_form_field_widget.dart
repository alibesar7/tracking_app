import 'package:flutter/material.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    this.obscureText = false,
    required this.label,
    this.focusNode,
    this.keyboardType,
    required this.hint,
    this.validator,
    this.onChanged,
    this.controller,
    this.enabled = true,
    this.suffixIcon,
  });
  final bool obscureText;
  final String label;
  final String hint;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final TextEditingController? controller;
  final bool enabled;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        obscureText: obscureText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        focusNode: focusNode,
        keyboardType: keyboardType,
        cursorColor: AppColors.pink,
        validator: validator,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.grey2),
          ),
          suffixIcon: suffixIcon,
          hint: Text(
            hint,
            style: textTheme.labelSmall!.copyWith(color: AppColors.grey2),
          ),
          labelText: label,
        ),
      ),
    );
  }
}
