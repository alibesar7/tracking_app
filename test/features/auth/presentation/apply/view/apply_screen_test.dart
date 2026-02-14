// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:tracking_app/features/auth/data/models/request/apply_request_model.dart';
// import 'package:tracking_app/features/auth/domain/entities/country_entity.dart';
// import 'package:tracking_app/features/auth/presentation/apply/manager/apply_intent.dart';
// import 'package:tracking_app/features/auth/presentation/apply/manager/apply_state.dart';
// import 'package:tracking_app/features/auth/presentation/apply/view/apply_success_view.dart';

// void main() {
//   group('ApplySuccessScreen Widget Tests -', () {
//     testWidgets('should display success message', (tester) async {
//       // Act
//       await tester.pumpWidget(const MaterialApp(home: ApplySuccessScreen()));
//       await tester.pumpAndSettle();

//       // Assert
//       expect(find.text('Application Submitted!'), findsOneWidget);
//       expect(
//         find.text(
//           'Congratulations! Your application has been submitted successfully.',
//         ),
//         findsOneWidget,
//       );
//     });

//     testWidgets('should display back to login button', (tester) async {
//       // Act
//       await tester.pumpWidget(const MaterialApp(home: ApplySuccessScreen()));
//       await tester.pumpAndSettle();

//       // Assert
//       expect(find.text('Back to Login'), findsOneWidget);
//       expect(find.byType(ElevatedButton), findsOneWidget);
//     });

//     testWidgets('should display success icon', (tester) async {
//       // Act
//       await tester.pumpWidget(const MaterialApp(home: ApplySuccessScreen()));
//       await tester.pumpAndSettle();

//       // Assert - Check for circular container with success decoration
//       final container = tester.widget<Container>(
//         find
//             .descendant(
//               of: find.byType(Column).first,
//               matching: find.byType(Container),
//             )
//             .first,
//       );

//       final decoration = container.decoration as BoxDecoration?;
//       expect(decoration?.shape, BoxShape.circle);
//     });

//     testWidgets('should navigate when back button is tapped', (tester) async {
//       // Arrange
//       bool navigationCalled = false;

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: Builder(
//               builder: (context) {
//                 return ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ApplySuccessScreen(),
//                       ),
//                     ).then((_) => navigationCalled = true);
//                   },
//                   child: const Text('Go to Success'),
//                 );
//               },
//             ),
//           ),
//         ),
//       );

//       // Navigate to success screen
//       await tester.tap(find.text('Go to Success'));
//       await tester.pumpAndSettle();

//       // Verify we're on success screen
//       expect(find.text('Application Submitted!'), findsOneWidget);

//       // Tap back to login button
//       await tester.tap(find.text('Back to Login'));
//       await tester.pumpAndSettle();

//       // Assert - Should navigate back to first route
//       expect(find.text('Go to Success'), findsOneWidget);
//     });
//   });

//   group('ApplyState Tests -', () {
//     test('initial state should have correct default values', () {
//       // Act
//       const state = ApplyState();

//       // Assert
//       expect(state.status, ApplyStatus.initial);
//       expect(state.countries, isEmpty);
//       expect(state.errorMessage, isNull);
//       expect(state.vehiclesStatus, ApplyStatus.initial);
//       expect(state.vehicles, isEmpty);
//       expect(state.vehiclesErrorMessage, isNull);
//       expect(state.applyStatus, ApplyStatus.initial);
//       expect(state.applyErrorMessage, isNull);
//     });

//     test('copyWith should update only specified fields', () {
//       // Arrange
//       const initialState = ApplyState();
//       final countries = [
//         const CountryEntity(
//           name: 'Egypt',
//           isoCode: 'EG',
//           flag: '🇪🇬',
//           phoneCode: '20',
//         ),
//       ];

//       // Act
//       final newState = initialState.copyWith(
//         status: ApplyStatus.success,
//         countries: countries,
//       );

//       // Assert
//       expect(newState.status, ApplyStatus.success);
//       expect(newState.countries, countries);
//       expect(newState.vehiclesStatus, ApplyStatus.initial); // Unchanged
//       expect(newState.applyStatus, ApplyStatus.initial); // Unchanged
//     });

//     test('state should support equality comparison', () {
//       // Arrange
//       const state1 = ApplyState();
//       const state2 = ApplyState();

//       // Assert
//       expect(state1, equals(state2));
//     });

//     test('different states should not be equal', () {
//       // Arrange
//       const state1 = ApplyState(status: ApplyStatus.initial);
//       const state2 = ApplyState(status: ApplyStatus.loading);

//       // Assert
//       expect(state1, isNot(equals(state2)));
//     });
//   });

//   group('ApplyIntent Tests -', () {
//     test('GetCountriesIntent should be created', () {
//       // Act
//       final intent = GetCountriesIntent();

//       // Assert
//       expect(intent, isA<ApplyIntent>());
//       expect(intent, isA<GetCountriesIntent>());
//     });

//     test('GetVehiclesIntent should be created', () {
//       // Act
//       final intent = GetVehiclesIntent();

//       // Assert
//       expect(intent, isA<ApplyIntent>());
//       expect(intent, isA<GetVehiclesIntent>());
//     });

//     test('SubmitApplyIntent should be created with request model', () {
//       // Arrange
//       final requestModel = ApplyRequestModel(
//         country: 'EG',
//         firstName: 'John',
//         lastName: 'Doe',
//         vehicleType: '1',
//         vehicleNumber: 'ABC123',
//         email: 'john@example.com',
//         phone: '+201234567890',
//         NID: '12345678901234',
//         password: 'Password123!',
//         rePassword: 'Password123!',
//         gender: 'male',
//         vehicleLicense: null,
//         NIDimg: null,
//       );

//       // Act
//       final intent = SubmitApplyIntent(requestModel);

//       // Assert
//       expect(intent, isA<ApplyIntent>());
//       expect(intent, isA<SubmitApplyIntent>());
//       expect(intent.applyRequestModel, requestModel);
//     });
//   });
// }
