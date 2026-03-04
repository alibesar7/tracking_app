import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final String status;

  final String? driverId;
  final String? totalPrice;
  final String? pickupAddress;
  final String? pickupName;
  final String? userAddress;
  final String? userName;
  final String? deviceToken;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.status,
    this.driverId,
    this.totalPrice,
    this.pickupAddress,
    this.pickupName,
    this.userAddress,
    this.userName,
    this.deviceToken,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    status,
    driverId,
    totalPrice,
    pickupAddress,
    pickupName,
    userAddress,
    userName,
    deviceToken,
  ];
}
