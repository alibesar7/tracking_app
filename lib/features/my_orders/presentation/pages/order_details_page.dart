import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/address_title.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/order_item_tile.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/section_lable.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/summary_row.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isCancelled = order.state.toLowerCase() == 'cancelled';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Order details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isCancelled ? Icons.cancel : Icons.check_circle,
                      size: 20,
                      color: isCancelled ? AppColors.red : AppColors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      order.state,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isCancelled ? AppColors.red : AppColors.green,
                      ),
                    ),
                  ],
                ),
                Text(
                  "# ${order.orderNumber}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const SectionLabel(label: "Pickup address"),
            const SizedBox(height: 8),
            AddressTile(
              title: order.store?.name ?? "Unknown Store",
              address: order.store?.address ?? "No Address Provided",
              image: order.store?.image ?? "https://i.pravatar.cc/150?u=s1",
              isStore: true,
            ),
            const SizedBox(height: 20),
            const SectionLabel(label: "User address"),
            const SizedBox(height: 8),
            AddressTile(
              title: "${order.user.firstName} ${order.user.lastName}",
              address: order.address.isNotEmpty
                  ? order.address
                  : "No Address Provided",
              image: order.user.photo,
              isStore: false,
            ),
            const SizedBox(height: 24),
            const SectionLabel(label: "Order details"),
            const SizedBox(height: 12),
            ...order.items.map((item) => OrderItemTile(item: item)),
            const SizedBox(height: 12),
            SummaryRow(label: "Total", value: "Egp ${order.totalPrice}"),
            const SizedBox(height: 12),
            SummaryRow(label: "Payment method", value: order.paymentType),
          ],
        ),
      ),
    );
  }
}
