import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverOrderButton.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverOrderInfoCard.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverOrderSectionLabel.dart';

class DriverOrderItem extends StatelessWidget {
  final Order order;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const DriverOrderItem({
    super.key,
    required this.order,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "driverOrderTitle".tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 16),
          DriverOrderSectionLabel("pickupAddress".tr()),
          const SizedBox(height: 8),
          DriverOrderInfoCard(
            image: order.store?.image,
            title: order.store?.name ?? "unknownStore".tr(),
            subtitle: order.store?.address ?? "noAddress".tr(),
            isStore: true,
          ),
          const SizedBox(height: 16),
          DriverOrderSectionLabel("userAddress".tr()),
          const SizedBox(height: 8),
          DriverOrderInfoCard(
            image: order.user?.photo != null
                ? "https://flower.elevateegy.com/uploads/${order.user!.photo!}"
                : null,
            title:
                "${order.user?.firstName ?? ''} ${order.user?.lastName ?? ''}",
            subtitle: order.shippingAddress?.street ?? "noAddress".tr(),
            isStore: false,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                "${order.totalPrice ?? 0} ${"egp".tr()}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const Spacer(),
              DriverOrderButton(
                text: "reject".tr(),
                onTap: onReject,
                isPrimary: false,
              ),
              const SizedBox(width: 8),
              DriverOrderButton(
                text: "accept".tr(),
                onTap: onAccept,
                isPrimary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
