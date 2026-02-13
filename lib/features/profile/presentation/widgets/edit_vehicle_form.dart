import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_intent.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

class EditVehicleForm extends StatefulWidget {
  final String vehicleType;
  final String vehicleNumber;
  final String vehicleLicense;

  const EditVehicleForm({
    super.key,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleLicense,
  });

  @override
  State<EditVehicleForm> createState() => _EditVehicleFormState();
}

class _EditVehicleFormState extends State<EditVehicleForm> {
  late final TextEditingController vehicleTypeController;
  late final TextEditingController vehicleNumberController;
  late final TextEditingController vehicleLicenseController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    vehicleTypeController = TextEditingController(text: widget.vehicleType);
    vehicleNumberController = TextEditingController(text: widget.vehicleNumber);
    vehicleLicenseController = TextEditingController(
      text: widget.vehicleLicense,
    );
  }

  @override
  void dispose() {
    vehicleTypeController.dispose();
    vehicleNumberController.dispose();
    vehicleLicenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    final state = context.watch<ProfileCubit>().state;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: vehicleTypeController,
              decoration: InputDecoration(
                labelText: LocaleKeys.vehicle_type.tr(),
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: vehicleNumberController,
              decoration: InputDecoration(
                labelText: LocaleKeys.vehicle_number.tr(),
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: vehicleLicenseController,
              readOnly: true,
              onTap: () async {
                final picked = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );

                if (picked != null) {
                  final file = File(picked.path);

                  cubit.doIntent(SelectVehicleLicenseIntent(file));

                  vehicleLicenseController.text = picked.name;

                  cubit.doIntent(UploadVehicleLicenseIntent());
                }
              },
              decoration: InputDecoration(
                labelText: LocaleKeys.vehicle_license.tr(),
                suffixIcon: Icon(Icons.upload),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: state.editProfileResource.isLoading == true
                    ? null
                    : () {
                        cubit.doIntent(
                          PerformEditProfile(
                            vehicleType: vehicleTypeController.text,
                            vehicleNumber: vehicleNumberController.text,
                            vehicleLicense: vehicleLicenseController.text,
                          ),
                        );
                      },
                child: Text(
                  state.editProfileResource.isLoading == true
                      ? LocaleKeys.loading.tr()
                      : LocaleKeys.update.tr(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
