import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/notification_model/notif_model.dart';
import 'package:my_project/data/models/tags_model/tags_model.dart';
import 'package:my_project/data/models/topic_model/topic_model.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/main.dart';
import 'package:my_project/src/notification/webservcies/firebase_notification_api.dart';
import 'package:path/path.dart' as path;

class AddTopicService {
  Future updateTags({uid, required List<dynamic>? tagsList, myTags}) async {
    TagsModel myData = TagsModel();
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(tagsCollection)
        .doc(uid)
        .get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    myData = TagsModel.fromMap(data!);
    tagsList = myData.tags;
    tagsList!.addAll(myTags);
    tagsList = (tagsList.toSet()).toList();
    await FirebaseFirestore.instance
        .collection(tagsCollection)
        .doc(uid)
        .update({'tags': tagsList});
  }

  addTopicNotif({notified, notifRef, uid, token, name}) async {
    final notifUid = notifRef.id;
    final api = FirebaseApi();
    NotificationModel notif = NotificationModel(
        uid: notifUid,
        notified: notified,
        date: DateTime.now(),
        notifier: uid,
        notification: 'just posted a new topic');
    await notifRef.set(notif.toMap());
    await api.requestPermission();
    await api.sendPushMesssage(
        token, 'New topic', '$name just posted a new topic');
  }

  Future publish(
      {topicUid,
      context,
      topics,
      myFollowers,
      images,
      uid,
      title,
      description,
      myTags,
      required DocumentReference<Map<String, dynamic>> topic,
      tagsList,
      notif}) async {
    final topicUid = topic.id;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      UserModel myData = UserModel();
      CollectionReference userRef =
          FirebaseFirestore.instance.collection(usersCollection);

      String userName = '';
      List<String>? myImages = [];
      DocumentSnapshot snapshot = await userRef.doc(uid).get();
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      myData = UserModel.fromMap(data!);
      userName = myData.username!;
      topics = myData.topics;
      myFollowers = myData.followers;
      String myPath;
      String imageUrl;
      //get images url and upload them to firestore storage
      if (images.isNotEmpty) {
        for (var image in images) {
          String? imageName = path.basename(image.path);
          myPath = 'files/topics_pic/${myData.uid}/$imageName';
          final ref = FirebaseStorage.instance.ref().child(myPath);
          await ref.putFile(image);
          imageUrl = await ref.getDownloadURL();
          myImages.add(imageUrl);
        }
      }

      TopicModel topicModel = TopicModel(
        uid: topicUid,
        title: title.text.trim(),
        description: description.text.trim(),
        author: userName,
        date: DateTime.now(),
        rating: 0.0,
        raters: 0,
        rate: 0.0,
        tags: myTags,
        files: myImages,
        authorUid: uid,
        notifEnabled: true,
      );
      topics!.add(topicUid);
      await topic.set(topicModel.toMap());
      await userRef.doc(uid).update({'topics': topics});
      await updateTags(uid: uid, tagsList: tagsList, myTags: myTags);
      for (var follower in myFollowers!) {
        String? token = await getToken(follower);
        await addTopicNotif(
            notified: follower,
            notifRef: notif,
            uid: uid,
            name: userName,
            token: token);
      }
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<String>? getToken(uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(uid)
        .get();

    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data != null) {
      UserModel myData = UserModel.fromMap(data);
      return myData.token!;
    }
    return '';
  }
}
