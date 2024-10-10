console.log('Current working directory:', process.cwd());
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const serviceAccount = require('./oma-bayti-firebase-adminsdk-qhq0k-e182962b08.json');
admin.initializeApp( {credential: admin.credential.cert(serviceAccount),
});


exports.checkAndUpdateField = functions.pubsub.schedule('0 0/12 * * *').onRun(async (context) => {
    // Get the current server time
    const serverTime = admin.firestore.Timestamp.now();
    console.log('server time:', serverTime);
    // Reference to your Firestore collection
    const collectionRef = firestore.collection('jobs');

    // Query documents where the timestamp field is less than the current server time
    const querySnapshot = await collectionRef.where('date', '<', serverTime).where('status', '==', 'Upcoming').get();
console.warn("server time:");
    // Iterate through the documents and update the other field
    querySnapshot.forEach((doc) => {
        // Update the other field (change 'otherField' to the field you want to update)
        console.log('working',doc.ref);
        return doc.ref.update({ status: 'Done' });
    });

    const querySnapshot2 = await collectionRef.where('date', '<', serverTime).where('status', '==', 'Waiting Acceptance').get();

querySnapshot2.forEach((doc) => {
        // Update the other field (change 'otherField' to the field you want to update)
        console.log('working',doc.ref);
        return doc.ref.update({ status: 'Cancelled' });
    });
    return null;
});




//exports.sendNotificationOnMessage = functions.firestore
//    .document('notifications/{notificationId}')
//    .onCreate(async (snap, context) => {
//
//        const data = snap.data();
//
//        // Get the FCM token of the recipient (message receiver)
//        const recipientToken = data.recipientFCMToken;
//        console.log('FUnction accessed');
// console.log("recipientToken");
//  console.log(recipientToken);
//        // Notification payload
//        const payload = {
//            notification: {
//                title: 'Bayti',
//                body: data.text,
//            },
//        };
//
//        // Send the notification
//        return admin.messaging().sendToDevice(recipientToken, payload);
//    });
//
//async function getRecipientToken(recipientUid) {
//    // Fetch the recipient's FCM token from Firestore or any other storage
//    // In a real application, you would need to implement this function
//    // based on your data structure and user management logic.
//    // For simplicity, let's assume you have a 'users' collection with FCM tokens.
//
//    const userSnapshot = await admin.firestore().collection('users').doc(recipientUid).get();
//
//    if (userSnapshot.exists) {
//        const userData = userSnapshot.data();
//        return userData.fcmToken;
//    } else {
//          workerSnapshot = await admin.firestore().collection('workers').doc(recipientUid).get();
//          const workerData = workerSnapshot.data();
//        return workerData.fcmToken;
//    }
//}