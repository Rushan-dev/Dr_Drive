import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
        role: role == UserRole.mod
            ? UserRole.user
            : role, // Default new mods to user until approved
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
  Stream<UserModel?> getUserData(String? uid) {
    if (uid == null || uid.isEmpty) {
      return Stream.value(null);
    }
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

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Initialize Google Sign-In with web client ID for web platform
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            '902970483982-n2gjnh5oouofaegjmf5u97o7m6ll1ind.apps.googleusercontent.com',
        scopes: ['email', 'profile'],
      );

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Check if user document exists
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          // Create new user in Firestore if doesn't exist
          final newUser = UserModel(
            id: user.uid,
            email: user.email ?? '',
            name: user.displayName ?? user.email?.split('@')[0] ?? 'User',
            role: UserRole.user,
            createdAt: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(newUser.toMap());
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } on PlatformException catch (e) {
      print('Platform Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error during Google Sign-In: $e');
      rethrow;
    }
  }

  // Sign in anonymously as guest
  Future<UserCredential?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();

      // Create a guest user document
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'email': 'guest@example.com',
        'name': 'Guest User',
        'role': 'guest',
        'isGuest': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'admin-restricted-operation') {
        print(
          'Anonymous authentication is not enabled. Please enable it in Firebase Console.',
        );
        // You might want to show a user-friendly message or fallback to another auth method
        return null;
      } else {
        print('Firebase Auth Error (${e.code}): ${e.message}');
        rethrow;
      }
    } catch (e) {
      print('Unexpected error during anonymous sign-in: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
