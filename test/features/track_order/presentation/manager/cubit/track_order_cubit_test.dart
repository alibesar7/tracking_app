import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
import 'package:tracking_app/features/track_order/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/track_order/domain/usecases/track_order_usecase.dart';
import 'package:tracking_app/features/track_order/domain/usecases/driver_usecase.dart';
import 'package:tracking_app/features/track_order/presentation/manager/cubit/track_order_cubit.dart';

class MockTrackOrderUseCase extends Mock implements TrackOrderUseCase {}

class MockTrackDriverUseCase extends Mock implements TrackDriverUseCase {}

class MockAuthStorage extends Mock implements AuthStorage {}

void main() {
  late MockTrackOrderUseCase mockTrackOrderUseCase;
  late MockTrackDriverUseCase mockTrackDriverUseCase;
  late MockAuthStorage mockAuthStorage;
  late TrackOrderCubit cubit;

  setUp(() {
    mockTrackOrderUseCase = MockTrackOrderUseCase();
    mockTrackDriverUseCase = MockTrackDriverUseCase();
    mockAuthStorage = MockAuthStorage();

    cubit = TrackOrderCubit(
      mockTrackOrderUseCase,
      mockTrackDriverUseCase,
      mockAuthStorage,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('loadUserOrders', () {
    final order = OrderEntity(id: 'o1', userId: 'u1', status: 'delivered');
    final ordersStream = Stream.value([order]);

    test('emits error if token is null', () async {
      when(() => mockAuthStorage.getToken()).thenAnswer((_) async => null);

      await cubit.loadUserOrders();

      expect(cubit.state.isLoading, false);
      expect(cubit.state.error, 'User not logged in');
      expect(cubit.state.orders, []);
    });

    test('emits orders when SuccessApiResult is returned', () async {
      when(
        () => mockAuthStorage.getToken(),
      ).thenAnswer((_) async => 'dummy.token.value');
      when(
        () => mockTrackOrderUseCase.call(any()),
      ).thenReturn(SuccessApiResult(data: ordersStream));

      await cubit.loadUserOrders();

      final emittedOrders = await cubit.stream.first;
      expect(emittedOrders.orders.length, 1);
      expect(emittedOrders.orders.first.id, 'o1');
    });

    test('emits error when ErrorApiResult is returned', () async {
      when(
        () => mockAuthStorage.getToken(),
      ).thenAnswer((_) async => 'dummy.token.value');
      when(
        () => mockTrackOrderUseCase.call(any()),
      ).thenReturn(ErrorApiResult(error: 'Network Error'));

      await cubit.loadUserOrders();

      expect(cubit.state.isLoading, false);
      expect(cubit.state.error, 'Network Error');
      expect(cubit.state.orders, []);
    });
  });

  group('trackDriver', () {
    final driver = DriverEntity(id: 'd1', lat: 10.0, lng: 20.0);
    final driverStream = Stream.value(driver);

    test('emits driver when SuccessApiResult is returned', () async {
      when(
        () => mockTrackDriverUseCase.call('d1'),
      ).thenReturn(SuccessApiResult(data: driverStream));

      cubit.trackDriver('d1');

      final emittedState = await cubit.stream.first;
      expect(emittedState.driver, isNotNull);
      expect(emittedState.driver!.id, 'd1');
      expect(emittedState.driver!.lat, 10.0);
      expect(emittedState.driver!.lng, 20.0);
    });

    test('emits error if stream has error', () async {
      final errorStream = Stream<DriverEntity>.error('Driver not found');

      when(
        () => mockTrackDriverUseCase.call('d1'),
      ).thenReturn(SuccessApiResult(data: errorStream));

      cubit.trackDriver('d1');

      final emittedState = await cubit.stream.first;
      expect(emittedState.error, 'Driver not found');
    });
  });

  test('close cancels subscriptions', () async {
    final orderStream = Stream.value([
      OrderEntity(id: 'o1', userId: 'u1', status: 'delivered'),
    ]);
    final driverStream = Stream.value(DriverEntity(id: 'd1', lat: 10, lng: 20));

    when(() => mockAuthStorage.getToken()).thenAnswer((_) async => 'token');
    when(
      () => mockTrackOrderUseCase.call(any()),
    ).thenReturn(SuccessApiResult(data: orderStream));
    when(
      () => mockTrackDriverUseCase.call(any()),
    ).thenReturn(SuccessApiResult(data: driverStream));

    await cubit.loadUserOrders();
    cubit.trackDriver('d1');

    await cubit.close();
    expect(cubit.isClosed, true);
  });
}
