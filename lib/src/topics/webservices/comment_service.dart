import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/notification_model/notif_model.dart';
import 'package:my_project/data/models/topic_model/comment_model.dart';
import 'package:my_project/main.dart';

class CommentService {
  updateLike({uid, date, likes}) async {
    final queryTopic = FirebaseFirestore.instance
        .collection(topicsCollection)
        .where('uid', isEqualTo: uid)
        .get();

    final value = await queryTopic;

    for (final element in value.docs) {
      final QuerySnapshot snapshot = await element.reference
          .collection('${uid}comments')
          .where('date', isEqualTo: date)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var element in snapshot.docs) {
          element.reference.update({
            'likes': likes,
          });
        }
      }
    }
  }

  CommentModel getReply({author, reply}) {
    CommentModel myReply = CommentModel(
      author: author,
      text: reply.text.trim(),
      likes: [],
      date: DateTime.now(),
      replies: [],
    );
    return myReply;
  }

  DocumentReference<Map<String, dynamic>> get _notif =>
      FirebaseFirestore.instance.collection(notifCollection).doc();
  replyNotif({notified, userUid, text}) async {
    final DocumentReference<Map<String, dynamic>> notifRef = _notif;
    final notifUid = notifRef.id;
    NotificationModel notif = NotificationModel(
        uid: notifUid,
        notified: notified,
        date: DateTime.now(),
        notifier: userUid,
        notification: 'just replied to your comment "$text"');
    await notifRef.set(notif.toMap());
  }

  likeNotif({notified, userUid, text}) async {
    final DocumentReference<Map<String, dynamic>> notifRef = _notif;
    final notifUid = notifRef.id;
    NotificationModel notif = NotificationModel(
        uid: notifUid,
        notified: notified,
        date: DateTime.now(),
        notifier: userUid,
        notification: 'just liked your comment "${text}"');
    await notifRef.set(notif.toMap());
  }

  updateReplies(
      {context,
      uid,
      widgetReplies,
      myReply,
      date,
      reply,
      authorUid,
      userUid}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      final queryTopic = FirebaseFirestore.instance
          .collection(topicsCollection)
          .where('uid', isEqualTo: uid)
          .get();

      final value = await queryTopic;
      List<dynamic> replies = widgetReplies;
      replies.add(myReply!.toMap());
      for (final element in value.docs) {
        final QuerySnapshot snapshot = await element.reference
            .collection('${uid}comments')
            .where('date', isEqualTo: date)
            .get();

        if (snapshot.docs.isNotEmpty) {
          for (var element in snapshot.docs) {
            element.reference.update({
              'replies': replies,
            }).then((_) {
              reply.clear(); // Clear the text editing controller
            });
          }
        }
      }
      if (authorUid != userUid) {
        await replyNotif(notified: authorUid);
      }
    } catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  //for the comment alert
  replyTopicNotif({notified, userUid, title}) async {
    final DocumentReference<Map<String, dynamic>> notifRef = _notif;
    final notifUid = notifRef.id;
    NotificationModel notif = NotificationModel(
        uid: notifUid,
        notified: notified,
        date: DateTime.now(),
        notifier: userUid,
        notification: 'just replied to your topic "${title}"');
    await notifRef.set(notif.toMap());
  }

  addComment(
      {author,
      controller,
      uid,
      userUid,
      authorUid,
      onCommentAdded,
      title}) async {
    try {
      CommentModel myComment = CommentModel(
        author: author,
        text: controller.text.trim(),
        likes: [],
        date: DateTime.now(),
        replies: [],
      );

      CollectionReference topicRef =
          FirebaseFirestore.instance.collection(topicsCollection);
      QuerySnapshot querySnapshot =
          await topicRef.where('uid', isEqualTo: uid).get();
      for (var element in querySnapshot.docs) {
        element.reference.collection('${uid}comments').add(myComment.toMap());
      }
      if (authorUid != userUid) {
        await replyTopicNotif(notified: authorUid);
      }
      onCommentAdded();
    } catch (e) {
      print('Error: $e');
    }
  }
}
