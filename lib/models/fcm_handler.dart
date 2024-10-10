

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


Future<void> backgroundmessage(RemoteMessage message) async{
  print("hello noti");

}


class FCMHandler {
  static void initializeFCM(BuildContext context) async {
print("object;");
    await Firebase.initializeApp();


    User? currentUser = FirebaseAuth.instance.currentUser;

    FirebaseMessaging.instance.onTokenRefresh.listen((String? newToken) async {
      print('FCM Token Refreshed: $newToken');


      if (currentUser != null) {
        await updateUserFcmToken(currentUser.uid, newToken);
      }
    });
 FirebaseMessaging.onBackgroundMessage((backgroundmessage));

    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {

      String? currentToken = await FirebaseMessaging.instance.getToken();
      print('Current FCM Token: $currentToken');

      if (currentUser != null) {
        await updateUserFcmToken(currentUser.uid, currentToken);
      }

    } else {
      print('User declined permission for push notifications');


      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: AutoSizeText('No Notification Permissions',maxLines: 1,),
            content: AutoSizeText("Grant Permissions to receive Notifications"),
            actions: [
              TextButton(
                onPressed: () {

                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }



  static Future<void> updateUserFcmToken(String userId, String? newToken) async {
    try {
      DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      String accountDB;
      (querySnapshot.exists)?accountDB="workers":accountDB="users";

      CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection(accountDB);


      await usersCollection.doc(userId).update({
        'fcmToken': newToken,
      });

      print('FCM Token updated in the user collection.');
    } catch (error) {
      print('Error updating FCM Token in user collection: $error');
    }
  }
}