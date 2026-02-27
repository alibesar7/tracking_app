import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/track_order/api/track_order_remote_source_impl.dart';
import 'package:tracking_app/features/track_order/data/datasource/track_order_remote_source.dart';
import 'package:tracking_app/features/track_order/data/models/track_order_model.dart';
import 'package:tracking_app/features/track_order/data/models/driver_model.dart';

/// ---------------- MOCKS ----------------

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

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
  late TrackOrderRemoteDataSourceImpl dataSource;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    dataSource = TrackOrderRemoteDataSourceImpl(mockFirestore);
  });

  group('trackOrder', () {
    test('returns SuccessApiResult with mapped models', () async {
      final mockCollection = MockCollectionReference();
      final mockQuery = MockQuery();
      final mockSnapshot = MockQuerySnapshot();
      final mockDoc = MockQueryDocumentSnapshot();

      when(() => mockFirestore.collection('orders')).thenReturn(mockCollection);

      when(() => mockCollection.where(any())).thenReturn(mockQuery);

      when(
        () => mockQuery.snapshots(),
      ).thenAnswer((_) => Stream.value(mockSnapshot));

      when(() => mockSnapshot.docs).thenReturn([mockDoc]);

      when(() => mockDoc.id).thenReturn('1');

      when(() => mockDoc.data()).thenReturn({
        'status': 'delivered',
        'driver_id': 'd1',
        'total_price': 100,
        'userAddress': {'user_id': 'u1'},
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

      when(() => mockSnapshot.data()).thenReturn({'lat': 30.0, 'lng': 31.0});

      final result = dataSource.trackDriver('d1');

      expect(result, isA<SuccessApiResult>());

      final stream = (result as SuccessApiResult).data;
      final driver = await stream.first;

      expect(driver, isA<DriverModel>());
      expect(driver.id, 'd1');
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

      when(() => mockFirestore.collection('orders')).thenReturn(mockCollection);

      when(() => mockCollection.doc('1')).thenReturn(mockDocRef);

      when(() => mockDocRef.update(any())).thenAnswer((_) async {});

      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);

      final result = await dataSource.updateOrderStatus('1', 'delivered');

      expect(result, mockSnapshot);

      verify(() => mockDocRef.update({'status': 'delivered'})).called(1);
    });
  });
}
