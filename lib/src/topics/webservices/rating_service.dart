import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_project/constants/firebase_consts.dart';

class RateService {
  updateRating({uid, rating, rate, raters}) async {
    CollectionReference userRef =
        FirebaseFirestore.instance.collection(topicsCollection);
    await userRef.where('uid', isEqualTo: uid).get().then((value) {
      for (var element in value.docs) {
        element.reference.update({
          'rating': rating +
              rate, // Update the 'rating' field with the new rating value
          'raters': raters + 1,
          'rate': (rating + rate) / (raters + 1)
        });
      }
    });
  }
}
