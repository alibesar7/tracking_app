import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:tracking_app/features/auth/data/models/request/forget_password_request.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/data/models/response/forgetpassword_response.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  AuthRemoteDatasource remoteDatasource;
  AuthRepoImpl(this.remoteDatasource);

  @override
  Future<void> forgetPassword(String email) async {
    final result = await remoteDatasource.forgetPassword(
      ForgetPasswordRequest(email: email),
    );
  }

  @override
  Future<void> verifyResetCode(String code) {
    // TODO: implement verifyResetCode
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }
}
