import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';

// ignore: must_be_immutable
class NewPassword extends StatelessWidget {
  NewPassword({super.key, required this.oldPass});
  String? oldPass;
  final newPass = TextEditingController();
  final confirm = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  changePassword({email, oldPass, newPass}) async {
    final cred = EmailAuthProvider.credential(email: email, password: oldPass);
    await currentUser!.reauthenticateWithCredential(cred).then(
      (value) {
        currentUser!.updatePassword(newPass);
      },
    ).catchError((err) {
      Utils.showSnackBar(err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Write your old password',
        style: TextStyle(fontSize: 22),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              obscureText: true,
              controller: newPass,
              decoration: InputDecoration(
                hintText: 'New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(
                height:
                    10), // Added SizedBox to add some spacing between the text fields
            TextField(
              obscureText: true,
              controller: confirm,
              decoration: InputDecoration(
                hintText: 'Confirm password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ElevatedButton(
                onPressed: () async {
                  final mail = currentUser!.email;
                  if (newPass.text.trim() == confirm.text.trim()) {
                    await changePassword(
                        email: mail,
                        oldPass: oldPass,
                        newPass: newPass.text.trim());
                  }
                  print('password changed');
                },
                style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  child: Text(
                    'Change password',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
