import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/my_orders/domain/repo/my_orders_repo.dart';
import 'package:tracking_app/features/my_orders/domain/usecases/get_order_use_case.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_cubit.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_intent.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_state.dart';

import 'my_orders_cubit_test.mocks.dart';

@GenerateMocks([GetOrderUseCase, AuthStorage])
void main() {
  late MyOrdersCubit cubit;
  late MockGetOrderUseCase mockGetOrderUseCase;
  late MockAuthStorage mockAuthStorage;

  setUpAll(() {
    provideDummy<ApiResult<MyOrdersResult>>(
      SuccessApiResult(data: MyOrdersResult(orders: [])),
    );
  });

  setUp(() {
    mockGetOrderUseCase = MockGetOrderUseCase();
    mockAuthStorage = MockAuthStorage();
    cubit = MyOrdersCubit(mockGetOrderUseCase, mockAuthStorage);
  });

  tearDown(() {
    cubit.close();
  });

  const tToken = 'token123';
  final tOrdersResult = MyOrdersResult(orders: []);

  group('MyOrdersCubit', () {
    test('initial state should be correct', () {
      expect(cubit.state.ordersResource.status, Status.initial);
      expect(cubit.state.orders, isEmpty);
      expect(cubit.state.isLoadingMore, false);
    });

    blocTest<MyOrdersCubit, MyOrdersState>(
      'emits [loading, success] when GetMyOrdersIntent is successful',
      build: () {
        when(mockAuthStorage.getToken()).thenAnswer((_) async => tToken);
        when(
          mockGetOrderUseCase.call(
            token: anyNamed('token'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => SuccessApiResult(data: tOrdersResult));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetMyOrdersIntent(page: 1, limit: 10)),
      expect: () => [
        isA<MyOrdersState>().having(
          (s) => s.ordersResource.status,
          'status',
          Status.loading,
        ),
        isA<MyOrdersState>().having(
          (s) => s.ordersResource.status,
          'status',
          Status.success,
        ),
      ],
      verify: (_) {
        verify(mockAuthStorage.getToken()).called(1);
        verify(
          mockGetOrderUseCase.call(token: 'Bearer $tToken', page: 1, limit: 10),
        ).called(1);
      },
    );

    blocTest<MyOrdersCubit, MyOrdersState>(
      'emits [loading, error] when GetMyOrdersIntent fails',
      build: () {
        when(mockAuthStorage.getToken()).thenAnswer((_) async => tToken);
        when(
          mockGetOrderUseCase.call(
            token: anyNamed('token'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => ErrorApiResult(error: 'Server error'));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetMyOrdersIntent(page: 1, limit: 10)),
      expect: () => [
        isA<MyOrdersState>().having(
          (s) => s.ordersResource.status,
          'status',
          Status.loading,
        ),
        isA<MyOrdersState>().having(
          (s) => s.ordersResource.status,
          'status',
          Status.error,
        ),
      ],
    );

    blocTest<MyOrdersCubit, MyOrdersState>(
      'emits [loading, error] when token is missing',
      build: () {
        when(mockAuthStorage.getToken()).thenAnswer((_) async => null);
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetMyOrdersIntent(page: 1, limit: 10)),
      expect: () => [
        isA<MyOrdersState>().having(
          (s) => s.ordersResource.status,
          'status',
          Status.loading,
        ),
        isA<MyOrdersState>().having(
          (s) => s.ordersResource.status,
          'status',
          Status.error,
        ),
      ],
    );
  });
}
