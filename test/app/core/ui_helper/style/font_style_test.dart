import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/app/core/ui_helper/style/font_style.dart';

void main() {
  group('AppStyles Tests', () {
    test('font32BlackSemiBold should have correct properties', () {
      final style = AppStyles.font32BlackSemiBold;

      expect(style.fontSize, 32);
      expect(style.color, AppColors.blackColor);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.fontFamily, 'SansArabic');
    });

    test('subtitle should have correct properties', () {
      final style = AppStyles.subtitle;

      expect(style.fontSize, 12);
      expect(style.color, AppColors.grey);
      expect(style.fontWeight, FontWeight.normal);
    });

    test('All styles should use the correct default fontFamily', () {
      expect(AppStyles.black24SemiBold.fontFamily, 'SansArabic');
      expect(AppStyles.font16Black.fontFamily, 'SansArabic');
      expect(AppStyles.purple18bold.fontFamily, 'SansArabic');
    });

    test('Special case: medium20 should use Inter font', () {
      expect(AppStyles.medium20.fontFamily, 'Inter');
      expect(AppStyles.medium20.fontSize, 20);
    });

    test('red14Normal should return red color from AppColors', () {
      expect(AppStyles.red14Normal.color, AppColors.red);
      expect(AppStyles.red14Normal.fontSize, 14);
    });

    test('Check for specific bug: font12White color fix', () {
      expect(AppStyles.font12White.color, AppColors.blackColor);
    });
  });
}
