import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/topic_model/topic_model.dart';

import 'package:my_project/presentation/components/comment_alert.dart';
import 'package:my_project/presentation/components/leadingButton.dart';
import 'package:my_project/presentation/pages/authentification/welcome_page.dart';
import 'package:my_project/presentation/widgets/homeScreenWidgets/displayTopicWidget.dart';

// ignore: must_be_immutable
class DisplayTopic extends StatelessWidget {
  DisplayTopic({
    super.key,
    required this.uid,
    required this.title,
    required this.userName,
    required this.date,
    required this.rating,
    required this.image,
    required this.text,
    required this.tags,
    required this.raters,
  });
  String uid;
  String title;
  String userName;
  DateTime date;
  double rating;
  String text;
  List<dynamic> tags;
  List<dynamic> image;
  int raters;
  final myUid = FirebaseAuth.instance.currentUser!.uid;
  String? authUid;
  getAuthUid() async {
    final queryTopic = FirebaseFirestore.instance
        .collection(topicsCollection)
        .where('uid', isEqualTo: uid)
        .get();
    final value = await queryTopic;
    for (final element in value.docs) {
      Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
      TopicModel myData = TopicModel.fromMap(data!);
      authUid = myData.authorUid!;
    }
  }

  @override
  Widget build(BuildContext context) {
    onSelected() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Welcome()));
    }

    getAuthUid();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CommentAlert(
                    author: userName,
                    uid: uid,
                    enabled: true,
                  );
                });
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          child: const Icon(FontAwesomeIcons.reply),
        ),
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: MyLeadingButton(
              myContext: context,
            ),
            toolbarHeight: 70,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(FontAwesomeIcons.bell),
                iconSize: 25,
                color: Colors.black87,
              ),
              PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black87,
                    size: 30,
                  ),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                            onTap: () => onSelected(),
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
                            ))
                      ]),
            ]),
        body: DisplayTopicWidget(
          uid: uid,
          title: title,
          userName: userName,
          date: date,
          rating: rating,
          image: image,
          text: text,
          tags: tags,
          raters: raters,
        ),
      ),
    );
  }
}
