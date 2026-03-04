import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/address_title.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/section_lable.dart';
import 'package:tracking_app/features/track_order/presentation/manager/cubit/track_order_cubit.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isPending = order.state.toLowerCase() == 'pending';
    final isCancelled = order.state.toLowerCase() == 'cancelled';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Flower order",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      isCancelled ? Icons.cancel : Icons.check_circle,
                      size: 18,
                      color: _statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      order.state,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _statusColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  "# ${order.orderNumber}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Pickup address ──
            SectionLabel(label: "Pickup address"),
            const SizedBox(height: 8),
            AddressTile(
              title: order.store?.name ?? "Unknown Store",
              address: order.store?.address ?? "No Address Provided",
              image:
                  order.store?.image ??
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6-k6E9vG_c9B_I0m_K-7J1f8e6C9F5G1g5A&s",
              isStore: true,
            ),

            const SizedBox(height: 12),

            // ── User address ──
            SectionLabel(label: "User address"),
            const SizedBox(height: 8),
            AddressTile(
              title: "${order.user.firstName} ${order.user.lastName}",
              address: order.address.isNotEmpty
                  ? order.address
                  : "No Address Provided",
              image: order.user.photo,
              isStore: false,
            ),

            // ── Price + Accept / Reject buttons (only for pending) ──
            if (isPending) ...[
              const SizedBox(height: 16),
              BlocBuilder<TrackOrderCubit, TrackOrderState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      // Price
                      Text(
                        "EGP ${order.totalPrice}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackColor,
                        ),
                      ),
                      const Spacer(),
                      // Reject button
                      SizedBox(
                        height: 36,
                        child: OutlinedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  context
                                      .read<TrackOrderCubit>()
                                      .updateOrderStatus(order.id, 'Cancelled');
                                },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.pink,
                            side: const BorderSide(
                              color: AppColors.pink,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          child: const Text(
                            "Reject",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Accept button
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  context
                                      .read<TrackOrderCubit>()
                                      .updateOrderStatus(order.id, 'Accepted');
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.pink,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          child: const Text(
                            "Accept",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Returns the appropriate color for the current order status.
  Color get _statusColor {
    switch (order.state.toLowerCase()) {
      case 'pending':
        return AppColors.pink;
      case 'cancelled':
        return AppColors.red;
      default:
        return AppColors.green;
    }
  }
}
