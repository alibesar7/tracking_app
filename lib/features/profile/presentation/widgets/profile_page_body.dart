import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/app/core/ui_helper/style/font_style.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_intent.dart';
import 'package:tracking_app/features/profile/presentation/widgets/info_card.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_item.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';
import '../../../../app/core/router/route_names.dart';
import '../../../auth/presentation/logout/manager/logout_cubit.dart';
import '../../../auth/presentation/logout/manager/logout_intent.dart';
import '../../../auth/presentation/logout/manager/logout_state.dart';
import 'language_bottom_sheet.dart';

class ProfilePageBody extends StatelessWidget {
  const ProfilePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileCubit>().state;
    final user = state.driver;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              await context.push(RouteNames.editDriverProfile, extra: user);
              if (context.mounted) {
                context.read<ProfileCubit>().doIntent(GetProfileIntent());
              }
            },
            child: InfoCard(
              child: Row(
                children: [
                  ProfileAvatar(
                    userName:
                        "${user?.firstName ?? ''} ${user?.lastName ?? ''}",
                    imageUrl: user?.photo,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${user?.firstName ?? 'Admin'} ${user?.lastName ?? 'User'}",
                          style: AppStyles.black14bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user?.email ?? 'test@gmail.com',
                          style: AppStyles.black14Medium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user?.phone ?? '01010101010',
                          style: AppStyles.black14Medium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          InfoCard(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await context.push(RouteNames.editVehicle, extra: user);
                      if (context.mounted) {
                        context.read<ProfileCubit>().doIntent(
                          GetProfileIntent(),
                        );
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Vehicle Info", style: AppStyles.black14bold),
                        const SizedBox(height: 5),
                        Text(
                          user?.vehicleType ?? "N/A",
                          style: AppStyles.black14Medium,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user?.vehicleNumber ?? "N/A",
                          style: AppStyles.black14Medium,
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),

          const SizedBox(height: 16),

          ProfileItem(
            itemName: "Language",
            icon: Icons.language,
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const LanguageBottomSheet(),
              );
            },
            trailing: Text(
              context.locale.languageCode == 'ar' ? "Arabic" : "English",
              style: AppStyles.font14Black.copyWith(color: AppColors.pink),
            ),
          ),
          BlocConsumer<LogoutCubit, LogoutStates>(
            listener: (context, state) {
              if (state.logoutResource.isSuccess) {
                context.go(RouteNames.login);
              }
              if (state.logoutResource.isError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.logoutResource.error ??
                          LocaleKeys.logoutFailed.tr(),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state.logoutResource.isLoading;
              return ProfileItem(
                itemName: LocaleKeys.logout.tr(),
                icon: Icons.logout,
                trailing: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.logout, color: AppColors.pink),
                onTap: isLoading
                    ? null
                    : () {
                        context.read<LogoutCubit>().doIntent(PerformLogout());
                      },
              );
            },
          ),
        ],
      ),
    );
  }
}
