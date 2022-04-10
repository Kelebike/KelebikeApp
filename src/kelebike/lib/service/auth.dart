import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Using Stream to listen to Authentication State
  Stream<User?> get authStateChanges => _auth.idTokenChanges();

  //giriş yap fonksiyonu
  Future signIn(String email, String password) async {
    var user;
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  //forgot password
  @override
  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return "user-not-found";
    }
  }

  //çıkış yap fonksiyonu
  signOut() async {
    return await _auth.signOut();
  }

  //kayıt ol fonksiyonu
  Future createPerson(String email, String password) async {
    try {
      var user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firestore
          .collection("Person")
          .doc(user.user!.uid)
          .set({'email': email});
    } catch (e) {
      return "user-cannot-created";
    }

    User? _user = FirebaseAuth.instance.currentUser;

    if (!(_user!.emailVerified)) {
      await _user.sendEmailVerification();
    }
  }
}
