import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/models/request/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_response_model.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_model.dart';
import 'package:tracking_app/features/auth/domain/entities/country_entity.dart';
import 'package:tracking_app/features/auth/domain/usecase/apply_usecase.dart';
import 'package:tracking_app/features/auth/domain/usecase/get_all_vehicles_usecase.dart';
import 'package:tracking_app/features/auth/domain/usecase/get_countries_usecase.dart';
import 'package:tracking_app/features/auth/presentation/apply/manager/apply_cubit.dart';
import 'package:tracking_app/features/auth/presentation/apply/manager/apply_intent.dart';
import 'package:tracking_app/features/auth/presentation/apply/manager/apply_state.dart';

// Mock classes
class MockGetCountriesUseCase extends Mock implements GetCountriesUseCase {}

class MockGetAllVehiclesUseCase extends Mock implements GetAllVehiclesUseCase {}

class MockApplyUseCase extends Mock implements ApplyUseCase {}

void main() {
  late ApplyCubit applyCubit;
  late MockGetCountriesUseCase mockGetCountriesUseCase;
  late MockGetAllVehiclesUseCase mockGetAllVehiclesUseCase;
  late MockApplyUseCase mockApplyUseCase;

  setUp(() {
    mockGetCountriesUseCase = MockGetCountriesUseCase();
    mockGetAllVehiclesUseCase = MockGetAllVehiclesUseCase();
    mockApplyUseCase = MockApplyUseCase();

    applyCubit = ApplyCubit(
      mockGetCountriesUseCase,
      mockGetAllVehiclesUseCase,
      mockApplyUseCase,
    );
  });

  tearDown(() {
    applyCubit.close();
  });

  group('ApplyCubit -', () {
    group('GetCountriesIntent', () {
      final testCountries = [
        const CountryEntity(
          name: 'Egypt',
          isoCode: 'EG',
          flag: '🇪🇬',
          phoneCode: '20',
        ),
        const CountryEntity(
          name: 'United States',
          isoCode: 'US',
          flag: '🇺🇸',
          phoneCode: '1',
        ),
      ];

      blocTest<ApplyCubit, ApplyState>(
        'emits [loading, success] when GetCountriesIntent succeeds',
        build: () {
          when(
            () => mockGetCountriesUseCase(),
          ).thenAnswer((_) async => SuccessApiResult(data: testCountries));
          return applyCubit;
        },
        act: (cubit) => cubit.onIntent(GetCountriesIntent()),
        expect: () => [
          const ApplyState(status: ApplyStatus.loading),
          ApplyState(status: ApplyStatus.success, countries: testCountries),
        ],
        verify: (_) {
          verify(() => mockGetCountriesUseCase()).called(1);
        },
      );

      blocTest<ApplyCubit, ApplyState>(
        'emits [loading, failure] when GetCountriesIntent fails',
        build: () {
          when(
            () => mockGetCountriesUseCase(),
          ).thenAnswer((_) async => ErrorApiResult(error: 'Network error'));
          return applyCubit;
        },
        act: (cubit) => cubit.onIntent(GetCountriesIntent()),
        expect: () => [
          const ApplyState(status: ApplyStatus.loading),
          const ApplyState(
            status: ApplyStatus.failure,
            errorMessage: 'Network error',
          ),
        ],
        verify: (_) {
          verify(() => mockGetCountriesUseCase()).called(1);
        },
      );
    });

    group('GetVehiclesIntent', () {
      final testVehicles = [
        VehicleModel(id: '1', type: 'Car'),
        VehicleModel(id: '2', type: 'Motorcycle'),
      ];

      blocTest<ApplyCubit, ApplyState>(
        'emits [loading, success] when GetVehiclesIntent succeeds',
        build: () {
          when(
            () => mockGetAllVehiclesUseCase(),
          ).thenAnswer((_) async => SuccessApiResult(data: testVehicles));
          return applyCubit;
        },
        act: (cubit) => cubit.onIntent(GetVehiclesIntent()),
        expect: () => [
          const ApplyState(vehiclesStatus: ApplyStatus.loading),
          ApplyState(
            vehiclesStatus: ApplyStatus.success,
            vehicles: testVehicles,
          ),
        ],
        verify: (_) {
          verify(() => mockGetAllVehiclesUseCase()).called(1);
        },
      );

      blocTest<ApplyCubit, ApplyState>(
        'emits [loading, failure] when GetVehiclesIntent fails',
        build: () {
          when(() => mockGetAllVehiclesUseCase()).thenAnswer(
            (_) async => ErrorApiResult(error: 'Failed to load vehicles'),
          );
          return applyCubit;
        },
        act: (cubit) => cubit.onIntent(GetVehiclesIntent()),
        expect: () => [
          const ApplyState(vehiclesStatus: ApplyStatus.loading),
          const ApplyState(
            vehiclesStatus: ApplyStatus.failure,
            vehiclesErrorMessage: 'Failed to load vehicles',
          ),
        ],
        verify: (_) {
          verify(() => mockGetAllVehiclesUseCase()).called(1);
        },
      );
    });

    group('SubmitApplyIntent', () {
      final testApplyRequest = ApplyRequestModel(
        country: 'EG',
        firstName: 'John',
        lastName: 'Doe',
        vehicleType: '1',
        vehicleNumber: 'ABC123',
        email: 'john@example.com',
        phone: '+201234567890',
        NID: '12345678901234',
        password: 'Password123!',
        rePassword: 'Password123!',
        gender: 'male',
        vehicleLicense: null,
        NIDimg: null,
      );

      final testApplyResponse = ApplyResponseModel(
        message: 'Application submitted successfully',
        token: 'test_token',
        id: '123',
      );

      setUpAll(() {
        registerFallbackValue(testApplyRequest);
      });

      blocTest<ApplyCubit, ApplyState>(
        'emits [loading, success] when SubmitApplyIntent succeeds',
        build: () {
          when(
            () => mockApplyUseCase(any()),
          ).thenAnswer((_) async => SuccessApiResult(data: testApplyResponse));
          return applyCubit;
        },
        act: (cubit) => cubit.onIntent(SubmitApplyIntent(testApplyRequest)),
        expect: () => [
          const ApplyState(applyStatus: ApplyStatus.loading),
          const ApplyState(applyStatus: ApplyStatus.success),
        ],
        verify: (_) {
          verify(() => mockApplyUseCase(testApplyRequest)).called(1);
        },
      );

      blocTest<ApplyCubit, ApplyState>(
        'emits [loading, failure] when SubmitApplyIntent fails',
        build: () {
          when(
            () => mockApplyUseCase(any()),
          ).thenAnswer((_) async => ErrorApiResult(error: 'Submission failed'));
          return applyCubit;
        },
        act: (cubit) => cubit.onIntent(SubmitApplyIntent(testApplyRequest)),
        expect: () => [
          const ApplyState(applyStatus: ApplyStatus.loading),
          const ApplyState(
            applyStatus: ApplyStatus.failure,
            applyErrorMessage: 'Submission failed',
          ),
        ],
        verify: (_) {
          verify(() => mockApplyUseCase(testApplyRequest)).called(1);
        },
      );
    });

    test('initial state is correct', () {
      expect(
        applyCubit.state,
        const ApplyState(
          status: ApplyStatus.initial,
          countries: [],
          vehiclesStatus: ApplyStatus.initial,
          vehicles: [],
          applyStatus: ApplyStatus.initial,
        ),
      );
    });
  });
}
