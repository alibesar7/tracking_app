import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:tracking_app/features/auth/data/mappers/change_password_dto_mapper.dart';
import 'package:tracking_app/features/auth/data/models/change_password_dto.dart';
import 'package:tracking_app/features/auth/domain/models/change_password_model.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  AuthRemoteDatasource authDatasource;
  AuthRepoImpl(this.authDatasource);

  @override
  Future<ApiResult<ChangePasswordModel>> changePassword({
    String? password,
    String? newPassword,
  }) async {
    ApiResult<ChangePasswordDto> response = await authDatasource.changePassword(
      password: password,
      newPassword: newPassword,
    );
    switch (response) {
      case SuccessApiResult<ChangePasswordDto>():
        ChangePasswordDto dto = response.data;
        ChangePasswordModel changePassModel = dto.toChangePassModel();
        return SuccessApiResult<ChangePasswordModel>(data: changePassModel);
      case ErrorApiResult<ChangePasswordDto>():
        return ErrorApiResult<ChangePasswordModel>(error: response.error);
    }
  }
}
