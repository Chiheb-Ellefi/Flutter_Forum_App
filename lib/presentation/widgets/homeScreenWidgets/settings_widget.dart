import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/contant_values.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/presentation/pages/profile/edit_profile.dart';
import 'package:my_project/routes/app_router.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String? image, userName, email;

  String uid = FirebaseAuth.instance.currentUser!.uid;

  UserModel myData = UserModel();

  CollectionReference userRef =
      FirebaseFirestore.instance.collection(usersCollection);
  void handleProfileUpdated() {
    // Perform any necessary actions after profile update, such as fetching updated data
    getProfilePic();
  }

  Future<void> getProfilePic() async {
    await userRef
        .where(
          "uid",
          isEqualTo: uid,
        )
        .get()
        .then((value) {
      value.docs.forEach((element) {
        Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
        myData = UserModel.fromMap(data!);
        image = myData.profilePicture;
        userName = myData.username;
        email = myData.email;
      });
    });
    setState(() {}); // Update the widget's state after retrieving the data
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getProfilePic();
  }

  bool light0 = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.black87, fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 70,
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
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 70,
                foregroundImage: NetworkImage(
                  image ?? avatarDefault,
                ),
                child: const Icon(
                  FontAwesomeIcons.camera,
                  size: 50,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                userName ?? '',
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                email ?? '',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => EditProile(
                              onProfileUpdated: handleProfileUpdated)));
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0, backgroundColor: myBlue2),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Prefrences',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Expanded(
                  child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.bell,
                      size: 25,
                    ),
                    title: const Text(
                      'Notifications',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Switch(
                      value: light0,
                      activeColor: myBlue2,
                      onChanged: (bool value) {
                        setState(() {
                          light0 = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.tags,
                      size: 25,
                    ),
                    title: const Text(
                      'Manage Tags',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.chevronRight,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.globe,
                      size: 25,
                    ),
                    title: const Text(
                      'Language',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.chevronRight,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.lock,
                      size: 25,
                    ),
                    title: const Text(
                      'Change Password',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.chevronRight,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: const ListTile(
                      leading: Icon(
                        FontAwesomeIcons.rightFromBracket,
                        size: 25,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
