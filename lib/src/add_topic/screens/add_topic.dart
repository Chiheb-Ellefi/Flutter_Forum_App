import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_project/src/add_topic/webserices/add_topic_service.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/src/home/components/leading_button.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:my_project/src/notification/components/notif_button.dart';
import 'package:my_project/src/topics/components/tag_dropdown.dart';

class CreateTopicWidget extends StatefulWidget {
  const CreateTopicWidget({Key? key}) : super(key: key);

  @override
  State<CreateTopicWidget> createState() => _CreateTopicWidgetState();
}

class _CreateTopicWidgetState extends State<CreateTopicWidget> {
  AddTopicService service = AddTopicService();
  List tags = [];
  List<String> myTags = [];
  List<dynamic>? tagsList = [];
  final _title = TextEditingController();
  final _description = TextEditingController();
  final GlobalKey<TagsState> _tagKeyState = GlobalKey();
  List? topics = [];

  String str = '';
  List<File> images = [];
  final uid = FirebaseAuth.instance.currentUser!.uid;
  DocumentReference<Map<String, dynamic>> get _topic =>
      FirebaseFirestore.instance.collection(topicsCollection).doc();
  DocumentReference<Map<String, dynamic>> get _notif =>
      FirebaseFirestore.instance.collection(notifCollection).doc();
  List? myFollowers;
  TextEditingController controller = TextEditingController();

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        images.add(imageTemporary);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  void addItemToDataSource(str) {
    setState(() {
      tags.add(Item(
        title: str,
        active: true,
        index: 1,
      ));
      myTags.add(str);
    });
  }

  @override
  Widget build(BuildContext context) {
    String val = '';
    AlertDialog addTag = AlertDialog(
      content: Container(
        padding: const EdgeInsets.all(10),
        height: 200,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TagDropdown(
                      onChanged: (newValue) {
                        setState(() {
                          val = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: myBlue2,
                    child: Center(
                      child: IconButton(
                        iconSize: 15,
                        color: Colors.white,
                        onPressed: () {
                          // Call the method to add an item to the data source

                          if (val != '') {
                            addItemToDataSource(val);
                          }
                        },
                        icon: const Icon(
                          FontAwesomeIcons.plus,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const Row(children: <Widget>[
                Expanded(
                    child: Divider(
                  thickness: .5,
                  color: Colors.black87,
                )),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("OR"),
                ),
                Expanded(
                    child: Divider(
                  thickness: .5,
                  color: Colors.black87,
                )),
              ]),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tag',
                        hintText: 'Enter a tag',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: myBlue2,
                    child: Center(
                      child: IconButton(
                        iconSize: 15,
                        color: Colors.white,
                        onPressed: () {
                          str = controller.text;
                          // Call the method to add an item to the data source
                          try {
                            addItemToDataSource(
                                str.substring(0, 1).toUpperCase() +
                                    str.substring(1).toLowerCase());
                          } catch (e) {
                            print(e);
                          }
                          controller.clear();
                        },
                        icon: const Icon(
                          FontAwesomeIcons.plus,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ),
      ],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: const Text(
              'Create Topic',
              style: TextStyle(color: Colors.black87, fontSize: 25),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: MyLeadingButton(
              myContext: context,
            ),
            toolbarHeight: 70,
            actions: const [
              MyNotifButton(),
            ]),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Title',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      service.publish(
                          topic: _topic,
                          topicUid: _topic.id,
                          context: context,
                          topics: topics,
                          myFollowers: myFollowers,
                          images: images,
                          uid: uid,
                          title: _title,
                          description: _description,
                          myTags: myTags,
                          tagsList: tagsList,
                          notif: _notif);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myBlue1,
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                      child: Text(
                        'Publish',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                  controller: _title,
                  decoration: InputDecoration(
                    hintText: 'Topic title',
                    suffixIcon: IconButton(
                      onPressed: () {
                        _title.clear();
                      },
                      icon: const Icon(FontAwesomeIcons.xmark),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tags',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
                    child: const Text('Add'),
                    onPressed: () {
                      // Call the method to add an item to the data source
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return addTag;
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Tags(
                key: _tagKeyState,
                itemCount: tags.length,
                itemBuilder: (index) {
                  final tag = tags[index];
                  return ItemTags(
                    index: index,
                    title: tag.title,
                    key: Key(index.toString()),
                    active: tag.active,
                    customData: tag.customData,
                    combine: ItemTagsCombine.withTextBefore,
                    icon: ItemTagsIcon(
                      icon: Icons.add,
                    ),
                    removeButton: ItemTagsRemoveButton(
                      onRemoved: () {
                        // Remove the item from the data source.
                        setState(() {
                          // required
                          tags.removeAt(index);
                        });
                        //required
                        return true;
                      },
                    ),
                    //
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Description',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                  maxLines: 5,
                  minLines: 1,
                  controller: _description,
                  decoration: InputDecoration(
                    hintText: 'Topic description',
                    suffixIcon: IconButton(
                      onPressed: () {
                        _description.clear();
                      },
                      icon: const Icon(FontAwesomeIcons.xmark),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Images',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
                    onPressed: pickImage,
                    child: const Text('Add'),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onDoubleTap: () {
                        // Remove the image on double tap
                        removeImage(index);
                      },
                      child: Image.file(
                        images[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
