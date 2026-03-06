import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/api/datasource/order_details_remote_datasource_impl.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';
import 'order_details_remote_datasource_impl_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  Dio,
])
void main() {
  late OrderDetailsRemoteDatasourceImpl dataSource;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocument;
  late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshot;
  late MockDio mockDio;

  const String tOrderId = 'pxkMaEmWYVuvV5jkW0JK';

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocument = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();
    mockDio = MockDio();

    dataSource = OrderDetailsRemoteDatasourceImpl(
      firestore: mockFirestore,
      dio: mockDio,
    );
  });
  group('getOrderStream', () {
    final tOrderJson = {
      'driver_id': '1',
      'user_id': 'U11',
      'userAddress': {'name': 'mariam', 'address': 'alex', 'userId': 'U11'},
      'oder_dt': {
        'items': [],
        'status': 'accepted',
        'totalPrice': 500.0,
        'orderId': tOrderId,
        'userAddress': 'alex',
        'pickupAddress': {'name': 'mariam', 'address': 'alex'},
      },
    };

    test('should return SuccessApiResult with Stream of OrderDto', () async {
      when(mockFirestore.collection('orders')).thenReturn(mockCollection);
      when(mockCollection.doc(tOrderId)).thenReturn(mockDocument);

      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.data()).thenReturn(tOrderJson);
      when(mockSnapshot.id).thenReturn(tOrderId);

      when(
        mockDocument.snapshots(),
      ).thenAnswer((_) => Stream.value(mockSnapshot));

      final result = dataSource.getOrderStream(tOrderId);

      expect(result, isA<SuccessApiResult<Stream<OrderDto>>>());
      final stream = (result as SuccessApiResult<Stream<OrderDto>>).data;
      await expectLater(
        stream,
        emits(
          isA<OrderDto>()
              .having((o) => o.orderId, 'orderId', tOrderId)
              .having((o) => o.orderDetails.status, 'status', 'accepted'),
        ),
      );
    });
  });
}
