import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/models/response/forgetpassword_response.dart';

void main() {
  group("ForgetpasswordResponse", () {

    test("fromJson should parse correctly", () {
      // Arrange
      final json = {
        "message": "Reset email sent",
        "info": "Check your inbox",
      };

      // Act
      final model = ForgetpasswordResponse.fromJson(json);

      // Assert
      expect(model.message, "Reset email sent");
      expect(model.info, "Check your inbox");
    });

    test("toJson should return correct map", () {
      // Arrange
      final model = ForgetpasswordResponse(
        message: "Reset email sent",
        info: "Check your inbox",
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json["message"], "Reset email sent");
      expect(json["info"], "Check your inbox");
    });

    test("copyWith should override only provided fields", () {
      // Arrange
      final model = ForgetpasswordResponse(
        message: "Old message",
        info: "Old info",
      );

      // Act
      final updatedModel = model.copyWith(
        message: "New message",
      );

      // Assert
      expect(updatedModel.message, "New message");
      expect(updatedModel.info, "Old info"); // unchanged
    });

    test("should handle null values correctly", () {
      // Arrange
      final model = ForgetpasswordResponse();

      // Assert
      expect(model.message, null);
      expect(model.info, null);

      final json = model.toJson();
      expect(json.containsKey("message"), true);
      expect(json.containsKey("info"), true);
    });

  });
}
