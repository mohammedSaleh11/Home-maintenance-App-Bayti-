
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:grad_project/auth/main_page.dart';
import 'models/FirebaseMessagingService.dart';
import 'models/JobRatingService.dart';
import 'models/fcm_handler.dart';
import 'models/jobService.dart';
import 'models/local_notifications.dart';
import 'screens/Login_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //final FirebaseMessagingService _notificationHandler = FirebaseMessagingService();
  //FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();

  //late final LocalNotifications service;
  //service = LocalNotifications();
  //service.intialize();

  runApp(Bayti());
}

class Bayti extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    jobService jobservice =jobService();
    return MaterialApp(
      home: AnimatedSplashScreen(
        backgroundColor: Color(0xFFF5F5F5),
        duration: 1500,
        splash: Image.asset('images/splash.png',
         ),
        splashIconSize: 250,
        nextScreen: main_page(),
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}





