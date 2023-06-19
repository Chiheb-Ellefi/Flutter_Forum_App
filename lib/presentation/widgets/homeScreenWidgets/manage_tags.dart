import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/tags_model/tags_model.dart';
import 'package:my_project/presentation/components/leadingButton.dart';
import 'package:my_project/presentation/components/notification/notif_button.dart';

class ManageTags extends StatefulWidget {
  const ManageTags({super.key});

  @override
  State<ManageTags> createState() => _ManageTagsState();
}

class _ManageTagsState extends State<ManageTags> {
  List<dynamic>? tags;

  final uid = FirebaseAuth.instance.currentUser!.uid;

  TagsModel myData = TagsModel();
  final controller = TextEditingController();
  Future<void> getTags() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(tagsCollection)
        .doc(uid)
        .get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    myData = TagsModel.fromMap(data!);
    tags = myData.tags;
  }

  showDeleteDialog({index}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              content: const Text(
                "Are you sure you want to delete this tag this can't be undone",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const SizedBox(
                      width: 100,
                      height: 40,
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () async {
                      setState(() {
                        tags!.removeAt(index);
                      });
                      await update();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    child: const SizedBox(
                      width: 100,
                      height: 40,
                      child: Center(
                        child: Text(
                          'Delete',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )),
              ],
            ));
  }

  showMyDialog({index}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        tags![index] = controller.text.trim();
                      });
                      await update();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    child: const Text('Edit Tag'))
              ],
            ));
  }

  update() async {
    await FirebaseFirestore.instance
        .collection(tagsCollection)
        .doc(uid)
        .update({'tags': tags});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Manage Tags',
            style: TextStyle(color: Colors.black87, fontSize: 25),
          ),
          centerTitle: true,
          leading: MyLeadingButton(myContext: context),
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 70,
          actions: const [
            MyNotifButton(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<void>(
            future: getTags(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading indicator while fetching the tags
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Show an error message if there's an error
                return const Text('Error loading tags');
              } else {
                return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                          color: Colors.grey,
                        ),
                    itemCount: tags!.length,
                    itemBuilder: (context, index) => ListTile(
                          title: Text(
                            tags![index],
                            style: const TextStyle(fontSize: 20),
                          ),
                          trailing: PopupMenuButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.black87,
                                size: 30,
                              ),
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                        onTap: () {
                                          showMyDialog(index: index);
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.penToSquare,
                                              color: Colors.black87,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Edit',
                                              style: TextStyle(fontSize: 15),
                                            )
                                          ],
                                        )),
                                    PopupMenuItem(
                                        onTap: () {
                                          showDeleteDialog(index: index);
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.trashCan,
                                              color: Colors.black87,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Delete',
                                              style: TextStyle(fontSize: 15),
                                            )
                                          ],
                                        ))
                                  ]),
                        ));
              }
            },
          ),
        ),
      ),
    );
  }
}
