import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpFrom extends StatelessWidget {
  const SignUpFrom({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.facebook,
                size: 50,
                color: Colors.blue.shade600,
              ),
              const Icon(
                FontAwesomeIcons.googlePlus,
                size: 50,
                color: Colors.red,
              ),
              const Icon(
                FontAwesomeIcons.apple,
                size: 50,
              )
            ],
          ),
        ),
      ],
    );
  }
}
