import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/features/auth/presentation/login/manager/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/login/widgets/loginScreenBody.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: const Loginscreenbody(),
    );
  }
}
