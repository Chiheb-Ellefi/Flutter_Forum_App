import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/tags_model/tags_model.dart';

class TagService {
  Future<List> getTags({uid, tags}) async {
    TagsModel myData = TagsModel();
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(tagsCollection)
        .doc(uid)
        .get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    myData = TagsModel.fromMap(data!);
    tags = myData.tags;
    return tags;
  }
}
