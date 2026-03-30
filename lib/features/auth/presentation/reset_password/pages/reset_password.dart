import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../../../app/config/base_state/base_state.dart';
import '../../../../../app/core/router/route_names.dart';
import '../../../../../app/core/widgets/show_app_dialog.dart';
import '../../../../../app/core/widgets/show_snak_bar.dart';
import '../manager/reset_password_cubit.dart';
import '../widgets/reset_password_form.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.password.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listenWhen: (p, c) => p.resource.status != c.resource.status,
          listener: (context, state) {
            if (state.resource.status == Status.success) {
              showAppSnackbar(context, LocaleKeys.passwordUpdated.tr());
              context.push(RouteNames.login);
            }
            if (state.resource.status == Status.error) {
              showAppDialog(
                context,
                message:
                    state.resource.error ?? LocaleKeys.an_error_occurred.tr(),
                isError: true,
              );
            }
          },
          builder: (context, state) {
            return const ResetPasswordForm();
          },
        ),
      ),
    );
  }
}
