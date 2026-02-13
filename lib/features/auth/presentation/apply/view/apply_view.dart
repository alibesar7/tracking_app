import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'apply_success_view.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../../app/config/di/di.dart';
import '../manager/apply_cubit.dart';
import '../manager/apply_state.dart';
import '../manager/apply_intent.dart';
import '../../../../../app/core/widgets/custom_text_form_field.dart';
import '../../../../../app/core/utils/validators_helper.dart';
import 'package:tracking_app/features/auth/domain/entities/country_entity.dart';
import 'package:tracking_app/features/auth/data/models/request/apply_request_model.dart';

class ApplyScreen extends StatefulWidget {
  const ApplyScreen({super.key});

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Controllers
  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedCountry;
  String? _selectedVehicleType;
  String _selectedGender = 'female';

  // ✅ Store picked files (NOT paths)
  File? _vehicleLicenseFile;
  File? _nidImgFile;

  @override
  void dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
    _vehicleNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _idNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(Function(File) onPicked) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);

      final int sizeInBytes = await file.length();
      final double sizeInMb = sizeInBytes / (1024 * 1024);

      // ✅ allow up to 3MB (change if you want)
      if (sizeInMb <= 3) {
        onPicked(file);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("File size must be less than 3MB"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          LocaleKeys.apply.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: BlocProvider(
        create: (context) => getIt<ApplyCubit>()
          ..onIntent(GetCountriesIntent())
          ..onIntent(GetVehiclesIntent()),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  LocaleKeys.welcomeApply.tr(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  LocaleKeys.joinTeamMessage.tr(),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Country Dropdown
                BlocBuilder<ApplyCubit, ApplyState>(
                  builder: (context, state) {
                    if (state.status == ApplyStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.status == ApplyStatus.failure) {
                      return Text(
                        state.errorMessage ??
                            LocaleKeys.failedToLoadCountries.tr(),
                        style: const TextStyle(color: Colors.red),
                      );
                    }
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: LocaleKeys.country.tr(),
                        border: const OutlineInputBorder(),
                      ),
                      value: _selectedCountry,
                      items: state.countries.map((country) {
                        return DropdownMenuItem<String>(
                          value: country.isoCode,
                          child: Text(
                            "${country.flag} ${country.name}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => _selectedCountry = v),
                      validator: (v) =>
                          v == null ? LocaleKeys.requiredField.tr() : null,
                    );
                  },
                ),
                const SizedBox(height: 16),

                // First Name
                CustomTextFormField(
                  controller: _firstNameController,
                  label: LocaleKeys.firstLegalName.tr(),
                  hint: LocaleKeys.enterFirstLegalName.tr(),
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 16),

                // Second Name
                CustomTextFormField(
                  controller: _secondNameController,
                  label: LocaleKeys.secondLegalName.tr(),
                  hint: LocaleKeys.enterSecondLegalName.tr(),
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 16),

                // Vehicle Type Dropdown
                BlocBuilder<ApplyCubit, ApplyState>(
                  builder: (context, state) {
                    if (state.vehiclesStatus == ApplyStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.vehiclesStatus == ApplyStatus.failure) {
                      return Text(
                        state.vehiclesErrorMessage ??
                            LocaleKeys.failedToLoadVehicles.tr(),
                        style: const TextStyle(color: Colors.red),
                      );
                    }
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: LocaleKeys.vehicleType.tr(),
                        border: const OutlineInputBorder(),
                      ),
                      value: _selectedVehicleType,
                      items: state.vehicles
                          .where((element) => element.id != null)
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.type ?? "Unknown"),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _selectedVehicleType = v),
                      validator: (v) =>
                          v == null ? LocaleKeys.requiredField.tr() : null,
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Vehicle Number
                CustomTextFormField(
                  controller: _vehicleNumberController,
                  label: LocaleKeys.vehicleNumber.tr(),
                  hint: LocaleKeys.enterVehicleNumber.tr(),
                  validator: (v) =>
                      v?.isEmpty ?? true ? LocaleKeys.requiredField.tr() : null,
                ),
                const SizedBox(height: 16),

                // Vehicle License Upload (File)
                _buildUploadField(
                  LocaleKeys.vehicleLicense.tr(),
                  LocaleKeys.uploadLicensePhoto.tr(),
                  onSaved: (f) => _vehicleLicenseFile = f,
                  validator: (f) =>
                      f == null ? LocaleKeys.licensePhotoRequired.tr() : null,
                ),
                const SizedBox(height: 16),

                // Email
                CustomTextFormField(
                  controller: _emailController,
                  label: LocaleKeys.email.tr(),
                  hint: LocaleKeys.enterEmail.tr(),
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Phone
                CustomTextFormField(
                  controller: _phoneController,
                  label: LocaleKeys.phone.tr(),
                  hint: LocaleKeys.enterPhoneNumber.tr(),
                  validator: Validators.validatePhone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // ID Number
                CustomTextFormField(
                  controller: _idNumberController,
                  label: LocaleKeys.idNumber.tr(),
                  hint: LocaleKeys.enterNationalId.tr(),
                  validator: (v) =>
                      v?.isEmpty ?? true ? LocaleKeys.requiredField.tr() : null,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // ID Image Upload (File)
                _buildUploadField(
                  LocaleKeys.idImage.tr(),
                  LocaleKeys.uploadIdImage.tr(),
                  onSaved: (f) => _nidImgFile = f,
                  validator: (f) =>
                      f == null ? LocaleKeys.idImageRequired.tr() : null,
                ),
                const SizedBox(height: 16),

                // Password
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _passwordController,
                        label: LocaleKeys.password.tr(),
                        hint: LocaleKeys.enterPassword.tr(),
                        validator: Validators.validatePassword,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _confirmPasswordController,
                        label: LocaleKeys.confirmPassword.tr(),
                        hint: LocaleKeys.confirmNewPassword.tr(),
                        validator: (val) => Validators.validateRePassword(
                          val,
                          _passwordController.text,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Gender
                Row(
                  children: [
                    Text(
                      LocaleKeys.gender.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text(LocaleKeys.femaleGender.tr()),
                        value: 'female',
                        groupValue: _selectedGender,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) => setState(() => _selectedGender = v!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text(LocaleKeys.maleGender.tr()),
                        value: 'male',
                        groupValue: _selectedGender,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) => setState(() => _selectedGender = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Continue Button
                BlocConsumer<ApplyCubit, ApplyState>(
                  listener: (context, state) {
                    if (state.applyStatus == ApplyStatus.success) {
                      // Navigate to success screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const ApplySuccessScreen(),
                        ),
                      );
                    } else if (state.applyStatus == ApplyStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.applyErrorMessage ??
                                LocaleKeys.submissionFailed.tr(),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.applyStatus == ApplyStatus.loading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                final countryEntity = state.countries
                                    .cast<CountryEntity>()
                                    .firstWhere(
                                      (element) =>
                                          element.isoCode == _selectedCountry,
                                      orElse: () => state.countries.first,
                                    );
                                final phoneCode = countryEntity.phoneCode ?? "";
                                final rawPhone = _phoneController.text.trim();

                                final normalizedPhone = rawPhone.startsWith("0")
                                    ? rawPhone.substring(1)
                                    : rawPhone;
                                final request = ApplyRequestModel(
                                  country: _selectedCountry,
                                  firstName: _firstNameController.text,
                                  lastName: _secondNameController.text,
                                  vehicleType: _selectedVehicleType,
                                  vehicleNumber: _vehicleNumberController.text,
                                  email: _emailController.text,
                                  phone: "+$phoneCode$normalizedPhone",
                                  NID: _idNumberController.text,
                                  password: _passwordController.text,
                                  rePassword: _confirmPasswordController.text,
                                  gender: _selectedGender,

                                  vehicleLicense: _vehicleLicenseFile,
                                  NIDimg: _nidImgFile,
                                );

                                context.read<ApplyCubit>().onIntent(
                                  SubmitApplyIntent(request),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD01C68),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: state.applyStatus == ApplyStatus.loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              LocaleKeys.continueTxt.tr(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ Upload field that stores a File (not String path)
  Widget _buildUploadField(
    String label,
    String hint, {
    required Function(File?) onSaved,
    required String? Function(File?) validator,
  }) {
    return FormField<File>(
      validator: validator,
      onSaved: onSaved,
      builder: (FormFieldState<File> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.file_upload_outlined),
                errorText: state.errorText,
              ),
              child: GestureDetector(
                onTap: () {
                  _pickImage((file) {
                    state.didChange(file);
                  });
                },
                child: Text(
                  state.value != null
                      ? state.value!.path.split('/').last
                      : hint,
                  style: TextStyle(
                    color: state.value != null
                        ? Colors.black
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
