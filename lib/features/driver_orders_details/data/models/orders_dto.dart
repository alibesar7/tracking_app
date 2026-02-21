class OrderDto {
  final String orderId;
  final String driverId;
  final String userId;
  final OrderDetailsDto orderDetails;
  final UserAddressDto userAddress;

  OrderDto({
    required this.orderId,
    required this.driverId,
    required this.userId,
    required this.orderDetails,
    required this.userAddress,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json, String id) {
    return OrderDto(
      orderId: id,
      driverId: json['driver_id'] ?? '',
      userId: json['user_id'] ?? '',
      orderDetails: OrderDetailsDto.fromJson(json['oder_dt'] ?? {}),
      userAddress: UserAddressDto.fromJson(json['userAddress'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      'user_id': userId,
      'oder_dt': (orderDetails).toJson(),
      'userAddress': (userAddress).toJson(),
    };
  }
}

class OrderDetailsDto {
  final List<OrderItemDto> items;
  final String status;
  final double totalPrice;
  final PickedAddressDto pickupAddress;
  final String orderId;
  final String userAddress;

  OrderDetailsDto({
    required this.items,
    required this.status,
    required this.totalPrice,
    required this.pickupAddress,
    required this.orderId,
    required this.userAddress,
  });

  factory OrderDetailsDto.fromJson(Map<String, dynamic> json) {
    return OrderDetailsDto(
      status: json['status'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      pickupAddress: PickedAddressDto.fromJson(json['pickupAddress'] ?? {}),
      items: (json['items'] as List? ?? [])
          .map((i) => OrderItemDto.fromJson(i))
          .toList(),
      orderId: json['orderId'] ?? '',
      userAddress: json['userAddress'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalPrice': totalPrice,
      'pickupAddress': (pickupAddress).toJson(),
      'items': items.map((i) => (i).toJson()).toList(),
      'orderId': orderId,
      'userAddress': userAddress,
    };
  }
}

class OrderItemDto {
  final String productId;
  final String title;
  final String image;
  final int quantity;
  final double price;

  OrderItemDto({
    required this.productId,
    required this.title,
    required this.image,
    required this.quantity,
    required this.price,
  });

  factory OrderItemDto.fromJson(Map<String, dynamic> json) {
    return OrderItemDto(
      productId: json['productId'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'image': image,
      'quantity': quantity,
      'price': price,
    };
  }
}

class PickedAddressDto {
  final String name;
  final String address;

  PickedAddressDto({required this.name, required this.address});

  factory PickedAddressDto.fromJson(Map<String, dynamic> json) {
    return PickedAddressDto(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'address': address};
  }
}

class UserAddressDto {
  final String name;
  final String address;
  final String userId;

  UserAddressDto({
    required this.name,
    required this.address,
    required this.userId,
  });

  factory UserAddressDto.fromJson(Map<String, dynamic> json) {
    return UserAddressDto(
      name: json['name'] ?? '',
      address: json['adress'] ?? '',
      userId: json['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'adress': address, 'user_id': userId};
  }
}
