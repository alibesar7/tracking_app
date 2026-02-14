import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/mappers/change_password_dto_mapper.dart';
import 'package:tracking_app/features/auth/data/model/response/change_password_dto.dart';
import 'package:tracking_app/features/auth/domain/models/change_password_model.dart';

void main() {
  group('ChangePasswordDtoMapper', () {
    test('should map ChangePasswordDto to ChangePasswordModel correctly', () {
      final dto = ChangePasswordDto(
        message: 'change pass successfully',
        error: 'error',
        token: '',
      );

      final result = dto.toChangePassModel();

      expect(result, isA<ChangePasswordModel>());
      expect(result.message, 'change pass successfully');
      expect(result.error, dto.error);
    });
  });
}
