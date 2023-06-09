import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';
import 'package:my_project/main.dart';
import 'package:my_project/presentation/components/loginButton.dart';

class FirstChnagePassword extends StatefulWidget {
  const FirstChnagePassword({super.key});

  @override
  State<FirstChnagePassword> createState() => _FirstChnagePasswordState();
}

class _FirstChnagePasswordState extends State<FirstChnagePassword> {
  final _formKey = GlobalKey<FormState>();
  String _mail = '';
  Future resetPass() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _mail.trim());
      Utils.showSnackBar('Password reset email sent ');
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    onPressed() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        await resetPass();
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
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
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    child: Text(
                      'Enter your email address to receive a confirmation code',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
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
                  MyButton(
                      text: 'Continue',
                      color: myBlue4,
                      backColor: myBlue1,
                      onPressed: onPressed)
                ],
              )),
        ),
      ),
    );
  }
}
