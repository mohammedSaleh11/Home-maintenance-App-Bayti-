//const functions = require('firebase-functions');
//const admin = require('firebase-admin');
//admin.initializeApp();
//
//exports.sendNotification = functions.https.onCall((data, context) => {
//  const { token, title, body } = data;
//
//  if (!token || !title || !body) {
//    throw new functions.https.HttpsError('invalid-argument', 'Missing required parameters.');
//  }
//
//  const message = {
//    token: token,
//    notification: {
//      title: title,
//      body: body,
//    },
//  };
//
//  return admin.messaging().send(message)
//    .then((result) => {
//      return { status: 'success', message: 'Notification sent successfully' };
//    })
//    .catch((error) => {
//      throw new functions.https.HttpsError('internal', 'Error sending notification: ' + error);
//    });
//});