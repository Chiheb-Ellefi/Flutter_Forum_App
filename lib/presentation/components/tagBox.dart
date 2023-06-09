import 'package:flutter/material.dart';
import 'package:my_project/config/themes.dart';

// ignore: must_be_immutable
class TagBox extends StatefulWidget {
  TagBox({super.key, required this.text, required this.enabled});
  String text;
  bool enabled;

  @override
  State<TagBox> createState() => _TagBoxState();
}

class _TagBoxState extends State<TagBox> {
  @override
  Widget build(BuildContext context) {
    Color myColor = widget.enabled ? myBlue1 : Colors.black87;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: myColor,
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
                fontSize: 15, color: myColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
