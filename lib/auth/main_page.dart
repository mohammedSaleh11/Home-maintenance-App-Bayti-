import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/job_card.dart';

import '../screens/App_state_screen.dart';
import '../screens/admin_app_state.dart';
import '../screens/admin_home_screen.dart';
import '../screens/sp_app_state_screen.dart';
import 'auth_page.dart';

class main_page extends StatelessWidget {
  const main_page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator if the snapshot is still loading
              return SafeArea(child: Center(child: CircularProgressIndicator()));
            }

            if (snapshot.hasData) {
              // User is logged in
              print(snapshot.data!.uid);

              // Check if the user's uid is in the "workers" collection
              return FutureBuilder<bool>(
                future: checkUidInWorkerCollection(snapshot.data!.uid),
                builder: (context, AsyncSnapshot<bool> workerSnapshot) {
                  if (workerSnapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator if the workerSnapshot is still loading
                    return CircularProgressIndicator();
                  }

                  // Check if the user's uid is in the "users" collection
                  return FutureBuilder<bool>(
                    future: checkUidInUserCollection(snapshot.data!.uid),
                    builder: (context, AsyncSnapshot<bool> userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        // Show a loading indicator if the userSnapshot is still loading
                        return CircularProgressIndicator();
                      }

                      if (uid == "hq7FPvfqzNchboPdCRXKBfNx2fu1")
                        return myAdminAppState();
                      if (workerSnapshot.hasData && workerSnapshot.data == true) {
                        // User is a worker
                        return mySpAppState(Page: 'workers');
                      } else if (userSnapshot.hasData && userSnapshot.data == true) {
                        // User is not a worker and is in the "users" collection
                        return myAppState(Page: 'users');
                      } else {
                        // User is not a worker and is not in the "users" collection
                        // You can handle this case as needed
                        return AuthPage();
                      }
                    },
                  );
                },
              );
            } else {
              // User is logged out
              print("logged out");
              return AuthPage();
            }
          },
        ),
      ),
    );
  }

  Future<bool> checkUidInWorkerCollection(String? uid) async {
    print(uid);
    try {
      DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(uid)
          .get();

      return querySnapshot.exists;
    } catch (e) {
      // Handle errors if any
      print("Error checking uid in worker collection: $e");
      return false;
    }
  }

  Future<bool> checkUidInUserCollection(String? uid) async {
    print(uid);
    try {
      DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      return querySnapshot.exists;
    } catch (e) {
      // Handle errors if any
      print("Error checking uid in user collection: $e");
      return false;
    }
  }
}
