import 'package:flutter/material.dart';
import 'package:my_project/src/settings/webservices/manage_tags_service.dart';

class EditDialog extends StatefulWidget {
  const EditDialog(
      {super.key,
      required this.index,
      required this.tags,
      required this.uid,
      required this.setState});
  final index;
  final uid;
  final tags;
  final VoidCallback setState;

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  List<dynamic>? tags;
  ManageTagsService service = ManageTagsService();
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    tags = widget.tags;
    return AlertDialog(
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              setState(() {
                tags![widget.index] = controller.text.trim();
              });
              await service.update(uid: widget.uid, tags: tags);
              controller.clear();
              widget.setState();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: const Text('Edit Tag'))
      ],
    );
  }
}
