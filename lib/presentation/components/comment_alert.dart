// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/topic_model/comment_model.dart';

class CommentAlert extends StatefulWidget {
  CommentAlert({super.key, required this.uid, required this.author});

  String uid;
  String author;

  @override
  State<CommentAlert> createState() => _CommentAlertState();
}

class _CommentAlertState extends State<CommentAlert> {
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  final _controller = TextEditingController();
  addComment() async {
    try {
      CommentModel myComment = CommentModel(
        author: widget.author,
        text: _controller.text.trim(),
        likes: [],
        date: DateTime.now(),
        replies: [],
      );

      CollectionReference topicRef =
          FirebaseFirestore.instance.collection(topicsCollection);
      QuerySnapshot querySnapshot =
          await topicRef.where('uid', isEqualTo: widget.uid).get();
      for (var element in querySnapshot.docs) {
        element.reference
            .collection('${widget.uid}comments')
            .add(myComment.toMap());
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Comment'),
      content: TextField(
        controller: _controller,
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                addComment();
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
            child: const Text('Comment'),
          ),
        )
      ],
    );
  }
}
