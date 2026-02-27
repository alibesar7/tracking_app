import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/models/request/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_response_model.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/usecase/apply_usecase.dart';

// Mock class
class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late ApplyUseCase applyUseCase;
  late MockAuthRepo mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    applyUseCase = ApplyUseCase(mockAuthRepo);
  });

  group('ApplyUseCase -', () {
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
      email: 'john@example.com',
      firstName: 'John',
      lastName: 'Doe',
    );

    setUpAll(() {
      registerFallbackValue(testApplyRequest);
    });

    test('should return SuccessApiResult when apply succeeds', () async {
      // Arrange
      when(
        () => mockAuthRepo.apply(any()),
      ).thenAnswer((_) async => SuccessApiResult(data: testApplyResponse));

      // Act
      final result = await applyUseCase(testApplyRequest);

      // Assert
      expect(result, isA<SuccessApiResult<ApplyResponseModel>>());
      expect((result as SuccessApiResult).data, testApplyResponse);
      verify(() => mockAuthRepo.apply(testApplyRequest)).called(1);
    });

    test('should return ErrorApiResult when apply fails', () async {
      // Arrange
      const errorMessage = 'Network error';
      when(
        () => mockAuthRepo.apply(any()),
      ).thenAnswer((_) async => ErrorApiResult(error: errorMessage));

      // Act
      final result = await applyUseCase(testApplyRequest);

      // Assert
      expect(result, isA<ErrorApiResult<ApplyResponseModel>>());
      expect((result as ErrorApiResult).error, errorMessage);
      verify(() => mockAuthRepo.apply(testApplyRequest)).called(1);
    });

    test(
      'should call repository apply method with correct parameters',
      () async {
        // Arrange
        when(
          () => mockAuthRepo.apply(any()),
        ).thenAnswer((_) async => SuccessApiResult(data: testApplyResponse));

        // Act
        await applyUseCase(testApplyRequest);

        // Assert
        final captured = verify(
          () => mockAuthRepo.apply(captureAny()),
        ).captured;
        expect(captured.length, 1);
        final capturedRequest = captured.first as ApplyRequestModel;
        expect(capturedRequest.email, testApplyRequest.email);
        expect(capturedRequest.firstName, testApplyRequest.firstName);
        expect(capturedRequest.lastName, testApplyRequest.lastName);
        expect(capturedRequest.phone, testApplyRequest.phone);
      },
    );
  });
}
