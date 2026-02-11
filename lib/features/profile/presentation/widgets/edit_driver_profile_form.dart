import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_intent.dart';
import 'profile_image_section.dart';

class EditDriverProfileForm extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? photo;

  const EditDriverProfileForm({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.photo,
  });

  @override
  State<EditDriverProfileForm> createState() => _EditDriverProfileFormState();
}

class _EditDriverProfileFormState extends State<EditDriverProfileForm> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  final authStorage = getIt<AuthStorage>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
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
            ProfileImageSection(),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(labelText: 'First name'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(labelText: 'Last name'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),

            const SizedBox(height: 16),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: '.......................',
                suffix: GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Change",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              obscureText: true,
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: state.editProfileResource.isLoading == true
                    ? null
                    : () async {
                        final token = await authStorage.getToken();
                        if (token == null) return;

                        if (state.selectedPhoto != null) {
                          cubit.doIntent(
                            UploadSelectedPhotoIntent('Bearer $token'),
                          );
                        }

                        cubit.doIntent(
                          PerformEditProfile(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
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
