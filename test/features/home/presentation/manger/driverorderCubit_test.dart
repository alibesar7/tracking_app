import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';
import 'package:tracking_app/features/home/domain/repo/driverOrderRepo.dart';
import 'package:tracking_app/features/home/domain/usecase/getdriverOrderUsecase.dart';
import 'package:tracking_app/features/home/domain/usecase/getdriverOrderUsecase.dart';
import 'package:tracking_app/features/home/domain/usecase/upload_driver_fire_data_use_case.dart';
import 'package:tracking_app/features/home/presentation/manger/driverorderCubit.dart';
import 'package:tracking_app/features/home/presentation/manger/driverorderIntent.dart';
import 'package:tracking_app/features/home/presentation/manger/driverorderStates.dart';

import 'driverorderCubit_test.mocks.dart';

@GenerateMocks([DriverOrderRepo, AuthStorage, UploadDriverFireDataUseCase])
void main() {
  late DriverOrderCubit driverOrderCubit;
  late MockDriverOrderRepo mockDriverOrderRepo;
  late MockUploadDriverFireDataUseCase mockUploadDriverFireDataUseCase;
  late GetDriverOrdersUseCase getDriverOrdersUseCase;
  late MockAuthStorage mockAuthStorage;

  setUp(() {
    provideDummy<ApiResult<OrderResponse>>(
      SuccessApiResult(data: OrderResponse()),
    );
    mockDriverOrderRepo = MockDriverOrderRepo();
    mockAuthStorage = MockAuthStorage();
    mockUploadDriverFireDataUseCase = MockUploadDriverFireDataUseCase();
    getDriverOrdersUseCase = GetDriverOrdersUseCase(mockDriverOrderRepo);
    driverOrderCubit = DriverOrderCubit(
      getDriverOrdersUseCase,
      mockAuthStorage,
      mockUploadDriverFireDataUseCase,
      mockDriverOrderRepo,
    );
  });

  tearDown(() {
    driverOrderCubit.close();
  });

  group('DriverOrderCubit', () {
    test('initial state is DriverOrderState with Resource.initial', () {
      expect(driverOrderCubit.state.orderResource.status, Status.initial);
    });

    final tOrderResponse = OrderResponse(
      message: 'Success',
      orders: [
        Order(id: '1', state: 'pending'),
        Order(id: '2', state: 'pending'),
      ],
    );

    group('GetPendingOrders', () {
      blocTest<DriverOrderCubit, DriverOrderState>(
        'emits [loading, success] when GetPendingOrders is added and token exists and api call is successful',
        build: () {
          when(mockAuthStorage.getToken()).thenAnswer((_) async => 'token');
          when(
            mockDriverOrderRepo.getPendingOrders('token'),
          ).thenAnswer((_) async => SuccessApiResult(data: tOrderResponse));
          return driverOrderCubit;
        },
        act: (cubit) => cubit.onIntent(GetPendingOrders()),
        expect: () => [
          isA<DriverOrderState>().having(
            (state) => state.orderResource.status,
            'status',
            Status.loading,
          ),
          isA<DriverOrderState>()
              .having(
                (state) => state.orderResource.status,
                'status',
                Status.success,
              )
              .having(
                (state) => state.orderResource.data,
                'data',
                tOrderResponse,
              ),
        ],
      );

      blocTest<DriverOrderCubit, DriverOrderState>(
        'emits [loading, error] when GetPendingOrders is added and token is null',
        build: () {
          when(mockAuthStorage.getToken()).thenAnswer((_) async => null);
          return driverOrderCubit;
        },
        act: (cubit) => cubit.onIntent(GetPendingOrders()),
        expect: () => [
          isA<DriverOrderState>().having(
            (state) => state.orderResource.status,
            'status',
            Status.loading,
          ),
          isA<DriverOrderState>()
              .having(
                (state) => state.orderResource.status,
                'status',
                Status.error,
              )
              .having(
                (state) => state.orderResource.error,
                'error',
                'User not authenticated',
              ),
        ],
      );

      blocTest<DriverOrderCubit, DriverOrderState>(
        'emits [loading, error] when GetPendingOrders is added and api call fails',
        build: () {
          when(mockAuthStorage.getToken()).thenAnswer((_) async => 'token');
          when(
            mockDriverOrderRepo.getPendingOrders('token'),
          ).thenAnswer((_) async => ErrorApiResult(error: 'API Error'));
          return driverOrderCubit;
        },
        act: (cubit) => cubit.onIntent(GetPendingOrders()),
        expect: () => [
          isA<DriverOrderState>().having(
            (state) => state.orderResource.status,
            'status',
            Status.loading,
          ),
          isA<DriverOrderState>()
              .having(
                (state) => state.orderResource.status,
                'status',
                Status.error,
              )
              .having(
                (state) => state.orderResource.error,
                'error',
                'API Error',
              ),
        ],
      );
    });

    group('RemoveOrder', () {
      final orderToRemove = Order(id: '1', state: 'pending');
      final orderToKeep = Order(id: '2', state: 'pending');
      final initialOrders = [orderToRemove, orderToKeep];
      final initialOrderResponse = OrderResponse(orders: initialOrders);

      blocTest<DriverOrderCubit, DriverOrderState>(
        'emits [success] with updated orders when RemoveOrder is added',
        build: () => driverOrderCubit,
        seed: () => DriverOrderState(
          orderResource: Resource.success(initialOrderResponse),
        ),
        act: (cubit) => cubit.onIntent(RemoveOrder(orderToRemove)),
        expect: () => [
          isA<DriverOrderState>().having(
            (state) => state.orderResource.data?.orders,
            'orders',
            [orderToKeep],
          ),
        ],
      );

      blocTest<DriverOrderCubit, DriverOrderState>(
        'does nothing when RemoveOrder is added but current state is not success',
        build: () => driverOrderCubit,
        seed: () => DriverOrderState(orderResource: Resource.loading()),
        act: (cubit) => cubit.onIntent(RemoveOrder(orderToRemove)),
        expect: () => [],
      );
    });
  });
}
