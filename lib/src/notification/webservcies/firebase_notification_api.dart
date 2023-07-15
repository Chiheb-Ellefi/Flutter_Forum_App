import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/main.dart';
import 'package:http/http.dart' as http;
import 'package:my_project/src/notification/screens/notification.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('title: ${message.notification!.title}');
  print('body: ${message.notification!.body}');
  print('Playload: ${message.data}');
}

class FirebaseApi {
  Future<void> saveFcmToken() async {
    String? token = await _firebaseMessaging.getToken();
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'token': token});
  }

  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notifiations',
      description: 'This channel is used for important notifications',
      importance: Importance.defaultImportance);
  final _localNotifications = FlutterLocalNotificationsPlugin();
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState!.pushNamed(NotificationWidget.route,
        arguments: message as RemoteMessage);
  }

  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (notification) {
      final message = RemoteMessage.fromMap(jsonDecode(notification.payload!));
      handleMessage(message);
    });
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((event) {
      final notification = event.notification;
      if (notification == null) return;
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                _androidChannel.id, _androidChannel.name,
                channelDescription: _androidChannel.description,
                icon: '@drawable/ic_launcher'),
          ),
          payload: jsonEncode(event.toMap()));
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('tokkkkeeeen $fCMToken');
    initPushNotification();
    initLocalNotifications();
  }

////my functions
  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('user declined or has notccepted permission');
    }
  }

  Future<void> sendPushMesssage(String token, String body, String title) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAApKsG9WM:APA91bGCUt2NthDFxWQKGofrdwgaP17e5EFGdug7R-Qn-wsVrOqRuLdiJa2JCYQRHWcpv8lFd5G13D_df7x9LqDZc95ram9Mx9Z4YY7eXSFh69vQayDc8SMybZOORyDWu32YVms-exx8',
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_ACTION',
              'status': 'done',
              'body': body,
              'title': title
            },
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
              'android_channel_id': 'high_importance_channel'
            },
            'to': token
          }));
    } catch (e) {
      if (kDebugMode) {
        print('error push notif : $e');
      }
    }
  }
}
