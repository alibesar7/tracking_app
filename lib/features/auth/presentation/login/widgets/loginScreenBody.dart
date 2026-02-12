import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/app/core/ui_helper/style/font_style.dart';
import 'package:tracking_app/app/core/widgets/custom_button.dart';
import 'package:tracking_app/app/core/widgets/custom_text_form_field.dart';
import 'package:tracking_app/app/core/widgets/password_text_form_field.dart';
import 'package:tracking_app/app/core/widgets/show_snak_bar.dart';
import 'package:tracking_app/features/auth/presentation/login/manager/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/login/manager/login_intent.dart';
import 'package:tracking_app/features/auth/presentation/login/manager/login_states.dart';

class Loginscreenbody extends StatefulWidget {
  const Loginscreenbody({super.key});

  @override
  State<Loginscreenbody> createState() => _LoginscreenbodyState();
}

class _LoginscreenbodyState extends State<Loginscreenbody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state.loginResource.status == Status.error) {
          showAppSnackbar(
            context,
            (state.loginResource.error ?? 'unknownError').tr(),
          );
        } else if (state.loginResource.status == Status.success) {
          showAppSnackbar(context, 'success'.tr());
          context.go(RouteNames.profile);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.blackColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('login'.tr(), style: AppStyles.black24SemiBold),
            centerTitle: false,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      controller: _emailController,
                      label: 'email'.tr(),
                      hint: 'enterEmail'.tr(),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'emailRequired'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    PasswordTextFormField(
                      controller: _passwordController,
                      label: 'password'.tr(),
                      hint: 'enterPassword'.tr(),
                      isVisible: _isPasswordVisible,
                      onToggleVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'passwordRequired'.tr();
                        }
                        if (value.length < 6) {
                          return 'least6Characters'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: state.rememberMe,
                              activeColor: AppColors.pink,
                              onChanged: (value) {
                                context.read<LoginCubit>().doAction(
                                  ToggleRememberMe(value ?? false),
                                );
                              },
                            ),
                            Text(
                              'rememberMe'.tr(),
                              style: AppStyles.font14Black,
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to Forget Password
                          },
                          child: Text(
                            'forgotPasswordTitle'.tr(),
                            style: AppStyles.font14Black.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        isEnabled: true,
                        isLoading: state.loginResource.status == Status.loading,
                        text: 'continueTxt'.tr(),
                        color: AppColors.pink,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<LoginCubit>().doAction(
                              PerformLogin(
                                email: _emailController.text,
                                password: _passwordController.text,
                                rememberMe: state.rememberMe,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
