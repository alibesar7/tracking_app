import 'package:flutter/material.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/address_title.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/section_lable.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                      color: isCancelled ? AppColors.red : AppColors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      order.state,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isCancelled ? AppColors.red : AppColors.green,
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
          ],
        ),
      ),
    );
  }
}
