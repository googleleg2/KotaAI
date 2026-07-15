import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthRepository {
  const AuthRepository();

  User? get currentUser => AuthService.currentUser;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return AuthService.signIn(
      email,
      password,
    );
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) {
    return AuthService.register(
      email,
      password,
    );
  }

  Future<void> logout() {
    return AuthService.logout();
  }
}