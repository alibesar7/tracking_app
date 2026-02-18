class UserAddressDto {
  final String address;
  final String name;

  UserAddressDto({required this.address, required this.name});

  factory UserAddressDto.fromJson(Map<String, dynamic> json) {
    return UserAddressDto(
      address: json['address'].toString(),
      name: json['name'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'address': address, 'name': name};
  }
}

class OrderDto {
  final String driverId;
  final String id;
  final String status;
  final String totalPrice;
  final UserAddressDto userAddress;
  final String userId;

  OrderDto({
    required this.driverId,
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.userAddress,
    required this.userId,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) {
    return OrderDto(
      driverId: json['driverId'].toString(),
      id: json['id'].toString(),
      status: json['status'].toString(),
      totalPrice: json['totalPrice'].toString(),
      userAddress: json['userAddress '] != null
          ? UserAddressDto.fromJson(
              Map<String, dynamic>.from(json['userAddress ']),
            )
          : UserAddressDto(address: 'No Address', name: 'No Name'),
      userId: json['userId'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'id': id,
      'status': status,
      'totalPrice': totalPrice,
      'userAddress': userAddress.toJson(),
      'userId': userId,
    };
  }
}
