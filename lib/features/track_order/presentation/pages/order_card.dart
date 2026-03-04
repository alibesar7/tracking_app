import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
import 'package:tracking_app/features/track_order/presentation/pages/address_tile.dart';
import 'package:tracking_app/features/track_order/presentation/pages/order_header.dart';
import 'package:tracking_app/features/track_order/presentation/pages/status_button.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(order.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OrderHeader(order: order, statusColor: statusColor),
          const Divider(height: 1),

          AddressTile(
            title: LocaleKeys.pickupAddress.tr(),
            name: order.pickupName ?? LocaleKeys.store.tr(),
            address: order.pickupAddress ?? '-',
            icon: Icons.store_rounded,
            iconBg: AppColors.pink.withOpacity(0.1),
            iconColor: AppColors.pink,
          ),

          AddressTile(
            title: LocaleKeys.userAddress.tr(),
            name: order.userName ?? LocaleKeys.customer.tr(),
            address: order.userAddress ?? '-',
            icon: Icons.person_pin_circle_rounded,
            iconBg: Colors.grey.shade100,
            iconColor: Colors.grey.shade600,
          ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.totalPrice.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${LocaleKeys.egp.tr()} ${order.totalPrice ?? '0'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                StatusButton(order: order),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'arrived':
        return Colors.deepPurple;
      case 'picked':
        return Colors.indigo;
      case 'on the way':
        return Colors.teal;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
