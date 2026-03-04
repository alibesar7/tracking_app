import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_cubit.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_intent.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_state.dart';
import 'package:tracking_app/features/my_orders/presentation/pages/my_orders_page.dart';

class MockMyOrdersCubit extends MockCubit<MyOrdersState>
    implements MyOrdersCubit {}

void main() {
  late MockMyOrdersCubit mockCubit;
  late GetIt getIt;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    registerFallbackValue(GetMyOrdersIntent(page: 1, limit: 10));
  });

  setUp(() {
    getIt = GetIt.instance;
    mockCubit = MockMyOrdersCubit();

    if (getIt.isRegistered<MyOrdersCubit>()) {
      getIt.unregister<MyOrdersCubit>();
    }
    getIt.registerSingleton<MyOrdersCubit>(mockCubit);

    when(() => mockCubit.doIntent(any())).thenAnswer((_) async {});
    when(() => mockCubit.state).thenReturn(MyOrdersState());
  });

  tearDown(() {
    getIt.reset();
  });

  Widget createWidgetUnderTest() {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MaterialApp(home: MyOrdersPage()),
    );
  }

  testWidgets('MyOrdersPage renders correctly', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text("My orders"), findsOneWidget);
      expect(find.text("Recent orders"), findsOneWidget);
    });
  });
}
