import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/profile/data/datasorce/profile_remote_datasource.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';
import 'package:tracking_app/features/profile/data/repo/profile_repo_imp.dart';

import 'profile_repo_imp_test.mocks.dart';

@GenerateMocks([ProfileRemoteDatasource])
void main() {
  late MockProfileRemoteDatasource mockDataSource;
  late ProfileRepoImpl repo;

  setUp(() {
    mockDataSource = MockProfileRemoteDatasource();
    repo = ProfileRepoImpl(mockDataSource);
    provideDummy<ApiResult<EditProfileResponse>>(
      SuccessApiResult(data: EditProfileResponse()),
    );
  });

  group('ProfileRepoImpl.editProfile()', () {
    final token = "test_token";
    final firstName = "Test";
    final lastName = "User";

    test(
      'returns SuccessApiResult when datasource returns SuccessApiResult',
      () async {
        // ARRANGE
        final fakeResponse = EditProfileResponse(message: "Success");
        when(
          mockDataSource.editProfile(
            token: anyNamed('token'),
            request: anyNamed('request'),
          ),
        ).thenAnswer((_) async => SuccessApiResult(data: fakeResponse));

        // ACT
        final result = await repo.editProfile(
          token: token,
          firstName: firstName,
          lastName: lastName,
        );

        // ASSERT
        expect(result, isA<SuccessApiResult<EditProfileResponse>>());
        final data = (result as SuccessApiResult).data;
        expect(data.message, "Success");
        verify(
          mockDataSource.editProfile(
            token: token,
            request: anyNamed('request'),
          ),
        ).called(1);
      },
    );

    test(
      'returns ErrorApiResult when datasource returns ErrorApiResult',
      () async {
        // ARRANGE
        when(
          mockDataSource.editProfile(
            token: anyNamed('token'),
            request: anyNamed('request'),
          ),
        ).thenAnswer((_) async => ErrorApiResult(error: "Network Error"));

        // ACT
        final result = await repo.editProfile(
          token: token,
          firstName: firstName,
          lastName: lastName,
        );

        // ASSERT
        expect(result, isA<ErrorApiResult<EditProfileResponse>>());
        expect((result as ErrorApiResult).error, "Network Error");
        verify(
          mockDataSource.editProfile(
            token: token,
            request: anyNamed('request'),
          ),
        ).called(1);
      },
    );
  });

  group('ProfileRepoImpl.uploadPhoto()', () {
    final token = "test_token";
    final file = File('test_path');

    test(
      'returns SuccessApiResult when datasource returns SuccessApiResult',
      () async {
        // ARRANGE
        final fakeResponse = EditProfileResponse(message: "Photo Uploaded");
        when(
          mockDataSource.uploadPhoto(
            token: anyNamed('token'),
            photo: anyNamed('photo'),
          ),
        ).thenAnswer((_) async => SuccessApiResult(data: fakeResponse));

        // ACT
        final result = await repo.uploadPhoto(token: token, photo: file);

        // ASSERT
        expect(result, isA<SuccessApiResult<EditProfileResponse>>());
        final data = (result as SuccessApiResult).data;
        expect(data.message, "Photo Uploaded");
        verify(mockDataSource.uploadPhoto(token: token, photo: file)).called(1);
      },
    );

    test(
      'returns ErrorApiResult when datasource returns ErrorApiResult',
      () async {
        // ARRANGE
        when(
          mockDataSource.uploadPhoto(
            token: anyNamed('token'),
            photo: anyNamed('photo'),
          ),
        ).thenAnswer((_) async => ErrorApiResult(error: "Upload Failed"));

        // ACT
        final result = await repo.uploadPhoto(token: token, photo: file);

        // ASSERT
        expect(result, isA<ErrorApiResult<EditProfileResponse>>());
        expect((result as ErrorApiResult).error, "Upload Failed");
        verify(mockDataSource.uploadPhoto(token: token, photo: file)).called(1);
      },
    );
  });
}
