import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/features/driver_orders_details/data/datasource/order_details_remote_datasource.dart';
import 'package:tracking_app/features/driver_orders_details/data/repos/order_details_repo_impl.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'order_details_repo_impl_test.mocks.dart';

@GenerateMocks([OrderDetailsRemoteDatasource, DocumentSnapshot])
void main() {
  late OrderDetailsRepoImpl repository;
  late MockOrderDetailsRemoteDatasource mockRemoteDataSource;
  late MockDocumentSnapshot mockSnapshot;

  setUp(() {
    mockRemoteDataSource = MockOrderDetailsRemoteDatasource();
    mockSnapshot = MockDocumentSnapshot();
    repository = OrderDetailsRepoImpl(mockRemoteDataSource);
  });

  const tOrderId = 'pxkMaEmWYVuvV5jkW0JK';

  final tOrderData = {
    'driverId': 'D123',
    'id': 'O456',
    'status': 'accepted',
    'totalPrice': '150.0',
    'userAddress ': {'address': 'Alex', 'name': 'Mariam'},
    'userId': 'U789',
  };

  group('getOrderDetails', () {
    test(
      'should emit OrderModel when the remote data source returns a valid DocumentSnapshot',
      () async {
        when(mockSnapshot.exists).thenReturn(true);
        when(mockSnapshot.data()).thenReturn(tOrderData);
        when(
          mockRemoteDataSource.getOrderStream(tOrderId),
        ).thenAnswer((_) => Stream.value(mockSnapshot));

        final result = repository.getOrderDetails(tOrderId);

        expect(
          result,
          emits(
            isA<OrderModel>()
                .having((o) => o.id, 'order id', 'O456')
                .having((o) => o.userAddress.name, 'user name', 'Mariam'),
          ),
        );
      },
    );

    test(
      'should throw an Exception when the document does not exist',
      () async {
        when(mockSnapshot.exists).thenReturn(false);
        when(
          mockRemoteDataSource.getOrderStream(tOrderId),
        ).thenAnswer((_) => Stream.value(mockSnapshot));

        final result = repository.getOrderDetails(tOrderId);

        expect(result, emitsError(isA<Exception>()));
      },
    );

    test(
      'should throw an Exception when data is null even if snapshot exists',
      () async {
        when(mockSnapshot.exists).thenReturn(true);
        when(mockSnapshot.data()).thenReturn(null);
        when(
          mockRemoteDataSource.getOrderStream(tOrderId),
        ).thenAnswer((_) => Stream.value(mockSnapshot));

        final result = repository.getOrderDetails(tOrderId);

        expect(result, emitsError(isA<Exception>()));
      },
    );
  });
}
