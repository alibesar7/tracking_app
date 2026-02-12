import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/app/core/ui_helper/style/font_style.dart';
import 'package:tracking_app/features/profile/presentation/widgets/info_card.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_item.dart';
import '../../../../app/core/router/route_names.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../auth/presentation/logout/manager/logout_cubit.dart';
import '../../../auth/presentation/logout/manager/logout_intent.dart';
import '../../../auth/presentation/logout/manager/logout_state.dart';
import 'language_bottom_sheet.dart';
import 'profile_avatar.dart';

class ProfilePageBody extends StatelessWidget {
  const ProfilePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final String userName = "Alice Brown";
    final String email = "amarium363@gmail.com";
    final String phone = "01222910063";

    final String? avatarUrl = null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          InfoCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProfileAvatar(userName: userName, imageUrl: avatarUrl),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(userName, style: AppStyles.black14bold),
                    SizedBox(height: 5),
                    Text(email, style: AppStyles.black14Medium),
                    SizedBox(height: 5),
                    Text(phone, style: AppStyles.black14Medium),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
          SizedBox(height: 16,),
          InfoCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Vichel Info", style: AppStyles.black14bold),
                    SizedBox(height: 5),
                    Text("Data", style: AppStyles.black14Medium),
                    SizedBox(height: 5),
                    Text("Data", style: AppStyles.black14Medium),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
          SizedBox(height: 16,),
          ProfileItem(
            itemName: LocaleKeys.language.tr(),
            icon: Icons.language,
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const LanguageBottomSheet(),
              );
            },
            trailing: Text(
              context.locale.languageCode == 'ar'
                  ? LocaleKeys.arabic.tr()
                  : LocaleKeys.english.tr(),
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
                      state.logoutResource.error ?? LocaleKeys.logoutFailed.tr(),
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
