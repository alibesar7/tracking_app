import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/features/auth/presentation/verify_reset/manger/cubit/verify_reset_cubit.dart';
import 'package:tracking_app/features/auth/presentation/verify_reset/widgets/resend_action_widget.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../../../app/config/base_state/base_state.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class VerifyResetCodeForm extends StatelessWidget {
  const VerifyResetCodeForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VerifyResetCodeCubit>();

    return BlocBuilder<VerifyResetCodeCubit, VerifyResetCodeState>(
      buildWhen: (previous, current) =>
          previous.canResend != current.canResend ||
          previous.resendCountdown != current.resendCountdown ||
          previous.resource.status != current.resource.status,
      builder: (context, state) {
        final isLoading = state.resource.status == Status.loading;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  LocaleKeys.emailVerification.tr(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.instruction.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 48),

                OtpTextField(
                  numberOfFields: 6,
                  borderColor: Theme.of(context).colorScheme.primary,
                  enabledBorderColor: Theme.of(context).colorScheme.outline,
                  focusedBorderColor: Theme.of(context).colorScheme.primary,
                  showFieldAsBox: true,
                  fieldWidth: 52,
                  fieldHeight: 64,
                  borderRadius: BorderRadius.circular(12),
                  textStyle: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                  onCodeChanged: (code) =>
                      cubit.doIntent(FormChangedIntent(code)),
                  onSubmit: (code) {
                    cubit.doIntent(FormChangedIntent(code));
                    cubit.doIntent(SubmitVerifyCodeIntent());
                  },
                ),

                const SizedBox(height: 32),

                if (isLoading)
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),

                if (!isLoading) const SizedBox(height: 32),
                buildResendSectionWithCountdown(context, cubit, state),

                const SizedBox(height: 20),
                Text(
                  'Code sent to: ${cubit.email}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
