import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/tags_model/tags_model.dart';

class TagDropdown extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const TagDropdown({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TagDropdownState createState() => _TagDropdownState();
}

class _TagDropdownState extends State<TagDropdown> {
  String? val;
  List<dynamic>? tags;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  TagsModel myData = TagsModel();
  Future<void> getTags() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(tagsCollection)
        .doc(uid)
        .get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    myData = TagsModel.fromMap(data!);
    tags = myData.tags;
  }

  @override
  void initState() {
    super.initState();
    getTags().then((_) {
      setState(() {
        if (tags != null) {
          val = tags![0];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: getTags(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while fetching the tags
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show an error message if there's an error
          return const Text('Error loading tags');
        } else {
          return Container(
            padding: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButton<String>(
              style: const TextStyle(fontSize: 20, color: Colors.black87),
              borderRadius: BorderRadius.circular(10),
              isExpanded: true,
              underline: Container(),
              value: val,
              onChanged: (String? newValue) {
                setState(() {
                  val = newValue!;
                });
                widget.onChanged(
                    newValue!); // Notify the parent widget about the value change
              },
              items: tags!.map<DropdownMenuItem<String>>((dynamic value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
