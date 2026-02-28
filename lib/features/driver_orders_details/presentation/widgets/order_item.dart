import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/app/core/values/paths.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/manager/order_details_cubit.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({super.key});

  @override
  Widget build(BuildContext context) {
    final order = BlocProvider.of<OrderDetailsCubit>(context).state.data!.data;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: order?.orderDetails.items.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGrey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl:
                      "${AppPaths.mediaUrl}${order!.orderDetails.items[index].image}",
                  placeholder: (context, url) => Shimmer(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.lightGrey,
                        AppColors.white,
                        AppColors.lightGrey,
                      ],
                    ),
                    child: const CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderDetails.items[index].title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'EGP ${order.orderDetails.items[index].price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'X${order.orderDetails.items[index].quantity}',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.pink,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
