import 'package:flutter/material.dart';
import 'package:grad_project/screens/chat_screen.dart';
import 'package:grad_project/screens/contact_us.dart';
import 'package:grad_project/screens/notifications.dart';
import 'package:grad_project/screens/sp_home_screen.dart';
import 'package:grad_project/screens/sp_profile_screen.dart';
import 'package:grad_project/screens/sp_job_list_screen.dart';

class mySpAppState extends StatefulWidget {
  final String Page;
  mySpAppState({ Key? key, required this.Page}) : super(key: key);
  @override
  State<mySpAppState> createState() => _mySpAppStateState();
}

class _mySpAppStateState extends State<mySpAppState> {
  int currentIndex = 0;
  late List<Widget> pages = [];
  @override
  void initState() {
    super.initState();
    // Initialize the pages list here
    pages = [
      spHomePage(),
      ChatPage(Page: widget.Page),
      spProfilePage(),
    ];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return notifications();
                  }),
                );


              },
              icon: Icon(
                Icons.notifications,
                size: 30,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return jobList();
                  }),
                );

              },
              icon: Icon(
                Icons.list_alt,
                size: 30,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return contactUs();
                  }),
                );

              },
              icon: Icon(
                Icons.contact_support,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
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
              Icons.chat,
            ),
            label: '',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
