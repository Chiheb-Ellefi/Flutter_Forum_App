import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/contant_values.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/constants/strings.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';
import 'package:my_project/main.dart';
import 'package:my_project/presentation/components/loginButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_project/presentation/pages/authentification/verifyEmail.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

// ignore: must_be_immutable
class TermsAlert extends StatefulWidget {
  TermsAlert(
      {super.key,
      required this.mail,
      required this.password,
      required this.phoneNumber,
      required this.dob,
      required this.userName,
      required this.myImage});
  String mail, password, phoneNumber, userName;
  File? myImage;
  DateTime? dob;

  @override
  State<TermsAlert> createState() => _TermsAlertState();
}

class _TermsAlertState extends State<TermsAlert> {
  String? imageUrl;
  CollectionReference get _users =>
      FirebaseFirestore.instance.collection(usersCollection);
  String? myPath;

  // ignore: body_might_complete_normally_nullable
  Future<UserCredential?> registerWithEmailAndPassword(
      String mail, String password, BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      UserCredential result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail.trim(),
        password: password.trim(),
      );
      if (widget.myImage != null) {
        String? imageName =
            widget.myImage != null ? path.basename(widget.myImage!.path) : null;
        myPath = 'files/profile_pic/$imageName';
        final ref = FirebaseStorage.instance.ref().child(myPath!);
        await ref.putFile(widget.myImage!);
        imageUrl = await ref.getDownloadURL();
      }
      UserModel userModel = UserModel(
          uid: result.user!.uid,
          username: widget.userName.trim(),
          email: result.user!.email ?? "No email",
          phoneNumber: widget.phoneNumber.trim(),
          dateOfBirth: widget.dob ?? DateTime.now(),
          profilePicture: imageUrl ?? avatarDefault,
          followers: [],
          following: [],
          topics: [],
          isAnonymous: false);
      await _users.doc(result.user!.uid).set(userModel.toMap());

      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      return result;
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Terms Of Use')),
      content: const SizedBox(
          height: 400,
          child: SingleChildScrollView(
            child: Text(
              termsOfUse,
              textAlign: TextAlign.justify,
            ),
          )),
      actions: [
        Center(
            child: MyButton(
                text: 'Accept',
                color: myBlue4,
                backColor: myBlue1,
                onPressed: () async {
                  dynamic result = await registerWithEmailAndPassword(
                      widget.mail, widget.password, context);

                  if (result == null) {
                    print('error signing in');
                  }
                  print('signed in');
                  print(result);

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VerifyEmailPage()));
                }))
      ],
    );
  }
}
