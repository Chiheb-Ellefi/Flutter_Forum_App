import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/presentation/pages/authentification/verifyEmail.dart';

import 'package:my_project/presentation/widgets/authentication/welcomeWidget.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Future<DocumentSnapshot?> getUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(uid)
          .get();
      if (snapshot.exists) {
        return snapshot;
      } else {
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return FutureBuilder<DocumentSnapshot?>(
            future: getUser(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (userSnapshot.hasError) {
                return const Center(
                  child: Text('Error occurred!'),
                );
              } else if (userSnapshot.hasData) {
                if (snapshot.hasData) {
                  return const VerifyEmailPage();
                } else {
                  return const WelcomeWidget();
                }
              } else {
                return const WelcomeWidget();
              }
            },
          );
        },
      ),
    );
  }
}
