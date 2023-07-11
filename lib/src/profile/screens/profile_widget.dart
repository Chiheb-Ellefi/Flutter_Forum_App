import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/contant_values.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/topic_model/topic_model.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/data/webservices/get_topic/get_topics.dart';
import 'package:my_project/src/notification/components/notif_button.dart';
import 'package:my_project/src/profile/webservices/profile_service.dart';
import 'package:my_project/src/topics/components/report_alert.dart';
import 'package:my_project/src/topics/screens/topic.dart';

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
  List? followers = [], topics = [], myFollowing = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  late Query<TopicModel> queryTopic;
  bool isMyProfile = false;
  bool isFollowing = false;
  String followText = '';
  ProfileService service = ProfileService();

  DocumentReference<Map<String, dynamic>> get _notif =>
      FirebaseFirestore.instance.collection(notifCollection).doc();

  getProfile() async {
    UserModel? userData = await service.getUserProfile(userUid: widget.uid);
    if (mounted) {
      setState(() {
        image = userData!.profilePicture;
        userName = userData.username;
        followers = userData.followers ?? [];
        topics = userData.topics ?? [];
        isFollowing = followers!.contains(uid);
        followText = isFollowing ? 'UnFollow' : 'Follow';
      });
    }
  }

  getMyProfile() async {
    UserModel? userData = await service.getUserProfile(userUid: uid);
    if (mounted) {
      setState(() {
        myFollowing = userData!.following ?? [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isMyProfile = uid == widget.uid;
    getProfile();
    getMyProfile();
  }

  reportTopic() async {
    showDialog(
        context: context,
        builder: (context) => ReportAlert(
              collection: reportsCollection,
              reporter: uid,
              reported: widget.uid,
            ));
  }

  @override
  Widget build(BuildContext context) {
    queryTopic = service.initializeQuery(uid: widget.uid);
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
            const MyNotifButton(),
            if (widget.uid != uid)
              PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black87,
                    size: 30,
                  ),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                            onTap: () {
                              reportTopic();
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.flag,
                                  color: Colors.black87,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Report',
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            )),
                      ]),
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
                backgroundImage: const NetworkImage(avatarDefault),
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
                      service.follow(
                          isFollowing: isFollowing,
                          followText: followText,
                          followers: followers,
                          myFollowing: myFollowing,
                          uid: uid,
                          notifRef: _notif,
                          userUid: widget.uid);
                      setState(() {
                        isFollowing = !isFollowing;
                        followText = isFollowing ? 'UnFollow' : 'Follow';
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
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Most recent topics',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FirestoreListViewWidget<TopicModel>(
                physics: const NeverScrollableScrollPhysics(),
                shrink: true,
                query: queryTopic,
                itemBuilder: (context, snapshot) {
                  final topic = snapshot.data();
                  return Topic(
                    authorUid: widget.uid,
                    uid: topic!.uid!, // Add a unique key to each child widget
                    title: topic.title!,
                    userName: topic.author!,
                    date: topic.date!,
                    rating: topic.rating!,
                    image: topic.files!,
                    text: topic.description!,
                    tags: topic.tags!,
                    raters: topic.raters!,
                    notifEnabled: topic.notifEnabled,
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
