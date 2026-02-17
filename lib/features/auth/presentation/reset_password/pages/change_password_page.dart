import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/manager/change_password_states.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../../../../app/config/base_state/base_state.dart';
import '../../../../../app/core/router/route_names.dart';
import '../../../../../app/core/widgets/show_app_dialog.dart';
import '../../../../../app/core/widgets/show_snak_bar.dart';
import '../manager/change_password_cubit.dart';
import '../widgets/change_password_form.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = getIt<ChangePasswordCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.resetPassword.tr(),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.blackColor,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider<ChangePasswordCubit>(
          create: (context) => bloc,
          child: BlocConsumer<ChangePasswordCubit, ChangePasswordStates>(
            listenWhen: (previous, current) =>
                previous.data?.status != current.data?.status,
            listener: (context, state) {
              if (state.data?.status == Status.success) {
                showAppSnackbar(context, LocaleKeys.passwordUpdated.tr());
                context.push(RouteNames.login);
              }
              if (state.data?.status == Status.error) {
                showAppDialog(
                  context,
                  message:
                      state.data?.error ?? LocaleKeys.an_error_occurred.tr(),
                  isError: true,
                );
              }
            },
            builder: (context, state) {
              return ChangePasswordForm();
            },
          ),
        ),
      ),
    );
  }
}
