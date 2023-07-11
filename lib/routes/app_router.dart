import 'package:flutter/material.dart';
import 'package:my_project/src/authentification/sign_up/screens/first_sign_up.dart';

import 'package:my_project/src/authentification/sign_in/screens/login_screen.dart';

import 'package:my_project/src/authentification/local_sign_in/screens/finger_print_auth.dart';

import 'package:my_project/src/authentification/welcome/screens/welcome_page.dart';
import 'package:my_project/src/add_topic/screens/add_topic.dart';

import '../constants/strings.dart';

class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => const Welcome());
      case signUp:
        return MaterialPageRoute(
            builder: (BuildContext context) => const FirstSignUp());
      case fingerPrintAuth:
        return MaterialPageRoute(
            builder: (BuildContext context) => const FingerPrintPage());
      case loginPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage());
      case addtopic:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CreateTopicWidget());

      default:
        // Handle unknown routes here
        return null;
    }
  }
}
