



import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications{

  LocalNotifications();
  final _localnotificationservice=FlutterLocalNotificationsPlugin();

  Future<void> intialize() async{
const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('');

final InitializationSettings settings=InitializationSettings(android: androidInitializationSettings);

await _localnotificationservice.initialize(settings);

// FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   print("heleee");
//   showNotification(
//     id: 0, // Set your desired notification ID
//     title: message.notification?.title ?? '',
//     body: message.notification?.body ?? '',
//   );
// });


  }
  Future<void> showNotification({
    required int id,
    required String title,
    required String body}) async{ final details= await _notificationdetails();
  await _localnotificationservice.show(id, title, body, details);

  }


  Future<NotificationDetails> _notificationdetails()async{
 const  AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
     "channelId",
     "channelName",
 channelDescription: "des",
     importance: Importance.max,
 priority: Priority.max,
 playSound: true);

 return NotificationDetails(android: androidNotificationDetails);



  }


}