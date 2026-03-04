import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/features/Onboarding/presentation/pages/onboardingScreen.dart';
import 'package:tracking_app/features/app_sections/presentation/pages/app_sections.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/pages/drivers_orders_details_page.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/pages/location_page.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';
import 'package:tracking_app/features/profile/presentation/pages/edit_driver_profile_page.dart';
import 'package:tracking_app/features/profile/presentation/pages/edit_vehicle_page.dart';
import 'package:tracking_app/features/profile/presentation/pages/profile_page.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';
import 'package:tracking_app/features/my_orders/presentation/pages/order_details_page.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_pass/manager/cubit/forget_pass_cubit.dart';
import 'package:tracking_app/features/auth/presentation/forget_pass/pages/forget_pass_page.dart';
import 'package:tracking_app/features/auth/presentation/login/pages/loginScreen.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/manager/reset_password_cubit.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/pages/change_password_page.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/pages/reset_password.dart';
import 'package:tracking_app/features/auth/presentation/verify_reset/manger/cubit/verify_reset_cubit.dart';
import 'package:tracking_app/features/auth/presentation/verify_reset/pages/verify_reset_page.dart';

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
      path: RouteNames.editDriverProfile,
      builder: (context, state) {
        final driver = state.extra as DriverModel?;
        return EditDriverProfilePage(driver: driver);
      },
    ),

    GoRoute(
      path: RouteNames.editVehicle,
      builder: (context, state) {
        final driver = state.extra as DriverModel;
        return EditVehiclePage(driver: driver);
      },
    ),

    GoRoute(
      path: RouteNames.ordersDetailsPage,
      builder: (context, state) => DriversOrdersDetailsPage(),
    ),

    GoRoute(
      path: RouteNames.orderDetails,
      builder: (context, state) {
        final order = state.extra as OrderEntity;
        return OrderDetailsPage(order: order);
      },
    ),

    GoRoute(
      path: RouteNames.locationPage,
      builder: (context, state) => LocationPage(),
    ),
  ],
);
