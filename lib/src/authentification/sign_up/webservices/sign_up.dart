import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_project/constants/contant_values.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/tags_model/tags_model.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';
import 'package:my_project/main.dart';
import 'package:path/path.dart' as path;

class SignService {
  Future<UserCredential?> registerUser(
      {context,
      mail,
      password,
      users,
      myImage,
      myPath,
      imageUrl,
      userName,
      phoneNumber,
      dob}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      UserCredential result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail.trim(),
        password: password.trim(),
      );
      if (myImage != null) {
        String? imageName =
            myImage != null ? path.basename(myImage!.path) : null;
        myPath = 'files/profile_pic/$imageName';
        final ref = FirebaseStorage.instance.ref().child(myPath!);
        await ref.putFile(myImage!);
        imageUrl = await ref.getDownloadURL();
      }
      UserModel userModel = UserModel(
          uid: result.user!.uid,
          username: userName.trim(),
          email: result.user!.email ?? "No email",
          phoneNumber: phoneNumber.trim(),
          dateOfBirth: dob ?? DateTime.now(),
          profilePicture: imageUrl ?? avatarDefault,
          followers: [],
          following: [],
          topics: [],
          isAdmin: false,
          isAnonymous: false);
      await users.doc(result.user!.uid).set(userModel.toMap());
      //initialize the tags document for the new user
      TagsModel tagsModel = TagsModel(uid: result.user!.uid, tags: [
        'Sports',
        'Tourism',
        'Gaming',
        'Web',
        'Mobile',
        'Event',
        'TVs'
      ]);
      await FirebaseFirestore.instance
          .collection(tagsCollection)
          .doc(result.user!.uid)
          .set(tagsModel.toMap());
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      return result;
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    return null;
  }
}
