import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/src/add_topic/webserices/add_topic_service.dart';
import 'package:my_project/src/topics/components/tag.dart';
import 'package:my_project/src/topics/screens/display_topic.dart';

// ignore: must_be_immutable
class Topic extends StatefulWidget {
  Topic(
      {super.key,
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
      required this.authorUid});
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
  String? authorUid;

  @override
  State<Topic> createState() => _TopicState();
}

class _TopicState extends State<Topic> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      getUserToken();
    }
  }

  String? mToken;
  getToken() async {
    AddTopicService service = AddTopicService();
    final token = await service.getToken(widget.authorUid);
    return token;
  }

  getUserToken() async {
    mToken = await getToken();
  }

  bool isAnonymous = FirebaseAuth.instance.currentUser!.isAnonymous;

  onPressed() {
    if (!isAnonymous) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DisplayTopicWidget(
                token: mToken!,
                authorUid: widget.authorUid!,
                uid: widget.uid,
                title: widget.title,
                userName: widget.userName,
                date: widget.date,
                rating: widget.rating,
                image: widget.image,
                text: widget.text,
                tags: widget.tags,
                raters: widget.raters,
                notifEnabled: widget.notifEnabled,
              )));
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
                content: const Text(
                  'To access the detailed topic information, please sign in to your account.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: myBlue3),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:
                          const Text('Cancel', style: TextStyle(fontSize: 20))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                      child:
                          const Text('Sign in', style: TextStyle(fontSize: 20)))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(Icons.person, size: 30, color: Colors.grey),
                    Text(widget.userName,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.date.day}/${widget.date.month}/${widget.date.year}',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                    RatingBar.builder(
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
                      unratedColor: Colors.grey.shade200,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.image.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
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
                Text(
                  widget.text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      color: Color.fromRGBO(16, 22, 35, .600),
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.tags.length,
                            itemBuilder: (context, index) => Tag(
                                  text: widget.tags[index],
                                )),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        FontAwesomeIcons.comment,
                        size: 25,
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
