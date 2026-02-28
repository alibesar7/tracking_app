import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';

extension OrderDtoMapper on OrderDto {
  OrderModel toOrderModel() {
    return OrderModel(
      driverId: driverId,
      orderId: orderId,
      userAddress: userAddress.toUserAddressModel(),
      userId: userId,
      orderDetails: orderDetails.toOrderDetailsModel(),
    );
  }
}

extension OrderDetailsDtoMapper on OrderDetailsDto {
  OrderDetailsModel toOrderDetailsModel() {
    return OrderDetailsModel(
      items: items.map((i) => i.toOrderItemModel()).toList(),
      status: status,
      totalPrice: totalPrice,
      pickupAddress: pickupAddress.toPickedAddressModel(),
      orderId: orderId,
      userAddress: userAddress,
    );
  }
}

extension OrderItemDtoMapper on OrderItemDto {
  OrderItemModel toOrderItemModel() {
    return OrderItemModel(
      productId: productId,
      title: title,
      image: image,
      quantity: quantity,
      price: price,
    );
  }
}

extension PickedAddressDtoMapper on PickedAddressDto {
  PickedAddressModel toPickedAddressModel() {
    return PickedAddressModel(name: name, address: address);
  }
}

extension UserAddressDtoMapper on UserAddressDto {
  UserAddressModel toUserAddressModel() {
    return UserAddressModel(name: name, address: address, userId: userId);
  }
}
