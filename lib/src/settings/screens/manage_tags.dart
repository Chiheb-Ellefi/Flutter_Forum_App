import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/src/home/components/leading_button.dart';
import 'package:my_project/src/notification/components/notif_button.dart';
import 'package:my_project/src/settings/components/edit_tags/delete_tags.dart';
import 'package:my_project/src/settings/components/edit_tags/edit_dialog.dart';
import 'package:my_project/src/settings/webservices/manage_tags_service.dart';

class ManageTags extends StatefulWidget {
  const ManageTags({super.key});

  @override
  State<ManageTags> createState() => _ManageTagsState();
}

ManageTagsService service = ManageTagsService();
List<dynamic>? tags;
final uid = FirebaseAuth.instance.currentUser!.uid;

class _ManageTagsState extends State<ManageTags> {
  getMyTags() async {
    tags = await service.getTags(uid: uid, tags: tags);
  }

  showDeleteDialog({index}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => DeleteDialog(
              index: index,
              tags: tags,
              uid: uid,
              setState: () {
                setState(() {});
              },
            ));
  }

  showMyDialog({index}) {
    showDialog(
        context: context,
        builder: (context) => EditDialog(
              index: index,
              uid: uid,
              tags: tags,
              setState: () {
                setState(() {});
              },
            ));
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
            future: getMyTags(),
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
