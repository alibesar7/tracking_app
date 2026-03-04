import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/track_order/data/models/driver_model.dart';
import 'package:tracking_app/features/track_order/data/models/track_order_model.dart';
import 'package:tracking_app/features/track_order/data/repos/track_order_repo_imp.dart';
import 'package:tracking_app/features/track_order/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
import 'package:tracking_app/features/track_order/data/datasource/track_order_remote_source.dart';

class MockRemoteDataSource extends Mock implements TrackOrderRemoteDataSource {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late MockRemoteDataSource mockRemote;
  late TrackOrderRepoImpl repo;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    repo = TrackOrderRepoImpl(mockRemote);
  });

  group('trackOrder', () {
    test('returns SuccessApiResult with mapped OrderEntity', () async {
      final model = TrackOrderModel(
        id: 'o1',
        userId: 'u1',
        driverId: 'd1',
        status: 'delivered',
        totalPrice: '100',
        pickupAddress: 'p1',
        pickupName: 'pn',
        userAddress: 'u1',
        userName: 'un',
        deviceToken: 'token1',
      );

      when(
        () => mockRemote.trackOrder('u1'),
      ).thenReturn(SuccessApiResult(data: Stream.value([model])));

      final result = repo.trackOrder('u1');

      expect(result, isA<SuccessApiResult<Stream<List<OrderEntity>>>>());

      final list = await (result as SuccessApiResult).data.first;

      expect(list.length, 1);
      expect(list.first, isA<OrderEntity>());
      expect(list.first.id, 'o1');
      expect(list.first.userId, 'u1');
      expect(list.first.status, 'delivered');
    });

    test('returns ErrorApiResult if remote fails', () {
      when(
        () => mockRemote.trackOrder('u1'),
      ).thenReturn(ErrorApiResult(error: 'Network Error'));

      final result = repo.trackOrder('u1');

      expect(result, isA<ErrorApiResult>());
      expect((result as ErrorApiResult).error, 'Network Error');
    });
  });

  group('trackOrderWithDriver', () {
    test('returns SuccessApiResult with mapped DriverEntity', () async {
      final model = DriverModel(
        id: 'd1',
        lat: 10.0,
        lng: 20.0,
        name: 'Driver Name',
        phone: '12345678',
        deviceToken: 'token1',
      );

      when(
        () => mockRemote.trackDriver('d1'),
      ).thenReturn(SuccessApiResult(data: Stream.value(model)));

      final result = repo.trackOrderWithDriver('d1');

      expect(result, isA<SuccessApiResult<Stream<DriverEntity>>>());

      final driver = await (result as SuccessApiResult).data.first;

      expect(driver, isA<DriverEntity>());
      expect(driver.id, 'd1');
      expect(driver.lat, 10.0);
      expect(driver.lng, 20.0);
      expect(driver.name, 'Driver Name');
    });

    test('returns ErrorApiResult if remote fails', () {
      when(
        () => mockRemote.trackDriver('d1'),
      ).thenReturn(ErrorApiResult(error: 'Driver not found'));

      final result = repo.trackOrderWithDriver('d1');

      expect(result, isA<ErrorApiResult>());
      expect((result as ErrorApiResult).error, 'Driver not found');
    });
  });

  group('updateOrderStatus', () {
    test('calls remoteDataSource.updateOrderStatus', () async {
      when(
        () => mockRemote.updateOrderStatus('o1', 'delivered',),
      ).thenAnswer((_) async => MockDocumentSnapshot());

      await repo.updateOrderStatus('o1', 'delivered',);

      verify(
        () => mockRemote.updateOrderStatus('o1', 'delivered', ),
      ).called(1);
    });
  });
}
