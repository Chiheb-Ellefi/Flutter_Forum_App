import 'package:flutter/material.dart';
import 'package:my_project/data/webservices/utils/Utils.dart';
import 'package:my_project/routes/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_project/src/notification/screens/notification.dart';
import 'package:my_project/src/notification/webservcies/firebase_notification_api.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});
  final AppRouter appRouter;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        NotificationWidget.route: (context) => const NotificationWidget(),
      },
      scaffoldMessengerKey: messengerKey,
      navigatorKey: navigatorKey,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
