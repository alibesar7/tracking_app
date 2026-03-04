import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/app/core/widgets/custom_button.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
import 'package:tracking_app/features/track_order/presentation/manager/cubit/track_order_cubit.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

class StatusButton extends StatelessWidget {
  final OrderEntity order;

  const StatusButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackOrderCubit, TrackOrderState>(
      builder: (context, state) {
        final status = order.status.trim().toLowerCase();

        String buttonText;
        String nextStatus;

        switch (status) {
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
          case 'cancelled':
            return const SizedBox.shrink();

          default:
            buttonText = LocaleKeys.accept.tr();
            nextStatus = 'Accepted';
        }

        /// 🔹 Pending → Show Reject + Accept
        if (status == 'pending') {
          return SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    isEnabled: !state.isLoading,
                    isLoading: state.isLoading,
                    text: LocaleKeys.reject.tr(),
                    isOutlined: true,
                    color: AppColors.red,
                    onPressed: () async {
                      await context.read<TrackOrderCubit>().updateOrderStatus(
                        order.id,
                        'Cancelled',
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    isEnabled: !state.isLoading,
                    isLoading: state.isLoading,
                    text: buttonText,
                    color: AppColors.pink,
                    onPressed: () async {
                      if (order.deviceToken == null) return;

                      await context.read<TrackOrderCubit>().updateOrderStatus(
                        order.id,
                        nextStatus,
                      );

                      if (nextStatus == 'Accepted' && context.mounted) {
                        context.go(RouteNames.ordersDetailsPage);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }

        /// 🔹 Other statuses → Single button
        return SizedBox(
          width: double.infinity,
          child: CustomButton(
            isEnabled: !state.isLoading,
            isLoading: state.isLoading,
            text: buttonText,
            color: AppColors.pink,
            onPressed: () async {
              if (order.deviceToken == null) return;

              await context.read<TrackOrderCubit>().updateOrderStatus(
                order.id,
                nextStatus,
              );
            },
          ),
        );
      },
    );
  }
}
