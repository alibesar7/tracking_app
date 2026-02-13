import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/app/core/ui_helper/style/font_style.dart';
import 'package:tracking_app/app/core/values/paths.dart';
import 'package:tracking_app/app/core/widgets/custom_button.dart';

class Onboardingscreen extends StatelessWidget {
  const Onboardingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.05),
                  Center(
                    child: Image(
                      image: const AssetImage(AppPaths.onboardingImage),
                      width: width * 0.85,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  Text(
                    'onboardingTitle'.tr(),
                    style: AppStyles.medium20.copyWith(color: Colors.black),
                  ),
                  Text(
                    'onboardingDescription'.tr(),
                    style: AppStyles.medium20.copyWith(color: Colors.black),
                  ),
                  SizedBox(height: height * 0.1),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      color: AppColors.pink,
                      isEnabled: true,
                      isLoading: false,
                      text: 'login'.tr(),
                      onPressed: () {
                        context.push(RouteNames.login);
                      },
                    ),
                  ),
                  SizedBox(height: height * 0.015),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      color: Colors.grey.shade600,
                      isEnabled: true,
                      isLoading: false,
                      isOutlined: true,
                      text: 'applyNow'.tr(),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(height: height * 0.25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
