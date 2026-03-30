import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverOrderButton.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverOrderInfoCard.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverOrderSectionLabel.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.01,
      ),
      padding: EdgeInsets.all(width * 0.04),
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
            LocaleKeys.driverOrderTitle.tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          SizedBox(height: height * 0.02),
          DriverOrderSectionLabel(LocaleKeys.pickupAddress.tr()),
          SizedBox(height: height * 0.01),
          DriverOrderInfoCard(
            image: order.store?.image,
            title: order.store?.name ?? LocaleKeys.unknownStore.tr(),
            subtitle: order.store?.address ?? LocaleKeys.noAddress.tr(),
            isStore: true,
          ),
          SizedBox(height: height * 0.02),
          DriverOrderSectionLabel(LocaleKeys.userAddress.tr()),
          SizedBox(height: height * 0.01),
          DriverOrderInfoCard(
            image: order.user?.photo != null
                ? "https://flower.elevateegy.com/uploads/${order.user!.photo!}"
                : null,
            title:
                "${order.user?.firstName ?? ''} ${order.user?.lastName ?? ''}",
            subtitle:
                order.shippingAddress?.street ?? LocaleKeys.noAddress.tr(),
            isStore: false,
          ),
          SizedBox(height: height * 0.03),
          Row(
            children: [
              Text(
                "${order.totalPrice ?? 0} ${LocaleKeys.egp.tr()}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              const Spacer(),
              DriverOrderButton(
                text: LocaleKeys.reject.tr(),
                onTap: onReject,
                isPrimary: false,
              ),
              SizedBox(width: width * 0.02),
              DriverOrderButton(
                text: LocaleKeys.accept.tr(),
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
