import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // get instance of firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // sign in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, password) async {
    // try to sign user in
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
    // catch any errors
    on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // sign up
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, password) async {
    // try create user
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
    // catch any errors
    on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // sign out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
