import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/src/follow/webservice/follow_service.dart';

// ignore: must_be_immutable
class MyListTile extends StatefulWidget {
  MyListTile(
      {super.key,
      required this.text,
      required this.image,
      required this.followerUid,
      required this.uid,
      required this.followers,
      required this.following,
      required this.followerFollowers,
      required this.name,
      required this.token});
  final String text;
  String? name, token;
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
  bool isFollowing = false;

  CollectionReference userRef =
      FirebaseFirestore.instance.collection(usersCollection);
  FollowersService service = FollowersService();

  @override
  void initState() {
    super.initState();
    myFollowers = List<String>.from(widget.followerFollowers ?? []);
    myFollowing = List<String>.from(widget.following ?? []);
    isFollowing = myFollowing!.contains(widget.followerUid);
  }

  DocumentReference<Map<String, dynamic>> get _notif =>
      FirebaseFirestore.instance.collection(notifCollection).doc();

  @override
  Widget build(BuildContext context) {
    final IconData myIcon =
        isFollowing ? FontAwesomeIcons.userMinus : FontAwesomeIcons.userPlus;
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
            service.follow(
                name: widget.name,
                token: widget.token,
                isFollowing: isFollowing,
                myFollowers: myFollowers,
                myFollowing: myFollowing,
                uid: widget.uid,
                followerUid: widget.followerUid,
                userRef: userRef,
                notifRef: _notif);
            setState(() {
              isFollowing = !isFollowing;
            });
          },
          icon: Icon(myIcon),
        ),
      ],
    );
  }
}
