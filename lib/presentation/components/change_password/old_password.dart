import 'package:flutter/material.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/presentation/components/change_password/new_password.dart';

class OldPassword extends StatelessWidget {
  OldPassword({super.key});
  final oldPass = TextEditingController();
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
                showDialog(
                    context: context,
                    builder: (context) => NewPassword(
                          oldPass: oldPass.text.trim(),
                        ));
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
