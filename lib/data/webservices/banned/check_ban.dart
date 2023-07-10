import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_project/constants/firebase_consts.dart';

class UserBan {
  Future<DocumentSnapshot?> isBanned({uid}) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(banCollection)
        .doc(uid)
        .get();
    if (snapshot.exists) {
      return snapshot;
    } else {
      return null;
    }
  }
}
