import 'package:flutter/material.dart';
import 'package:my_project/presentation/pages/addTopic/addTopic.dart';
import 'package:my_project/presentation/pages/authentification/LoginPage.dart';

import 'package:my_project/presentation/pages/authentification/fingerPrintAuth.dart';
import 'package:my_project/presentation/pages/authentification/signUp.dart';

import 'package:my_project/presentation/pages/authentification/welcome_page.dart';

import '../constants/strings.dart';

class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => const Welcome());
      case signUp:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignUp());
      case fingerPrintAuth:
        return MaterialPageRoute(
            builder: (BuildContext context) => const FingerPrintPage());
      case loginPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage());
      case addtopic:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CreateTopic());

      default:
        // Handle unknown routes here
        return null;
    }
  }
}
