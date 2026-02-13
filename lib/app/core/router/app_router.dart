import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/pages/change_password_page.dart';
import 'package:tracking_app/features/Onboarding/presentation/pages/onboardingScreen.dart';
import 'package:tracking_app/features/app_sections/presentation/pages/app_sections.dart';
import 'package:tracking_app/features/auth/presentation/login/pages/loginScreen.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/features/profile/presentation/pages/profile_page.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view.dart';

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


