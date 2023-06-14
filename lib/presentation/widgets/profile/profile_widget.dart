import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/contant_values.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/topic_model/topic_model.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/data/webservices/add_topic/get_topic/get_topics.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';
import 'package:my_project/presentation/components/topic.dart';

// ignore: must_be_immutable
class ProfileWidget extends StatefulWidget {
  ProfileWidget({
    super.key,
    required this.uid,
  });
  String? uid;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  String? image, userName;
  List? followers = [], topics = [], following = [];
  UserModel myData = UserModel();
  CollectionReference userRef =
      FirebaseFirestore.instance.collection(usersCollection);
  CollectionReference topicsRef =
      FirebaseFirestore.instance.collection(topicsCollection);
  String uid = FirebaseAuth.instance.currentUser!.uid;
  late Query<TopicModel> queryTopic;
  bool isMyProfile = false;
  bool isFollowing = false;
  String followText = '';

  Future<void> getProfilePic() async {
    await userRef
        .where(
          "uid",
          isEqualTo: widget.uid,
        )
        .get()
        .then((value) {
      for (var element in value.docs) {
        Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
        myData = UserModel.fromMap(data!);
        image = myData.profilePicture;
        userName = myData.username;
        followers = myData.followers ?? [];
        following = myData.following;
        topics = myData.topics ?? [];
      }
    });
    isFollowing = followers!.contains(uid);
    setState(() {}); // Update the widget's state after retrieving the data
  }

  follow() async {
    if (isFollowing) {
      followText = 'Follow';

      followers!.remove(uid);
      following!.remove(widget.uid);
    } else {
      followText = 'UnFollow';

      followers!.add(uid);
      following!.add(widget.uid);
    }

    try {
      await userRef
          .where(
            "uid",
            isEqualTo: widget.uid,
          )
          .get()
          .then((value) {
        for (var element in value.docs) {
          element.reference.update({'followers': followers});
        }
      });
      await userRef
          .where(
            "uid",
            isEqualTo: uid,
          )
          .get()
          .then((value) {
        for (var element in value.docs) {
          element.reference.update({'following': following});
        }
      });
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  void initializeQuery() {
    queryTopic = FirebaseFirestore.instance
        .collection(topicsCollection)
        .where('authorUid', isEqualTo: widget.uid)
        .withConverter<TopicModel>(
          fromFirestore: (snapshot, _) => TopicModel.fromMap(snapshot.data()!),
          toFirestore: (topic, _) => topic.toMap(),
        );
  }

  @override
  void initState() {
    super.initState();
    getProfilePic();
    isMyProfile = uid == widget.uid;
    followText = isFollowing ? 'UnFollow' : 'Follow';
  }

  @override
  Widget build(BuildContext context) {
    initializeQuery();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.black87, fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 70,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
              ),
              iconSize: 30,
              color: Colors.black87,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(FontAwesomeIcons.bell),
              iconSize: 25,
              color: Colors.black87,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 70,
                foregroundImage: NetworkImage(
                  image ?? avatarDefault,
                ),
                child: const Icon(
                  FontAwesomeIcons.camera,
                  size: 50,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                userName ?? '',
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (!isMyProfile)
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
                    onPressed: () {
                      follow();
                      setState(() {
                        isFollowing = !isFollowing;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20),
                      child: Text(
                        followText,
                        style: const TextStyle(fontSize: 15),
                      ),
                    )),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Followers',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          followers!.length.toString(),
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.black,
                    ),
                    Column(
                      children: [
                        const Text(
                          'Topics',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          topics!.length.toString(),
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    )
                  ],
                ),
              ),
              FirestoreListViewWidget<TopicModel>(
                physics: const NeverScrollableScrollPhysics(),
                shrink: true,
                query: queryTopic,
                itemBuilder: (context, snapshot) {
                  final topic = snapshot.data();
                  return Topic(
                    uid: topic!.uid!, // Add a unique key to each child widget
                    title: topic.title!,
                    userName: topic.author!,
                    date: topic.date!,
                    rating: topic.rating!,
                    image: topic.files!,
                    text: topic.description!,
                    tags: topic.tags!,
                    raters: topic.raters!,
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
