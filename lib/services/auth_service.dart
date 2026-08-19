import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth get auth => _auth;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => _auth.currentUser != null;

  // ============================================================
  // SIGN UP
  // ============================================================

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    final credential =
        await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;

    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'id': user.uid,
          'email': user.email,
          'role': 'customer',
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }

    return credential;
  }

  // ============================================================
  // SIGN IN
  // ============================================================

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // ============================================================
  // CHECK ADMIN ROLE
  // ============================================================

  Future<bool> isAdmin() async {
    final user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!snapshot.exists) {
        return false;
      }

      final data = snapshot.data();

      if (data == null) {
        return false;
      }

      return data['role']?.toString().toLowerCase() == 'admin';
    } catch (_) {
      return false;
    }
  }

  // ============================================================
  // GET USER ROLE
  // ============================================================

  Future<String> getUserRole() async {
    final user = _auth.currentUser;

    if (user == null) {
      return 'customer';
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      final data = snapshot.data();

      return data?['role']?.toString().toLowerCase() ??
          'customer';
    } catch (_) {
      return 'customer';
    }
  }

  // ============================================================
  // PASSWORD RESET
  // ============================================================

  Future<void> sendPasswordResetEmail(
    String email,
  ) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  // ============================================================
  // SIGN OUT
  // ============================================================

  Future<void> signOut() async {
    await _auth.signOut();
  }
}