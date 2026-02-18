import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';

void main() {
  group('OrderResponse', () {
    final tOrderResponse = OrderResponse(message: 'Success');

    test('should work with copyWith', () {
      final result = tOrderResponse.copyWith(message: 'New Success');
      expect(result.message, 'New Success');
    });

    test('fromJson should return a valid model', () {
      final Map<String, dynamic> jsonMap = {"message": "Success", "orders": []};
      final result = OrderResponse.fromJson(jsonMap);
      expect(result, isA<OrderResponse>());
      expect(result.message, "Success");
    });

    test('toJson should return a JSON map containing proper data', () {
      final result = tOrderResponse.toJson();
      final expectedMap = {
        "message": "Success",
        "metadata": null,
        "orders": null,
      };
      expect(result, expectedMap);
    });
  });
}
