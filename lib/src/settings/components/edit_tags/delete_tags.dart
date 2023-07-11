import 'package:flutter/material.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/src/settings/webservices/manage_tags_service.dart';

class DeleteDialog extends StatefulWidget {
  const DeleteDialog(
      {super.key,
      required this.index,
      required this.tags,
      required this.uid,
      required this.setState});
  final index;
  final tags;
  final uid;
  final VoidCallback setState;
  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  List<dynamic>? tags;
  ManageTagsService service = ManageTagsService();
  @override
  Widget build(BuildContext context) {
    tags = widget.tags;
    return AlertDialog(
      content: const Text(
        "Are you sure you want to delete this tag this can't be undone",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const SizedBox(
              width: 100,
              height: 40,
              child: Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )),
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              setState(() {
                tags!.removeAt(widget.index);
              });
              await service.update(uid: widget.uid, tags: tags);
              widget.setState();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: const SizedBox(
              width: 100,
              height: 40,
              child: Center(
                child: Text(
                  'Delete',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )),
      ],
    );
  }
}
