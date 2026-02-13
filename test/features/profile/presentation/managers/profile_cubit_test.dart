import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';
import 'package:tracking_app/features/profile/domain/usecases/edit_profile_usecase.dart';
import 'package:tracking_app/features/profile/domain/usecases/upload_profile_photo_usecase.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_intent.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_state.dart';

import 'profile_cubit_test.mocks.dart';

@GenerateMocks([EditProfileUseCase, UploadProfilePhotoUseCase, AuthStorage])
void main() {
  late MockEditProfileUseCase mockEditProfileUseCase;
  late MockUploadProfilePhotoUseCase mockUploadProfilePhotoUseCase;
  late MockAuthStorage mockAuthStorage;
  late ProfileCubit cubit;

  setUp(() {
    mockEditProfileUseCase = MockEditProfileUseCase();
    mockUploadProfilePhotoUseCase = MockUploadProfilePhotoUseCase();
    mockAuthStorage = MockAuthStorage();
    cubit = ProfileCubit(
      mockEditProfileUseCase,
      mockUploadProfilePhotoUseCase,
      mockAuthStorage,
    );
    provideDummy<ApiResult<EditProfileResponse>>(
      SuccessApiResult(data: EditProfileResponse()),
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('PerformEditProfile Intent', () {
    final intent = PerformEditProfile(
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
    );
    final token = 'test_token';
    final response = EditProfileResponse(
      message: 'Success',
      driver: DriverModel(firstName: 'Test', lastName: 'User'),
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits loading then success when usecase returns SuccessApiResult',
      build: () {
        when(mockAuthStorage.getToken()).thenAnswer((_) async => token);
        when(
          mockEditProfileUseCase.call(
            token: 'Bearer $token',
            firstName: intent.firstName,
            lastName: intent.lastName,
            email: intent.email,
            phone: intent.phone,
            vehicleType: intent.vehicleType,
            vehicleNumber: intent.vehicleNumber,
            vehicleLicense: intent.vehicleLicense,
          ),
        ).thenAnswer((_) async => SuccessApiResult(data: response));
        when(mockAuthStorage.saveUser(any)).thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.doIntent(intent),
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.editProfileResource.status,
          'status',
          Status.loading,
        ),
        isA<ProfileState>()
            .having(
              (s) => s.editProfileResource.status,
              'status',
              Status.success,
            )
            .having((s) => s.editProfileResource.data, 'data', response),
      ],
      verify: (_) {
        verify(mockAuthStorage.getToken()).called(1);
        verify(
          mockEditProfileUseCase.call(
            token: 'Bearer $token',
            firstName: intent.firstName,
            lastName: intent.lastName,
            email: intent.email,
            phone: intent.phone,
            vehicleType: intent.vehicleType,
            vehicleNumber: intent.vehicleNumber,
            vehicleLicense: intent.vehicleLicense,
          ),
        ).called(1);
        verify(mockAuthStorage.saveUser(any)).called(1);
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits loading then error when usecase returns ErrorApiResult',
      build: () {
        when(mockAuthStorage.getToken()).thenAnswer((_) async => token);
        when(
          mockEditProfileUseCase.call(
            token: 'Bearer $token',
            firstName: intent.firstName,
            lastName: intent.lastName,
            email: intent.email,
            phone: intent.phone,
            vehicleType: intent.vehicleType,
            vehicleNumber: intent.vehicleNumber,
            vehicleLicense: intent.vehicleLicense,
          ),
        ).thenAnswer((_) async => ErrorApiResult(error: 'Update failed'));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(intent),
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.editProfileResource.status,
          'status',
          Status.loading,
        ),
        isA<ProfileState>()
            .having((s) => s.editProfileResource.status, 'status', Status.error)
            .having(
              (s) => s.editProfileResource.error,
              'error',
              'Update failed',
            ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits error when token is missing',
      build: () {
        when(mockAuthStorage.getToken()).thenAnswer((_) async => null);
        return cubit;
      },
      act: (cubit) => cubit.doIntent(intent),
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.editProfileResource.status,
          'status',
          Status.loading,
        ),
        isA<ProfileState>()
            .having((s) => s.editProfileResource.status, 'status', Status.error)
            .having(
              (s) => s.editProfileResource.error,
              'error',
              'Token not found',
            ),
      ],
    );
  });

  group('SelectPhotoIntent', () {
    final file = File('test_path');
    blocTest<ProfileCubit, ProfileState>(
      'updates selectedPhoto in state',
      build: () => cubit,
      act: (cubit) => cubit.doIntent(SelectPhotoIntent(file)),
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.selectedPhoto,
          'selectedPhoto',
          file,
        ),
      ],
    );
  });

  group('UploadSelectedPhotoIntent', () {
    final file = File('test_path');
    final token = 'test_token';
    final response = EditProfileResponse(
      message: 'Success',
      driver: DriverModel(photo: 'url'),
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits loading then success when photo is selected and upload succeeds',
      build: () {
        when(mockAuthStorage.getToken()).thenAnswer((_) async => token);
        when(
          mockUploadProfilePhotoUseCase.call(
            token: 'Bearer $token',
            photo: file,
          ),
        ).thenAnswer((_) async => SuccessApiResult(data: response));
        when(mockAuthStorage.saveUser(any)).thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) {
        cubit.doIntent(SelectPhotoIntent(file));
        cubit.doIntent(UploadSelectedPhotoIntent('dummy_token'));
      },
      skip: 1, // Skip the state emit from SelectPhotoIntent
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.uploadPhotoResource.status,
          'status',
          Status.loading,
        ),
        isA<ProfileState>()
            .having(
              (s) => s.uploadPhotoResource.status,
              'status',
              Status.success,
            )
            .having((s) => s.uploadPhotoResource.data, 'data', response)
            .having((s) => s.selectedPhoto, 'selectedPhoto', isNull),
      ],
      verify: (_) {
        verify(mockAuthStorage.getToken()).called(1);
        verify(
          mockUploadProfilePhotoUseCase.call(
            token: 'Bearer $token',
            photo: file,
          ),
        ).called(1);
        verify(mockAuthStorage.saveUser(any)).called(1);
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      'does nothing if no photo is selected',
      build: () => cubit,
      act: (cubit) => cubit.doIntent(UploadSelectedPhotoIntent('dummy')),
      expect: () => [],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits error if token is missing',
      build: () {
        when(mockAuthStorage.getToken()).thenAnswer((_) async => null);
        return cubit;
      },
      act: (cubit) {
        cubit.doIntent(SelectPhotoIntent(file));
        cubit.doIntent(UploadSelectedPhotoIntent('dummy'));
      },
      skip: 1,
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.uploadPhotoResource.status,
          'status',
          Status.loading,
        ),
        isA<ProfileState>().having(
          (s) => s.uploadPhotoResource.error,
          'error',
          'Token not found',
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits error when upload fails',
      build: () {
        when(mockAuthStorage.getToken()).thenAnswer((_) async => token);
        when(
          mockUploadProfilePhotoUseCase.call(
            token: 'Bearer $token',
            photo: file,
          ),
        ).thenAnswer((_) async => ErrorApiResult(error: 'Upload Failed'));
        return cubit;
      },
      act: (cubit) {
        cubit.doIntent(SelectPhotoIntent(file));
        cubit.doIntent(UploadSelectedPhotoIntent('dummy'));
      },
      skip: 1,
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.uploadPhotoResource.status,
          'status',
          Status.loading,
        ),
        isA<ProfileState>()
            .having((s) => s.uploadPhotoResource.status, 'status', Status.error)
            .having(
              (s) => s.uploadPhotoResource.error,
              'error',
              'Upload Failed',
            ),
      ],
    );
  });
}
