import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_intent.dart';

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    final state = context.watch<ProfileCubit>().state;

    ImageProvider? image;
    if (state.selectedPhoto != null) {
      image = kIsWeb
          ? NetworkImage(state.selectedPhoto!.path)
          : FileImage(File(state.selectedPhoto!.path));
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: image,
              child: image == null
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
            if (state.uploadPhotoResource.isLoading == true)
              const CircularProgressIndicator(color: AppColors.pink),
          ],
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () async {
            final picker = ImagePicker();
            final file = await picker.pickImage(source: ImageSource.gallery);
            if (file != null) {
              cubit.doIntent(SelectPhotoIntent(File(file.path)));
            }
          },
          icon: const Icon(Icons.camera_alt, color: AppColors.pink),
          label: const Text(
            "Change Photo",
            style: TextStyle(color: AppColors.pink),
          ),
        ),
      ],
    );
  }
}
