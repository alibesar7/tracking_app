import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/driver_orders_details/data/mapper/order_dto_mapper.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';

void main() {
  group('OrderDtoMapper', () {
    test('Convert OrderDto to OrderModel correctly', () {
      final tUserAddressDto = UserAddressDto(
        address: 'Alex',
        name: 'Mariam',
        userId: 'U123',
      );

      final tOrderDto = OrderDto(
        driverId: 'D123',
        userAddress: tUserAddressDto,
        userId: 'U789',
        orderId: '22',
        orderDetails: OrderDetailsDto(
          items: [],
          status: 'pending',
          totalPrice: 500,
          pickupAddress: PickedAddressDto(
            name: 'Store',
            address: '123 Main St',
          ),
          orderId: '22',
          userAddress: 'alex',
        ),
      );

      final result = tOrderDto.toOrderModel();

      expect(result, isA<OrderModel>());
      expect(result.driverId, tOrderDto.driverId);
      expect(result.userAddress.name, tOrderDto.userAddress.name);
      expect(result.userAddress.address, tOrderDto.userAddress.address);
      expect(result.userAddress.userId, tOrderDto.userAddress.userId);
      expect(result.userId, tOrderDto.userId);
    });
  });

  group('OrderDetailsDtoMapper', () {
    test('Convert OrderDetailsDto to OrderDetailsModel correctly', () {
      final tpickupAddressDto = PickedAddressDto(
        name: 'Store',
        address: '123 Main St',
      );
      final tDto = OrderDetailsDto(
        items: [],
        status: 'pending',
        totalPrice: 500,
        pickupAddress: tpickupAddressDto,
        orderId: '1',
        userAddress: 'alex',
      );

      final result = tDto.toOrderDetailsModel();

      expect(result, isA<OrderDetailsModel>());
      expect(result.items, tDto.items);
      expect(result.status, tDto.status);
      expect(result.totalPrice, tDto.totalPrice);
      expect(result.pickupAddress.name, tDto.pickupAddress.name);
      expect(result.orderId, tDto.orderId);
    });
  });

  group('OrderItemDtoMapper', () {
    test('Convert OrderItemDto to OrderItemModel correctly', () {
      final tDto = OrderItemDto(
        productId: '1',
        title: 'Item 1',
        price: 100,
        quantity: 2,
        image: 'image_url',
      );

      final result = tDto.toOrderItemModel();

      expect(result.productId, tDto.productId);
      expect(result.title, tDto.title);
      expect(result.price, tDto.price);
      expect(result.quantity, tDto.quantity);
      expect(result.image, tDto.image);
    });
  });

  group('PickedAddressDtoMapper', () {
    test('Convert PickedAddressDto to PickedAddressModel correctly', () {
      final tDto = PickedAddressDto(name: 'Store', address: '123 Main St');

      final result = tDto.toPickedAddressModel();

      expect(result.name, tDto.name);
      expect(result.address, tDto.address);
    });
  });

  group('UserAddressDtoMapper', () {
    test('Convert UserAddressDto to UserAddressModel correctly', () {
      final tDto = UserAddressDto(
        name: 'Store',
        address: '123 Main St',
        userId: 'U123',
      );

      final result = tDto.toUserAddressModel();

      expect(result.name, tDto.name);
      expect(result.address, tDto.address);
    });
  });
}
