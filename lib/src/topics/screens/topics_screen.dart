import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_project/data/models/topic_model/topic_model.dart';
import 'package:my_project/data/webservices/get_topic/get_topics.dart';
import 'package:my_project/src/notification/components/notif_button.dart';
import 'package:my_project/src/topics/components/tagBox.dart';
import 'package:my_project/src/topics/screens/topic.dart';
import 'package:my_project/src/topics/webservices/topics_service.dart';

class TopicsWidget extends StatefulWidget {
  const TopicsWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TopicsWidgetState createState() => _TopicsWidgetState();
}

class _TopicsWidgetState extends State<TopicsWidget> {
  List<String> tags = [];
  final myTags = <String>[];
  late Query<TopicModel> queryTopic;
  TextEditingController searchController = TextEditingController();
  TopicsServices service = TopicsServices();
  String search = '';
  bool isTagEnabled(String tag) {
    return myTags.contains(tag);
  }

  getTags() async {
    tags = await service.getTags();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTags();
  }

  String _capitalizeFirstLetter(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  void toggleTag(String tag) {
    setState(() {
      if (isTagEnabled(tag)) {
        myTags.remove(tag);
      } else {
        myTags.add(tag);
      }
    });
  }

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    queryTopic = search == ''
        ? service.initializeQuery(myTags)
        : service.searchQuery(
            _capitalizeFirstLetter(search),
            searchController,
            queryTopic,
            myTags,
          );
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Topics',
          style: TextStyle(color: Colors.black87, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: isSearching ? Colors.grey.shade100 : Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            },
            icon: const Icon(
              Icons.search,
            ),
            iconSize: 30,
            color: Colors.black87,
          ),
          const MyNotifButton(),
        ],
      ),
      body: Column(
        children: [
          if (isSearching)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
                decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black), // Set the desired border color
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black
                              .withOpacity(1)), // Set the desired border color
                    ),
                    hintText: 'Serach here ...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
              ),
            ),
          const SizedBox(
            height: 15,
          ),
          Container(
            color: Colors.grey.shade100,
            height: 50,
            width: double.infinity,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  final tag = tags[index];
                  final isEnabled = isTagEnabled(tag);
                  return GestureDetector(
                    onTap: () {
                      toggleTag(tag);
                    },
                    child: TagBox(
                      text: tag,
                      enabled: isEnabled,
                    ),
                  );
                }),
          ),
          Expanded(
            child: FirestoreListViewWidget<TopicModel>(
              shrink: false,
              physics: const AlwaysScrollableScrollPhysics(),
              query: queryTopic,
              itemBuilder: (context, snapshot) {
                final topic = snapshot.data();
                return Topic(
                  authorUid: topic!.authorUid,
                  uid: topic.uid!, // Add a unique key to each child widget
                  title: topic.title!,
                  userName: topic.author!,
                  date: topic.date!,
                  rating: topic.rating!,
                  image: topic.files!,
                  text: topic.description!,
                  tags: topic.tags!,
                  raters: topic.raters!,
                  notifEnabled: topic.notifEnabled!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
