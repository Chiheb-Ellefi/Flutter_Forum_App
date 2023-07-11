import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Tag extends StatefulWidget {
  Tag({super.key, required this.text});
  String text;
  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Center(
          child: Text(
            '#${widget.text}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
