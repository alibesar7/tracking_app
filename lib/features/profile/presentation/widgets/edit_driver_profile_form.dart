import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_intent.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';
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
                    decoration: InputDecoration(
                      labelText: LocaleKeys.firstName.tr(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.lastName.tr(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: LocaleKeys.email.tr()),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(labelText: LocaleKeys.phone.tr()),
            ),

            const SizedBox(height: 16),

            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: LocaleKeys.password.tr(),
                hintText: '.......................',
                suffix: GestureDetector(
                  onTap: () {},
                  child: Text(
                    LocaleKeys.change.tr(),
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
                          cubit.doIntent(UploadSelectedPhotoIntent());
                        }

                        cubit.doIntent(
                          PerformEditProfile(
                            firstName: firstNameController.text.trim(),
                            lastName: lastNameController.text.trim(),
                            email: emailController.text.trim(),
                            phone: phoneController.text.trim(),
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
