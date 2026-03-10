sealed class OrderDetailsIntent {}

class GetOrderDetails extends OrderDetailsIntent {}

class UpdateOrderState extends OrderDetailsIntent {
  final String currentStatus;
  UpdateOrderState(this.currentStatus);
}
