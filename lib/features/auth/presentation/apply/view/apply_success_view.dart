import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../generated/locale_keys.g.dart';

class ApplySuccessScreen extends StatelessWidget {
  const ApplySuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/Vector.svg",
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Success Title
              Text(
                LocaleKeys.applicationSubmitted.tr(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Success Message
              Text(
                LocaleKeys.congratulationsMessage.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              Text(
                LocaleKeys.reviewMessage.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Return to Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD01C68),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    LocaleKeys.backToLogin.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
