import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/presentation/widgets/profile/profile_widget.dart';

class MyProfile extends StatelessWidget {
  MyProfile({super.key});

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return ProfileWidget(
      uid: uid,
    );
  }
}
