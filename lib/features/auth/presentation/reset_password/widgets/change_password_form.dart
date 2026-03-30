import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/config/validation/app_validation.dart';
import 'package:tracking_app/app/core/widgets/custom_button.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/manager/change_password_intent.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/manager/change_password_states.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/widgets/text_form_field_widget.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';
import '../manager/change_password_cubit.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  bool _currentPassHidden = true;
  bool _newPassHidden = true;
  bool _confirmPassHidden = true;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ChangePasswordCubit>(context);

    return SingleChildScrollView(
      child: Form(
        key: bloc.formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormFieldWidget(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _currentPassHidden = !_currentPassHidden;
                  });
                },
                icon: Icon(
                  _currentPassHidden ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              keyboardType: TextInputType.text,
              obscureText: _currentPassHidden,
              label: LocaleKeys.currentPassword.tr(),
              hint: LocaleKeys.currentPassword.tr(),
              validator: (val) => Validators.passwordValidator(val),
              onChanged: (value) {
                bloc.doIntent(
                  CurrentPasswordIntent(currentPass: value.toString()),
                );
                bloc.doIntent(FormValidIntent());
              },
            ),
            const SizedBox(height: 20),
            TextFormFieldWidget(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _newPassHidden = !_newPassHidden;
                  });
                },
                icon: Icon(
                  _newPassHidden ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              keyboardType: TextInputType.text,
              obscureText: _newPassHidden,
              label: LocaleKeys.newPassword.tr(),
              hint: LocaleKeys.newPassword.tr(),
              validator: (val) =>
                  Validators.newPasswordValidator(val, bloc.currentPass),
              onChanged: (value) {
                bloc.doIntent(NewPasswordIntent(newPass: value.toString()));
                bloc.doIntent(FormValidIntent());
              },
            ),
            const SizedBox(height: 20),
            TextFormFieldWidget(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _confirmPassHidden = !_confirmPassHidden;
                  });
                },
                icon: Icon(
                  _confirmPassHidden ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              obscureText: _confirmPassHidden,
              label: LocaleKeys.confirmPassword.tr(),
              hint: LocaleKeys.confirmPassword.tr(),
              validator: (val) =>
                  Validators.confirmPasswordValidator(val, bloc.newPass),
              onChanged: (value) {
                bloc.doIntent(
                  ConfirmPasswordIntent(confirmPass: value.toString()),
                );
                bloc.doIntent(FormValidIntent());
              },
            ),

            const SizedBox(height: 32),
            BlocBuilder<ChangePasswordCubit, ChangePasswordStates>(
              builder: (context, state) {
                return CustomButton(
                  text: LocaleKeys.update.tr(),
                  isEnabled: state.isFormValid ?? false,
                  isLoading: state.data?.status == Status.loading,
                  onPressed: () {
                    bloc.doIntent(SubmitChangePasswordIntent());
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
