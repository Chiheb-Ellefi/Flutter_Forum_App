import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/presentation/widgets/homeScreenWidgets/settings_widget.dart';
import 'package:my_project/presentation/widgets/homeScreenWidgets/topicsWidget.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  int index = 0;
  final screens = [
    TopicsWidget(),
    const Center(
      child: Text(
        'Profile',
        style: TextStyle(fontSize: 70),
      ),
    ),
    const Center(
      child: Text(
        'Followers',
        style: TextStyle(fontSize: 70),
      ),
    ),
    Settings(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade100,
        /*  appBar: AppBar(
            /* title: const Text(
              'Topics',
              style: TextStyle(color: Colors.black87, fontSize: 30),
            ),
            centerTitle: true, */
            backgroundColor: Colors.white,
            elevation: 0,
            /* leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(FontAwesomeIcons.arrowLeft),
                iconSize: 30,
                color: Colors.black87,
              ),
            ), */
            toolbarHeight: 70,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                ),
                iconSize: 40,
                color: Colors.black87,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(FontAwesomeIcons.bell),
                iconSize: 30,
                color: Colors.black87,
              ),
            ]), */
        body: screens[index],

        //Floating Action Button

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/addtopic');
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          child: const Icon(FontAwesomeIcons.plus),
        ),

        //Navigation bar

        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: Colors.grey.shade200,
              iconTheme: MaterialStateProperty.all(
                  const IconThemeData(color: Colors.black87)),
              backgroundColor: Colors.white,
              labelTextStyle: MaterialStateProperty.all(
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          child: NavigationBar(
            height: 70,
            selectedIndex: index,
            onDestinationSelected: (index) => setState(() {
              this.index = index;
            }),
            destinations: const [
              NavigationDestination(
                  icon: Icon(
                    Icons.newspaper_outlined,
                    size: 30,
                  ),
                  label: 'Topics'),
              NavigationDestination(
                  icon: Icon(
                    Icons.person_outlined,
                    size: 30,
                  ),
                  label: 'Profile'),
              NavigationDestination(
                  icon: Icon(
                    Icons.group_outlined,
                    size: 30,
                  ),
                  label: 'Followers'),
              NavigationDestination(
                  icon: Icon(
                    Icons.settings_outlined,
                    size: 30,
                  ),
                  label: 'Settings')
            ],
          ),
        ),
      ),
    );
  }
}
