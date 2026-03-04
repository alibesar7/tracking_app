import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/profile/data/datasorce/profile_lacal_datasource.dart';
import 'package:tracking_app/features/profile/data/datasorce/profile_remote_datasource.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';
import 'package:tracking_app/features/profile/data/repo/profile_repo_imp.dart';

import 'profile_repo_imp_test.mocks.dart';

@GenerateMocks([ProfileRemoteDatasource, ProfileLocalDataSource])
void main() {
  provideDummy<SuccessApiResult<EditProfileResponse>>(
    SuccessApiResult(data: EditProfileResponse()),
  );
  provideDummy<ErrorApiResult<EditProfileResponse>>(
    ErrorApiResult(error: 'dummy error'),
  );
  provideDummy<ApiResult<EditProfileResponse>>(
    SuccessApiResult(data: EditProfileResponse()),
  );
  provideDummy<File>(File('dummy_path'));

  late MockProfileRemoteDatasource mockRemote;
  late MockProfileLocalDataSource mockLocal;
  late ProfileRepoImpl repo;

  setUp(() {
    mockRemote = MockProfileRemoteDatasource();
    mockLocal = MockProfileLocalDataSource();
    repo = ProfileRepoImpl(mockRemote, mockLocal);
  });

  group('ProfileRepoImpl.editProfile()', () {
    final token = "test_token";
    final firstName = "Test";
    final lastName = "User";

    test(
      'returns SuccessApiResult when datasource returns SuccessApiResult',
      () async {
        final fakeResponse = EditProfileResponse(message: "Success");
        when(
          mockRemote.editProfile(
            token: anyNamed('token'),
            request: anyNamed('request'),
          ),
        ).thenAnswer((_) async => SuccessApiResult(data: fakeResponse));

        final result = await repo.editProfile(
          token: token,
          firstName: firstName,
          lastName: lastName,
        );

        expect(result, isA<SuccessApiResult<EditProfileResponse>>());
        final data = (result as SuccessApiResult).data;
        expect(data.message, "Success");

        verify(
          mockRemote.editProfile(token: token, request: anyNamed('request')),
        ).called(1);
        verify(mockLocal.saveUser(any)).called(1);
      },
    );

    test(
      'returns ErrorApiResult when datasource returns ErrorApiResult',
      () async {
        when(
          mockRemote.editProfile(
            token: anyNamed('token'),
            request: anyNamed('request'),
          ),
        ).thenAnswer((_) async => ErrorApiResult(error: "Network Error"));

        final result = await repo.editProfile(
          token: token,
          firstName: firstName,
          lastName: lastName,
        );

        expect(result, isA<ErrorApiResult<EditProfileResponse>>());
        expect((result as ErrorApiResult).error, "Network Error");

        verify(
          mockRemote.editProfile(token: token, request: anyNamed('request')),
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
        final fakeResponse = EditProfileResponse(message: "Photo Uploaded");
        when(
          mockRemote.uploadPhoto(
            token: anyNamed('token'),
            photo: anyNamed('photo'),
          ),
        ).thenAnswer((_) async => SuccessApiResult(data: fakeResponse));

        final result = await repo.uploadPhoto(token: token, photo: file);

        expect(result, isA<SuccessApiResult<EditProfileResponse>>());
        final data = (result as SuccessApiResult).data;
        expect(data.message, "Photo Uploaded");

        verify(mockRemote.uploadPhoto(token: token, photo: file)).called(1);
        verify(mockLocal.saveUser(any)).called(1);
      },
    );

    test(
      'returns ErrorApiResult when datasource returns ErrorApiResult',
      () async {
        when(
          mockRemote.uploadPhoto(
            token: anyNamed('token'),
            photo: anyNamed('photo'),
          ),
        ).thenAnswer((_) async => ErrorApiResult(error: "Upload Failed"));

        final result = await repo.uploadPhoto(token: token, photo: file);

        expect(result, isA<ErrorApiResult<EditProfileResponse>>());
        expect((result as ErrorApiResult).error, "Upload Failed");

        verify(mockRemote.uploadPhoto(token: token, photo: file)).called(1);
      },
    );
  });
}
