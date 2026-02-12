import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/features/auth/presentation/logout/manager/logout_cubit.dart';
import 'package:tracking_app/features/profile/presentation/pages/profile_page.dart';

import '../../config/di/di.dart';

final GoRouter appRouter = GoRouter(
    initialLocation: RouteNames.profile,

    routes: [
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<LogoutCubit>(),
          child: const ProfilePage(),
        ),
      ),
]);
