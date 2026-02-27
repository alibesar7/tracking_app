import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/features/app_sections/presentation/manager/app_section_cubit.dart';
import 'package:tracking_app/features/app_sections/presentation/widgets/app_section_view.dart';

class AppSections extends StatelessWidget {
  const AppSections({super.key});

  @override
  Widget build(BuildContext context) {
    final AppSectionCubit appSectionCubit = getIt<AppSectionCubit>();

    return BlocProvider<AppSectionCubit>(
      create: (_) => appSectionCubit,
      child: AppSectionsView(),
    );
  }
}
