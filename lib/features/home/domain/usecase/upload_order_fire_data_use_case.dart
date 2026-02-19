import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:injectable/injectable.dart' hide Order;
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';

@injectable
class UploadOrderFireDataUseCase {
  final FirebaseFirestore _firestore;

  UploadOrderFireDataUseCase(@Named('firestore') this._firestore);

  Future<void> call({required Order order, required String driverId}) async {
    final orderCollection = _firestore.collection('orders');

    final data = {
      'driver_id': driverId,
      'oder_dt': {
        'items':
            order.orderItems
                ?.map(
                  (e) => {
                    'productId': e.product?.id,
                    'title': e.product?.title,
                    'quantity': e.quantity,
                    'price': e.product?.price,
                    'image': e.product?.imgCover,
                  },
                )
                .toList() ??
            [],
        'orderId': order.id,
        'pickupAddress': {
          'address': order.store?.address ?? '',
          'name': order.store?.name ?? '',
        },
        'status': order.state ?? 'pending',
        'totalPrice': order.totalPrice ?? 0,
        'userAddress':
            '${order.shippingAddress?.street ?? ''}, ${order.shippingAddress?.city ?? ''}',
      },
      'userAddress': {
        'adress':
            '${order.shippingAddress?.street ?? ''}, ${order.shippingAddress?.city ?? ''}',
        'name': '${order.user?.firstName ?? ''} ${order.user?.lastName ?? ''}',
        'user_id': order.user?.id ?? '',
      },
      'user_id': order.user?.id ?? '',
    };

    if (order.id != null) {
      await orderCollection.doc(order.id).set(data, SetOptions(merge: true));
    } else {
      await orderCollection.add(data);
    }
  }
}
