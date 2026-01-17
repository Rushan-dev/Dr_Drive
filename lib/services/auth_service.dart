import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Register with email and password
  Future<UserModel> register(
    String email,
    String password, 
    String name, 
    UserRole role,
  ) async {
    try {
      // Create user in Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user in Firestore
      final user = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name,
        role: role == UserRole.mod ? UserRole.user : role, // Default new mods to user until approved
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(user.toMap());
      
      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Get user data
  Stream<UserModel?> getUserData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return UserModel.fromMap(snapshot.data()!, snapshot.id);
    });
  }

  // Update user role (admin only)
  Future<void> updateUserRole(String userId, UserRole newRole) async {
    await _firestore.collection('users').doc(userId).update({
      'role': newRole.toString().split('.').last,
    });
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
