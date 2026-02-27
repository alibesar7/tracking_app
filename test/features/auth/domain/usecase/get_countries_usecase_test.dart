import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/domain/entities/country_entity.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/usecase/get_countries_usecase.dart';

// Mock class
class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late GetCountriesUseCase getCountriesUseCase;
  late MockAuthRepo mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    getCountriesUseCase = GetCountriesUseCase(mockAuthRepo);
  });

  group('GetCountriesUseCase -', () {
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
      const CountryEntity(
        name: 'United Kingdom',
        isoCode: 'GB',
        flag: '🇬🇧',
        phoneCode: '44',
      ),
    ];

    test('should return SuccessApiResult when getCountries succeeds', () async {
      // Arrange
      when(
        () => mockAuthRepo.getCountries(),
      ).thenAnswer((_) async => SuccessApiResult(data: testCountries));

      // Act
      final result = await getCountriesUseCase();

      // Assert
      expect(result, isA<SuccessApiResult<List<CountryEntity>>>());
      final successResult = result as SuccessApiResult<List<CountryEntity>>;
      expect(successResult.data, testCountries);
      expect(successResult.data.length, 3);
      expect(successResult.data.first.name, 'Egypt');
      verify(() => mockAuthRepo.getCountries()).called(1);
    });

    test('should return ErrorApiResult when getCountries fails', () async {
      // Arrange
      const errorMessage = 'Failed to fetch countries';
      when(
        () => mockAuthRepo.getCountries(),
      ).thenAnswer((_) async => ErrorApiResult(error: errorMessage));

      // Act
      final result = await getCountriesUseCase();

      // Assert
      expect(result, isA<ErrorApiResult<List<CountryEntity>>>());
      expect((result as ErrorApiResult).error, errorMessage);
      verify(() => mockAuthRepo.getCountries()).called(1);
    });

    test('should call repository getCountries method', () async {
      // Arrange
      when(
        () => mockAuthRepo.getCountries(),
      ).thenAnswer((_) async => SuccessApiResult(data: testCountries));

      // Act
      await getCountriesUseCase();

      // Assert
      verify(() => mockAuthRepo.getCountries()).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test('should return empty list when no countries available', () async {
      // Arrange
      when(
        () => mockAuthRepo.getCountries(),
      ).thenAnswer((_) async => SuccessApiResult(data: const []));

      // Act
      final result = await getCountriesUseCase();

      // Assert
      expect(result, isA<SuccessApiResult<List<CountryEntity>>>());
      expect((result as SuccessApiResult).data, isEmpty);
    });
  });
}
