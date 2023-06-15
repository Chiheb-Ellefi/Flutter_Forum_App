import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';

// ignore: must_be_immutable
class MyListTile extends StatefulWidget {
  MyListTile(
      {super.key,
      required this.text,
      required this.isFollowing,
      required this.image,
      required this.followerUid,
      required this.uid,
      required this.followers,
      required this.following,
      required this.followerFollowers});
  final String text;
  bool isFollowing;
  final String image;
  final String uid;
  final String followerUid;
  List? followers = [], following = [], followerFollowers = [];

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  List? myFollowers = [];
  List? myFollowing = [];
  UserModel myData = UserModel();
  CollectionReference userRef =
      FirebaseFirestore.instance.collection(usersCollection);

  @override
  void initState() {
    super.initState();
    myFollowers = List<String>.from(widget.followerFollowers ?? []);
    myFollowing = List<String>.from(widget.following ?? []);
  }

  follow() async {
    if (widget.isFollowing) {
      myFollowers!.remove(widget.uid);
      myFollowing!.remove(widget.followerUid);
    } else {
      myFollowers!.add(widget.uid);
      myFollowing!.add(widget.followerUid);
    }

    try {
      await userRef.doc(widget.followerUid).update({'followers': myFollowers});
      await userRef.doc(widget.uid).update({'following': myFollowing});
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final IconData myIcon = widget.isFollowing
        ? FontAwesomeIcons.userMinus
        : FontAwesomeIcons.userPlus;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              backgroundImage: NetworkImage(
                widget.image,
              ),
              radius: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              widget.text,
              style: const TextStyle(fontSize: 25),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            follow();
            setState(() {
              widget.isFollowing = !widget.isFollowing;
            });
          },
          icon: Icon(myIcon),
        ),
      ],
    );
  }
}
