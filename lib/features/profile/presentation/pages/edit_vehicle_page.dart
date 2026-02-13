import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/widgets/edit_vehicle_page_body.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

class EditVehiclePage extends StatelessWidget {
  final DriverModel? driver;
  const EditVehiclePage({super.key, this.driver});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            LocaleKeys.editVehicle.tr(),
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        body: EditVehiclePageBody(driver: driver),
      ),
    );
  }
}
