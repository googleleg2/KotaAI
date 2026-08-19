import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _service = AuthService.instance;

  bool _loading = false;
  bool _isAdmin = false;

  bool get loading => _loading;

  User? get user => _service.currentUser;

  bool get loggedIn => _service.isLoggedIn;

  bool get isAdmin => _isAdmin;

  Stream<User?> get authState =>
      _service.authStateChanges;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);

      await _service.signIn(
        email: email,
        password: password,
      );

      _isAdmin = await _service.isAdmin();

      notifyListeners();

      return null;
    } on FirebaseAuthException catch (e) {
      _isAdmin = false;
      return e.message;
    } catch (_) {
      _isAdmin = false;
      return "Something went wrong.";
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // SIGNUP
  // ============================================================

  Future<String?> signup({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);

      await _service.signUp(
        email: email,
        password: password,
      );

      _isAdmin = false;

      notifyListeners();

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (_) {
      return "Something went wrong.";
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // REFRESH ROLE
  // ============================================================

  Future<void> refreshRole() async {
    if (!loggedIn) {
      _isAdmin = false;
      notifyListeners();
      return;
    }

    _isAdmin = await _service.isAdmin();

    notifyListeners();
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    _isAdmin = false;

    await _service.signOut();

    notifyListeners();
  }
}