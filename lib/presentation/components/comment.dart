import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/notification_model/notif_model.dart';
import 'package:my_project/data/models/topic_model/comment_model.dart';
import 'package:my_project/main.dart';

// ignore: must_be_immutable
class Comment extends StatefulWidget {
  Comment(
      {super.key,
      required this.authorUid,
      required this.author,
      required this.text,
      required this.date,
      required this.likes,
      required this.replies,
      required this.uid});
  String author;
  String text;
  int date;
  List<dynamic>? likes;
  List<dynamic> replies;
  String authorUid;

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

    for (final element in value.docs) {
      final QuerySnapshot snapshot = await element.reference
          .collection('${widget.uid}comments')
          .where('date', isEqualTo: widget.date)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var element in snapshot.docs) {
          element.reference.update({
            'likes': likes,
          });
        }
      }
    }
  }

  final reply = TextEditingController();
  CommentModel? myReply;
  CommentModel getReply() {
    CommentModel myReply = CommentModel(
      author: widget.author,
      text: reply.text.trim(),
      likes: [],
      date: DateTime.now(),
      replies: [],
    );
    return myReply;
  }

  DocumentReference<Map<String, dynamic>> get _notif =>
      FirebaseFirestore.instance.collection(notifCollection).doc();
  replyNotif({notified}) async {
    final DocumentReference<Map<String, dynamic>> notifRef = _notif;
    final notifUid = notifRef.id;
    NotificationModel notif = NotificationModel(
        uid: notifUid,
        notified: notified,
        date: DateTime.now(),
        notifier: userUid,
        notification: 'just replied to your comment "${widget.text}"');
    await notifRef.set(notif.toMap());
  }

  likeNotif({notified}) async {
    final DocumentReference<Map<String, dynamic>> notifRef = _notif;
    final notifUid = notifRef.id;
    NotificationModel notif = NotificationModel(
        uid: notifUid,
        notified: notified,
        date: DateTime.now(),
        notifier: userUid,
        notification: 'just liked your comment "${widget.text}"');
    await notifRef.set(notif.toMap());
  }

  updateReplies() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      final queryTopic = FirebaseFirestore.instance
          .collection(topicsCollection)
          .where('uid', isEqualTo: widget.uid)
          .get();

      final value = await queryTopic;
      final commentsList = <CommentModel>[];
      List<dynamic> replies = widget.replies;
      replies.add(myReply!.toMap());
      for (final element in value.docs) {
        final QuerySnapshot snapshot = await element.reference
            .collection(widget.uid + 'comments')
            .where('date', isEqualTo: widget.date)
            .get();

        if (snapshot.docs.isNotEmpty) {
          for (var element in snapshot.docs) {
            element.reference.update({
              'replies': replies,
            }).then((_) {
              reply.clear(); // Clear the text editing controller
            });
          }
        }
      }
      if (widget.authorUid != userUid) {
        await replyNotif(notified: widget.authorUid);
      }
    } catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  bool isCommentListVisible = false;
  List<dynamic>? likes;
  bool? isLiked;
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  Icon? myIcon;
  List<dynamic>? myComments;
  List<dynamic>? myReplies;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    likes = widget.likes;
    isLiked = widget.likes!.contains(userUid);
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(widget.date);
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color:
            isCommentListVisible ? Colors.grey.shade400 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
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
                              color: Colors.black87,
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
                    onPressed: () async {
                      if (isLiked!) {
                        likes!.remove(userUid);
                        setState(() {
                          isLiked = !isLiked!;
                        });
                      } else {
                        likes!.add(userUid);
                        setState(() {
                          isLiked = !isLiked!;
                        });
                        if (userUid != widget.authorUid) {
                          await likeNotif(notified: widget.authorUid);
                        }
                      }
                      updateLike();
                    },
                    icon: Icon(
                      isLiked! ? Icons.favorite_rounded : Icons.favorite_border,
                      color: isLiked! ? Colors.red : Colors.black,
                      size: 28,
                    ),
                  ),
                  Text(likes!.length.toString(),
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
                        isCommentListVisible = !isCommentListVisible;
                      });
                    },
                    icon: Icon(
                        isCommentListVisible
                            ? FontAwesomeIcons.solidMessage
                            : FontAwesomeIcons.message,
                        color: Colors.black87),
                  ),
                  Text(
                    widget.replies.length.toString(),
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ],
          ),
          if (isCommentListVisible)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: TextField(
                    controller: reply,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (reply.text.trim() != '') {
                              myReply = getReply();
                              reply.clear();
                              updateReplies();
                            }
                          },
                          icon: const Icon(
                            FontAwesomeIcons.reply,
                            color: Colors.black87,
                          ),
                        ),
                        hintText: 'Reply to this comment '),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.replies.length,
                  itemBuilder: (context, index) {
                    final comment = widget.replies[index];
                    return Comment(
                      authorUid: widget.authorUid,
                      uid: widget.uid,
                      text: comment['text'],
                      author: comment['author'],
                      date: comment['date'],
                      likes: comment['likes'],
                      replies: comment['replies'],
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
