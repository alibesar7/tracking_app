import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';
import 'package:tracking_app/features/home/domain/repo/driverOrderRepo.dart';
import 'package:tracking_app/features/home/domain/usecase/getdriverOrderUsecase.dart';
import 'package:tracking_app/features/home/presentation/manger/driverorderCubit.dart';
import 'package:tracking_app/features/home/presentation/pages/driverOrderScreen.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverOrderItem.dart';

import 'driverOrderScreen_test.mocks.dart';

@GenerateMocks([DriverOrderRepo, AuthStorage])
void main() {
  late MockDriverOrderRepo mockDriverOrderRepo;
  late MockAuthStorage mockAuthStorage;
  late GetDriverOrdersUseCase getDriverOrdersUseCase;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() async {
    mockDriverOrderRepo = MockDriverOrderRepo();
    mockAuthStorage = MockAuthStorage();
    getDriverOrdersUseCase = GetDriverOrdersUseCase(mockDriverOrderRepo);

    provideDummy<ApiResult<OrderResponse>>(
      SuccessApiResult(data: OrderResponse()),
    );

    await GetIt.I.reset();
    GetIt.I.registerFactory<DriverOrderCubit>(
      () => DriverOrderCubit(getDriverOrdersUseCase, mockAuthStorage),
    );
  });

  Widget createWidgetUnderTest() {
    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MaterialApp(home: DriverOrderScreen()),
    );
  }

  group('DriverOrderScreen Integration Tests', () {
    testWidgets('displays CircularProgressIndicator when loading', (
      tester,
    ) async {
      // Arrange
      when(mockAuthStorage.getToken()).thenAnswer((_) async => 'token');

      when(mockDriverOrderRepo.getPendingOrders(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return SuccessApiResult(data: OrderResponse(orders: []));
      });

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('displays error message when error occurs', (tester) async {
      // Arrange
      const errorMessage = 'Network Error';
      when(mockAuthStorage.getToken()).thenAnswer((_) async => 'token');
      when(
        mockDriverOrderRepo.getPendingOrders(any),
      ).thenAnswer((_) async => ErrorApiResult(error: errorMessage));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('displays "noPendingOrders" when success but empty list', (
      tester,
    ) async {
      // Arrange
      when(mockAuthStorage.getToken()).thenAnswer((_) async => 'token');
      when(mockDriverOrderRepo.getPendingOrders(any)).thenAnswer(
        (_) async => SuccessApiResult(data: OrderResponse(orders: [])),
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('noPendingOrders'), findsOneWidget);
    });
  });
}
