import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static final FirebaseAuth auth =
      FirebaseAuth.instance;

  static User? get currentUser =>
      auth.currentUser;

  static Future<UserCredential> signIn(
      String email,
      String password) {
    return auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential> register(
      String email,
      String password) {
    return auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> logout() async {
    await auth.signOut();
  }
}