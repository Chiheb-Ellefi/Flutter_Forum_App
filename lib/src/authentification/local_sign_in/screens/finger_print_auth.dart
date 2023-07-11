import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/src/authentification/sign_in/components/sign_in_button.dart';
import 'package:my_project/src/authentification/welcome/screens/welcome_page.dart';

class FingerPrintPage extends StatelessWidget {
  const FingerPrintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 100,
          title: const Text(
            'Configure fingerprint',
            style: TextStyle(
                color: Colors.black, fontFamily: 'Inter', fontSize: 25),
          ),
          leading: IconButton(
            icon: const Icon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              'assets/fingerprint.png',
              width: 150,
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Fingerprint Authentication',
              style: TextStyle(fontFamily: 'Inter', fontSize: 30),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              width: 300,
              child: Text(
                'Authenticate using your fingerprint instead of your password',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Inter', fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
                text: 'Configure',
                color: myBlue4,
                backColor: myBlue1,
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                }),
            Expanded(
              flex: 1,
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Welcome()));
                  },
                  child: Container(
                      width: double.infinity,
                      height: 100,
                      child: const Center(
                          child: Text(
                        "Don't want to use fingerprint ",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400),
                      ))),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
