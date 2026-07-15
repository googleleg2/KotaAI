import 'package:flutter/foundation.dart';

class NotificationController extends ChangeNotifier {
  bool _enabled = true;

  bool get enabled => _enabled;

  void enableNotifications() {
    _enabled = true;
    notifyListeners();
  }

  void disableNotifications() {
    _enabled = false;
    notifyListeners();
  }

  Future<void> sendPromotion({
    required String title,
    required String body,
  }) async {
    // TODO
    //
    // Firebase Messaging
    //
    // Cloud Functions
    //
    // Smart Discount Engine
  }
}