// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create user profile
  Future<void> createUserProfile(
    String uid,
    String firstName,
    String lastName,
    String email,
  ) async {
    try {
      debugPrint('Attempting to create user profile for uid: $uid');
      await _firestore.collection('users').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint('User profile created successfully for uid: $uid');
    } catch (e) {
      debugPrint('Error creating user profile for uid $uid: $e');
      rethrow;
    }
  }

  // Get user profile with retry logic
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    if (uid.isEmpty) {
      debugPrint('Empty uid provided to getUserProfile');
      return null;
    }

    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      try {
        debugPrint(
          'Attempting to get user profile for uid: $uid (attempt ${retryCount + 1})',
        );
        final doc = await _firestore.collection('users').doc(uid).get();

        if (doc.exists) {
          final data = doc.data();
          debugPrint('User profile retrieved successfully for uid: $uid');
          debugPrint('Profile data: $data');
          return data;
        } else {
          debugPrint('No user profile found for uid: $uid');
          return null;
        }
      } catch (e) {
        retryCount++;
        debugPrint(
          'Error getting user profile for uid $uid (attempt $retryCount): $e',
        );

        if (retryCount == maxRetries) {
          debugPrint('Max retries reached for uid $uid, returning null');
          return null;
        }

        debugPrint('Waiting ${retryDelay.inSeconds} seconds before retry...');
        await Future.delayed(retryDelay);
      }
    }
    return null;
  }

  // Update user profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      debugPrint('Attempting to update user profile for uid: $uid');
      await _firestore.collection('users').doc(uid).update(data);
      debugPrint('User profile updated successfully for uid: $uid');
    } catch (e) {
      debugPrint('Error updating user profile for uid $uid: $e');
      rethrow;
    }
  }
}
