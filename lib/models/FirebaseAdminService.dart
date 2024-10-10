import 'package:firebase_admin/firebase_admin.dart' as admin;

class FirebaseAdminService {
  static void initialize() {
    // Replace the path to your Firebase Admin SDK JSON file
    admin.FirebaseAdmin.instance.initializeApp(
      admin.AppOptions(
        credential: admin.Credentials.cert({
          "projectId": "your-project-id",
          "clientEmail": "your-client-email",
          "privateKey": "your-private-key",
        }),
        databaseUrl: "https://your-project-id.firebaseio.com",
      ),
    );
  }

}