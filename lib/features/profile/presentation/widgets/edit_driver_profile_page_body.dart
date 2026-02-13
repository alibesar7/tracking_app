import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app/core/widgets/show_snak_bar.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_state.dart';
import 'edit_driver_profile_form.dart';

class EditDriverProfilePageBody extends StatelessWidget {
  final DriverModel? user;

  const EditDriverProfilePageBody({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) =>
          prev.editProfileResource != curr.editProfileResource ||
          prev.uploadPhotoResource != curr.uploadPhotoResource,
      listener: (context, state) {
        if (state.editProfileResource.isSuccess == true) {
          showAppSnackbar(context, "Profile updated successfully");
        } else if (state.editProfileResource.isError == true) {
          showAppSnackbar(
            context,
            state.editProfileResource.error ?? "Edit profile failed",
          );
        }

        if (state.uploadPhotoResource.isSuccess == true) {
          showAppSnackbar(context, "Photo uploaded successfully");
        } else if (state.uploadPhotoResource.isError == true) {
          showAppSnackbar(
            context,
            state.uploadPhotoResource.error ?? "Upload photo failed",
          );
        }
      },
      child: EditDriverProfileForm(
        firstName: user?.firstName ?? '',
        lastName: user?.lastName ?? '',
        email: user?.email ?? '',
        phone: user?.phone ?? '',
        photo: user?.photo,
      ),
    );
  }
}
