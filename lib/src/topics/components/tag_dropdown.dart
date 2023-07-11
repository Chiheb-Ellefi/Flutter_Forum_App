import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/src/topics/webservices/tag_service.dart';

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
  TagService service = TagService();

  @override
  void initState() {
    super.initState();
    getMyTags();
  }

  void getMyTags() async {
    tags = await service.getTags(uid: uid);
    setState(() {
      if (tags != null && tags!.isNotEmpty) {
        val = tags![0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (tags == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (tags!.isEmpty) {
      return const Text('No tags found');
    } else {
      return Container(
        padding: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
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
            widget.onChanged(newValue!);
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
  }
}
