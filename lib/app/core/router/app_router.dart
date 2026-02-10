import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/pages/change_password_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.changePassword,
  routes: [
    GoRoute(
      path: RouteNames.changePassword,
      builder: (context, state) => const ChangePasswordPage(),
    ),
  ],
);
