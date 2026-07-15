import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static CollectionReference users() =>
      db.collection('users');

  static CollectionReference menu() =>
      db.collection('menu');

  static CollectionReference orders() =>
      db.collection('orders');

  static CollectionReference discounts() =>
      db.collection('discounts');

  static CollectionReference notifications() =>
      db.collection('notifications');

  static CollectionReference analytics() =>
      db.collection('analytics');

  static CollectionReference settings() =>
      db.collection('settings');
}