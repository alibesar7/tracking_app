import 'package:tracking_app/features/track_order/domain/entities/order_location_entity.dart';

class OrderModel extends Order {
  OrderModel({
    required super.id,
    required super.driverId,
    required super.userId,
    required super.status,
    required super.totalPrice,
    required super.address,
    required super.name,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      driverId: json['driverId'] ?? '',
      userId: json['userId'] ?? '',
      status: json['status'] ?? '',
      totalPrice: json['totalPrice'] ?? '',
      address: json['userAddress']?['address'] ?? '',
      name: json['userAddress']?['name'] ?? '',
    );
  }
}
