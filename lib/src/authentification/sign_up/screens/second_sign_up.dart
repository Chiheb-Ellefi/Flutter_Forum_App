import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/src/authentification/sign_in/components/sign_in_button.dart';
import 'package:my_project/src/authentification/sign_up/components/sign_up_with.dart';
import 'package:my_project/src/authentification/sign_up/screens/terms_alert.dart';

// ignore: must_be_immutable
class SecondSignUp extends StatefulWidget {
  SecondSignUp(
      {super.key,
      required this.mail,
      required this.password,
      required this.myImage});
  String mail = '', password = '';
  File? myImage;

  @override
  State<SecondSignUp> createState() => _SecondSignUpState();
}

class _SecondSignUpState extends State<SecondSignUp> {
  String name = '';
  PhoneNumber? number;
  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return widget.myImage;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: ${e}');
    }
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: dateTime ?? DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          dateTime = value;
        });
      }
    });
  }

  final _formKey2 = GlobalKey<FormState>();

  DateTime? dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    onPressed() {
      if (_formKey2.currentState!.validate()) {
        _formKey2.currentState!.save();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return TermsAlert(
              mail: widget.mail,
              password: widget.password,
              dob: dateTime,
              phoneNumber: number.toString(),
              userName: name,
              myImage: image,
            );
          },
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 100,
        title: const Text(
          'Sign up',
          style:
              TextStyle(color: Colors.black, fontFamily: 'Inter', fontSize: 25),
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
        child: Center(
          child: Form(
              key: _formKey2,
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
                            : widget.myImage != null
                                ? Image.file(
                                    widget.myImage!,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset('assets/addimage.gif'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Invalid username';
                        }
                      },
                      onSaved: (value) {
                        name = value ?? "";
                      },
                      decoration: const InputDecoration(
                          label: Text('Username'),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: IntlPhoneField(
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        initialCountryCode: 'TN',
                        onChanged: (phone) {
                          number = phone;
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            '${dateTime!.day.toString()} / ${dateTime!.month.toString()} / ${dateTime!.year.toString()}',
                            style: const TextStyle(
                                fontFamily: 'Inter', fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: IconButton(
                            onPressed: _showDatePicker,
                            icon: const Icon(
                              FontAwesomeIcons.calendar,
                              size: 35,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyButton(
                      text: 'Sign Up',
                      color: myBlue4,
                      backColor: myBlue1,
                      onPressed: onPressed),
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
              )),
        ),
      ),
    );
  }
}
