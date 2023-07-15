import 'package:flutter/material.dart';
import 'package:my_project/src/authentification/sign_in/webservices/sign_in_services.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/src/authentification/sign_in/components/sign_in_button.dart';
import 'package:my_project/src/authentification/change_password/screens/reset_password.dart';
import 'package:my_project/src/authentification/sign_up/components/sign_up_with.dart';
import 'package:my_project/src/authentification/local_sign_in/components/fingerprint_alert.dart';
import 'package:my_project/src/notification/webservcies/firebase_notification_api.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  FirebaseApi api = FirebaseApi();

  bool notShowPassword = true;
  final _formKey = GlobalKey<FormState>();
  String? mail, password;
  SignInService service = SignInService();
  Future onPressed() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      dynamic result = await service.fetchUser(
          mail: mail, password: password, context: context);
      await api.saveFcmToken();
      if (result == null) {
        print('error signing in');
      }
      print('signed in');
    }
  }

  forgotPass() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const FirstChnagePassword()));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.length > 255) {
                        return 'Email is too long';
                      } else if (!(RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value))) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      mail = value ?? "";
                    },
                    decoration: const InputDecoration(
                        label: Text('Email'), border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 56,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextFormField(
                      obscureText: notShowPassword,
                      enableSuggestions: false,
                      autocorrect: false,
                      onSaved: (value) {
                        password = value ?? "";
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                notShowPassword = !notShowPassword;
                              });
                            },
                            icon: notShowPassword
                                ? const Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.black87,
                                    size: 20,
                                  )
                                : const Icon(
                                    Icons.remove_red_eye,
                                    size: 20,
                                  ),
                          ),
                          label: Text('Password'),
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
            MyButton(
              text: 'Login',
              color: myBlue4,
              backColor: myBlue1,
              onPressed: onPressed,
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: forgotPass,
              child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: myBlue1,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400),
                  ))),
            ),
            const SizedBox(
              height: 70,
            ),
            const SizedBox(
              width: double.infinity,
              child: SignUpFrom(),
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Row(children: <Widget>[
                Expanded(
                    child: Divider(
                  thickness: 2,
                )),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "OR",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                    child: Divider(
                  thickness: 2,
                )),
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        const FingerPrintAlert());
              },
              child: Column(
                children: [
                  Image.asset('assets/fingerprint.png', width: 70),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Use fingerprint',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 18),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
