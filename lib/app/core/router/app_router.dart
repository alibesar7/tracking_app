import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/features/app_sections/presentation/pages/app_sections.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.appStart,

  routes: [
    GoRoute(
      path: RouteNames.appStart,
      builder: (context, state) => AppSections(),
    ),
  ],
);
