import 'package:flutter/material.dart';
import 'package:grad_project/screens/chat_screen.dart';
import 'package:grad_project/screens/contact_us.dart';
import 'package:grad_project/screens/notifications.dart';
import 'package:grad_project/screens/sp_home_screen.dart';
import 'package:grad_project/screens/sp_profile_screen.dart';
import 'package:grad_project/screens/sp_job_list_screen.dart';
import 'package:grad_project/screens/admin_home_screen.dart';
import 'package:grad_project/screens/admin_account_manage_screen.dart';
import 'package:grad_project/screens/admin_feedback_screen.dart';
class myAdminAppState extends StatefulWidget {
  @override
  State<myAdminAppState> createState() => _myAdminAppStateState();
}

class _myAdminAppStateState extends State<myAdminAppState> {
  final List<Widget> pages = [
    AdminHome(),
    AdminAccountManage(),
    feedbacksPage(),
  ];
  int currentIndex = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),

      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex=index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.manage_accounts,
            ),
            label: '',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.feedback,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
