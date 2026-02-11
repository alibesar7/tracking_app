import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';
import 'package:tracking_app/features/profile/domain/usecases/edit_profile_usecase.dart';
import 'package:tracking_app/features/profile/domain/usecases/upload_profile_photo_usecase.dart';
import 'profile_intent.dart';
import 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final EditProfileUseCase _editProfileUseCase;
  final UploadProfilePhotoUseCase _uploadPhotoUseCase;
  final AuthStorage _authStorage;

  ProfileCubit(
    this._editProfileUseCase,
    this._uploadPhotoUseCase,
    this._authStorage,
  ) : super(ProfileState());

  void doIntent(ProfileIntent intent) {
    switch (intent.runtimeType) {
      case PerformEditProfile:
        _editProfile(intent as PerformEditProfile);
        break;
      case SelectPhotoIntent:
        _selectPhoto(intent as SelectPhotoIntent);
        break;
      case UploadSelectedPhotoIntent:
        _uploadPhoto();
        break;
    }
  }

  Future<void> _editProfile(PerformEditProfile intent) async {
    emit(state.copyWith(editProfileResource: Resource.loading()));

    final token = await _authStorage.getToken();

    if (token == null || token.isEmpty) {
      emit(
        state.copyWith(editProfileResource: Resource.error("Token not found")),
      );
      return;
    }

    final result = await _editProfileUseCase.call(
      token: 'Bearer $token',
      firstName: intent.firstName,
      lastName: intent.lastName,
      email: intent.email,
      phone: intent.phone,
      vehicleType: intent.vehicleType,
      vehicleNumber: intent.vehicleNumber,
      vehicleLicense: intent.vehicleLicense,
    );

    if (isClosed) return;

    switch (result) {
      case SuccessApiResult<EditProfileResponse>():
        final updatedUser = result.data.driver;
        if (updatedUser != null) {
          await _authStorage.saveUser(
            DriverModel.fromEditProfileUser(updatedUser),
          );
        }

        emit(
          state.copyWith(editProfileResource: Resource.success(result.data)),
        );
        break;

      case ErrorApiResult<EditProfileResponse>():
        emit(state.copyWith(editProfileResource: Resource.error(result.error)));
        break;
    }
  }

  void _selectPhoto(SelectPhotoIntent intent) {
    emit(state.copyWith(selectedPhoto: intent.photo));
  }

  Future<void> _uploadPhoto() async {
    if (state.selectedPhoto == null) return;

    emit(state.copyWith(uploadPhotoResource: Resource.loading()));

    final token = await _authStorage.getToken();

    if (token == null || token.isEmpty) {
      emit(
        state.copyWith(uploadPhotoResource: Resource.error("Token not found")),
      );
      return;
    }

    final result = await _uploadPhotoUseCase.call(
      token: 'Bearer $token',
      photo: state.selectedPhoto!,
    );

    if (isClosed) return;

    switch (result) {
      case SuccessApiResult<EditProfileResponse>():
        final updatedUser = result.data.driver;
        if (updatedUser != null) {
          await _authStorage.saveUser(
            DriverModel.fromEditProfileUser(updatedUser),
          );
        }

        emit(
          state.copyWith(
            selectedPhoto: null,
            uploadPhotoResource: Resource.success(result.data),
          ),
        );
        break;

      case ErrorApiResult<EditProfileResponse>():
        emit(state.copyWith(uploadPhotoResource: Resource.error(result.error)));
        break;
    }
  }
}
