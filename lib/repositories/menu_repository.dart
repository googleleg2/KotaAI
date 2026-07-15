import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ingredient.dart';
import '../services/firestore_service.dart';

class MenuRepository {
  const MenuRepository();

  Future<List<Ingredient>> loadMenu() async {
    final snapshot =
        await FirestoreService.menu().get();

    return snapshot.docs.map((doc) {
      return Ingredient.fromMap(
        doc.data() as Map<String, dynamic>,
      );
    }).toList();
  }
}