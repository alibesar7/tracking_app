import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../ui_helper/color/colors.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, _) => SizedBox(height: 16),
      itemBuilder: (_, _) => Shimmer.fromColors(
        baseColor: AppColors.white,
        highlightColor: AppColors.lightGrey,
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
