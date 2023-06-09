import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/presentation/components/comment.dart';
import 'package:my_project/presentation/components/tag.dart';
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
      required this.raters})
      : super(key: key);
  String uid;
  String title;
  String userName;
  DateTime date;
  double rating;
  String text;
  List<String> tags;
  List<String> image;
  int raters;

  @override
  State<DisplayTopicWidget> createState() => _DisplayTopicWidgetState();
}

class _DisplayTopicWidgetState extends State<DisplayTopicWidget> {
  bool isListViewVisible = false;
  bool isCommentListVisible = false;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                        onTap: () async {
                          /*  await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return RatingDialog(
                                uid: widget.uid,
                                raters: widget.raters,
                                rating: widget.rating,
                              );
                            },
                          ); */
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
                      Column(
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
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Comments',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.message,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (isListViewVisible)
              ListView.builder(
                shrinkWrap:
                    true, // Allow the ListView to take up all available vertical space
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scrolling for the ListView
                itemCount: 5,
                itemBuilder: (context, index) => Comment(
                  text: "its a very good topic  its a very good topic ",
                  author: 'Chiheb Ellefi',
                  date: '',
                  likes: '200',
                  isLiked: isLiked,
                  replies: '200',
                  isCommentListVisible: isCommentListVisible,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
