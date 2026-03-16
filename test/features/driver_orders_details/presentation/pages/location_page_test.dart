import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/drivers_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/location_type.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/manager/order_details_cubit.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/manager/order_details_states.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/pages/location_page.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/widgets/address_card.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/widgets/section_title.dart';

import 'drivers_orders_details_page_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockOrderDetailsCubit mockCubit;
  final driverData = DriverDataModel(
    deviceToken: '',
    currentLocation: DriverLocationModel(lat: 30.0, lng: 31.0),
    id: '',
    name: '',
    phone: '',
  );
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
              child: const LocationPage(locationType: LocationType.pickup),
            ),
          );
        },
      ),
    );
  }

  group('Location Page widget test', () {
    testWidgets('LocationPage shows loading indicator when driver is null', (
      WidgetTester tester,
    ) async {
      when(
        mockCubit.state,
      ).thenReturn(OrderDetailsStates(driverData: Resource.loading()));
      when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(OrderDetailsStates(driverData: Resource.loading())),
      );

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    testWidgets('Full LocationPage interaction and listener coverage', (
      tester,
    ) async {
      final orderData = OrderModel(
        userAddress: UserAddressModel(name: '', address: '', userId: ''),
        orderId: '',
        driverId: '',
        userId: '',
        orderDetails: OrderDetailsModel(
          items: [],
          status: '',
          totalPrice: 500,
          pickupAddress: PickedAddressModel(name: '', address: ''),
          orderId: '',
          userAddress: '',
        ),
      );

      final fullState = OrderDetailsStates(
        driverData: Resource.success(driverData),
        data: Resource.success(orderData),
        polylines: [LatLng(30.0, 31.0), LatLng(30.1, 31.1)],
        destination: LatLng(30.1, 31.1),
      );

      when(mockCubit.state).thenReturn(fullState);
      when(mockCubit.stream).thenAnswer((_) => Stream.value(fullState));
      when(
        mockCubit.setDestinationFromAddress(any, any),
      ).thenAnswer((_) async {});
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final map = tester.widget<GoogleMap>(find.byType(GoogleMap));
      expect(map.mapType, MapType.normal);
      expect(map.initialCameraPosition.zoom, 18);

      expect(fullState.polylines, isNotEmpty);
      expect(fullState.destination, isNotNull);

      verify(mockCubit.setDestinationFromAddress(any, any)).called(1);
    });

    testWidgets('LocationPage shows GoogleMap when driver exists', (
      WidgetTester tester,
    ) async {
      when(mockCubit.state).thenReturn(
        OrderDetailsStates(driverData: Resource.success(driverData)),
      );
      when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(
          OrderDetailsStates(
            driverData: Resource.success(driverData),
            data: Resource.success(null),
          ),
        ),
      );

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(GoogleMap), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(Expanded),
          matching: find.byType(GoogleMap),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(Stack),
          matching: find.byType(GoogleMap),
        ),
        findsOneWidget,
      );
      expect(find.byType(Positioned), findsWidgets);
      expect(find.byType(InkWell), findsAtLeast(1));
      expect(find.byType(CircleAvatar), findsNWidgets(3));
      expect(find.byType(AddressCard), findsWidgets);
      expect(
        find.descendant(
          of: find.byType(Column),
          matching: find.byType(AddressCard),
        ),
        findsWidgets,
      );
      expect(find.byType(SectionTitle), findsWidgets);
      expect(
        find.descendant(
          of: find.byType(Column),
          matching: find.byType(SectionTitle),
        ),
        findsWidgets,
      );
    });

    testWidgets('Back button is displayed', (WidgetTester tester) async {
      when(mockCubit.state).thenReturn(
        OrderDetailsStates(driverData: Resource.success(driverData)),
      );
      when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(
          OrderDetailsStates(driverData: Resource.success(driverData)),
        ),
      );

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
      await tester.pump();
    });
  });
}
