import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/track_order/data/models/track_order_model.dart';

void main() {
  group('TrackOrderModel.fromFirestore', () {
    test('parses flat structure correctly', () {
      final data = {
        'driver_id': 'driver1',
        'status': 'on_the_way',
        'totalPrice': '200',
        'userId': 'user1',
      };

      final model = TrackOrderModel.fromFirestore('order1', data);

      expect(model.id, 'order1');
      expect(model.driverId, 'driver1');
      expect(model.status, 'on_the_way');
      expect(model.totalPrice, '200');
      expect(model.userId, 'user1');
    });

    test('parses nested structure correctly', () {
      final data = {
        'driverId': 'driver2',
        'userAddress': {'user_id': 'user2'},
        'oder_dt': {'status': 'delivered', 'totalPrice': 350},
      };

      final model = TrackOrderModel.fromFirestore('order2', data);

      expect(model.id, 'order2');
      expect(model.driverId, 'driver2');
      expect(model.status, 'delivered');
      expect(model.totalPrice, '350'); // int converted to string
      expect(model.userId, 'user2');
    });

    test('handles null values safely', () {
      final data = {
        'driver_id': null,
        'status': null,
        'totalPrice': null,
        'userId': null,
      };

      final model = TrackOrderModel.fromFirestore('order3', data);

      expect(model.driverId, '');
      expect(model.status, '');
      expect(model.totalPrice, '');
      expect(model.userId, '');
    });

    test('handles missing nested maps', () {
      final data = <String, dynamic>{};

      final model = TrackOrderModel.fromFirestore('order4', data);

      expect(model.driverId, '');
      expect(model.status, '');
      expect(model.totalPrice, '');
      expect(model.userId, '');
    });
  });
}
