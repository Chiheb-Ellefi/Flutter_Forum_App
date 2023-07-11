import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/src/follow/components/followers_tile.dart';
import 'package:my_project/src/follow/webservice/follow_service.dart';
import 'package:my_project/src/profile/screens/profile_widget.dart';

class FollowersWidget extends StatefulWidget {
  const FollowersWidget({super.key});

  @override
  State<FollowersWidget> createState() => _FollowersWidgetState();
}

class _FollowersWidgetState extends State<FollowersWidget> {
  List? followers = [], following = [];
  UserModel? myData = UserModel();
  CollectionReference userRef =
      FirebaseFirestore.instance.collection(usersCollection);
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FollowersService service = FollowersService();
  getProfile() async {
    myData = await service.getProfilePic(uid: uid, userRef: userRef);
    if (mounted) {
      setState(() {
        following = myData!.following;
        followers = myData!.followers;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider();
        },
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: followers!.length,
        itemBuilder: (context, index) {
          return FutureBuilder<DocumentSnapshot>(
            future: userRef
                .doc(followers![index])
                .get(), // Get the user document using the follower's uid
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: myBlue2,
                ));
              }
              if (snapshot.hasData) {
                Map<String, dynamic>? userData = snapshot.data!.data() as Map<
                    String, dynamic>?; // Extract user data from the snapshot
                if (userData != null) {
                  String username = userData['username'] ?? '';
                  String profilePicture = userData['profilePicture'];
                  List followerFollowers = userData[
                      'followers']; // Get the username from the user data
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfileWidget(uid: followers![index])));
                    },
                    child: MyListTile(
                      followerFollowers: followerFollowers,
                      uid: uid,
                      followerUid: followers![index],
                      followers: followers,
                      following: following,
                      image: profilePicture,
                      text: username,
                    ),
                  );
                }
              }
              return const SizedBox(); // Return an empty container if the data is not available yet
            },
          );
        },
      ),
    );
  }
}
