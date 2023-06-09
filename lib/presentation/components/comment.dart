import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/topic_model/comment_model.dart';

// ignore: must_be_immutable
class Comment extends StatefulWidget {
  Comment(
      {super.key,
      required this.author,
      required this.text,
      required this.date,
      required this.likes,
      required this.replies,
      required this.isCommentListVisible,
      required this.isLiked,
      required this.uid});
  String author;
  String text;
  int date;
  int likes;
  int replies;
  bool isCommentListVisible;
  bool isLiked;
  String uid;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  updateLike() async {
    final queryTopic = FirebaseFirestore.instance
        .collection(topicsCollection)
        .where('uid', isEqualTo: widget.uid)
        .get();

    final value = await queryTopic;
    final commentsList = <CommentModel>[];

    for (final element in value.docs) {
      final QuerySnapshot snapshot = await element.reference
          .collection(widget.uid + 'comments')
          .where('date', isEqualTo: widget.date)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final comments = snapshot.docs.forEach((element) {
          element.reference.update({'likes': likes, 'isLiked': isLiked});
        });
      }
    }
  }

  int likes = 0;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(widget.date);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person_outlined, size: 30),
                        Text(widget.author,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    ),
                    Text('${date.day}/${date.month}/${date.year}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        )),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.trashCan),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Delete')
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            widget.text,
            style: const TextStyle(
              color: Color.fromRGBO(16, 22, 35, .600),
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.isLiked = !widget.isLiked;
                        widget.likes = widget.isLiked
                            ? widget.likes + 1
                            : widget.likes - 1;
                        likes = widget.likes;
                        isLiked = widget.isLiked;
                      });
                      updateLike();
                    },
                    icon: Icon(
                      widget.isLiked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border,
                      color: widget.isLiked ? Colors.red : Colors.black,
                      size: 28,
                    ),
                  ),
                  Text(widget.likes.toString(),
                      style: const TextStyle(fontSize: 17)),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.isCommentListVisible =
                            !widget.isCommentListVisible;
                      });
                    },
                    icon: Icon(
                        widget.isCommentListVisible
                            ? FontAwesomeIcons.solidMessage
                            : FontAwesomeIcons.message,
                        color: Colors.black87),
                  ),
                  Text(
                    widget.replies.toString(),
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ],
          ),
          if (widget.isCommentListVisible)
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.replies,
                itemBuilder: (context, index) => Comment(
                  uid: widget.uid,
                  text: "Reply $index", // Replace with actual comment text
                  author: 'Author $index', // Replace with actual author name
                  date: widget.date,
                  likes: 200, // Replace with actual likes count
                  replies: 10, // Replace with actual replies count
                  isLiked: false, // Replace with actual liked status
                  isCommentListVisible:
                      false, // Replace with actual visibility status
                ),
              ),
            ),
        ],
      ),
    );
  }
}
