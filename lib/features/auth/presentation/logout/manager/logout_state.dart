import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/auth/data/models/response/logout_response_dto/logout_response_dto.dart';

class LogoutStates {
  final Resource<LogoutResponseDto> logoutResource;

  LogoutStates({Resource<LogoutResponseDto>? logoutResource})
    : logoutResource = logoutResource ?? Resource.initial();

  LogoutStates copyWith({Resource<LogoutResponseDto>? logoutResource}) {
    return LogoutStates(logoutResource: logoutResource ?? this.logoutResource);
  }
}
