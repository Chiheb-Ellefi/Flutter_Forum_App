import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_project/data/models/user_model/user_model.dart';

class SettingsService {
  Future<UserModel> getProfilePic(
      {required CollectionReference userRef, uid}) async {
    UserModel myData = UserModel();
    await userRef
        .where(
          "uid",
          isEqualTo: uid,
        )
        .get()
        .then((value) {
      for (var element in value.docs) {
        Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
        myData = UserModel.fromMap(data!);
      }
    });
    return myData;
  }
}
