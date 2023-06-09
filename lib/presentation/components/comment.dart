import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      required this.isLiked});
  String author;
  String text;
  String date;
  String likes;
  String replies;
  bool isCommentListVisible;
  bool isLiked;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.person_outlined, size: 30),
                    Row(
                      children: [
                        Text(widget.author,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(widget.date,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    )
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
                            ? (int.parse(widget.likes) + 1).toString()
                            : (int.parse(widget.likes) - 1).toString();
                      });
                    },
                    icon: Icon(
                      widget.isLiked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border,
                      color: widget.isLiked ? Colors.red : Colors.black,
                      size: 28,
                    ),
                  ),
                  Text(widget.likes, style: const TextStyle(fontSize: 17)),
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
                    widget.replies,
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
                itemCount: int.parse(widget.replies),
                itemBuilder: (context, index) => Comment(
                  text: "Reply $index", // Replace with actual comment text
                  author: 'Author $index', // Replace with actual author name
                  date: widget.date,
                  likes: '200', // Replace with actual likes count
                  replies: '10', // Replace with actual replies count
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
