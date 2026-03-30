import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/widgets/show_user_email.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';
import '../../../../../app/config/base_state/base_state.dart';
import '../../../../../app/core/utils/validators_helper.dart';
import '../../../../../app/core/widgets/custom_button.dart';
import '../../../../../app/core/widgets/password_text_form_field.dart';
import '../manager/reset_password_cubit.dart';
import '../manager/reset_password_intents.dart';

class ResetPasswordForm extends StatelessWidget {
  const ResetPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResetPasswordCubit>();
    final email = cubit.email;

    return Form(
      key: cubit.formKey,
      onChanged: () => cubit.doIntent(ChangePasswordIntent.formChanged),
      child: Column(
        children: [
          const SizedBox(height: 20),

          ShowUserEmail(context, email),

          const SizedBox(height: 24),

          BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
            buildWhen: (p, c) =>
                p.togglePasswordVisibility != c.togglePasswordVisibility,
            builder: (context, state) {
              return PasswordTextFormField(
                controller: cubit.newPasswordController,
                label: LocaleKeys.newPassword.tr(),
                isVisible: state.togglePasswordVisibility,
                onToggleVisibility: () => cubit.doIntent(
                  ChangePasswordIntent.togglePasswordVisibility,
                ),
                validator: Validators.validatePassword,
                hint: LocaleKeys.enterYourPassword,
              );
            },
          ),

          const SizedBox(height: 32),

          BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
            buildWhen: (p, c) =>
                p.isFormValid != c.isFormValid ||
                p.resource.status != c.resource.status,
            builder: (context, state) {
              return CustomButton(
                text: LocaleKeys.confirm.tr(),
                isEnabled: state.isFormValid,
                isLoading: state.resource.status == Status.loading,
                onPressed: () => cubit.doIntent(ChangePasswordIntent.submit),
              );
            },
          ),
        ],
      ),
    );
  }
}
