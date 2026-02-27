import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/get_order_details_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/manager/order_details_cubit.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/manager/order_details_states.dart';
import 'order_details_cubit_test.mocks.dart';

@GenerateMocks([GetOrderDetailsUsecase, AuthStorage])
void main() {
  late OrderDetailsCubit cubit;
  late MockGetOrderDetailsUsecase mockUsecase;
  late MockAuthStorage mockAuthStorage;

  setUp(() {
    mockUsecase = MockGetOrderDetailsUsecase();
    mockAuthStorage = MockAuthStorage();
    final sl = GetIt.instance;
    sl.registerSingleton<AuthStorage>(mockAuthStorage);
    cubit = OrderDetailsCubit(mockUsecase);
    provideDummy<ApiResult<Stream<OrderModel>>>(ErrorApiResult(error: 'dummy'));
  });

  tearDown(() {
    cubit.close();
    GetIt.instance.reset();
  });

  const tOrderId = 'order_123';
  final tOrderModel = OrderModel(
    driverId: 'D1',
    userAddress: UserAddressModel(address: 'Shebin', name: 'Ali', userId: 'U1'),
    userId: 'U1',
    orderId: tOrderId,
    orderDetails: OrderDetailsModel(
      items: [],
      status: 'accepted',
      totalPrice: 500,
      pickupAddress: PickedAddressModel(name: 'Pharmacy', address: 'Downtown'),
      orderId: tOrderId,
      userAddress: 'Shebin',
    ),
  );
  group('OrderDetailsCubit Tests', () {
    blocTest<OrderDetailsCubit, OrderDetailsStates>(
      'emits [Loading, Success] when data is fetched successfully',
      build: () {
        when(
          mockUsecase.call(any),
        ).thenAnswer((_) => SuccessApiResult(data: Stream.value(tOrderModel)));
        return cubit;
      },
      act: (cubit) => cubit.getOrderDetails(tOrderId),
      expect: () => [
        isA<OrderDetailsStates>().having(
          (s) => s.data?.status,
          'status',
          Status.loading,
        ),
        isA<OrderDetailsStates>()
            .having((s) => s.data?.status, 'status', Status.success)
            .having((s) => s.data?.data, 'data', tOrderModel),
      ],
    );

    blocTest<OrderDetailsCubit, OrderDetailsStates>(
      'emits [Loading, Error] when fetching data fails',
      build: () {
        when(
          mockUsecase.call(any),
        ).thenAnswer((_) => ErrorApiResult(error: 'Server Error'));
        return cubit;
      },
      act: (cubit) => cubit.getOrderDetails(tOrderId),
      expect: () => [
        isA<OrderDetailsStates>().having(
          (s) => s.data?.status,
          'status',
          Status.loading,
        ),
        isA<OrderDetailsStates>()
            .having((s) => s.data?.status, 'status', Status.error)
            .having((s) => s.data?.error, 'error', 'Server Error'),
      ],
    );
  });
}
