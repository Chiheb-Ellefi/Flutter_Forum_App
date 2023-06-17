import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/tags_model/tags_model.dart';
import 'package:my_project/data/models/topic_model/topic_model.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/main.dart';
import 'package:my_project/presentation/components/leadingButton.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:my_project/presentation/components/tag_dropdown.dart';
import 'package:path/path.dart' as path;

class CreateTopicWidget extends StatefulWidget {
  const CreateTopicWidget({Key? key}) : super(key: key);

  @override
  State<CreateTopicWidget> createState() => _CreateTopicWidgetState();
}

class _CreateTopicWidgetState extends State<CreateTopicWidget> {
  /* @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addTags();
  }

  addTags() async {
    TagsModel tagsModel = TagsModel(uid: uid, tags: ['hello', 'hi', 'chiheb']);
    await FirebaseFirestore.instance
        .collection(tagsCollection)
        .doc(uid)
        .set(tagsModel.toMap());
  } */

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

  Future updateTags() async {
    TagsModel myData = TagsModel();
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(tagsCollection)
        .doc(uid)
        .get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    myData = TagsModel.fromMap(data!);
    tagsList = myData.tags;
    tagsList!.addAll(myTags);
    tagsList = (tagsList!.toSet()).toList();
    await FirebaseFirestore.instance
        .collection(tagsCollection)
        .doc(uid)
        .update({'tags': tagsList});
  }

  Future publish() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      UserModel myData = UserModel();
      CollectionReference userRef =
          FirebaseFirestore.instance.collection(usersCollection);

      String userName = '';
      List<String>? myImages = [];
      DocumentSnapshot snapshot = await userRef.doc(uid).get();
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      myData = UserModel.fromMap(data!);
      userName = myData.username!;
      topics = myData.topics;
      String myPath;
      String imageUrl;
      //get images url and upload them to firestore storage
      if (images.isNotEmpty) {
        for (var image in images) {
          String? imageName = path.basename(image.path);
          myPath = 'files/topics_pic/${myData.uid}/$imageName';
          final ref = FirebaseStorage.instance.ref().child(myPath);
          await ref.putFile(image);
          imageUrl = await ref.getDownloadURL();
          myImages.add(imageUrl);
        }
      }

      TopicModel topicModel = TopicModel(
        uid: _topic.id,
        title: _title.text.trim(),
        description: _description.text.trim(),
        author: userName,
        date: DateTime.now(),
        rating: 0,
        raters: 0,
        tags: myTags,
        files: myImages,
        authorUid: uid,
      );
      topics!.add(_topic.id);
      await _topic.set(topicModel.toMap());
      await userRef.doc(uid).update({'topics': topics});
      updateTags();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  TextEditingController controller = TextEditingController();
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
                          addItemToDataSource(
                              str.substring(0, 1).toUpperCase() +
                                  str.substring(1).toLowerCase());

                          // Close the dialog
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
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(FontAwesomeIcons.bell),
                iconSize: 25,
                color: Colors.black87,
              ),
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
                    onPressed: publish,
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
                    child: const Text('Add'),
                    onPressed: pickImage,
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
