import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/models/response/logout_response_dto/logout_response_dto.dart';

import 'package:tracking_app/features/auth/domain/usecase/logout_usecase.dart';
import 'package:tracking_app/features/auth/presentation/logout/manager/logout_state.dart';
import 'logout_intent.dart';

@injectable
class LogoutCubit extends Cubit<LogoutStates> {
  final LogoutUseCase _logoutUseCase;
  final AuthStorage _authStorage;

  LogoutCubit(this._logoutUseCase, this._authStorage) : super(LogoutStates());

  void doIntent(LogoutIntent intent) {
    switch (intent.runtimeType) {
      case PerformLogout:
        _performLogout();
        break;
    }
  }

  Future<void> _performLogout() async {
    emit(state.copyWith(logoutResource: Resource.loading()));
    final token = await _authStorage.getToken();
    if (token == null || token.isEmpty) {
      emit(state.copyWith(logoutResource: Resource.error("Token not found")));
      return;
    }
    final result = await _logoutUseCase.call('Bearer $token');
    switch (result) {
      case SuccessApiResult<LogoutResponseDto>():
        await _authStorage.clearAll();
        emit(state.copyWith(logoutResource: Resource.success(result.data)));
        break;
      case ErrorApiResult<LogoutResponseDto>():
        emit(state.copyWith(logoutResource: Resource.error(result.error)));
        break;
    }
  }
}
