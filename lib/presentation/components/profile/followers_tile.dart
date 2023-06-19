import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/notification_model/notif_model.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';

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
      required this.followerFollowers});
  final String text;
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
  UserModel myData = UserModel();
  CollectionReference userRef =
      FirebaseFirestore.instance.collection(usersCollection);

  @override
  void initState() {
    super.initState();
    myFollowers = List<String>.from(widget.followerFollowers ?? []);
    myFollowing = List<String>.from(widget.following ?? []);
    isFollowing = myFollowing!.contains(widget.followerUid);
  }

  follow() async {
    if (isFollowing) {
      myFollowers!.remove(widget.uid);
      myFollowing!.remove(widget.followerUid);
    } else {
      myFollowers!.add(widget.uid);
      myFollowing!.add(widget.followerUid);
      await followNotif(notified: widget.followerUid);
    }

    try {
      await userRef.doc(widget.followerUid).update({'followers': myFollowers});
      await userRef.doc(widget.uid).update({'following': myFollowing});
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  DocumentReference<Map<String, dynamic>> get _notif =>
      FirebaseFirestore.instance.collection(notifCollection).doc();
  followNotif({notified}) async {
    final DocumentReference<Map<String, dynamic>> notifRef = _notif;
    final notifUid = notifRef.id;
    NotificationModel notif = NotificationModel(
        uid: notifUid,
        notified: notified,
        date: DateTime.now(),
        notifier: widget.uid,
        notification: 'just started following you');
    await notifRef.set(notif.toMap());
  }

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
            follow();
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
