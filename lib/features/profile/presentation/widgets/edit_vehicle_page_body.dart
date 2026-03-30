import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app/core/widgets/show_snak_bar.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_state.dart';
import 'edit_vehicle_form.dart';

class EditVehiclePageBody extends StatelessWidget {
  final DriverModel? driver;

  const EditVehiclePageBody({super.key, this.driver});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) =>
          prev.editProfileResource != curr.editProfileResource,
      listener: (context, state) {
        if (state.editProfileResource.isSuccess == true) {
          showAppSnackbar(context, "Vehicle updated successfully");
        } else if (state.editProfileResource.isError == true) {
          showAppSnackbar(
            context,
            state.editProfileResource.error ?? "Update failed",
          );
        }
      },
      child: EditVehicleForm(
        vehicleType: driver?.vehicleType ?? '',
        vehicleNumber: driver?.vehicleNumber ?? '',
        vehicleLicense: driver?.vehicleLicense ?? '',
      ),
    );
  }
}
