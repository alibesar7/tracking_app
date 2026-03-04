import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/app/core/api_manger/api_client.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/profile/api/profile_remote_datasource_imp.dart';
import 'package:tracking_app/features/profile/data/models/requests/edit_profile_request.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';

import 'profile_remote_datasource_imp_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient mockApiClient;
  late ProfileRemoteDatasourceImp dataSource;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = ProfileRemoteDatasourceImp(mockApiClient);
  });

  group('ProfileRemoteDatasourceImp.editProfile()', () {
    final token = "test_token";
    final request = EditProfileRequest(firstName: "Test");

    test(
      'returns SuccessApiResult<EditProfileResponse> when apiClient returns valid response',
      () async {
        // ARRANGE
        final fakeResponse = EditProfileResponse(message: "Success");
        final dioResponse = Response<EditProfileResponse>(
          requestOptions: RequestOptions(path: '/edit-profile'),
          data: fakeResponse,
          statusCode: 200,
        );
        final httpResponse = HttpResponse<EditProfileResponse>(
          fakeResponse,
          dioResponse,
        );

        when(
          mockApiClient.editProfile(
            token: anyNamed('token'),
            request: anyNamed('request'),
          ),
        ).thenAnswer((_) async => httpResponse);

        // ACT
        final result = await dataSource.editProfile(
          token: token,
          request: request,
        );

        // ASSERT
        expect(result, isA<SuccessApiResult<EditProfileResponse>>());
        final data = (result as SuccessApiResult).data;
        expect(data.message, "Success");
        verify(
          mockApiClient.editProfile(token: token, request: request),
        ).called(1);
      },
    );

    test('returns ErrorApiResult when apiClient throws Exception', () async {
      // ARRANGE
      when(
        mockApiClient.editProfile(
          token: anyNamed('token'),
          request: anyNamed('request'),
        ),
      ).thenThrow(Exception("network error"));

      // ACT
      final result = await dataSource.editProfile(
        token: token,
        request: request,
      );

      // ASSERT
      expect(result, isA<ErrorApiResult<EditProfileResponse>>());
      expect(
        (result as ErrorApiResult).error.toString(),
        contains("network error"),
      );
      verify(
        mockApiClient.editProfile(token: token, request: request),
      ).called(1);
    });
  });

  group('ProfileRemoteDatasourceImp.uploadPhoto()', () {
    final token = "test_token";
    final file = File('test_path');

    test(
      'returns SuccessApiResult<EditProfileResponse> when apiClient returns valid response',
      () async {
        // ARRANGE
        final fakeResponse = EditProfileResponse(message: "Photo Uploaded");
        final dioResponse = Response<EditProfileResponse>(
          requestOptions: RequestOptions(path: '/upload-photo'),
          data: fakeResponse,
          statusCode: 200,
        );
        final httpResponse = HttpResponse<EditProfileResponse>(
          fakeResponse,
          dioResponse,
        );

        when(
          mockApiClient.uploadPhoto(
            token: anyNamed('token'),
            photo: anyNamed('photo'),
          ),
        ).thenAnswer((_) async => httpResponse);

        // ACT
        final result = await dataSource.uploadPhoto(token: token, photo: file);

        // ASSERT
        expect(result, isA<SuccessApiResult<EditProfileResponse>>());
        final data = (result as SuccessApiResult).data;
        expect(data.message, "Photo Uploaded");
        verify(mockApiClient.uploadPhoto(token: token, photo: file)).called(1);
      },
    );

    test('returns ErrorApiResult when apiClient throws Exception', () async {
      // ARRANGE
      when(
        mockApiClient.uploadPhoto(
          token: anyNamed('token'),
          photo: anyNamed('photo'),
        ),
      ).thenThrow(Exception("network error"));

      // ACT
      final result = await dataSource.uploadPhoto(token: token, photo: file);

      // ASSERT
      expect(result, isA<ErrorApiResult<EditProfileResponse>>());
      expect(
        (result as ErrorApiResult).error.toString(),
        contains("network error"),
      );
      verify(mockApiClient.uploadPhoto(token: token, photo: file)).called(1);
    });
  });
}
