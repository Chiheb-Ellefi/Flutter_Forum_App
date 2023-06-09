import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/presentation/pages/authentification/verifyEmail.dart';

import 'package:my_project/presentation/widgets/authentication/welcomeWidget.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error occurred ! '),
              );
            } else if (snapshot.hasData) {
              return const VerifyEmailPage();
            } else {
              return const WelcomeWidget();
            }
          }),
    );
  }
}
