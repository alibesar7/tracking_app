import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

class OrderHeader extends StatelessWidget {
  final OrderEntity order;
  final Color statusColor;

  const OrderHeader({
    super.key,
    required this.order,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    String translatedStatus = order.status;
    switch (order.status.toLowerCase()) {
      case 'pending':
        translatedStatus = LocaleKeys.pending.tr();
        break;
      case 'accepted':
        translatedStatus = LocaleKeys.accepted.tr();
        break;
      case 'arrived':
        translatedStatus = LocaleKeys.arrived.tr();
        break;
      case 'picked':
        translatedStatus = LocaleKeys.picked.tr();
        break;
      case 'on the way':
        translatedStatus = LocaleKeys.onTheWay.tr();
        break;
      case 'delivered':
        translatedStatus = LocaleKeys.delivered.tr();
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              translatedStatus,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            "#${order.id.length >= 6 ? order.id.substring(0, 6).toUpperCase() : order.id.toUpperCase()}",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
