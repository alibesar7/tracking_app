import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_intent.dart';

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
              decoration: const InputDecoration(labelText: 'Vehicle Type'),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: vehicleNumberController,
              decoration: const InputDecoration(labelText: 'Vehicle Number'),
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
              decoration: const InputDecoration(
                labelText: 'Vehicle License',
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
                      ? "Loading..."
                      : "Update",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
