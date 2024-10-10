import 'package:cloud_functions/cloud_functions.dart';

class NotificationService {
  static Future<void> sendNotification(String fcmToken, String title, String body) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'sendNotification', // The name of your Cloud Function
      );

      final result = await callable.call({
        'token': fcmToken,
        'title': title,
        'body': body,
      });

      print('Notification sent successfully: ${result.data}');
    } catch (error) {
      print('Error sending notification: $error');
    }
  }
}