import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/features/auth/presentation/verify_reset/manger/cubit/verify_reset_cubit.dart';

import '../../../../../generated/locale_keys.g.dart';

Widget buildResendSectionWithCountdown(
  BuildContext context,
  VerifyResetCodeCubit cubit,
  VerifyResetCodeState state,
) {
  final canResend = state.canResend;
  final cooldownSeconds = state.resendCountdown;

  return Column(
    children: [
      Text(
        LocaleKeys.didNotReceive.tr(),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 8),

      if (canResend)
        InkWell(
          onTap: () => cubit.doIntent(ResendCodeIntent()),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.pink, width: 1),
            ),
            child: Text(
              LocaleKeys.resend.tr(),
              style: TextStyle(
                color: Colors.pink,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      else
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer_outlined, color: Colors.pink, size: 20),
              const SizedBox(width: 8),
              Text(
                _formatTime(cooldownSeconds),
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'until you can resend',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ),
    ],
  );
}

String _formatTime(int seconds) {
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
}
