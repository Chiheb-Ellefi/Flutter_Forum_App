import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/ban_model/ban_model.dart';

class WelcomeSerices {
  Future<void> checkBan({userBan, isBanned, ban, uid}) async {
    DocumentSnapshot? snapshot = await userBan.isBanned(uid: uid);
    isBanned = snapshot == null ? false : true;
    if (isBanned && snapshot != null) {
      Map<String, dynamic> myData = snapshot.data() as Map<String, dynamic>;
      ban = BanModel.fromMap(myData);
      final banDuration = ban.duration;
      final now = DateTime.now().millisecondsSinceEpoch;
      final banDurationInMillis = banDuration?.millisecondsSinceEpoch ?? 0;
      final remainingDuration =
          Duration(milliseconds: banDurationInMillis - now);
      final hasBanEnded = remainingDuration <= Duration.zero;

      if (hasBanEnded) {
        await FirebaseFirestore.instance
            .collection(banCollection)
            .doc(uid)
            .delete();
      }
    }
  }

  Future<DocumentSnapshot?> getUser({userBan, isBanned, ban}) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(uid)
          .get();
      if (snapshot.exists) {
        await checkBan(
            userBan: userBan,
            isBanned: isBanned,
            ban: ban,
            uid: uid); // Call isUserBanned here
        return snapshot;
      } else {
        return null;
      }
    }
    return null;
  }

  // Sign in anonymously
  Future<User?> signInAnon() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential result = await auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print('Error signing in anonymously: $e');
      return null;
    }
  }
}
