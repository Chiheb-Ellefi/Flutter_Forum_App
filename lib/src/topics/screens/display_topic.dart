import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/data/models/topic_model/comment_model.dart';
import 'package:my_project/src/topics/components/comment.dart';
import 'package:my_project/src/topics/components/comment_alert.dart';
import 'package:my_project/src/home/components/leading_button.dart';
import 'package:my_project/src/notification/components/notif_button.dart';
import 'package:my_project/src/topics/components/rate_dialog.dart';
import 'package:my_project/src/topics/components/tag.dart';
import 'package:my_project/src/authentification/welcome/screens/welcome_page.dart';
import 'package:my_project/src/profile/screens/profile_widget.dart';
import 'package:my_project/src/topics/webservices/display_topic_service.dart';
import 'package:readmore/readmore.dart';

// ignore: must_be_immutable
class DisplayTopicWidget extends StatefulWidget {
  DisplayTopicWidget(
      {Key? key,
      required this.title,
      required this.userName,
      required this.date,
      required this.rating,
      required this.image,
      required this.text,
      required this.tags,
      required this.uid,
      required this.raters,
      required this.notifEnabled,
      required this.authorUid})
      : super(key: key);

  String uid;
  String title;
  String userName;
  DateTime date;
  double rating;
  String text;
  List<dynamic> tags;
  List<dynamic> image;
  int raters;
  bool? notifEnabled;
  String authorUid;

  @override
  State<DisplayTopicWidget> createState() => _DisplayTopicWidgetState();
}

class _DisplayTopicWidgetState extends State<DisplayTopicWidget> {
  Stream<List<CommentModel>>? commentsStream;
  StreamSubscription<List<CommentModel>>? commentsSubscription;
  List<CommentModel>? myComments;
  bool isListViewVisible = false;
  bool isCommentListVisible = false;
  bool isLiked = false;
  String len = '';
  String? authUid;
  bool? commentsEnabled;

  @override
  void initState() {
    super.initState();
    getAuthUid();
    commentsEnabled = widget.notifEnabled;
    commentsStream = service.getComments(uid: widget.uid);
    commentsSubscription = commentsStream!.listen((comments) {
      setState(() {
        myComments = comments;
        len = comments.length.toString();
      });
    });
  }

  DisplayTopicService service = DisplayTopicService();
  onSelected() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Welcome()));
  }

  final uid = FirebaseAuth.instance.currentUser!.uid;
  getAuthUid() async {
    authUid = await service.getAuthUid(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    commentsStream = service.getComments(uid: widget.uid);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            barrierDismissible: commentsEnabled!,
            context: context,
            builder: (context) {
              return CommentAlert(
                title: widget.title,
                authorUid: widget.authorUid,
                author: widget.userName,
                uid: widget.uid,
                enabled: commentsEnabled!,
                onCommentAdded: () {
                  setState(() {}); // Rebuild the widget
                },
              );
            },
          );
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        child: const Icon(FontAwesomeIcons.reply),
      ),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: MyLeadingButton(
            myContext: context,
          ),
          toolbarHeight: 70,
          actions: [
            const MyNotifButton(),
            PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black87,
                  size: 30,
                ),
                itemBuilder: (context) => [
                      if (authUid != uid)
                        PopupMenuItem(
                            onTap: () {
                              service.reportTopic(
                                  uid: uid,
                                  widgetUid: widget.uid,
                                  context: context);
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.flag,
                                  color: Colors.black87,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Report',
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            )),
                      if (authUid == uid)
                        PopupMenuItem(
                            onTap: () async {
                              await service.deleteTopic(
                                  context: context,
                                  uid: widget.uid,
                                  authUid: authUid);
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.trashCan,
                                  color: Colors.black87,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Delete',
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ))
                    ]),
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 230,
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return RatingDialog(
                                  uid: widget.uid,
                                  raters: widget.raters,
                                  rating: widget.rating,
                                );
                              },
                            );
                          },
                          child: RatingBar.builder(
                            itemBuilder: ((context, _) => const Icon(
                                  Icons.star_rate,
                                  color: Color.fromRGBO(255, 195, 0, 1),
                                )),
                            onRatingUpdate: (rating) {},
                            allowHalfRating: true,
                            initialRating: widget.raters != 0
                                ? widget.rating / widget.raters
                                : 0,
                            ignoreGestures: true,
                            itemSize: 20,
                            unratedColor: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(FontAwesomeIcons.calendar, size: 22),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Date',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${widget.date.day}/${widget.date.month}/${widget.date.year}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileWidget(uid: authUid)));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.person_outlined, size: 30),
                                  Text(
                                    'Author',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.userName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.tags.length,
                              itemBuilder: (context, index) => Tag(
                                text: widget.tags[index],
                              ),
                            ),
                          ),
                        ),
                        if (authUid == uid)
                          Switch(
                            value: commentsEnabled!,
                            activeColor: myBlue2,
                            onChanged: (bool value) async {
                              setState(() {
                                commentsEnabled = value;
                              });
                              await service.updateCommentEnabled(
                                  uid: widget.uid,
                                  commentsEnabled: commentsEnabled);
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Description',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              if (widget.image.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.image.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Image.network(
                        widget.image[index],
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              ReadMoreText(
                widget.text,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Color.fromRGBO(16, 22, 35, .600),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                trimLines: 10,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                lessStyle: const TextStyle(
                  color: myBlue1,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                moreStyle: const TextStyle(
                  color: myBlue1,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isListViewVisible = !isListViewVisible;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Comments ',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        Text(
                          len,
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(FontAwesomeIcons.message),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: isListViewVisible && commentsEnabled!,
                child: StreamBuilder<List<CommentModel>>(
                  stream: commentsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final comments = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return Comment(
                            authorUid: widget.authorUid,
                            uid: widget.uid,
                            text: comment.text!,
                            author: comment.author!,
                            date: comment.date!.millisecondsSinceEpoch,
                            likes: comment.likes,
                            replies: comment.replies!,
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Error loading comments');
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
