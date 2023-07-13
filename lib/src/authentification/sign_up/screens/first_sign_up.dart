import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/src/authentification/sign_in/components/sign_in_button.dart';
import 'package:my_project/src/authentification/sign_up/components/sign_up_with.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

import 'package:my_project/src/authentification/sign_up/screens/second_sign_up.dart';

class FirstSignUp extends StatefulWidget {
  const FirstSignUp({super.key});

  @override
  State<FirstSignUp> createState() => _FirstSignUpState();
}

class _FirstSignUpState extends State<FirstSignUp> {
  final _formKey = GlobalKey<FormState>();
  String _mail = '', _password = '', _confirm = '';
  bool notShowPassword = true;
  bool notShowConfirmPassword = true;
  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    onPressed() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SecondSignUp(
                  mail: _mail,
                  password: _password,
                  myImage: image,
                )));
      }
    }

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
            'Sign up',
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
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: image != null
                          ? Image.file(
                              image!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : Image.asset('assets/addimage.gif'),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.length > 250) {
                            return 'Email is too long';
                          } else if (!(RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value))) {
                            return 'mail is invalid';
                          }
                        },
                        onSaved: (value) {
                          _mail = value ?? "";
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
                          onChanged: (value) {
                            _password = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is required';
                            }
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
                              label: const Text('Password'),
                              border: const OutlineInputBorder()),
                        ),
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
                          obscureText: notShowConfirmPassword,
                          enableSuggestions: false,
                          autocorrect: false,
                          onSaved: (value) {
                            _confirm = value ?? "";
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Confirm please your password';
                            } else if (value != _password) {
                              return 'Password do not match';
                            }
                          },
                          decoration: InputDecoration(
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    notShowConfirmPassword =
                                        !notShowConfirmPassword;
                                  });
                                },
                                icon: notShowConfirmPassword
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
                              label: Text('Confirm password'),
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                MyButton(
                  text: 'Next',
                  color: myBlue4,
                  backColor: myBlue1,
                  onPressed: onPressed,
                ),
                const SizedBox(
                  height: 25,
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
                      child: Text("OR"),
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
                const Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: SignUpFrom(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
