/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotificationOnRequest = functions.firestore
  .document("requests/{requestId}")
  .onCreate(async (snap, context) => {
    const requestData = snap.data();

    const driverId = requestData.driver_id;
    if (!driverId) {
      console.log("No driver_id found in request.");
      return null;
    }

    // Get the driver document from Firestore
    const driverDoc = await admin.firestore().collection("driver").doc(driverId).get();
    if (!driverDoc.exists) {
      console.log("Driver not found for ID:", driverId);
      return null;
    }

    const fcmToken = driverDoc.data().fcm_token;
    if (!fcmToken) {
      console.log("No FCM token found for driver.");
      return null;
    }

    const payload = {
      notification: {
        title: "New Ride Request",
        body: "You have a new ride request. Tap to view details.",
      },
      token: fcmToken,
    };

    try {
      const response = await admin.messaging().send(payload);
      console.log("Successfully sent notification:", response);
    } catch (error) {
      console.error("Error sending notification:", error);
    }

    return null;
  });
