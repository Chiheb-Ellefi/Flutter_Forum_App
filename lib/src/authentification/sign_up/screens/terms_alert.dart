import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_project/src/authentification/sign_up/webservices/sign_up.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/constants/strings.dart';
import 'package:my_project/src/authentification/sign_in/components/sign_in_button.dart';
import 'package:my_project/src/authentification/verify_email/screens/verify_email.dart';
import 'package:my_project/src/notification/webservcies/firebase_notification_api.dart';

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
  FirebaseApi api = FirebaseApi();
  String? imageUrl;
  CollectionReference get users =>
      FirebaseFirestore.instance.collection(usersCollection);
  String? myPath;
  SignService service = SignService();

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
                  dynamic result = await service.registerUser(
                      context: context,
                      mail: widget.mail,
                      password: widget.password,
                      users: users,
                      myImage: widget.myImage,
                      myPath: myPath,
                      imageUrl: imageUrl,
                      userName: widget.userName,
                      phoneNumber: widget.phoneNumber,
                      dob: widget.dob);
                  await api.saveFcmToken();

                  if (result == null) {
                    print('error signing in');
                  }
                  print('signed in');
                  print(result);

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const VerifyEmailPage()));
                }))
      ],
    );
  }
}
