class TrackOrderModel {
  final String driverId;
  final String id;
  final String status;
  final String totalPrice;
  final String userId;

  TrackOrderModel({
    required this.driverId,
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.userId,
  });

  factory TrackOrderModel.fromFirestore(String id, Map<String, dynamic> data) {
    String safeString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      return value.toString();
    }

    dynamic userAddress = data['userAddress'];
    String parsedUserId = '';
    if (userAddress is Map) {
      parsedUserId = safeString(userAddress['user_id']);
    } else {
      parsedUserId = safeString(data['userId']);
    }

    dynamic orderDt = data['oder_dt'];
    String parsedStatus = '';
    String parsedTotal = '';
    if (orderDt is Map) {
      parsedStatus = safeString(orderDt['status']);
      parsedTotal = safeString(orderDt['totalPrice']);
    } else {
      parsedStatus = safeString(data['status']);
      parsedTotal = safeString(data['totalPrice']);
    }

    return TrackOrderModel(
      id: id,
      driverId: safeString(data['driver_id'] ?? data['driverId']),
      status: parsedStatus,
      totalPrice: parsedTotal,
      userId: parsedUserId,
    );
  }
}
