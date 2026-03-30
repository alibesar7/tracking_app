import 'package:tracking_app/features/auth/data/model/response/change_password_dto.dart';
import 'package:tracking_app/features/auth/domain/models/change_password_model.dart';

extension ChangePasswordDtoMapper on ChangePasswordDto {
  ChangePasswordModel toChangePassModel() {
    return ChangePasswordModel(message: message, token: token, error: error);
  }
}
