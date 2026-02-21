import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';

void main() {
  group('UserAddressDto Tests', () {
    test('should return a valid UserAddressDto from JSON', () {
      final Map<String, dynamic> json = {
        'adress': 'Alex',
        'name': 'Mariam',
        'user_id': 'U123',
      };

      final result = UserAddressDto.fromJson(json);

      expect(result.address, 'Alex');
      expect(result.name, 'Mariam');
      expect(result.userId, 'U123');
    });

    test('should return a valid JSON map from UserAddressDto', () {
      final dto = UserAddressDto(
        address: 'Alex',
        name: 'Mariam',
        userId: 'U123',
      );

      final result = dto.toJson();

      expect(result['adress'], 'Alex');
      expect(result['name'], 'Mariam');
      expect(result['user_id'], 'U123');
    });
  });

  group('PickedAddressDto Tests', () {
    test('should return a valid PickedAddressDto from JSON', () {
      final Map<String, dynamic> json = {'address': 'Alex', 'name': 'Mariam'};

      final result = PickedAddressDto.fromJson(json);

      expect(result.address, 'Alex');
      expect(result.name, 'Mariam');
    });

    test('should return a valid JSON map from PickedAddressDto', () {
      final dto = PickedAddressDto(address: 'Alex', name: 'Mariam');

      final result = dto.toJson();

      expect(result['address'], 'Alex');
      expect(result['name'], 'Mariam');
    });
  });

  group('OrderItemDto Tests', () {
    test('should return a valid OrderItemDto from JSON', () {
      final Map<String, dynamic> json = {
        'productId': '1',
        'title': 'red flower',
        'image': 'url',
        'quantity': 1,
        'price': 100,
      };

      final result = OrderItemDto.fromJson(json);

      expect(result.image, 'url');
      expect(result.title, 'red flower');
      expect(result.quantity, 1);
      expect(result.price, 100);
    });

    test('should return a valid JSON map from OrderItemDto', () {
      final dto = OrderItemDto(
        image: 'Alex',
        productId: '1',
        title: 'red flower',
        quantity: 1,
        price: 100,
      );

      final result = dto.toJson();

      expect(result['image'], 'Alex');
      expect(result['title'], 'red flower');
      expect(result['quantity'], 1);
      expect(result['price'], 100);
    });
  });

  group('OrderDetailsDto Tests', () {
    test('should return a valid OrderDetailsDto from JSON', () {
      final Map<String, dynamic> json = {
        'items': [],
        'status': 'accepted',
        'totalPrice': 100.0,
        'pickupAddress': {'name': 'Mariam', 'address': 'Alex'},
        'orderId': 'O456',
        'userAddress': 'alex',
      };

      final result = OrderDetailsDto.fromJson(json);

      expect(result.status, 'accepted');
      expect(result.totalPrice, 100.0);
      expect(result.orderId, 'O456');
    });

    test('should return a valid JSON map from OrderDetailsDto', () {
      final dto = OrderDetailsDto(
        items: [
          OrderItemDto(
            image: 'url',
            productId: '1',
            title: 'red flower',
            quantity: 1,
            price: 100,
          ),
        ],
        status: 'accepted',
        totalPrice: 100.0,
        pickupAddress: PickedAddressDto(address: 'Alex', name: 'Mariam'),
        orderId: 'O456',
        userAddress: 'alex',
      );

      final result = dto.toJson();

      expect(result['status'], 'accepted');
      expect(result['totalPrice'], 100.0);
      final firstItem = result['items'][0];
      expect(firstItem['image'], 'url');
      expect(firstItem['title'], 'red flower');
      expect(firstItem['price'], 100.0);
      expect(result['pickupAddress']['name'], 'Mariam');
    });
  });

  group('OrderDto Tests', () {
    final Map<String, dynamic> tOrderJson = {
      'driver_id': 'D123',
      'user_id': 'U789',
      'userAddress': {
        'name': 'Home',
        'address': 'Cairo, Egypt',
        'userId': 'U789',
      },
      'oder_dt': {
        'status': 'processing',
        'totalPrice': 250.0,
        'orderId': 'O100',
        'userAddress': 'Cairo, Egypt',
        'pickupAddress': {'name': 'Pharmacy', 'address': 'Downtown'},
        'items': [
          {
            'productId': 'p1',
            'title': 'Panadol',
            'image': 'panadol.png',
            'quantity': 2,
            'price': 125.0,
          },
        ],
      },
    };

    const String tOrderId = 'O100';

    test('should return a valid OrderDto from JSON and ID', () {
      final result = OrderDto.fromJson(tOrderJson, tOrderId);

      expect(result.orderId, tOrderId);
      expect(result.driverId, 'D123');
      expect(result.userId, 'U789');
      expect(result.userAddress, isA<UserAddressDto>());
      expect(result.userAddress.name, 'Home');

      expect(result.orderDetails, isA<OrderDetailsDto>());
      expect(result.orderDetails.status, 'processing');
      expect(result.orderDetails.items.length, 1);
      expect(result.orderDetails.items[0].title, 'Panadol');
    });

    test('should return a valid JSON map from OrderDto', () {
      final dto = OrderDto(
        orderId: tOrderId,
        driverId: 'D123',
        userId: 'U789',
        userAddress: UserAddressDto(
          name: 'Home',
          address: 'Cairo',
          userId: 'U789',
        ),
        orderDetails: OrderDetailsDto(
          items: [],
          status: 'pending',
          totalPrice: 0.0,
          pickupAddress: PickedAddressDto(name: 'Store', address: 'Street'),
          orderId: tOrderId,
          userAddress: 'Cairo',
        ),
      );

      final result = dto.toJson();

      expect(result['driver_id'], 'D123');
      expect(result['user_id'], 'U789');

      expect(result['userAddress'], isA<Map<String, dynamic>>());
      expect(result['oder_dt'], isA<Map<String, dynamic>>());
      expect(result['oder_dt']['status'], 'pending');
    });
  });
}
