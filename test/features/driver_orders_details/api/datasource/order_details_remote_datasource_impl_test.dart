import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/api/datasource/order_details_remote_datasource_impl.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/drivers_dto.dart';
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
  late MockDio mockDio;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocument;
  late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshot;

  const String tOrderId = 'pxkMaEmWYVuvV5jkW0JK';
  const String driverId = '6989f35de364ef61405211a0';

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockDio = MockDio();
    mockCollection = MockCollectionReference();
    mockDocument = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();

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

  group('getDriversData', () {
    final driverData = {
      'id': '6989f35de364ef61405211a0',
      'currentLocation': {'lat': 31.251555, 'lng': 29.9843417},
      'name': "mariam",
      'phone': '01205708282',
      'deviceToken': '',
    };

    test('should return SuccessApiResult with Stream of DriverDto', () async {
      when(mockFirestore.collection('drivers')).thenReturn(mockCollection);
      when(mockCollection.doc(driverId)).thenReturn(mockDocument);

      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.data()).thenReturn(driverData);
      when(mockSnapshot.id).thenReturn(driverId);

      when(
        mockDocument.snapshots(),
      ).thenAnswer((_) => Stream.value(mockSnapshot));

      final result = dataSource.getDriverData(driverId);

      expect(result, isA<SuccessApiResult<Stream<DriverDataDto>>>());
      final stream = (result as SuccessApiResult<Stream<DriverDataDto>>).data;
      await expectLater(
        stream,
        emits(
          isA<DriverDataDto>()
              .having((o) => o.name, 'name', 'mariam')
              .having((o) => o.id, 'id', driverId),
        ),
      );
    });
  });

  group('getLatLngFromAddress', () {
    test('should return LatLng when API responds with valid data', () async {
      final responseData = [
        {"lat": "30.0444", "lon": "31.2357"},
      ];

      when(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.getLatLngFromAddress("Cairo");

      expect(result, isA<SuccessApiResult<LatLng?>>());
      final success = result as SuccessApiResult<LatLng?>;
      expect(success.data!.latitude, 30.0444);
      expect(success.data!.longitude, 31.2357);
    });
  });

  group('getRealRoute', () {
    test(
      'should return List<LatLng> when API responds with valid route',
      () async {
        final responseData = {
          "code": "Ok",
          "routes": [
            {"geometry": "}_ilFjk~uO??"},
          ],
        };

        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        final result = await dataSource.getRealRoute(
          const LatLng(30.0444, 31.2357),
          const LatLng(30.0500, 31.2400),
        );

        expect(result, isA<SuccessApiResult<List<LatLng>>>());
        final success = result as SuccessApiResult<List<LatLng>>;
        expect(success.data, isNotEmpty);
      },
    );
  });
}
