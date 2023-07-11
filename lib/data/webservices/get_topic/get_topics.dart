import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_project/config/themes.dart';

class FirestoreListViewWidget<T> extends StatelessWidget {
  final Query<T> query;
  final Widget Function(BuildContext context, DocumentSnapshot<T> snapshot)
      itemBuilder;

  const FirestoreListViewWidget({
    required this.query,
    required this.itemBuilder,
    required this.shrink,
    required this.physics,
    Key? key,
  }) : super(key: key);
  final ScrollPhysics? physics;
  final bool shrink;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<T>>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: myBlue2,
          ));
        }

        final documents = snapshot.data?.docs ?? [];

        if (documents.isEmpty) {
          return const Center(
              child: Text('Sorry , there is no topics to show.'));
        }

        return ListView.builder(
          physics: physics,
          shrinkWrap: shrink,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final document = documents[index];
            return itemBuilder(context, document);
          },
        );
      },
    );
  }
}
