import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../app/core/ui_helper/color/colors.dart';
import '../../../../app/core/ui_helper/style/font_style.dart';
import '../../../../generated/locale_keys.g.dart';
import 'language_tile.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.change_language.tr(),
              style: AppStyles.black14Medium.copyWith(
                color: AppColors.pink,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            LanguageTile(
              title: LocaleKeys.arabic.tr(),
              value: const Locale('ar'),
              groupValue: context.locale,
              onChanged: (loc) async {
                await context.setLocale(loc);
                if (context.mounted) Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            LanguageTile(
              title: LocaleKeys.english.tr(),
              value: const Locale('en'),
              groupValue: context.locale,
              onChanged: (loc) async {
                await context.setLocale(loc);
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}


