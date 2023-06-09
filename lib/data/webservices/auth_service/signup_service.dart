// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:my_project/data/webservices/utils/Utils.dart';
import 'package:my_project/main.dart';

class SignUpService {
  Future<User?> signInWithEmailAndPassword(
      String mail, String password, BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: mail.trim(), password: password.trim());
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      print('Error signing in with email and password: $e');
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  /////////////////////////////////////////////////////////////////
  /* Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } catch (e) {
      print('Error registering with email and password: $e');
      return null;
    }
  } */
}
