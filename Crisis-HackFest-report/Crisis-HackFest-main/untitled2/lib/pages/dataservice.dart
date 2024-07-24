import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> createUser(String name, String email, String pno,
      String password, bool enter) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        enter = true;
        // Update the display name
        await user.updateDisplayName('volunteer');
        String userId = user.uid;
        await _firestore.collection("users").doc(userId).set({
          "name": name,
          "email": email,
          "pno": pno,
        });

        print('User created successfully with UID: $userId');
        return null; // No error
      } else {
        enter = false;
        print('User creation failed');
        return 'User creation failed';
      }
    } catch (e) {
      enter = false;
      String errorMessage;

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage =
            'The email address is already in use by another account.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          default:
            errorMessage = 'An unexpected error occurred.';
        }
      } else {
        errorMessage = 'An unexpected error occurred.';
      }

      print('Error creating user: $errorMessage');
      return errorMessage;
    }
  }

  Future<String?> createVictim(String name, String email, String pno,
      String password,bool enter) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Update the display name
        await user.updateDisplayName('victim');
        String userId = user.uid;
        await _firestore.collection("users-victim").doc(userId).set({
          "name": name,
          "email": email,
          "pno": pno,
        });

        print('User created successfully with UID: $userId');
        return null; // No error
      } else {
        print('User creation failed');
        return 'User creation failed';
      }
    } catch (e) {
      String errorMessage;

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage =
            'The email address is already in use by another account.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          default:
            errorMessage = 'An unexpected error occurred.';
        }
      } else {
        errorMessage = 'An unexpected error occurred.';
      }

      print('Error creating user: $errorMessage');
      return errorMessage;
    }
  }
}
