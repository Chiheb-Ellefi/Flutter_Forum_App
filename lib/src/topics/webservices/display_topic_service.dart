import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/topic_model/comment_model.dart';
import 'package:my_project/data/models/topic_model/topic_model.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/main.dart';
import 'package:my_project/src/topics/components/report_alert.dart';

class DisplayTopicService {
  Stream<List<CommentModel>> getComments({uid}) {
    final topicQuery = FirebaseFirestore.instance
        .collection(topicsCollection)
        .where('uid', isEqualTo: uid)
        .snapshots();

    return topicQuery.asyncMap((snapshot) async {
      final List<CommentModel> commentsList = [];

      for (final element in snapshot.docs) {
        final querySnapshot = await element.reference
            .collection('${uid}comments')
            .orderBy('date', descending: true)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final comments = querySnapshot.docs.map((doc) {
            final commentData = doc.data() as Map<String, dynamic>;
            return CommentModel.fromMap(commentData);
          }).toList();

          commentsList.addAll(comments);
        }
      }

      return commentsList;
    });
  }

  Future<String?> getAuthUid({uid}) async {
    String? authUid;
    final queryTopic = FirebaseFirestore.instance
        .collection(topicsCollection)
        .where('uid', isEqualTo: uid)
        .get();
    final value = await queryTopic;
    for (final element in value.docs) {
      Map<String, dynamic>? data = element.data();
      TopicModel myData = TopicModel.fromMap(data);
      authUid = myData.authorUid!;
    }
    return authUid;
  }

  updateCommentEnabled({uid, commentsEnabled}) async {
    final value = await FirebaseFirestore.instance
        .collection(topicsCollection)
        .where('uid', isEqualTo: uid)
        .get();
    for (final element in value.docs) {
      element.reference.update({'notifEnabled': commentsEnabled});
    }
  }

  removeTopic({authUid, uid}) async {
    final userRef = FirebaseFirestore.instance.collection('users');
    final snapshot = await userRef.doc(authUid).get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>?;
      final UserModel myData = UserModel.fromMap(data!);
      final List<dynamic>? topics = myData.topics;
      topics!.remove(uid);
      await userRef.doc(authUid).update({'topics': topics});
    }
  }

  deleteTopic({context, uid, authUid}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await removeTopic(authUid: authUid, uid: uid);
      final queryTopic = FirebaseFirestore.instance
          .collection(topicsCollection)
          .where('uid', isEqualTo: uid)
          .get();
      final value = await queryTopic;
      for (final element in value.docs) {
        element.reference.delete();
      }
    } catch (e) {
      print('Error deleting document: $e');
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  reportTopic({uid, widgetUid, context}) async {
    showDialog(
        context: context,
        builder: (context) => ReportAlert(
              collection: topicsReports,
              reporter: uid,
              reported: widgetUid,
            ));
  }
}
