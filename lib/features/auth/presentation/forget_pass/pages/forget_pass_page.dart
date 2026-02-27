import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/features/auth/presentation/forget_pass/widgets/forget_pass_form.dart';
import '../../../../../../../generated/locale_keys.g.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(LocaleKeys.password.tr()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go(RouteNames.onboarding),
        ),
      ),
      body: ForgetPasswordForm(),
    );
  }
}
