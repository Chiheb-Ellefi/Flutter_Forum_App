import 'package:flutter/material.dart';
import 'package:my_project/config/themes.dart';

import 'package:my_project/data/webservices/utils/Utils.dart';
import 'package:my_project/main.dart';
import 'package:my_project/presentation/components/loginButton.dart';
import 'package:my_project/presentation/pages/authentification/changePassword.dart';

import 'package:my_project/presentation/widgets/authentication/SignupFrom.dart';
import 'package:my_project/presentation/widgets/authentication/fingerprintAlert.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  String _mail = '', _password = '';

  @override
  Widget build(BuildContext context) {
    Future fetchUser() async {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
      try {
        UserCredential result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _mail.trim(), password: _password.trim());
        User? user = result.user;
        navigatorKey.currentState!.popUntil((route) => route.isFirst);
        return user;
      } on FirebaseAuthException catch (e) {
        print(e);
        Utils.showSnackBar(e.message);
      }
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }

    Future onPressed() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        dynamic result = await fetchUser();
        if (result == null) {
          print('error signing in');
        }
        print('signed in');
        print(result);
      }
    }

    forgotPass() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ChangePassword()));
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.length > 255) {
                        return 'Email is too long';
                      } else if (!(RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value))) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _mail = value ?? "";
                    },
                    decoration: const InputDecoration(
                        label: Text('Email'), border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    onSaved: (value) {
                      _password = value ?? "";
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        label: Text('Password'), border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
            MyButton(
              text: 'Login',
              color: myBlue4,
              backColor: myBlue1,
              onPressed: onPressed,
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: forgotPass,
              child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: myBlue1,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400),
                  ))),
            ),
            const SizedBox(
              height: 70,
            ),
            const SizedBox(
              width: double.infinity,
              child: SignUpFrom(),
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Row(children: <Widget>[
                Expanded(
                    child: Divider(
                  thickness: 2,
                )),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "OR",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                    child: Divider(
                  thickness: 2,
                )),
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        const FingerPrintAlert());
              },
              child: Column(
                children: [
                  Image.asset('assets/fingerprint.png', width: 70),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Use fingerprint',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 18),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
