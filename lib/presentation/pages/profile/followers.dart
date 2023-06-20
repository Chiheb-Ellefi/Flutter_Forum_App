import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/presentation/components/notification/notif_button.dart';
import 'package:my_project/presentation/widgets/profile/followers.dart';
import 'package:my_project/presentation/widgets/profile/following.dart';

class Followers extends StatelessWidget {
  const Followers({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Followers',
              style: TextStyle(color: Colors.black87, fontSize: 25),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 70,
            actions: const [
              MyNotifButton(),
            ],
            bottom: const TabBar(
              indicatorColor: Colors.black, // Customize the indicator color
              tabs: [
                Tab(
                  child: Text(
                    'Followers',
                    style: TextStyle(color: Colors.black87, fontSize: 20),
                  ),
                ),
                Tab(
                  child: Text(
                    'Following',
                    style: TextStyle(color: Colors.black87, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [FollowersWidget(), FollowingWidget()],
          ),
        ),
      ),
    );
  }
}
