import 'package:flutter/material.dart';
import 'package:my_project/main.dart';
import 'package:my_project/src/authentification/welcome/webservices/welcome_services.dart';
import 'package:my_project/config/themes.dart';

import 'package:my_project/src/authentification/sign_in/components/sign_in_button.dart';

class WelcomeWidget extends StatefulWidget {
  const WelcomeWidget({super.key});

  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget> {
  final WelcomeSerices _auth = WelcomeSerices();
  @override
  Widget build(BuildContext context) {
    signUp() {
      Navigator.pushNamed(context, '/signup');
    }

    signIn() {
      Navigator.pushNamed(context, '/login');
    }

    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 5,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Let's get Started",
                        style: TextStyle(fontFamily: 'Inter', fontSize: 30),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Column(children: [
                        MyButton(
                          text: 'Create Acount',
                          color: myBlue4,
                          backColor: myBlue2,
                          onPressed: signUp,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        MyButton(
                          text: 'Login',
                          color: myBlue1,
                          backColor: myBlue1,
                          onPressed: signIn,
                        ),
                      ]),
                      const SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                )),
            Expanded(
              flex: 1,
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: InkWell(
                    onTap: () async {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ));
                      dynamic result = await _auth.signInAnon();
                      if (result == null) {
                        print('error signing in');
                      }
                      print('signed in');
                      print(result);
                      navigatorKey.currentState!
                          .popUntil((route) => route.isFirst);
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: Material(
                        child: SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: Center(
                            child: Text(
                              'Continue as a guest',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
