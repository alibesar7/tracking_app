import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/features/auth/presentation/verify_reset/manger/cubit/verify_reset_cubit.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../../../app/config/base_state/base_state.dart';
import '../../../../../app/core/router/route_names.dart';
import '../../../../../app/core/widgets/show_app_dialog.dart';
import '../../../../../app/core/widgets/show_snak_bar.dart';
import '../widgets/verify_rest_code_form.dart';

class VerifyResetCodePage extends StatelessWidget {
  final String email;
  const VerifyResetCodePage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(LocaleKeys.emailVerification.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<VerifyResetCodeCubit, VerifyResetCodeState>(
          listenWhen: (previous, current) =>
              previous.resource.status != current.resource.status,
          listener: (context, state) {
            if (state.resource.status == Status.success &&
                state.code.isNotEmpty) {
              showAppSnackbar(context, LocaleKeys.yourEmailVerified.tr());
              context.push(RouteNames.resetPassword, extra: email);
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
            return VerifyResetCodeForm();
          },
        ),
      ),
    );
  }
}
