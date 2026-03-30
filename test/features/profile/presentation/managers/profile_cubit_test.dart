import 'dart:io';
import 'dart:convert';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';
import 'package:tracking_app/features/profile/domain/usecases/edit_profile_usecase.dart';
import 'package:tracking_app/features/profile/domain/usecases/upload_profile_photo_usecase.dart';
import 'package:tracking_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_intent.dart';
import 'package:tracking_app/features/profile/presentation/managers/profile_state.dart';

import 'profile_cubit_test.mocks.dart';

@GenerateMocks([
  EditProfileUseCase,
  UploadProfilePhotoUseCase,
  GetProfileUsecase,
  AuthStorage,
])
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

  late MockEditProfileUseCase mockEditProfileUseCase;
  late MockUploadProfilePhotoUseCase mockUploadPhotoUseCase;
  late MockGetProfileUsecase mockGetProfileUsecase;
  late MockAuthStorage mockAuthStorage;
  late ProfileCubit cubit;

  setUp(() {
    mockEditProfileUseCase = MockEditProfileUseCase();
    mockUploadPhotoUseCase = MockUploadProfilePhotoUseCase();
    mockGetProfileUsecase = MockGetProfileUsecase();
    mockAuthStorage = MockAuthStorage();
    when(mockAuthStorage.getUserJson()).thenAnswer((_) async => null);
    when(mockAuthStorage.getToken()).thenAnswer((_) async => 'test_token');
    when(
      mockGetProfileUsecase.call(token: anyNamed('token')),
    ).thenAnswer((_) async => SuccessApiResult(data: EditProfileResponse()));

    cubit = ProfileCubit(
      mockEditProfileUseCase,
      mockUploadPhotoUseCase,
      mockGetProfileUsecase,
      mockAuthStorage,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('GetProfileIntent', () {
    final token = 'test_token';
    final response = EditProfileResponse(
      message: 'Success',
      driver: DriverModel(firstName: 'Ali', lastName: 'Besar'),
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits loading then success when usecase returns SuccessApiResult',
      build: () {
        when(mockAuthStorage.getToken()).thenAnswer((_) async => token);
        when(
          mockGetProfileUsecase.call(token: 'Bearer $token'),
        ).thenAnswer((_) async => SuccessApiResult(data: response));
        when(mockAuthStorage.saveUserJson(any)).thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetProfileIntent()),
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.getProfileResource.status,
          'status',
          Status.loading,
        ),
        isA<ProfileState>()
            .having(
              (s) => s.getProfileResource.status,
              'status',
              Status.success,
            )
            .having((s) => s.driver?.firstName, 'firstName', 'Ali'),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits error when token is missing',
      build: () {
        when(mockAuthStorage.getToken()).thenAnswer((_) async => null);
        return cubit;
      },
      act: (cubit) => cubit.doIntent(GetProfileIntent()),
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.getProfileResource.status,
          'status',
          Status.loading,
        ),
        isA<ProfileState>().having(
          (s) => s.getProfileResource.error,
          'error',
          'Token not found',
        ),
      ],
    );
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
        when(mockAuthStorage.saveUserJson(any)).thenAnswer((_) async => {});
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
        verify(mockAuthStorage.getToken()).called(2);
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
        verify(mockAuthStorage.saveUserJson(any)).called(1);
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
      'uploads photo then edits profile when photo is present',
      build: () {
        when(mockAuthStorage.getToken()).thenAnswer((_) async => token);
        when(
          mockUploadPhotoUseCase.call(
            token: 'Bearer $token',
            photo: anyNamed('photo'),
          ),
        ).thenAnswer((_) async => SuccessApiResult(data: response));

        when(
          mockEditProfileUseCase.call(
            token: 'Bearer $token',
            firstName: 'Test',
            lastName: null,
            email: null,
            phone: null,
            vehicleType: null,
            vehicleNumber: null,
            vehicleLicense: null,
          ),
        ).thenAnswer((_) async => SuccessApiResult(data: response));
        when(mockAuthStorage.saveUserJson(any)).thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.doIntent(
        PerformEditProfile(firstName: 'Test', photo: File('test_photo')),
      ),
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
            .having((s) => s.selectedPhoto, 'selectedPhoto', isNull),
      ],
      verify: (_) {
        verify(
          mockUploadPhotoUseCase.call(
            token: 'Bearer $token',
            photo: anyNamed('photo'),
          ),
        ).called(1);
        verify(
          mockEditProfileUseCase.call(
            token: 'Bearer $token',
            firstName: 'Test',
            lastName: null,
            email: null,
            phone: null,
            vehicleType: null,
            vehicleNumber: null,
            vehicleLicense: null,
          ),
        ).called(1);
      },
    );
  });
}
