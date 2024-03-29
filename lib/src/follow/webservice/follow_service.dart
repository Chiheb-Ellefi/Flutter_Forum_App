import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/notification_model/notif_model.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';
import 'package:my_project/src/notification/webservcies/firebase_notification_api.dart';

class FollowersService {
  Future<UserModel?> getProfilePic({uid, userRef}) async {
    DocumentSnapshot snapshot = await userRef.doc(uid).get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    UserModel? myData = UserModel.fromMap(data!);
    return myData;
  }

  follow(
      {isFollowing,
      myFollowers,
      myFollowing,
      uid,
      name,
      token,
      followerUid,
      userRef,
      notifRef}) async {
    if (isFollowing) {
      myFollowers!.remove(uid);
      myFollowing!.remove(followerUid);
    } else {
      myFollowers!.add(uid);
      myFollowing!.add(followerUid);
      await followNotif(
          notified: followerUid,
          notifRef: notifRef,
          uid: uid,
          name: name,
          token: token);
    }

    try {
      await userRef.doc(followerUid).update({'followers': myFollowers});
      await userRef.doc(uid).update({'following': myFollowing});
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  followNotif({notified, notifRef, uid, token, name}) async {
    final notifUid = notifRef.id;
    final api = FirebaseApi();
    NotificationModel notif = NotificationModel(
        uid: notifUid,
        notified: notified,
        date: DateTime.now(),
        notifier: uid,
        notification: 'just started following you');
    await notifRef.set(notif.toMap());
    await api.requestPermission();
    await api.sendPushMesssage(
        token, 'New Follower', '$name Started following you');
  }

  Future<void> following(
      {removed, followers, uid, followingUid, myFollowing}) async {
    if (removed) {
      followers!.remove(uid);
      myFollowing!.remove(followingUid);
    } else {
      followers!.add(uid);
      myFollowing!.add(followingUid);
    }
    try {
      await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(followingUid)
          .update({'followers': followers});
      await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(uid)
          .update({'following': myFollowing});
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }
}
