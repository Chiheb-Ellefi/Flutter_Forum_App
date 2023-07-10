import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/ban_model/ban_model.dart';
import 'package:my_project/data/webservices/banned/check_ban.dart';
import 'package:my_project/presentation/pages/authentification/verifyEmail.dart';

import 'package:my_project/presentation/widgets/authentication/welcomeWidget.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  UserBan userBan = UserBan();
  BanModel ban = BanModel();
  bool isBanned = false;

  Future<void> checkBan() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot? snapshot = await userBan.isBanned(uid: uid);
    isBanned = snapshot == null ? false : true;
    if (isBanned && snapshot != null) {
      Map<String, dynamic> myData = snapshot.data() as Map<String, dynamic>;
      ban = BanModel.fromMap(myData);
      final banDuration = ban.duration;
      final now = DateTime.now().millisecondsSinceEpoch;
      final banDurationInMillis = banDuration?.millisecondsSinceEpoch ?? 0;
      final remainingDuration =
          Duration(milliseconds: banDurationInMillis - now);
      final hasBanEnded = remainingDuration <= Duration.zero;

      if (hasBanEnded) {
        await FirebaseFirestore.instance
            .collection(banCollection)
            .doc(uid)
            .delete();
        setState(() {});
      }
    }
  }

  Future<DocumentSnapshot?> getUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(uid)
          .get();
      if (snapshot.exists) {
        await checkBan(); // Call isUserBanned here
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
