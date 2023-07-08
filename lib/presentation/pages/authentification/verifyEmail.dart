import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';
import 'package:my_project/presentation/components/loginButton.dart';
import 'package:my_project/presentation/pages/authentification/LoginPage.dart';
import 'package:my_project/presentation/pages/homeScreen/homeScreen.dart';
import 'package:my_project/presentation/pages/authentification/welcome_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    isUserAnonymous = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;
    if (!isEmailVerified) {
      sendEmailVerification();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future sendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (!isUserAnonymous && user != null) {
        await user.sendEmailVerification();
        if (this.mounted) {
          setState(() => canResendEmail = false);
        }
        await Future.delayed(const Duration(seconds: 5));
        if (this.mounted) {
          setState(() => canResendEmail = true);
        }
      }
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  Future checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (!isUserAnonymous && user != null) {
      await user.reload();
      setState(() {
        isEmailVerified = user.emailVerified;
      });
      if (isEmailVerified) {
        timer?.cancel();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  bool isEmailVerified = false;
  bool isUserAnonymous = false;
  bool canResendEmail = false;
  Timer? timer;
  @override
  Widget build(BuildContext context) => isUserAnonymous
      ? const LoginPage()
      : isEmailVerified
          ? const HomeScreen()
          : Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                toolbarHeight: 100,
                title: const Text(
                  'Reset your password',
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Inter', fontSize: 25),
                ),
                leading: IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Welcome()),
                      (route) => false,
                    );
                  },
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'A verification email has been sent to your email ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontSize: 25),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyButton(
                          text: 'Resend Email',
                          color: myBlue1,
                          onPressed: () =>
                              canResendEmail ? sendEmailVerification : null,
                          backColor: myBlue1),
                      const SizedBox(
                        height: 20,
                      ),
                      MyButton(
                          text: 'Cancel',
                          color: myBlue2,
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Welcome()));
                          },
                          backColor: myBlue1)
                    ],
                  ),
                ),
              ),
            );
}
