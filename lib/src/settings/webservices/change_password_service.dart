import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';
import 'package:my_project/main.dart';

class ChangePasswordServie {
  changePassword({email, oldPass, newPass, context, currentUser}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    final cred = EmailAuthProvider.credential(email: email, password: oldPass);
    await currentUser!.reauthenticateWithCredential(cred).then(
      (value) {
        currentUser!.updatePassword(newPass);
      },
    ).catchError((err) {
      Utils.showSnackBar(err.toString());
    });
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
