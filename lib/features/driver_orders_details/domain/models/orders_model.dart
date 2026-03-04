class OrderModel {
  final String orderId;
  final String driverId;
  final String userId;
  final OrderDetailsModel orderDetails;
  final UserAddressModel userAddress;

  OrderModel({
    required this.orderId,
    required this.driverId,
    required this.userId,
    required this.orderDetails,
    required this.userAddress,
  });
}

class OrderDetailsModel {
  final List<OrderItemModel> items;
  final String status;
  final double totalPrice;
  final PickedAddressModel pickupAddress;
  final String orderId;
  final String userAddress;

  OrderDetailsModel({
    required this.items,
    required this.status,
    required this.totalPrice,
    required this.pickupAddress,
    required this.orderId,
    required this.userAddress,
  });
}

class OrderItemModel {
  final String productId;
  final String title;
  final String image;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.productId,
    required this.title,
    required this.image,
    required this.quantity,
    required this.price,
  });
}

class PickedAddressModel {
  final String name;
  final String address;

  PickedAddressModel({required this.name, required this.address});
}

class UserAddressModel {
  final String userId;
  final String name;
  final String address;

  UserAddressModel({
    required this.name,
    required this.address,
    required this.userId,
  });
}
