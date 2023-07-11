import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/src/topics/webservices/rating_service.dart';

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
  double rate = 0.0;
  RateService service = RateService();
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
              service.updateRating(
                  uid: widget.uid,
                  rate: rate,
                  raters: widget.raters,
                  rating: widget.rating);
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
