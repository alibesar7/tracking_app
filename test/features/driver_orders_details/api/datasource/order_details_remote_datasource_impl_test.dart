import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracking_app/features/driver_orders_details/api/datasource/order_details_remote_datasource_impl.dart';
import 'order_details_remote_datasource_impl_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
])
void main() {
  late OrderDetailsRemoteDatasourceImpl dataSource;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocument;
  late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshot;

  const String tOrderId = 'pxkMaEmWYVuvV5jkW0JK';
  const String tCollectionName = 'u8sj29sk2sff';

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocument = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();

    dataSource = OrderDetailsRemoteDatasourceImpl(firestore: mockFirestore);
  });

  test('return stream from documentSnapshot when call getOrderStream', () {
    when(mockFirestore.collection(tCollectionName)).thenReturn(mockCollection);
    when(mockCollection.doc(tOrderId)).thenReturn(mockDocument);
    when(
      mockDocument.snapshots(),
    ).thenAnswer((_) => Stream.value(mockSnapshot));

    final result = dataSource.getOrderStream(tOrderId);

    expect(result, emits(mockSnapshot));

    verify(mockFirestore.collection(tCollectionName)).called(1);
    verify(mockCollection.doc(tOrderId)).called(1);
  });
}
