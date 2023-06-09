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
import 'package:my_project/data/models/topic_model/topic_model.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/main.dart';
import 'package:my_project/presentation/components/leadingButton.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:path/path.dart' as path;

class CreateTopicWidget extends StatefulWidget {
  const CreateTopicWidget({super.key});

  @override
  State<CreateTopicWidget> createState() => _CreateTopicWidgetState();
}

class _CreateTopicWidgetState extends State<CreateTopicWidget> {
  List tags = [];
  List<String> myTags = [];
  final _title = TextEditingController();
  final _description = TextEditingController();
  final GlobalKey<TagsState> _tagKeyState = GlobalKey();
  String str = '';
  List<File> images = [];
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

  Future publish() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      UserModel myData = UserModel();
      CollectionReference userRef =
          FirebaseFirestore.instance.collection(usersCollection);

      String userName = '';
      List<String>? myImages = [];
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
          userName = myData.username!;
        });
      });
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
      await _topic.set(topicModel.toMap());
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    AlertDialog addTag = AlertDialog(
      content: Tags(
        textField: TagsTextField(
          textStyle: const TextStyle(fontSize: 15),
          constraintSuggestion: true,
          onChanged: (value) {
            str = value;
          },
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
          onPressed: () {
            // Call the method to add an item to the data source
            addItemToDataSource(str);
            Navigator.pop(context);
          },
          child: const Text('Add tag'),
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
