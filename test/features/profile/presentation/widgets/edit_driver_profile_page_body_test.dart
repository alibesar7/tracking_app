import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_intent.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_state.dart';
import 'package:tracking_app/features/profile/presentation/widgets/edit_driver_profile_page_body.dart';

@GenerateMocks([ProfileCubit, AuthStorage])
import 'edit_driver_profile_page_body_test.mocks.dart';

void main() {
  group('EditDriverProfilePageBody Tests', () {
    late MockProfileCubit mockCubit;
    late MockAuthStorage mockAuthStorage;

    final fakeUser = DriverModel(
      firstName: 'Ali',
      lastName: 'Besar',
      email: 'ali@example.com',
      phone: '0123456789',
    );

    setUp(() {
      mockCubit = MockProfileCubit();
      mockAuthStorage = MockAuthStorage();

      if (!getIt.isRegistered<AuthStorage>()) {
        getIt.registerSingleton<AuthStorage>(mockAuthStorage);
      }
    });

    tearDown(() {
      if (getIt.isRegistered<AuthStorage>()) {
        getIt.unregister<AuthStorage>();
      }
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<ProfileCubit>.value(
          value: mockCubit,
          child: Scaffold(body: EditDriverProfilePageBody(user: fakeUser)),
        ),
      );
    }

    testWidgets('initializes form fields with user data', (tester) async {
      when(mockCubit.state).thenReturn(ProfileState());
      when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Ali'), findsOneWidget);
      expect(find.text('Besar'), findsOneWidget);
      expect(find.text('ali@example.com'), findsOneWidget);
      expect(find.text('0123456789'), findsOneWidget);
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

    testWidgets('shows success snackbar when profile update is successful', (
      tester,
    ) async {
      final state1 = ProfileState();
      final state2 = ProfileState(editProfileResource: Resource.success(null));

      when(mockCubit.state).thenReturn(state1);
      when(mockCubit.stream).thenAnswer((_) => Stream.fromIterable([state2]));

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Profile updated successfully'), findsOneWidget);
    });

    testWidgets(
      'calls PerformEditProfile intent when update button is pressed',
      (tester) async {
        when(mockCubit.state).thenReturn(ProfileState());
        when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
        when(mockAuthStorage.getToken()).thenAnswer((_) async => 'test_token');

        await tester.pumpWidget(createWidgetUnderTest());

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        verify(
          mockCubit.doIntent(
            argThat(
              isA<PerformEditProfile>()
                  .having((i) => i.firstName, 'firstName', 'Ali')
                  .having((i) => i.lastName, 'lastName', 'Besar')
                  .having((i) => i.email, 'email', 'ali@example.com')
                  .having((i) => i.phone, 'phone', '0123456789'),
            ),
          ),
        ).called(1);
      },
    );
  });
}
