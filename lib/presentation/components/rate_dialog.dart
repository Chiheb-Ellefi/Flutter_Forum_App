import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/firebase_consts.dart';

// ignore: must_be_immutable
class RatingDialog extends StatefulWidget {
  RatingDialog(
      {super.key,
      required this.uid,
      required this.raters,
      required this.rating});
  String uid;
  int raters;
  double rating;
  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  updateRating() async {
    CollectionReference userRef =
        FirebaseFirestore.instance.collection(topicsCollection);
    await userRef.where('uid', isEqualTo: widget.uid).get().then((value) {
      print(value.size);
      value.docs.forEach((element) {
        element.reference.update({
          'rating': widget.rating +
              rate, // Update the 'rating' field with the new rating value
          'raters': widget.raters + 1,
          // Add other fields to update here
        });
      });
    });
  }

  double rate = 1.2;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Center(
        child: Text(
          'Rating',
          style: TextStyle(fontSize: 30),
        ),
      ),
      content: RatingBar.builder(
        itemBuilder: ((context, _) => const Icon(
              Icons.star_rate,
              color: Color.fromRGBO(255, 195, 0, 1),
            )),
        onRatingUpdate: (rating) {
          setState(() {
            rate = rating;
          });
        },
        allowHalfRating: true,
        initialRating: 0,
        ignoreGestures: false,
        itemSize: 40,
        unratedColor: Colors.grey.shade300,
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              updateRating();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
            child: const Text('Rate'),
          ),
        )
      ],
    );
  }
}
