import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/data/datasource/order_details_remote_datasource.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/drivers_dto.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';
import 'package:tracking_app/features/driver_orders_details/data/repos/order_details_repo_impl.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/drivers_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'order_details_repo_impl_test.mocks.dart';

@GenerateMocks([OrderDetailsRemoteDatasource, DocumentSnapshot, AuthStorage])
void main() {
  late OrderDetailsRepoImpl repository;
  late MockAuthStorage authStorage;
  late MockOrderDetailsRemoteDatasource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockOrderDetailsRemoteDatasource();
    authStorage = MockAuthStorage();
    repository = OrderDetailsRepoImpl(mockRemoteDataSource, authStorage);
    provideDummy<ApiResult<Stream<OrderDto>>>(
      ErrorApiResult(error: 'dummy_error'),
    );
    provideDummy<ApiResult<Stream<DriverDataDto>>>(
      ErrorApiResult(error: 'dummy_error'),
    );
    provideDummy<ApiResult<LatLng?>>(ErrorApiResult(error: 'dummy_error'));
    provideDummy<ApiResult<List<LatLng>>>(ErrorApiResult(error: 'dummy_error'));
  });

  const tOrderId = 'pxkMaEmWYVuvV5jkW0JK';
  const driverId = '6989f35de364ef61405211a0';

  final tOrderDto = OrderDto(
    driverId: 'D123',
    userAddress: UserAddressDto(
      address: 'Alex',
      name: 'Mariam',
      userId: 'U123',
    ),
    userId: 'U789',
    orderId: tOrderId,
    orderDetails: OrderDetailsDto(
      items: [],
      status: 'accepted',
      totalPrice: 150.0,
      pickupAddress: PickedAddressDto(name: 'Pharmacy', address: 'Downtown'),
      orderId: tOrderId,
      userAddress: 'Alex',
    ),
  );

  final driverDto = DriverDataDto(
    deviceToken: 'token',
    id: '6989f35de364ef61405211a0',
    name: 'mariam',
    phone: '01205708282',
    currentLocation: DriverLocationDto(lat: 30, lng: 29),
  );

  group('getOrderDetails', () {
    test(
      'should emit OrderModel when the remote data source returns SuccessApiResult with Stream',
      () async {
        when(authStorage.getOrderId()).thenAnswer((_) async => tOrderId);

        when(
          mockRemoteDataSource.getOrderStream(tOrderId),
        ).thenReturn(SuccessApiResult(data: Stream.value(tOrderDto)));

        final result = await repository.getOrderDetails();

        expect(result, isA<SuccessApiResult<Stream<OrderModel>>>());
        final stream = (result as SuccessApiResult<Stream<OrderModel>>).data;
        await expectLater(
          stream,
          emits(
            isA<OrderModel>()
                .having((o) => o.orderId, 'order id', tOrderId)
                .having((o) => o.userAddress.name, 'user name', 'Mariam')
                .having(
                  (o) => o.orderDetails.status,
                  'order status',
                  'accepted',
                )
                .having((o) => o.orderDetails.totalPrice, 'total price', 150.0),
          ),
        );
      },
    );

    test(
      'should throw an Exception when the document does not exist',
      () async {
        const errorMessage = "Network Error";
        when(authStorage.getOrderId()).thenAnswer((_) async => tOrderId);

        when(
          mockRemoteDataSource.getOrderStream(tOrderId),
        ).thenReturn(ErrorApiResult(error: errorMessage));

        final result = await repository.getOrderDetails();

        expect(result, isA<ErrorApiResult<Stream<OrderModel>>>());
        expect((result as ErrorApiResult).error, errorMessage);
      },
    );
  });

  group('getDriverData', () {
    test(
      'should emit DriverDataModel when the remote data source returns SuccessApiResult with Stream',
      () async {
        when(
          mockRemoteDataSource.getDriverData(driverId),
        ).thenReturn(SuccessApiResult(data: Stream.value(driverDto)));

        final result = repository.getDriverData(driverId);

        expect(result, isA<SuccessApiResult<Stream<DriverDataModel>>>());
        final stream =
            (result as SuccessApiResult<Stream<DriverDataModel>>).data;
        await expectLater(
          stream,
          emits(
            isA<DriverDataModel>()
                .having((o) => o.id, 'driver id', driverId)
                .having((o) => o.name, 'user name', driverDto.name)
                .having((o) => o.currentLocation.lat, 'lat', 30),
          ),
        );
      },
    );

    test(
      'should throw an Exception when the document does not exist',
      () async {
        const errorMessage = "Network Error";
        when(
          mockRemoteDataSource.getDriverData(driverId),
        ).thenReturn(ErrorApiResult(error: errorMessage));

        final result = repository.getDriverData(driverId);

        expect(result, isA<ErrorApiResult<Stream<DriverDataModel>>>());
        expect((result as ErrorApiResult).error, errorMessage);
      },
    );
  });
  group('getLatLngFromAddress', () {
    final tAddress = "Cairo";
    final tLatLng = LatLng(30.0, 31.0);

    test(
      'should return SuccessApiResult when remote data source succeeds',
      () async {
        when(
          mockRemoteDataSource.getLatLngFromAddress(tAddress),
        ).thenAnswer((_) async => SuccessApiResult<LatLng?>(data: tLatLng));

        final result = await repository.getLatLngFromAddress(tAddress);

        expect(result, isA<SuccessApiResult<LatLng?>>());
        expect((result as SuccessApiResult).data, tLatLng);
      },
    );

    test(
      'should return ErrorApiResult when remote data source fails',
      () async {
        when(mockRemoteDataSource.getLatLngFromAddress(tAddress)).thenAnswer(
          (_) async => ErrorApiResult<LatLng?>(error: "Network Error"),
        );

        final result = await repository.getLatLngFromAddress(tAddress);

        expect(result, isA<ErrorApiResult<LatLng?>>());
        expect((result as ErrorApiResult).error, "Network Error");
      },
    );
  });

  group('getRealRoute', () {
    final tMyLocation = LatLng(30.0, 31.0);
    final tDestination = LatLng(30.5, 31.5);
    final tRoute = [LatLng(30.0, 31.0), LatLng(30.5, 31.5)];

    test(
      'should return SuccessApiResult when remote data source succeeds',
      () async {
        when(
          mockRemoteDataSource.getRealRoute(tMyLocation, tDestination),
        ).thenAnswer((_) async => SuccessApiResult<List<LatLng>>(data: tRoute));

        final result = await repository.getRealRoute(tMyLocation, tDestination);

        expect(result, isA<SuccessApiResult<List<LatLng>>>());
        expect((result as SuccessApiResult).data, tRoute);
      },
    );

    test(
      'should return ErrorApiResult when remote data source fails',
      () async {
        when(
          mockRemoteDataSource.getRealRoute(tMyLocation, tDestination),
        ).thenAnswer(
          (_) async => ErrorApiResult<List<LatLng>>(error: "Routing Error"),
        );

        final result = await repository.getRealRoute(tMyLocation, tDestination);

        expect(result, isA<ErrorApiResult<List<LatLng>>>());
        expect((result as ErrorApiResult).error, "Routing Error");
      },
    );
  });
}
