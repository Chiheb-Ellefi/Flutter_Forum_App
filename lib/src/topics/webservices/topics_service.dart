import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/topic_model/topic_model.dart';

class TopicsServices {
  Future<List<String>> getTags({tags}) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(tagsCollection)
        .doc('myTags')
        .get();
    final myData = snapshot.data()
        as Map<String, dynamic>; // Update the type cast to Map<String, dynamic>
    tags = List<String>.from(myData['tags']);

    return tags;
  }

  Query<TopicModel> initializeQuery(List myTags) {
    Query<TopicModel> queryTopic;

    if (myTags.isNotEmpty) {
      queryTopic = FirebaseFirestore.instance
          .collection(topicsCollection)
          .where('tags', arrayContainsAny: myTags)
          .withConverter<TopicModel>(
            fromFirestore: (snapshot, _) =>
                TopicModel.fromMap(snapshot.data()!),
            toFirestore: (topic, _) => topic.toMap(),
          );
    } else {
      queryTopic = FirebaseFirestore.instance
          .collection(topicsCollection)
          .withConverter<TopicModel>(
            fromFirestore: (snapshot, _) =>
                TopicModel.fromMap(snapshot.data()!),
            toFirestore: (topic, _) => topic.toMap(),
          );
    }

    return queryTopic;
  }

  Query<TopicModel> searchQuery(
    String value,
    TextEditingController searchController,
    Query<TopicModel> queryTopic,
    List<String> myTags,
  ) {
    if (searchController.text.isNotEmpty) {
      queryTopic = FirebaseFirestore.instance
          .collection(topicsCollection)
          .where('title', isGreaterThanOrEqualTo: value)
          .where('title', isLessThanOrEqualTo: value + '\uf8ff')
          .withConverter<TopicModel>(
            fromFirestore: (snapshot, _) =>
                TopicModel.fromMap(snapshot.data()!),
            toFirestore: (topic, _) => topic.toMap(),
          );
    }
    return queryTopic;
  }
}
