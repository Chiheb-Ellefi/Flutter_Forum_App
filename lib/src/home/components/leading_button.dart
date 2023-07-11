import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class MyLeadingButton extends StatelessWidget {
  MyLeadingButton({super.key, required this.myContext});
  BuildContext myContext;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          Navigator.pop(myContext);
        },
        icon: const Icon(FontAwesomeIcons.arrowLeft),
        iconSize: 25,
        color: Colors.black87,
      ),
    );
  }
}
