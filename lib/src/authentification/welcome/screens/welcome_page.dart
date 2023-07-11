import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/src/authentification/welcome/webservices/welcome_services.dart';
import 'package:my_project/data/models/ban_model/ban_model.dart';
import 'package:my_project/data/webservices/banned/check_ban.dart';
import 'package:my_project/src/authentification/verify_email/screens/verify_email.dart';

import 'package:my_project/src/authentification/welcome/screens/welcome_widget.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  UserBan userBan = UserBan();
  BanModel ban = BanModel();
  bool isBanned = false;

  WelcomeSerices services = WelcomeSerices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return FutureBuilder<DocumentSnapshot?>(
            future: services.getUser(
                isBanned: isBanned, ban: ban, userBan: userBan),
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
                return isBanned
                    ? _buildBannedWidget()
                    : _buildWelcomeWidget(snapshot);
              } else {
                return const WelcomeWidget();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildBannedWidget() {
    final banDuration = ban.duration;
    final now = DateTime.now().millisecondsSinceEpoch;
    final banDurationInMillis = banDuration?.millisecondsSinceEpoch ?? 0;
    final remainingDuration = Duration(milliseconds: banDurationInMillis - now);

    final remainingDays = remainingDuration.inDays;
    final remainingHours = remainingDuration.inHours.remainder(24);
    final remainingMinutes = remainingDuration.inMinutes.remainder(60);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You are banned',
            style: TextStyle(fontSize: 30, color: Colors.red),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Remaining Time: $remainingDays days, $remainingHours hours, $remainingMinutes minutes',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade900),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              FirebaseAuth.instance.authStateChanges().listen((User? user) {});
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Text(
                'I get it ',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeWidget(AsyncSnapshot<User?> snapshot) {
    if (snapshot.hasData) {
      return const VerifyEmailPage();
    } else {
      return const WelcomeWidget();
    }
  }
}
