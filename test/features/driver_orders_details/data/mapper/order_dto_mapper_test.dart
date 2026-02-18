import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/driver_orders_details/data/mapper/order_dto_mapper.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';

void main() {
  group('OrderDtoMapper', () {
    test('Convert OrderDto to OrderModel correctly', () {
      final tUserAddressDto = UserAddressDto(address: 'Alex', name: 'Mariam');

      final tOrderDto = OrderDto(
        driverId: 'D123',
        id: 'O456',
        status: 'accepted',
        totalPrice: '150.0',
        userAddress: tUserAddressDto,
        userId: 'U789',
      );

      final result = tOrderDto.toOrderModel();

      expect(result, isA<OrderModel>());
      expect(result.id, tOrderDto.id);
      expect(result.status, tOrderDto.status);
      expect(result.totalPrice, tOrderDto.totalPrice);
      expect(result.userAddress.name, tOrderDto.userAddress.name);
      expect(result.userAddress.address, tOrderDto.userAddress.address);
    });
  });

  group('UserAddressDtoMapper', () {
    test('Convert UserAddressDto to UserAddressModel correctly', () {
      final tDto = UserAddressDto(address: 'Alex', name: 'Mariam');

      final result = tDto.toUserAddressModel();

      expect(result.name, tDto.name);
      expect(result.address, tDto.address);
    });
  });
}
