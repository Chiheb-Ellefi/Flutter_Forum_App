import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/topic_model/topic_model.dart';
import 'package:my_project/data/webservices/add_topic/get_topic/get_topics.dart';

import 'package:my_project/presentation/components/tagBox.dart';
import 'package:my_project/presentation/components/topic.dart';

class TopicsWidget extends StatefulWidget {
  const TopicsWidget({super.key});

  @override
  State<TopicsWidget> createState() => _TopicsWidgetState();
}

class _TopicsWidgetState extends State<TopicsWidget> {
  final tags = ['Sports', 'Tourism', 'Gaming', 'Web', 'Mobile', 'Event', 'TVs'];
  final queryTopic = FirebaseFirestore.instance
      .collection(topicsCollection)
      .withConverter<TopicModel>(
          fromFirestore: (snapshot, _) => TopicModel.fromMap(snapshot.data()!),
          toFirestore: (topic, _) => topic.toMap());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          title: const Text(
            'Topics',
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
          ]),
      body: Column(
        children: [
          Container(
            color: Colors.grey.shade100,
            height: 50,
            width: double.infinity,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tags.length,
                itemBuilder: (context, index) => TagBox(text: tags[index])),
          ),
          Expanded(
            child: FirestoreListViewWidget<TopicModel>(
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
          ),
        ],
      ),
    );
  }
}
