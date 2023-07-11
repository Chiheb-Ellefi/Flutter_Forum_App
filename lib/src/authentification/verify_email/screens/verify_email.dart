import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/src/authentification/verify_email/webservices/verifying_service.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/src/authentification/sign_in/components/sign_in_button.dart';
import 'package:my_project/src/authentification/sign_in/screens/login_screen.dart';
import 'package:my_project/src/home/screens/home_screen.dart';
import 'package:my_project/src/authentification/welcome/screens/welcome_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  VerifyEmailService verifyEmail = VerifyEmailService();
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    isUserAnonymous = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;
    if (!isEmailVerified) {
      verifyEmail.sendEmailVerification(
          isUserAnonymous: isUserAnonymous,
          ifMountedTrue: () {
            if (mounted) {
              setState(() => canResendEmail = false);
            }
          },
          ifMountedFalse: () {
            if (mounted) {
              setState(() => canResendEmail = true);
            }
          });
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => verifyEmail.checkEmailVerified(
            isEmailVerified: isEmailVerified,
            isUserAnonymous: isUserAnonymous,
            timer: timer,
            setEmailVerified: ({user}) {
              setState(() {
                isEmailVerified = user.emailVerified;
              });
            }),
      );
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
          ? const HomeScreenWidget()
          : Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                toolbarHeight: 100,
                title: const Text(
                  'Verify your email',
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
                      MaterialPageRoute(builder: (context) => const Welcome()),
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
                          onPressed: () => canResendEmail
                              ? verifyEmail.sendEmailVerification(
                                  isUserAnonymous: isUserAnonymous,
                                  ifMountedTrue: () {
                                    if (mounted) {
                                      setState(() => canResendEmail = false);
                                    }
                                  },
                                  ifMountedFalse: () {
                                    if (mounted) {
                                      setState(() => canResendEmail = true);
                                    }
                                  })
                              : null,
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
                                    builder: (context) => const Welcome()));
                          },
                          backColor: myBlue1)
                    ],
                  ),
                ),
              ),
            );
}
