import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/track_order/api/track_order_remote_source_impl.dart';
import 'package:tracking_app/features/track_order/data/models/track_order_model.dart';
import 'package:tracking_app/features/track_order/data/models/driver_model.dart';

/// ---------------- MOCKS ----------------

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockAuthStorage extends Mock implements AuthStorage {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

/// ----------------------------------------

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockAuthStorage mockAuthStorage;
  late TrackOrderRemoteDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(const <String, dynamic>{});
  });

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockAuthStorage = MockAuthStorage();
    dataSource = TrackOrderRemoteDataSourceImpl(mockFirestore, mockAuthStorage);
  });

  group('trackOrder', () {
    test('returns SuccessApiResult with mapped models', () async {
      final mockCollection = MockCollectionReference();
      final mockQuery = MockQuery();
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();

      when(() => mockFirestore.collection('orders')).thenReturn(mockCollection);
      when(
        () =>
            mockCollection.orderBy(any(), descending: any(named: 'descending')),
      ).thenReturn(mockQuery);
      when(() => mockQuery.where(any())).thenReturn(mockQuery);

      when(
        () => mockQuery.snapshots(),
      ).thenAnswer((_) => Stream.value(mockSnapshot));

      when(() => mockSnapshot.docs).thenReturn([mockDoc]);

      when(() => mockDoc.id).thenReturn('1');

      when(() => mockDoc.data()).thenReturn({
        'status': 'delivered',
        'driver_id': 'd1',
        'totalPrice': '100',
        'userId': 'u1',
        'deviceToken': 'token1',
      });

      final result = dataSource.trackOrder('u1');

      expect(result, isA<SuccessApiResult>());

      final stream = (result as SuccessApiResult).data;

      final list = await stream.first;

      expect(list, isA<List<TrackOrderModel>>());
      expect(list.length, 1);
      expect(list.first.id, '1');
    });

    test('returns ErrorApiResult when firestore throws', () {
      when(
        () => mockFirestore.collection('orders'),
      ).thenThrow(Exception('Firestore error'));

      final result = dataSource.trackOrder('u1');

      expect(result, isA<ErrorApiResult>());
    });
  });

  group('trackDriver', () {
    test('returns SuccessApiResult with driver model', () async {
      final mockCollection = MockCollectionReference();
      final mockDocRef = MockDocumentReference();
      final mockSnapshot = MockDocumentSnapshot();

      when(
        () => mockFirestore.collection('drivers'),
      ).thenReturn(mockCollection);

      when(() => mockCollection.doc('d1')).thenReturn(mockDocRef);

      when(
        () => mockDocRef.snapshots(),
      ).thenAnswer((_) => Stream.value(mockSnapshot));

      when(() => mockSnapshot.id).thenReturn('d1');

      when(() => mockSnapshot.data()).thenReturn({
        'currentLocation': {'lat': 30.0, 'lng': 31.0},
        'name': 'Driver Name',
        'phone': '12345',
        'deviceToken': 't1',
      });

      final result = dataSource.trackDriver('d1');

      expect(result, isA<SuccessApiResult>());

      final stream = (result as SuccessApiResult).data;
      final driver = await stream.first;

      expect(driver, isA<DriverModel>());
      expect(driver.id, 'd1');
      expect(driver.lat, 30.0);
    });

    test('returns ErrorApiResult if firestore throws', () {
      when(
        () => mockFirestore.collection('drivers'),
      ).thenThrow(Exception('Error'));

      final result = dataSource.trackDriver('d1');

      expect(result, isA<ErrorApiResult>());
    });
  });

  group('updateOrderStatus', () {
    test('updates order and returns document snapshot', () async {
      final mockCollection = MockCollectionReference();
      final mockDocRef = MockDocumentReference();
      final mockSnapshot = MockDocumentSnapshot();
      final mockNotificationCollection = MockCollectionReference();

      when(() => mockFirestore.collection('orders')).thenReturn(mockCollection);
      when(
        () => mockFirestore.collection('notification'),
      ).thenReturn(mockNotificationCollection);

      when(() => mockCollection.doc('1')).thenReturn(mockDocRef);
      when(() => mockDocRef.update(any())).thenAnswer((_) async {});
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);

      when(
        () => mockNotificationCollection.add(any()),
      ).thenAnswer((_) async => mockDocRef);

      final result = await dataSource.updateOrderStatus('1', 'delivered');

      expect(result, mockSnapshot);

      verify(() => mockDocRef.update(any())).called(1);
    });
  });
}
