import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/drivers_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/get_driver_data_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/get_order_details_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/location_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/push_notification_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/send_device_notification_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/update_order_state_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/manager/order_details_cubit.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/manager/order_details_states.dart';

import 'order_details_cubit_test.mocks.dart';

@GenerateMocks([
  GetOrderDetailsUsecase,
  GetDriverDataUsecase,
  LocationUsecase,
  PushNotificationUsecase,
  UpdateOrderStateUsecase,
  SendDeviceNotificationUsecase,
  AuthStorage,
])
void main() {
  late OrderDetailsCubit cubit;
  late MockGetOrderDetailsUsecase mockGetOrderDetailsUsecase;
  late MockGetDriverDataUsecase mockGetDriverDataUsecase;
  late MockLocationUsecase mockLocationUsecase;
  late MockUpdateOrderStateUsecase _updateOrderStateUsecase;
  late MockPushNotificationUsecase _pushNotificationUsecase;
  late MockSendDeviceNotificationUsecase _sendDeviceNotificationUsecase;
  late MockAuthStorage authStorage;

  setUpAll(() {
    mockGetOrderDetailsUsecase = MockGetOrderDetailsUsecase();
    mockGetDriverDataUsecase = MockGetDriverDataUsecase();
    mockLocationUsecase = MockLocationUsecase();
    _updateOrderStateUsecase = MockUpdateOrderStateUsecase();
    _pushNotificationUsecase = MockPushNotificationUsecase();
    _sendDeviceNotificationUsecase = MockSendDeviceNotificationUsecase();
    authStorage = MockAuthStorage();

    provideDummy<ApiResult<Stream<OrderModel>>>(
      SuccessApiResult(data: Stream.empty()),
    );
    provideDummy<ApiResult<Stream<DriverDataModel>>>(
      SuccessApiResult(data: Stream.empty()),
    );
    provideDummy<ApiResult<LatLng?>>(SuccessApiResult(data: null));
    provideDummy<ApiResult<List<LatLng>>>(SuccessApiResult(data: []));
  });

  setUp(() {
    getIt.registerSingleton<AuthStorage>(authStorage);

    cubit = OrderDetailsCubit(
      mockGetOrderDetailsUsecase,
      mockGetDriverDataUsecase,
      mockLocationUsecase,
      _updateOrderStateUsecase,
      _pushNotificationUsecase,
      _sendDeviceNotificationUsecase,
    );
  });

  tearDown(() {
    cubit.close();
    getIt.reset();
  });

  final orderData = OrderModel(
    orderId: '1',
    driverId: '11',
    userId: 'userId',
    orderDetails: OrderDetailsModel(
      items: [],
      status: 'deliver',
      totalPrice: 500,
      pickupAddress: PickedAddressModel(name: 'name', address: 'address'),
      orderId: '11',
      userAddress: 'userAddress',
    ),
    userAddress: UserAddressModel(
      name: 'name',
      address: 'address',
      userId: 'userId',
    ),
  );

  final driverData = DriverDataModel(
    id: 'id',
    name: 'name',
    phone: 'phone',
    deviceToken: 'deviceToken',
    currentLocation: DriverLocationModel(lat: 30, lng: 29),
  );

  final driverLocation = LatLng(30.0, 31.0);
  final destination = LatLng(31.0, 32.0);
  final polylines = [
    LatLng(30.0, 31.0),
    LatLng(30.5, 31.5),
    LatLng(31.0, 32.0),
  ];
  group('get order details', () {
    blocTest<OrderDetailsCubit, OrderDetailsStates>(
      'emits loading then success when order stream returns data',
      build: () {
        final controller = StreamController<OrderModel>();

        when(
          mockGetOrderDetailsUsecase.call(),
        ).thenAnswer((_) async => SuccessApiResult(data: controller.stream));

        when(mockGetDriverDataUsecase.call(orderData.driverId)).thenReturn(
          SuccessApiResult(
            data: Stream.value(
              DriverDataModel(
                id: '',
                name: '',
                phone: '',
                deviceToken: '',
                currentLocation: DriverLocationModel(lat: 30, lng: 29),
              ),
            ),
          ),
        );

        Future.microtask(() => controller.add(orderData));

        return cubit;
      },
      act: (cubit) => cubit.getOrderDetails(),
      expect: () => [
        isA<OrderDetailsStates>().having(
          (s) => s.data?.status,
          "status",
          Status.loading,
        ),
        isA<OrderDetailsStates>()
            .having((s) => s.data?.status, "status", Status.success)
            .having(
              (s) => s.data?.data?.orderDetails.totalPrice,
              "totalPrice",
              500,
            ),
        isA<OrderDetailsStates>().having(
          (s) => s.driverData?.status,
          "driverStatus",
          Status.loading,
        ),
        isA<OrderDetailsStates>().having(
          (s) => s.driverData?.status,
          "driverStatus",
          Status.success,
        ),
      ],
      verify: (_) {
        verify(mockGetOrderDetailsUsecase.call()).called(1);
        verify(mockGetDriverDataUsecase.call('11')).called(1);
      },
    );

    blocTest<OrderDetailsCubit, OrderDetailsStates>(
      'emits loading then error when getOrderDetailsUsecase fails',
      build: () {
        when(mockGetOrderDetailsUsecase.call()).thenAnswer(
          (_) async => ErrorApiResult<Stream<OrderModel>>(
            error: "Failed to fetch order",
          ),
        );

        return cubit;
      },
      act: (cubit) => cubit.getOrderDetails(),
      expect: () => [
        isA<OrderDetailsStates>().having(
          (s) => s.data?.status,
          "status",
          Status.loading,
        ),
        isA<OrderDetailsStates>().having(
          (s) => s.data?.status,
          "status",
          Status.error,
        ),
      ],
      verify: (_) {
        verify(mockGetOrderDetailsUsecase.call()).called(1);
      },
    );
  });

  group('get driver details', () {
    blocTest<OrderDetailsCubit, OrderDetailsStates>(
      'emits loading then success when driver stream returns data',
      build: () {
        final controller = StreamController<DriverDataModel>();

        when(
          mockGetDriverDataUsecase.call(driverData.id),
        ).thenReturn(SuccessApiResult(data: controller.stream));

        Future.microtask(() => controller.add(driverData));

        return cubit;
      },
      act: (cubit) => cubit.getDriverData(driverData.id),
      expect: () => [
        isA<OrderDetailsStates>().having(
          (s) => s.driverData?.status,
          "driverStatus",
          Status.loading,
        ),
        isA<OrderDetailsStates>().having(
          (s) => s.driverData?.status,
          "driverStatus",
          Status.success,
        ),
      ],
      verify: (_) {
        verify(mockGetDriverDataUsecase.call(driverData.id)).called(1);
      },
    );

    blocTest<OrderDetailsCubit, OrderDetailsStates>(
      'emits loading then error when getDriverDataUsecase fails',
      build: () {
        when(mockGetDriverDataUsecase.call(driverData.id)).thenReturn(
          ErrorApiResult<Stream<DriverDataModel>>(
            error: "Failed to fetch order",
          ),
        );

        return cubit;
      },
      act: (cubit) => cubit.getDriverData(driverData.id),
      expect: () => [
        isA<OrderDetailsStates>().having(
          (s) => s.driverData?.status,
          "status",
          Status.loading,
        ),
        isA<OrderDetailsStates>().having(
          (s) => s.driverData?.status,
          "status",
          Status.error,
        ),
      ],
      verify: (_) {
        verify(mockGetDriverDataUsecase.call(driverData.id)).called(1);
      },
    );
  });

  group('set destination', () {
    blocTest<OrderDetailsCubit, OrderDetailsStates>(
      'emits destination then polylines when setDestinationFromAddress succeeds',
      build: () {
        when(
          mockLocationUsecase.getAddress("Test Address"),
        ).thenAnswer((_) async => SuccessApiResult(data: destination));

        when(
          mockLocationUsecase.getRealRoute(driverLocation, destination),
        ).thenAnswer((_) async => SuccessApiResult(data: polylines));

        return cubit;
      },
      act: (cubit) =>
          cubit.setDestinationFromAddress("Test Address", driverLocation),
      expect: () => [
        isA<OrderDetailsStates>().having(
          (s) => s.destination,
          "destination",
          destination,
        ),
        isA<OrderDetailsStates>().having(
          (s) => s.polylines,
          "polylines",
          polylines,
        ),
      ],
      verify: (_) {
        verify(mockLocationUsecase.getAddress("Test Address")).called(1);
        verify(
          mockLocationUsecase.getRealRoute(driverLocation, destination),
        ).called(1);
      },
    );
  });

  group('get route', () {
    blocTest<OrderDetailsCubit, OrderDetailsStates>(
      'emits polylines when getRoute succeeds',
      build: () {
        cubit.emit(cubit.state.copyWith(destination: destination));

        when(
          mockLocationUsecase.getRealRoute(driverLocation, destination),
        ).thenAnswer((_) async => SuccessApiResult(data: polylines));

        return cubit;
      },
      act: (cubit) => cubit.getRoute(driverLocation),
      expect: () => [
        isA<OrderDetailsStates>().having(
          (s) => s.polylines,
          "polylines",
          polylines,
        ),
      ],
      verify: (_) {
        verify(
          mockLocationUsecase.getRealRoute(driverLocation, destination),
        ).called(1);
      },
    );
  });
}
