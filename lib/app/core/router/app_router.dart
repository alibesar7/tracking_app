import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/features/auth/presentation/forget_pass/manager/cubit/forget_pass_cubit.dart';
import 'package:tracking_app/features/auth/presentation/forget_pass/pages/forget_pass_page.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/manager/reset_password_cubit.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/pages/reset_password.dart';
import 'package:tracking_app/features/auth/presentation/verify_reset/manger/cubit/verify_reset_cubit.dart';
import 'package:tracking_app/features/auth/presentation/verify_reset/pages/verify_reset_page.dart';
import 'package:tracking_app/features/profile/presentation/pages/profile_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.forgetPassword, //  start here

  routes: [
    // RouteNames.verifyResetCode,
    GoRoute(
      path: RouteNames.verifyResetCode,
      builder: (context, state) {
        final email = state.extra as String;

        return BlocProvider(
          create: (_) => getIt<VerifyResetCodeCubit>(param1: email),
          child: VerifyResetCodePage(email: email),
        );
      },
    ),
    GoRoute(
      path: RouteNames.forgetPassword,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<ForgetPasswordCubit>(),
        child: const ForgetPasswordPage(),
      ),
    ),

    GoRoute(
      path: RouteNames.resetPassword,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<ResetPasswordCubit>(param1: state.extra as String),
        child: const ResetPasswordPage(),
      ),
    ),
    GoRoute(path:   RouteNames.profile, builder: (context, state) => const ProfilePage()),
  ],
);
