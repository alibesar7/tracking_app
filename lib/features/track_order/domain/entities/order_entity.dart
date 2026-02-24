class OrderEntity {
  final String id;
  final String userId;
  final String status;

  final String? driverId;
  final String? totalPrice;
  final String? address;
  final String? name;

  OrderEntity({
    required this.id,
    required this.userId,
    required this.status,
    this.driverId,
    this.totalPrice,
    this.address,
    this.name,
  });
}
