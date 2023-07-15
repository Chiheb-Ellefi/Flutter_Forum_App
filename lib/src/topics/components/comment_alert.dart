// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/src/topics/webservices/comment_service.dart';

class CommentAlert extends StatefulWidget {
  CommentAlert({
    Key? key,
    required this.token,
    required this.topicUid,
    required this.author,
    required this.enabled,
    required this.authorUid,
    required this.title,
    required this.onCommentAdded,
  });

  String topicUid;
  String token;
  String author;
  bool enabled;
  String authorUid;
  String title;
  final Function() onCommentAdded;
  @override
  State<CommentAlert> createState() => _CommentAlertState();
}

class _CommentAlertState extends State<CommentAlert> {
  DocumentReference<Map<String, dynamic>> get _notif =>
      FirebaseFirestore.instance.collection(notifCollection).doc();

  CommentService service = CommentService();
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.enabled) {
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
                  service.addComment(
                      token: widget.token,
                      title: widget.title,
                      author: widget.author,
                      controller: _controller,
                      topicUid: widget.topicUid,
                      userUid: userUid,
                      authorUid: widget.authorUid,
                      onCommentAdded: widget.onCommentAdded);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
              child: const Text('Comment'),
            ),
          )
        ],
      );
    } else {
      return AlertDialog(
        title: const Text('Comment'),
        content: const Text(
          'The author has disabled the comments',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
              child: const Text('Go back '),
            ),
          )
        ],
      );
    }
  }
}
