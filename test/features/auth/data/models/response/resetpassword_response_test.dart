import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/models/response/resetpassword_response.dart';

void main() {
  group("ResetpasswordResponse", () {
    test("fromJson should parse correctly", () {
      // Arrange
      final json = {
        "message": "Password reset successful",
        "token": "abc123token",
      };

      // Act
      final model = ResetpasswordResponse.fromJson(json);

      // Assert
      expect(model.message, "Password reset successful");
      expect(model.token, "abc123token");
    });

    test("toJson should return correct map", () {
      // Arrange
      final model = ResetpasswordResponse(
        message: "Password reset successful",
        token: "abc123token",
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json["message"], "Password reset successful");
      expect(json["token"], "abc123token");
    });

    test("copyWith should override only provided fields", () {
      // Arrange
      final model = ResetpasswordResponse(
        message: "Old message",
        token: "oldToken",
      );

      // Act
      final updated = model.copyWith(message: "New message");

      // Assert
      expect(updated.message, "New message");
      expect(updated.token, "oldToken"); // unchanged
    });

    test("should handle null values", () {
      final model = ResetpasswordResponse();

      expect(model.message, null);
      expect(model.token, null);

      final json = model.toJson();
      expect(json.containsKey("message"), true);
      expect(json.containsKey("token"), true);
    });
  });
}
