import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';
import 'package:my_project/main.dart';
import 'package:my_project/presentation/components/leadingButton.dart';
import 'package:path/path.dart' as path;
import '../../../constants/firebase_consts.dart';

class EditProile extends StatefulWidget {
  const EditProile({Key? key, required this.onProfileUpdated})
      : super(key: key);
  final VoidCallback onProfileUpdated;

  @override
  State<EditProile> createState() => _EditProileState();
}

class _EditProileState extends State<EditProile> {
  String? imageUrl;
  final user = FirebaseAuth.instance.currentUser;
  String? myPath;
  File? image;
  String? mail, name, myUrl, nameSaved, mailSaved;
  UserModel myData = UserModel();
  final _name = TextEditingController();
  final _email = TextEditingController();

  DateTime? dateTime = DateTime.now();

  final _formKey = GlobalKey<FormState>();
  CollectionReference userRef =
      FirebaseFirestore.instance.collection(usersCollection);

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    ).then((value) {
      setState(() {
        dateTime = value;
      });
    });
    // ignore: prefer_conditional_assignment
    if (dateTime == null) {
      dateTime = DateTime.now();
    }
  }

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

  uploadImage() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      if (image != null) {
        String? imageName = image != null ? path.basename(image!.path) : null;
        myPath = 'files/profile_pic/$imageName';
        final ref = FirebaseStorage.instance.ref().child(myPath!);
        await ref.putFile(image!);
        myUrl = await ref.getDownloadURL();
      }
    } catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  updateUser() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await userRef.where('uid', isEqualTo: user!.uid).get().then((value) {
        for (var element in value.docs) {
          element.reference.update({
            'email': mail == "" ? myData.email : mail,
            'username': name == "" ? myData.username : name,
            'dateOfBirth': dateTime!.millisecondsSinceEpoch,
            'profilePicture': myUrl,
          });
        }
      });
    } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
    }
    widget.onProfileUpdated();
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<void> getProfileData() async {
    await userRef
        .where(
          "uid",
          isEqualTo: user!.uid,
        )
        .get()
        .then((value) {
      for (var element in value.docs) {
        Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
        myData = UserModel.fromMap(data!);
        name = myData.username;
        mail = myData.email;
        dateTime = myData.dateOfBirth;
        myUrl = myData.profilePicture;
        print(myData);
      }
    });
    setState(() {}); // Update the widget's state after retrieving the data
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Edit profile',
              style: TextStyle(color: Colors.black87, fontSize: 25),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 70,
            leading: MyLeadingButton(myContext: context),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                ),
                iconSize: 30,
                color: Colors.black87,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(FontAwesomeIcons.bell),
                iconSize: 25,
                color: Colors.black87,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
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
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Username',
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 20)),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: _name,
                              onSaved: (value) {
                                if (value != "") {
                                  name = value;
                                }
                              },
                              decoration: const InputDecoration(
                                  label: Text('Username'),
                                  border: OutlineInputBorder())),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('Email',
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 20)),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.length > 250) {
                                return 'Email is too long';
                              } else if (value.length > 0) {
                                if (!(RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value))) {
                                  return 'mail is invalid';
                                }
                              }
                            },
                            onSaved: (value) {
                              if (value != "") {
                                mail = value;
                              }
                            },
                            controller: _email,
                            decoration: const InputDecoration(
                                label: Text('Email'),
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('Birthday',
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 20)),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: _showDatePicker,
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
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Icon(
                                    FontAwesomeIcons.calendar,
                                    size: 35,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        await uploadImage();
                        updateUser();
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
                    child: const SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          'Edit profile',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myBlue1,
                    ),
                    child: const SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
