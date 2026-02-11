import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.applyScreen,

routes: [
  GoRoute(
    path: RouteNames.applyScreen,
    builder: (context, state) => const ApplyScreen(),
  ),
    ]);
