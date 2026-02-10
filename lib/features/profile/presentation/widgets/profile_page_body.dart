import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/app/core/ui_helper/style/font_style.dart';
import 'package:tracking_app/features/profile/presentation/widgets/info_card.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_item.dart';
import '../../../../generated/locale_keys.g.dart';
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
          SizedBox(height: 16),
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
          SizedBox(height: 16),
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
          ProfileItem(
            itemName: LocaleKeys.logout.tr(),
            icon: Icons.logout,
            onTap: () {},
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.logout, color: AppColors.pink),
            ),
          ),
        ],
      ),
    );
  }
}
