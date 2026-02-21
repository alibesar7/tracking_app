import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/manager/order_details_cubit.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/manager/order_details_states.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/pages/drivers_orders_details_page.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/widgets/address_card.dart';
import 'drivers_orders_details_page_test.mocks.dart';

@GenerateMocks([OrderDetailsCubit])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockOrderDetailsCubit mockCubit;

  setUp(() async {
    await getIt.reset();
    mockCubit = MockOrderDetailsCubit();
    getIt.registerFactory<OrderDetailsCubit>(() => mockCubit);
    when(mockCubit.state).thenReturn(OrderDetailsStates());
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget buildTestableWidget() {
    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      saveLocale: false,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            home: BlocProvider<OrderDetailsCubit>.value(
              value: mockCubit,
              child: const DriversOrdersDetailsPage(),
            ),
          );
        },
      ),
    );
  }

  final tOrderModel = OrderModel(
    driverId: 'D1',
    userAddress: UserAddressModel(address: 'Shebin', name: 'Ali', userId: 'U1'),
    userId: 'U1',
    orderId: 'N123',
    orderDetails: OrderDetailsModel(
      items: [],
      status: 'accepted',
      totalPrice: 500,
      pickupAddress: PickedAddressModel(name: 'Pharmacy', address: 'Downtown'),
      orderId: 'N123',
      userAddress: 'Shebin',
    ),
  );

  group('DriversOrdersDetailsPage Widget Tests', () {
    testWidgets('should show CircularProgressIndicator when state is loading', (
      tester,
    ) async {
      when(
        mockCubit.state,
      ).thenReturn(OrderDetailsStates(data: Resource.loading()));
      when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(OrderDetailsStates(data: Resource.loading())),
      );

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
      'should display order details correctly when state is success',
      (tester) async {
        when(
          mockCubit.state,
        ).thenReturn(OrderDetailsStates(data: Resource.success(tOrderModel)));
        when(mockCubit.stream).thenAnswer(
          (_) => Stream.value(
            OrderDetailsStates(data: Resource.success(tOrderModel)),
          ),
        );

        await tester.pumpWidget(buildTestableWidget());
        await tester.pump();

        expect(find.textContaining('N123'), findsOneWidget);
        expect(find.text('Ali'), findsOneWidget);
        expect(find.text('Shebin'), findsAtLeastNWidgets(1));
        expect(find.textContaining('500'), findsOneWidget);
        expect(find.byType(AddressCard), findsAtLeastNWidgets(2));
      },
    );

    testWidgets('should display error message when state is error', (
      tester,
    ) async {
      const errorMessage = 'Failed to load order';
      when(
        mockCubit.state,
      ).thenReturn(OrderDetailsStates(data: Resource.error(errorMessage)));
      when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(
          OrderDetailsStates(data: Resource.error(errorMessage)),
        ),
      );

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
