import 'package:flutter/material.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/app/core/utils/app_launcher.dart';
import 'package:tracking_app/app/core/values/paths.dart';

class AddressCard extends StatelessWidget {
  final String title;
  final String address;
  final String imagePath;
  final String phoneNumber;

  const AddressCard({
    super.key,
    required this.title,
    required this.address,
    required this.imagePath,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: AssetImage(imagePath), radius: 25),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w400),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.blackColor,
                    ),
                    Flexible(
                      child: Text(
                        address,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => AppLauncher.launchPhone(phoneNumber),
            icon: Icon(Icons.phone_outlined, color: AppColors.pink, size: 20),
          ),

          IconButton(
            onPressed: () => AppLauncher.launchWhatsApp(phoneNumber),
            icon: ImageIcon(
              AssetImage(AppPaths.whatsappImage),
              color: AppColors.pink,
            ),
          ),
        ],
      ),
    );
  }
}
