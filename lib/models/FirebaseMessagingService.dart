import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_admin/firebase_admin.dart' as admin;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
AndroidNotificationChannel channel = AndroidNotificationChannel(
  'bayti_general', // Replace with your actual channel ID
  'General', // Replace with your desired channel name
  importance: Importance.high,
  playSound: true,
  showBadge: true,
);
class FirebaseMessagingService {
  FirebaseMessagingService() {
    initialize();
  }
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {

    // Request permission for receiving push notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    print('User granted permission: ${settings.authorizationStatus}');

    // Get the FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    const String channelId = 'bayti_general';
    const String channelName = 'General';
    const String channelDescription = 'Channel for handling notifications';
    // AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
    //   channelId,
    //   channelName,
    //   description: channelDescription,
    //   importance: Importance.high,
    //   playSound: true,
    //   showBadge: true,
    // );
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    //await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground Notification: ${message.notification?.body}');
      // _showNotification(message.notification?.title ?? '', message.notification?.body ?? '');
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Background/Terminated Notification: ${message.notification?.body}');
      // Handle the tap on the notification
      _handleNotificationTap(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('Terminated Notification: ${message.notification?.body}');
        // Handle the notification received when the app is terminated
        _handleNotificationTap(message);
      }
    });


    //
    // // Listen for token refresh
    // _firebaseMessaging.onTokenRefresh.listen((String token) {
    //   print('FCM Token refreshed: $token');
    //   // Save the updated token to your server or wherever you need it.
    // });
    // _subscribeToTopic();

  }
  void _showNotification(String title, String body) async {
    const int notificationId = 0;
    const String payload = 'notification_payload';

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'bayti_general',
      'General',
      channelDescription: 'Channel for handling notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

  }
  void _handleNotificationTap(RemoteMessage message) {
    // Handle the tap on the notification
    print('Handling notification tap: ${message.notification?.body}');
  }
  Future<void> _subscribeToTopic() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      try {
        await _firebaseMessaging.subscribeToTopic(token);
        print('Subscribed to topic: $token');
      } catch (e) {
        print('Error subscribing to topic: $e');
      }
    }
  }

  Future<void> sendNotificationToSingleDevice(String deviceToken, String title, String body) async {
    try {


    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}