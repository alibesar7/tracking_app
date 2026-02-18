import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';

extension OrderDtoMapper on OrderDto {
  OrderModel toOrderModel() {
    return OrderModel(
      driverId: driverId,
      id: id,
      status: status,
      totalPrice: totalPrice,
      userAddress: userAddress.toUserAddressModel(),
      userId: userId,
    );
  }
}

extension UserAddressDtoMapper on UserAddressDto {
  UserAddressModel toUserAddressModel() {
    return UserAddressModel(address: address, name: name);
  }
}
