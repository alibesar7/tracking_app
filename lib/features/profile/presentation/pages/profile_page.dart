import 'package:flutter/material.dart';
import 'package:tracking_app/app/core/widgets/custom_app_bar.dart';
import 'package:tracking_app/features/profile/presentation/widgets/notification_with_badge_widget.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';
import '../widgets/profile_page_body.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: LocaleKeys.profile,
          actions: [NotificationWithBadgeWidget()],
        ),
        body: ProfilePageBody(),
      ),
    );
  }
}
