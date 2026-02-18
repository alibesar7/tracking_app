class UserAddressModel {
  final String address;
  final String name;

  UserAddressModel({required this.address, required this.name});
}

class OrderModel {
  final String driverId;
  final String id;
  final String status;
  final String totalPrice;
  final UserAddressModel userAddress;
  final String userId;

  OrderModel({
    required this.driverId,
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.userAddress,
    required this.userId,
  });
}
