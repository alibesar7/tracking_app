import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/config/di/di.dart';
import '../manager/apply_cubit.dart';
import '../manager/apply_state.dart';
import '../manager/apply_intent.dart';
import '../../../../../app/core/widgets/custom_text_form_field.dart';
import '../../../../../app/core/utils/validators_helper.dart';

class ApplyScreen extends StatefulWidget {
  const ApplyScreen({super.key});

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _secondNameController =
      TextEditingController(); // Design says "Second legal name", could be last name
  final _vehicleNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedCountry;
  String? _selectedVehicleType;
  String _selectedGender = 'female'; // Default based on design or none

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Apply",
          style: TextStyle(fontWeight: FontWeight.bold),
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
                const Text(
                  "Welcome!!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "You want to be a delivery man?\nJoin our team",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Country Dropdown
                BlocBuilder<ApplyCubit, ApplyState>(
                  builder: (context, state) {
                    if (state.status == ApplyStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.status == ApplyStatus.failure) {
                      return Text(
                        state.errorMessage ?? "Failed to load countries",
                        style: const TextStyle(color: Colors.red),
                      );
                    }
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Country",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flag),
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
                      validator: (v) => v == null ? "Required" : null,
                    );
                  },
                ),
                const SizedBox(height: 16),

                // First Name
                CustomTextFormField(
                  controller: _firstNameController,
                  label: "First legal name",
                  hint: "Enter first legal name",
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 16),

                // Second Name
                CustomTextFormField(
                  controller: _secondNameController,
                  label: "Second legal name",
                  hint: "Enter second legal name",
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
                        state.vehiclesErrorMessage ?? "Failed to load vehicles",
                        style: const TextStyle(color: Colors.red),
                      );
                    }
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Vehicle type",
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedVehicleType,
                      items: state.vehicles
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.type,
                              child: Text(e.type ?? "Unknown"),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _selectedVehicleType = v),
                      validator: (v) => v == null ? "Required" : null,
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Vehicle Number
                CustomTextFormField(
                  controller: _vehicleNumberController,
                  label: "Vehicle number",
                  hint: "Enter vehicle number",
                  validator: (v) => v?.isEmpty ?? true ? "Required" : null,
                ),
                const SizedBox(height: 16),

                // Vehicle License Upload (Mock)
                _buildUploadField(
                  "Vehicle license",
                  "Upload license photo",
                  onSaved: (v) {},
                  validator: (v) => v == null || v.isEmpty
                      ? "License photo is required"
                      : null,
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
                  label: "ID number",
                  hint: "Enter national ID number",
                  validator: (v) => v?.isEmpty ?? true ? "Required" : null,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // ID Image Upload (Mock)
                _buildUploadField(
                  "ID image",
                  "Upload ID image",
                  onSaved: (v) {},
                  validator: (v) =>
                      v == null || v.isEmpty ? "ID image is required" : null,
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
                    const Text(
                      "Gender",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("Female"),
                        value: 'female',
                        groupValue: _selectedGender,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) => setState(() => _selectedGender = v!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text("Male"),
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
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process data
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFD01C68,
                    ), // Pink color from design
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadField(
    String label,
    String hint, {
    required Function(String?) onSaved,
    required String? Function(String?) validator,
  }) {
    return FormField<String>(
      validator: validator,
      onSaved: onSaved,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.upload_file),
                errorText: state.errorText,
              ),
              child: GestureDetector(
                onTap: () async {
                  // Mock file picking
                  // In a real app, use ImagePicker here
                  // await Future.delayed(Duration(seconds: 1));
                  state.didChange("mock_file_path.jpg");
                  onSaved("mock_file_path.jpg");
                },
                child: Text(
                  state.value ?? hint,
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
