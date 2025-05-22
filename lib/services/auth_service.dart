// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if email is verified
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  // Get sign-in methods for an email
  Future<List<String>> getSignInMethods(String email) async {
    try {
      return await _auth.fetchSignInMethodsForEmail(email);
    } catch (e) {
      print('Error checking sign-in methods: $e');
      return [];
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      print('Email verification error: $e');
      rethrow;
    }
  }

  // Sign up
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send verification email
      await userCredential.user?.sendEmailVerification();

      return userCredential;
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    }
  }

  // Sign in
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Password reset error: $e');
      rethrow;
    }
  }

  // Google sign-in
  Future<UserCredential?> signInWithGoogle() async {
    try {
      debugPrint('Starting Google sign-in process...');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        debugPrint('Google sign-in was canceled by user');
        return null;
      }

      debugPrint('Got Google user: ${googleUser.email}');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      debugPrint('Got Google auth tokens');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      debugPrint('Created Firebase credential');

      final userCredential = await _auth.signInWithCredential(credential);
      debugPrint(
        'Successfully signed in with Google: ${userCredential.user?.email}',
      );
      return userCredential;
    } catch (e, stackTrace) {
      debugPrint('Google sign-in error: $e');
      debugPrint('Stack trace: $stackTrace');
      if (e is FirebaseAuthException) {
        debugPrint('Firebase Auth Error Code: ${e.code}');
        debugPrint('Firebase Auth Error Message: ${e.message}');
      }
      rethrow;
    }
  }
}
