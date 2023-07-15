import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/notification_model/notif_model.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/data/webservices/get_topic/get_topics.dart';

import 'package:my_project/src/home/components/leading_button.dart';
import 'package:my_project/src/notification/components/notif_tile.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});
  static const route = '/notification-screen';

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late Query<NotificationModel> queryNotification;
  late Future<Map<String, dynamic>> userInfo;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, dynamic>> getInfo(String authUid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(authUid)
        .get();
    final data = snapshot.data() as Map<String, dynamic>;
    final myData = UserModel.fromMap(data);
    return {
      'userModel': myData,
      'documentId': snapshot.id,
    };
  }

  void initializeQuery() {
    queryNotification = FirebaseFirestore.instance
        .collection(notifCollection)
        .orderBy('date', descending: true)
        .withConverter<NotificationModel>(
          fromFirestore: (snapshot, _) =>
              NotificationModel.fromMap(snapshot.data()!),
          toFirestore: (topic, _) => topic.toMap(),
        );
  }

  Future<void> deleteNotification(String notifUid) async {
    await FirebaseFirestore.instance
        .collection(notifCollection)
        .doc(notifUid)
        .delete();
  }

  @override
  void initState() {
    super.initState();
    initializeQuery();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notifications',
            style: TextStyle(color: Colors.black87, fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 70,
          leading: MyLeadingButton(myContext: context),
        ),
        body: Column(
          children: [
            Expanded(
              child: FirestoreListViewWidget<NotificationModel>(
                query: queryNotification,
                shrink: false,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, snapshot) {
                  final myData = snapshot.data();

                  if (uid == myData!.notified) {
                    userInfo = getInfo(myData.notifier!);
                    return FutureBuilder<Map<String, dynamic>>(
                      future: userInfo,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // While waiting for data, you can show a loading indicator
                          return Center(child: Container());
                        } else if (snapshot.hasError) {
                          // If an error occurs, you can handle it here
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // Data is available, you can access it through snapshot.data
                          final userModel =
                              snapshot.data!['userModel'] as UserModel;
                          return NotifTile(
                            date: myData.date,
                            image: userModel.profilePicture,
                            notification: myData.notification!,
                            notifier: userModel.username!,
                            onDelete: () {
                              deleteNotification(myData.uid!);
                            },
                          );
                        }
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
