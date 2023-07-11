import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';
import 'package:my_project/main.dart';
import 'package:my_project/src/settings/components/change_password/new_password.dart';

class OldPassword extends StatefulWidget {
  const OldPassword({super.key});

  @override
  State<OldPassword> createState() => _OldPasswordState();
}

class _OldPasswordState extends State<OldPassword> {
  final oldPass = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;
  signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user!.email!,
        password: oldPass.text.trim(),
      );
      if (userCredential.user != null) {
        // Sign-in was successful
        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .popUntil((route) => route.isFirst); // Navigate to the first screen
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => NewPassword(
            oldPass: oldPass.text.trim(),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(); // Dismiss the progress indicator
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Invalid Password'),
            content: const Text('Please enter the correct old password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Error occurred during authentication, handle accordingly
      // ignore: use_build_context_synchronously
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      Utils.showSnackBar(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Write your old password',
        style: TextStyle(fontSize: 22),
      ),
      content: TextField(
        obscureText: true,
        controller: oldPass,
        decoration: InputDecoration(
          hintText: 'Old Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                signIn();
              },
              style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
