import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_model.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/usecase/get_all_vehicles_usecase.dart';

// Mock class
class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late GetAllVehiclesUseCase getAllVehiclesUseCase;
  late MockAuthRepo mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    getAllVehiclesUseCase = GetAllVehiclesUseCase(mockAuthRepo);
  });

  group('GetAllVehiclesUseCase -', () {
    final testVehicles = [
      VehicleModel(id: '1', type: 'Car'),
      VehicleModel(id: '2', type: 'Motorcycle'),
      VehicleModel(id: '3', type: 'Bicycle'),
      VehicleModel(id: '4', type: 'Van'),
    ];

    test(
      'should return SuccessApiResult when getAllVehicles succeeds',
      () async {
        // Arrange
        when(
          () => mockAuthRepo.getAllVehicles(),
        ).thenAnswer((_) async => SuccessApiResult(data: testVehicles));

        // Act
        final result = await getAllVehiclesUseCase();

        // Assert
        expect(result, isA<SuccessApiResult<List<VehicleModel>>>());
        final successResult = result as SuccessApiResult<List<VehicleModel>>;
        expect(successResult.data, testVehicles);
        expect(successResult.data.length, 4);
        expect(successResult.data.first.type, 'Car');
        verify(() => mockAuthRepo.getAllVehicles()).called(1);
      },
    );

    test('should return ErrorApiResult when getAllVehicles fails', () async {
      // Arrange
      const errorMessage = 'Failed to load vehicles';
      when(
        () => mockAuthRepo.getAllVehicles(),
      ).thenAnswer((_) async => ErrorApiResult(error: errorMessage));

      // Act
      final result = await getAllVehiclesUseCase();

      // Assert
      expect(result, isA<ErrorApiResult<List<VehicleModel>>>());
      expect((result as ErrorApiResult).error, errorMessage);
      verify(() => mockAuthRepo.getAllVehicles()).called(1);
    });

    test('should call repository getAllVehicles method', () async {
      // Arrange
      when(
        () => mockAuthRepo.getAllVehicles(),
      ).thenAnswer((_) async => SuccessApiResult(data: testVehicles));

      // Act
      await getAllVehiclesUseCase();

      // Assert
      verify(() => mockAuthRepo.getAllVehicles()).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    });

    test('should return empty list when no vehicles available', () async {
      // Arrange
      when(
        () => mockAuthRepo.getAllVehicles(),
      ).thenAnswer((_) async => SuccessApiResult(data: const []));

      // Act
      final result = await getAllVehiclesUseCase();

      // Assert
      expect(result, isA<SuccessApiResult<List<VehicleModel>>>());
      expect((result as SuccessApiResult).data, isEmpty);
    });

    test('should handle vehicles with null ids', () async {
      // Arrange
      final vehiclesWithNullId = [
        VehicleModel(id: null, type: 'Car'),
        VehicleModel(id: '2', type: 'Motorcycle'),
      ];
      when(
        () => mockAuthRepo.getAllVehicles(),
      ).thenAnswer((_) async => SuccessApiResult(data: vehiclesWithNullId));

      // Act
      final result = await getAllVehiclesUseCase();

      // Assert
      expect(result, isA<SuccessApiResult<List<VehicleModel>>>());
      final successResult = result as SuccessApiResult<List<VehicleModel>>;
      expect(successResult.data.first.id, isNull);
      expect(successResult.data.last.id, '2');
    });
  });
}
