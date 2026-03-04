import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';
import 'package:tracking_app/features/profile/domain/repo/profile_repo.dart';
import 'package:tracking_app/features/profile/domain/usecases/edit_profile_usecase.dart';

import 'edit_profile_usecase_test.mocks.dart';

@GenerateMocks([ProfileRepo])
void main() {
  late MockProfileRepo mockRepo;
  late EditProfileUseCase useCase;

  setUp(() {
    mockRepo = MockProfileRepo();
    useCase = EditProfileUseCase(mockRepo);
    provideDummy<ApiResult<EditProfileResponse>>(
      SuccessApiResult(data: EditProfileResponse()),
    );
  });

  group("EditProfileUseCase", () {
    final fakeResponse = EditProfileResponse(
      message: 'Success',
      driver: DriverModel(
        firstName: 'test',
        lastName: 'test',
        email: 'test@test.com',
      ),
    );

    test("returns SuccessApiResult when repo returns success", () async {
      when(
        mockRepo.editProfile(
          token: anyNamed('token'),
          firstName: anyNamed('firstName'),
          lastName: anyNamed('lastName'),
          email: anyNamed('email'),
          phone: anyNamed('phone'),
          vehicleType: anyNamed('vehicleType'),
          vehicleNumber: anyNamed('vehicleNumber'),
          vehicleLicense: anyNamed('vehicleLicense'),
        ),
      ).thenAnswer(
        (_) async => SuccessApiResult<EditProfileResponse>(data: fakeResponse),
      );

      final result =
          await useCase.call(
                token: 'fake_token',
                firstName: 'test',
                lastName: 'test',
                email: 'test@test.com',
              )
              as SuccessApiResult<EditProfileResponse>;

      expect(result, isA<SuccessApiResult<EditProfileResponse>>());
      final data = (result as SuccessApiResult).data;
      expect(data.message, fakeResponse.message);
      expect(data.driver?.email, fakeResponse.driver?.email);
      verify(
        mockRepo.editProfile(
          token: 'fake_token',
          firstName: 'test',
          lastName: 'test',
          email: 'test@test.com',
        ),
      ).called(1);
    });

    test("returns ErrorApiResult when repo returns error", () async {
      when(
        mockRepo.editProfile(
          token: anyNamed('token'),
          firstName: anyNamed('firstName'),
          lastName: anyNamed('lastName'),
          email: anyNamed('email'),
          phone: anyNamed('phone'),
          vehicleType: anyNamed('vehicleType'),
          vehicleNumber: anyNamed('vehicleNumber'),
          vehicleLicense: anyNamed('vehicleLicense'),
        ),
      ).thenAnswer(
        (_) async =>
            ErrorApiResult<EditProfileResponse>(error: 'Update failed'),
      );

      final result =
          await useCase.call(
                token: 'fake_token',
                firstName: 'test',
                lastName: 'test',
                email: 'test@test.com',
              )
              as ErrorApiResult<EditProfileResponse>;

      expect(result, isA<ErrorApiResult<EditProfileResponse>>());
      final error = (result as ErrorApiResult).error;
      expect(error, 'Update failed');
      verify(
        mockRepo.editProfile(
          token: 'fake_token',
          firstName: 'test',
          lastName: 'test',
          email: 'test@test.com',
        ),
      ).called(1);
    });
  });
}
