import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/notification_model/notif_model.dart';
import 'package:my_project/data/models/topic_model/topic_model.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';
import 'package:my_project/src/notification/webservcies/firebase_notification_api.dart';

class ProfileService {
  CollectionReference myRef =
      FirebaseFirestore.instance.collection(usersCollection);
  CollectionReference userRef =
      FirebaseFirestore.instance.collection(usersCollection);
  CollectionReference topicsRef =
      FirebaseFirestore.instance.collection(topicsCollection);
  Future<UserModel?> getUserProfile({userUid}) async {
    try {
      DocumentSnapshot snapshot = await userRef.doc(userUid).get();
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      UserModel userData = UserModel.fromMap(data!);
      return userData;
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
      return null;
    }
  }

  Query<TopicModel> initializeQuery({uid}) {
    late Query<TopicModel> queryTopic = FirebaseFirestore.instance
        .collection(topicsCollection)
        .where('authorUid', isEqualTo: uid)
        .withConverter<TopicModel>(
          fromFirestore: (snapshot, _) => TopicModel.fromMap(snapshot.data()!),
          toFirestore: (topic, _) => topic.toMap(),
        );
    return queryTopic;
  }

  follow(
      {isFollowing,
      followText,
      followers,
      myFollowing,
      uid,
      userUid,
      notifRef,
      name,
      token}) async {
    if (isFollowing) {
      followText = 'Follow';
      followers!.remove(uid);
      myFollowing!.remove(userUid);
    } else {
      followText = 'UnFollow';
      followers!.add(uid);
      myFollowing!.add(userUid);
      await followNotif(
          notifRef: notifRef,
          userUid: userUid,
          uid: uid,
          token: token,
          name: name);
    }

    try {
      await myRef.doc(uid).update({'following': myFollowing});
      await userRef.doc(userUid).update({'followers': followers});
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  Future<void> followNotif({notifRef, userUid, uid, token, name}) async {
    final notifUid = notifRef.id;
    final api = FirebaseApi();
    NotificationModel notif = NotificationModel(
        uid: notifUid,
        notified: userUid,
        date: DateTime.now(),
        notifier: uid,
        notification: 'just started following you');
    await notifRef.set(notif.toMap());
    await api.requestPermission();
    await api.sendPushMesssage(
        token, 'New Follower', '$name Started following you');
  }
}
