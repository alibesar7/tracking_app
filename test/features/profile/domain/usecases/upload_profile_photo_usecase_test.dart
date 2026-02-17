import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';
import 'package:tracking_app/features/profile/domain/repo/profile_repo.dart';
import 'package:tracking_app/features/profile/domain/usecases/upload_profile_photo_usecase.dart';

import 'upload_profile_photo_usecase_test.mocks.dart';

@GenerateMocks([ProfileRepo])
void main() {
  late MockProfileRepo mockRepo;
  late UploadProfilePhotoUseCase useCase;

  setUp(() {
    mockRepo = MockProfileRepo();
    useCase = UploadProfilePhotoUseCase(mockRepo);
    provideDummy<ApiResult<EditProfileResponse>>(
      SuccessApiResult(data: EditProfileResponse()),
    );
  });

  group("UploadProfilePhotoUseCase", () {
    final token = "test_token";
    final file = File('test_path');
    final fakeResponse = EditProfileResponse(
      message: 'Photo Uploaded',
      driver: DriverModel(
        firstName: 'test',
        lastName: 'test',
        email: 'test@test.com',
        photo: 'uploaded_photo.jpg',
      ),
    );

    test("returns SuccessApiResult when repo returns success", () async {
      when(
        mockRepo.uploadPhoto(
          token: anyNamed('token'),
          photo: anyNamed('photo'),
        ),
      ).thenAnswer(
        (_) async => SuccessApiResult<EditProfileResponse>(data: fakeResponse),
      );

      final result = await useCase.call(token: token, photo: file);

      expect(result, isA<SuccessApiResult<EditProfileResponse>>());
      final data = (result as SuccessApiResult).data;
      expect(data.message, fakeResponse.message);
      expect(data.driver?.photo, fakeResponse.driver?.photo);
      verify(mockRepo.uploadPhoto(token: token, photo: file)).called(1);
    });

    test("returns ErrorApiResult when repo returns error", () async {
      when(
        mockRepo.uploadPhoto(
          token: anyNamed('token'),
          photo: anyNamed('photo'),
        ),
      ).thenAnswer(
        (_) async =>
            ErrorApiResult<EditProfileResponse>(error: 'Upload failed'),
      );

      final result = await useCase.call(token: token, photo: file);

      expect(result, isA<ErrorApiResult<EditProfileResponse>>());
      final error = (result as ErrorApiResult).error;
      expect(error, 'Upload failed');
      verify(mockRepo.uploadPhoto(token: token, photo: file)).called(1);
    });
  });
}
