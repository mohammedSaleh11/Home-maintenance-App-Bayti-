import 'package:flutter/material.dart';
import 'package:grad_project/screens/Login_Screen.dart';

import '../screens/account_creation_screen.dart';
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {



  void toggleScreens() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    if (true) {
      print("show loginscreen");
      return Login_Screen();
    }
    }
  }
