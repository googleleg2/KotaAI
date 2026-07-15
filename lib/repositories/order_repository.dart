import '../models/order_model.dart';
import '../services/firestore_service.dart';

class OrderRepository {
  const OrderRepository();

  Future<void> placeOrder(
    OrderModel order,
  ) async {
    await FirestoreService.orders()
        .doc(order.id)
        .set(order.toMap());
  }

  Future<List<OrderModel>> getOrders(
    String userId,
  ) async {
    final snapshot =
        await FirestoreService.orders()
            .where(
              'userId',
              isEqualTo: userId,
            )
            .get();

    return snapshot.docs.map((doc) {
      return OrderModel.fromMap(
        doc.data() as Map<String, dynamic>,
      );
    }).toList();
  }
}