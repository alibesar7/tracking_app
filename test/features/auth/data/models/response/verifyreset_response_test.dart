import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/models/response/verifyreset_response.dart';

void main() {
  group("VerifyresetResponse", () {

    test("fromJson should parse correctly", () {
      // Arrange
      final json = {
        "status": "verified",
      };

      // Act
      final model = VerifyresetResponse.fromJson(json);

      // Assert
      expect(model.status, "verified");
    });

    test("toJson should return correct map", () {
      // Arrange
      final model = VerifyresetResponse(
        status: "verified",
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json["status"], "verified");
    });

    test("copyWith should override provided field", () {
      // Arrange
      final model = VerifyresetResponse(
        status: "pending",
      );

      // Act
      final updated = model.copyWith(
        status: "verified",
      );

      // Assert
      expect(updated.status, "verified");
    });

    test("should handle null values", () {
      final model = VerifyresetResponse();

      expect(model.status, null);

      final json = model.toJson();
      expect(json.containsKey("status"), true);
    });

  });
}
