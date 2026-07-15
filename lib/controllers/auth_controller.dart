import 'package:flutter/material.dart';

import '../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository =
      const AuthRepository();

  bool _loading = false;

  bool get loading => _loading;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    await _repository.login(
      email: email,
      password: password,
    );

    _setLoading(false);
  }

  Future<void> logout() async {
    await _repository.logout();
  }
}