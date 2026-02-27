import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

enum OrderStatus {
  accepted,
  pickup,
  outForDelivery,
  arrived,
  delivered,
  unknown;

  static OrderStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return OrderStatus.accepted;
      case 'pickup':
        return OrderStatus.pickup;
      case 'out_for_delivery':
        return OrderStatus.outForDelivery;
      case 'arrived':
        return OrderStatus.arrived;
      case 'delivered':
        return OrderStatus.delivered;
      default:
        debugPrint('Unknown order status: $status');
        return OrderStatus.unknown;
    }
  }
}

extension OrderStatusX on OrderStatus {
  int get step {
    switch (this) {
      case OrderStatus.accepted:
        return 1;
      case OrderStatus.pickup:
        return 2;
      case OrderStatus.outForDelivery:
        return 3;
      case OrderStatus.arrived:
        return 4;
      case OrderStatus.delivered:
        return 5;
      case OrderStatus.unknown:
        return 1;
    }
  }

  String get buttonTextKey {
    switch (this) {
      case OrderStatus.accepted:
        return LocaleKeys.arrivedAtPickupPoint.tr();
      case OrderStatus.pickup:
        return LocaleKeys.startDelivery.tr();
      case OrderStatus.outForDelivery:
        return LocaleKeys.arriverAtDestination.tr();
      case OrderStatus.arrived:
        return LocaleKeys.confirmDelivery.tr();
      case OrderStatus.delivered:
        return LocaleKeys.orderCompleted.tr();
      case OrderStatus.unknown:
        return LocaleKeys.arrivedAtPickupPoint;
    }
  }

  String get statusTextKey {
    switch (this) {
      case OrderStatus.accepted:
        return LocaleKeys.accepted.tr();
      case OrderStatus.pickup:
        return LocaleKeys.pickedUp.tr();
      case OrderStatus.outForDelivery:
        return LocaleKeys.outForDelivery.tr();
      case OrderStatus.arrived:
        return LocaleKeys.arrived.tr();
      case OrderStatus.delivered:
        return LocaleKeys.delivered.tr();
      case OrderStatus.unknown:
        return '';
    }
  }
}
