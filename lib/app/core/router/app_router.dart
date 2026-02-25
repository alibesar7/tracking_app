import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/features/Onboarding/presentation/pages/onboardingScreen.dart';
import 'package:tracking_app/features/app_sections/presentation/pages/app_sections.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_pass/manager/cubit/forget_pass_cubit.dart';
import 'package:tracking_app/features/auth/presentation/forget_pass/pages/forget_pass_page.dart';
import 'package:tracking_app/features/auth/presentation/login/pages/loginScreen.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/manager/reset_password_cubit.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/pages/change_password_page.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/pages/reset_password.dart';
import 'package:tracking_app/features/auth/presentation/verify_reset/manger/cubit/verify_reset_cubit.dart';
import 'package:tracking_app/features/auth/presentation/verify_reset/pages/verify_reset_page.dart';
import 'package:tracking_app/features/profile/presentation/pages/profile_page.dart';
import 'package:tracking_app/features/track_order/presentation/manager/cubit/track_order_cubit.dart';
import 'package:tracking_app/features/track_order/presentation/pages/track_order_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.onboarding,
  routes: [
    GoRoute(
      path: RouteNames.changePassword,
      builder: (context, state) => const ChangePasswordPage(),
    ),

    GoRoute(
      path: RouteNames.onboarding,
      builder: (context, state) => const Onboardingscreen(),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.profile,
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: RouteNames.appStart,
      builder: (context, state) => AppSections(),
    ),
    GoRoute(
      path: RouteNames.applyScreen,
      builder: (context, state) => const ApplyScreen(),
    ),
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
    GoRoute(
      path: RouteNames.profile,
      builder: (context, state) => const ProfilePage(),
    ),

    GoRoute(
      path: RouteNames.trackOrder,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<TrackOrderCubit>(),
        child: TrackOrderPage(),
      ),
    ),
  ],

  redirect: (context, state) async {
    final token = await getIt<AuthStorage>().getToken();
    final rememberMe = await getIt<AuthStorage>().getRememberMe();

    final bool loggingIn =
        state.matchedLocation == RouteNames.login ||
        state.matchedLocation == RouteNames.onboarding;

    if (loggingIn && token != null && rememberMe) {
      return RouteNames.profile;
    }
    return null;
  },
);
