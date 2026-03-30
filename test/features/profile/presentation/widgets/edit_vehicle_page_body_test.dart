import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_intent.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_state.dart';
import 'package:tracking_app/features/profile/presentation/widgets/edit_vehicle_page_body.dart';
import 'package:tracking_app/features/profile/presentation/widgets/edit_vehicle_form.dart';

@GenerateMocks([ProfileCubit])
import 'edit_vehicle_page_body_test.mocks.dart';

void main() {
  group('EditVehiclePageBody Tests', () {
    late MockProfileCubit mockCubit;

    final fakeDriver = DriverModel(
      vehicleType: 'Car',
      vehicleNumber: '123456',
      vehicleLicense: 'some_license.png',
    );

    setUp(() {
      mockCubit = MockProfileCubit();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<ProfileCubit>.value(
          value: mockCubit,
          child: Scaffold(body: EditVehiclePageBody(driver: fakeDriver)),
        ),
      );
    }

    testWidgets('initializes form fields with driver data', (tester) async {
      when(mockCubit.state).thenReturn(ProfileState());
      when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Car'), findsOneWidget);
      expect(find.text('123456'), findsOneWidget);
      expect(find.text('some_license.png'), findsOneWidget);
    });

    testWidgets(
      'shows loading indicator on update button when state is loading',
      (tester) async {
        when(
          mockCubit.state,
        ).thenReturn(ProfileState(editProfileResource: Resource.loading()));
        when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('loading'), findsOneWidget);
      },
    );

    testWidgets('shows success snackbar when update is successful', (
      tester,
    ) async {
      final state1 = ProfileState();
      final state2 = ProfileState(editProfileResource: Resource.success(null));

      when(mockCubit.state).thenReturn(state1);
      when(mockCubit.stream).thenAnswer((_) => Stream.fromIterable([state2]));

      await tester.pumpWidget(createWidgetUnderTest());

      mockCubit.emit(state2);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Vehicle updated successfully'), findsOneWidget);
    });

    testWidgets(
      'calls PerformEditProfile intent when update button is pressed',
      (tester) async {
        when(mockCubit.state).thenReturn(ProfileState());
        when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

        await tester.pumpWidget(createWidgetUnderTest());

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        verify(
          mockCubit.doIntent(
            argThat(
              isA<PerformEditProfile>()
                  .having((i) => i.vehicleType, 'vehicleType', 'Car')
                  .having((i) => i.vehicleNumber, 'vehicleNumber', '123456')
                  .having(
                    (i) => i.vehicleLicense,
                    'vehicleLicense',
                    'some_license.png',
                  ),
            ),
          ),
        ).called(1);
      },
    );
  });
}
