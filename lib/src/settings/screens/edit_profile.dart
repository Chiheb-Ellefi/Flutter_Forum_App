import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/src/home/components/leading_button.dart';
import 'package:my_project/src/notification/components/notif_button.dart';
import 'package:my_project/src/settings/webservices/edit_profile_service.dart';

class EditProile extends StatefulWidget {
  const EditProile({Key? key, required this.onProfileUpdated})
      : super(key: key);
  final VoidCallback onProfileUpdated;

  @override
  State<EditProile> createState() => _EditProileState();
}

class _EditProileState extends State<EditProile> {
  String? imageUrl;

  File? image;
  String? mail, name, myUrl, nameSaved, mailSaved;
  UserModel myData = UserModel();
  final _name = TextEditingController();
  final _email = TextEditingController();

  DateTime? dateTime = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  EditProfileService service = EditProfileService();
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
      print('Failed to pick image:${e}');
    }
  }

  getProfile() async {
    myData = await service.getProfileData(myData: myData);
    setState(() {
      name = myData.username;
      mail = myData.email;
      dateTime = myData.dateOfBirth;
      myUrl = myData.profilePicture;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getProfile();
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
            actions: const [
              MyNotifButton(),
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
                              } else if (value.isNotEmpty) {
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
                        myUrl = await service.uploadImage(
                            context: context, image: image);
                        // ignore: use_build_context_synchronously
                        await service.updateUser(
                            context: context,
                            mail: mail,
                            myData: myData,
                            name: name,
                            dateTime: dateTime,
                            myUrl: myUrl,
                            onProfileUpdated: widget.onProfileUpdated);
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
