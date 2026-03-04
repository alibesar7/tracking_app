import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
import 'package:tracking_app/features/track_order/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/track_order/domain/usecases/track_order_usecase.dart';
import 'package:tracking_app/features/track_order/domain/usecases/driver_usecase.dart';
import 'package:tracking_app/features/track_order/domain/usecases/update_state_usecase.dart';
import 'package:tracking_app/features/track_order/presentation/manager/cubit/track_order_cubit.dart';

class MockTrackOrderUseCase extends Mock implements TrackOrderUseCase {}

class MockTrackDriverUseCase extends Mock implements TrackDriverUseCase {}

class MockUpdateOrderStatusUseCase extends Mock
    implements UpdateOrderStatusUseCase {}

class MockAuthStorage extends Mock implements AuthStorage {}

void main() {
  late MockTrackOrderUseCase mockTrackOrderUseCase;
  late MockTrackDriverUseCase mockTrackDriverUseCase;
  late MockUpdateOrderStatusUseCase mockUpdateOrderStatusUseCase;
  late MockAuthStorage mockAuthStorage;

  setUp(() {
    mockTrackOrderUseCase = MockTrackOrderUseCase();
    mockTrackDriverUseCase = MockTrackDriverUseCase();
    mockUpdateOrderStatusUseCase = MockUpdateOrderStatusUseCase();
    mockAuthStorage = MockAuthStorage();
  });

  group('loadUserOrders', () {
    final order = OrderEntity(id: 'o1', userId: 'u1', status: 'delivered');
    final ordersStream = Stream.value([order]);

    blocTest<TrackOrderCubit, TrackOrderState>(
      'emits error if token is null',
      build: () {
        when(() => mockAuthStorage.getToken()).thenAnswer((_) async => null);
        return TrackOrderCubit(
          mockTrackOrderUseCase,
          mockTrackDriverUseCase,
          mockUpdateOrderStatusUseCase,
          mockAuthStorage,
        );
      },
      act: (cubit) => cubit.loadUserOrders(),
      expect: () => [
        const TrackOrderState(isLoading: true),
        const TrackOrderState(isLoading: false, error: 'User not logged in'),
      ],
    );

    blocTest<TrackOrderCubit, TrackOrderState>(
      'emits orders when SuccessApiResult is returned',
      build: () {
        when(
          () => mockAuthStorage.getToken(),
        ).thenAnswer((_) async => 'dummy.token.value');
        when(
          () => mockTrackOrderUseCase.call(any()),
        ).thenReturn(SuccessApiResult(data: ordersStream));
        when(
          () => mockTrackDriverUseCase.call(any()),
        ).thenReturn(ErrorApiResult(error: 'Driver error'));
        return TrackOrderCubit(
          mockTrackOrderUseCase,
          mockTrackDriverUseCase,
          mockUpdateOrderStatusUseCase,
          mockAuthStorage,
        );
      },
      act: (cubit) => cubit.loadUserOrders(),
      expect: () => [
        const TrackOrderState(isLoading: true),
        TrackOrderState(isLoading: false, orders: [order]),
      ],
    );
  });

  group('trackDriver', () {
    const driver = DriverEntity(
      id: 'd1',
      lat: 10.0,
      lng: 20.0,
      name: 'Driver 1',
      phone: '12345678',
      deviceToken: 't1',
    );
    final driverStream = Stream.value(driver);

    blocTest<TrackOrderCubit, TrackOrderState>(
      'emits driver when SuccessApiResult is returned',
      build: () {
        when(
          () => mockTrackDriverUseCase.call('d1'),
        ).thenReturn(SuccessApiResult(data: driverStream));
        return TrackOrderCubit(
          mockTrackOrderUseCase,
          mockTrackDriverUseCase,
          mockUpdateOrderStatusUseCase,
          mockAuthStorage,
        );
      },
      act: (cubit) => cubit.trackDriver('d1'),
      expect: () => [const TrackOrderState(driver: driver)],
    );

    blocTest<TrackOrderCubit, TrackOrderState>(
      'emits error if stream has error',
      build: () {
        final errorStream = Stream<DriverEntity>.error('Driver not found');
        when(
          () => mockTrackDriverUseCase.call('d1'),
        ).thenReturn(SuccessApiResult(data: errorStream));
        return TrackOrderCubit(
          mockTrackOrderUseCase,
          mockTrackDriverUseCase,
          mockUpdateOrderStatusUseCase,
          mockAuthStorage,
        );
      },
      act: (cubit) => cubit.trackDriver('d1'),
      expect: () => [const TrackOrderState(error: 'Driver not found')],
    );
  });

  group('updateOrderStatus', () {
    blocTest<TrackOrderCubit, TrackOrderState>(
      'emits isLoading then success',
      build: () {
        when(
          () => mockUpdateOrderStatusUseCase.call(any(), any()),
        ).thenAnswer((_) async {});
        return TrackOrderCubit(
          mockTrackOrderUseCase,
          mockTrackDriverUseCase,
          mockUpdateOrderStatusUseCase,
          mockAuthStorage,
        );
      },
      act: (cubit) => cubit.updateOrderStatus('o1', 'Delivered'),
      expect: () => [
        const TrackOrderState(isLoading: true),
        const TrackOrderState(isLoading: false),
      ],
    );
  });
}
