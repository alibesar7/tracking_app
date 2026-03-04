import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
import 'package:tracking_app/features/track_order/presentation/manager/cubit/track_order_cubit.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

class StatusButton extends StatelessWidget {
  final OrderEntity order;

  const StatusButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    String buttonText;
    String nextStatus;

    switch (order.status.toLowerCase()) {
      case 'pending':
        buttonText = LocaleKeys.accept.tr();
        nextStatus = 'Accepted';
        break;
      case 'accepted':
        buttonText = LocaleKeys.arrivedAtPickup.tr();
        nextStatus = 'Arrived';
        break;
      case 'arrived':
        buttonText = LocaleKeys.pickUpOrder.tr();
        nextStatus = 'Picked';
        break;
      case 'picked':
        buttonText = LocaleKeys.startDelivery.tr();
        nextStatus = 'On the Way';
        break;
      case 'on the way':
        buttonText = LocaleKeys.markAsDelivered.tr();
        nextStatus = 'Delivered';
        break;
      case 'delivered':
        return const SizedBox.shrink();
      default:
        buttonText = LocaleKeys.accept.tr();
        nextStatus = 'Accepted';
    }

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          if (order.deviceToken == null) return;

          context.read<TrackOrderCubit>().updateOrderStatus(
            order.id,
            nextStatus,
            order.deviceToken!,
          );
        },
        child: Text(
          buttonText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
