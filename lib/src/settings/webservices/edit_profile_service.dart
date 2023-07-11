import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';
import 'package:my_project/main.dart';
import 'package:path/path.dart' as path;

class EditProfileService {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference userRef =
      FirebaseFirestore.instance.collection(usersCollection);
  Future<String?> uploadImage({context, image}) async {
    String? myPath, myUrl;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      if (image != null) {
        String? imageName = image != null ? path.basename(image!.path) : null;
        myPath = 'files/profile_pic/$imageName';
        final ref = FirebaseStorage.instance.ref().child(myPath);
        await ref.putFile(image!);
        myUrl = await ref.getDownloadURL();
        return myUrl;
      }
    } catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    return null;
  }

  updateUser(
      {context, mail, myData, name, dateTime, myUrl, onProfileUpdated}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await userRef.doc(user!.uid).update({
        'email': mail == "" ? myData.email : mail,
        'username': name == "" ? myData.username : name,
        'dateOfBirth': dateTime!.millisecondsSinceEpoch,
        'profilePicture': myUrl,
      });
      ;
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
    onProfileUpdated();
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<UserModel> getProfileData({myData}) async {
    final snapshot = await userRef.doc(user!.uid).get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    myData = UserModel.fromMap(data!);
    return myData;
  }
}
