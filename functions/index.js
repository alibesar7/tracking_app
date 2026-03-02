const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.notifyFlowerShopOnStatusChange = functions.firestore
  .document("orders/{orderId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    // Only trigger if status changed
    if (before.status === after.status) {
      return null;
    }

    const shopToken = after.shopDeviceToken;

    if (!shopToken) {
      console.log("No shop device token found.");
      return null;
    }

    const message = {
      token: shopToken,
      notification: {
        title: "Order Status Updated",
        body: `Order #${context.params.orderId} is now ${after.status}`,
      },
      data: {
        orderId: context.params.orderId,
        status: after.status,
      },
    };

    try {
      await admin.messaging().send(message);
      console.log("Notification sent to flower shop.");
    } catch (error) {
      console.error("Error sending notification:", error);
    }

    return null;
  });