import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/src/follow/webservice/follow_service.dart';

// ignore: must_be_immutable
class MyFollowingListTile extends StatefulWidget {
  const MyFollowingListTile({
    Key? key,
    required this.text,
    required this.image,
    required this.followingUid,
    required this.uid,
    required this.following,
    required this.followerFollowers,
    required this.reset,
  }) : super(key: key);

  final String text;
  final String image;
  final String uid;
  final String followingUid;
  final List? following;
  final List<dynamic>? followerFollowers;
  final Function reset;

  @override
  State<MyFollowingListTile> createState() => _MyFollowingListTileState();
}

class _MyFollowingListTileState extends State<MyFollowingListTile> {
  late List? followers;
  late List? myFollowing;
  bool removed = false;
  FollowersService service = FollowersService();

  @override
  void initState() {
    super.initState();
    followers = List<String>.from(widget.followerFollowers ?? []);
    myFollowing = List<String>.from(widget.following ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final IconData myIcon = !removed
        ? FontAwesomeIcons.userMinus
        : FontAwesomeIcons.arrowRotateLeft;

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
            setState(() {
              removed = !removed;
            });
            service.following(
                removed: removed,
                followers: followers,
                uid: widget.uid,
                followingUid: widget.followingUid,
                myFollowing: myFollowing);
          },
          icon: Icon(myIcon),
        ),
      ],
    );
  }
}
