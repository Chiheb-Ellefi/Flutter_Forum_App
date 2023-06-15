import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/presentation/components/profile/following_tile.dart';
import 'package:my_project/presentation/widgets/profile/profile_widget.dart';

class FollowingWidget extends StatefulWidget {
  const FollowingWidget({Key? key}) : super(key: key);

  @override
  State<FollowingWidget> createState() => _FollowingWidgetState();
}

class _FollowingWidgetState extends State<FollowingWidget> {
  List? followers = [];
  List? myFollowing = [];
  UserModel myData = UserModel();
  CollectionReference userRef =
      FirebaseFirestore.instance.collection(usersCollection);
  late String uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    getProfilePic();
  }

  Future<void> getProfilePic() async {
    DocumentSnapshot snapshot = await userRef.doc(uid).get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    myData = UserModel.fromMap(data!);
    myFollowing = myData.following;

    if (mounted) {
      setState(() {
        // Update the widget's state after retrieving the data
      });
    }
  }

  reset() {
    if (mounted) {
      setState(() {
        // Update the widget's state after retrieving the data
      });
    }
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
        itemCount: myFollowing!.length,
        itemBuilder: (context, index) {
          return FutureBuilder<DocumentSnapshot>(
            future: userRef.doc(myFollowing![index]).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: myBlue2,
                  ),
                );
              }
              if (snapshot.hasData) {
                Map<String, dynamic>? userData =
                    snapshot.data!.data() as Map<String, dynamic>?;
                if (userData != null) {
                  String username = userData['username'] ?? '';
                  String profilePicture = userData['profilePicture'];
                  List<dynamic>? followerFollowers = userData['followers'];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileWidget(uid: myFollowing![index]),
                        ),
                      );
                    },
                    child: MyFollowingListTile(
                      followerFollowers: followerFollowers,
                      uid: uid,
                      followingUid: myFollowing![index],
                      following: myFollowing,
                      image: profilePicture,
                      text: username,
                      reset: reset,
                    ),
                  );
                }
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
