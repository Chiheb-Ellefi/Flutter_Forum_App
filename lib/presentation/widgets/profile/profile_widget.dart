import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/contant_values.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/notification_model/notif_model.dart';
import 'package:my_project/data/models/topic_model/topic_model.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/data/webservices/add_topic/get_topic/get_topics.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';
import 'package:my_project/presentation/components/notification/notif_button.dart';
import 'package:my_project/presentation/components/report_alert.dart';
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
  List? followers = [], topics = [], myFollowing = [];

  CollectionReference myRef =
      FirebaseFirestore.instance.collection(usersCollection);
  CollectionReference userRef =
      FirebaseFirestore.instance.collection(usersCollection);
  CollectionReference topicsRef =
      FirebaseFirestore.instance.collection(topicsCollection);
  String uid = FirebaseAuth.instance.currentUser!.uid;
  late Query<TopicModel> queryTopic;
  bool isMyProfile = false;
  bool isFollowing = false;
  String followText = '';

  Future<void> getProfile() async {
    DocumentSnapshot snapshot = await userRef.doc(widget.uid).get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    UserModel userData = UserModel.fromMap(data!);
    image = userData.profilePicture;
    userName = userData.username;
    followers = userData.followers ?? [];
    topics = userData.topics ?? [];
    isFollowing = followers!.contains(uid);
    followText = isFollowing ? 'UnFollow' : 'Follow';
    if (mounted) {
      setState(() {
        // Update the widget's state after retrieving the data
      });
    }
  }

  Future<void> getMyProfile() async {
    DocumentSnapshot snapshot = await myRef.doc(uid).get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    UserModel myData = UserModel.fromMap(data!);
    myFollowing = myData.following ?? [];
    if (mounted) {
      setState(() {
        // Update the widget's state after retrieving the data
      });
    }
  }

  DocumentReference<Map<String, dynamic>> get _notif =>
      FirebaseFirestore.instance.collection(notifCollection).doc();

  followNotif() async {
    final DocumentReference<Map<String, dynamic>> notifRef = _notif;
    final notifUid = notifRef.id;
    NotificationModel notif = NotificationModel(
        uid: notifUid,
        notified: widget.uid,
        date: DateTime.now(),
        notifier: uid,
        notification: 'just started following you');
    await notifRef.set(notif.toMap());
  }

  follow() async {
    if (isFollowing) {
      followText = 'Follow';
      followers!.remove(uid);
      myFollowing!.remove(widget.uid);
    } else {
      followText = 'UnFollow';
      followers!.add(uid);
      myFollowing!.add(widget.uid);
      await followNotif();
    }

    try {
      await myRef.doc(uid).update({'following': myFollowing});
      await userRef.doc(widget.uid).update({'followers': followers});
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
    getMyProfile();
    getProfile();
    isMyProfile = uid == widget.uid;
  }

  reportTopic() async {
    showDialog(
        context: context,
        builder: (context) => ReportAlert(
              reporter: uid,
              reported: widget.uid,
            ));
  }

  @override
  Widget build(BuildContext context) {
    followText = isFollowing ? 'UnFollow' : 'Follow';
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
