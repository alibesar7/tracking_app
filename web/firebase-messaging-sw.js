importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyDKWdkFjeKkEAfKFrMO2svs48t2d9OqRGw",
  appId: "1:725835190067:web:86225b1572d53a90e53846",
  messagingSenderId: "725835190067",
  projectId: "elevate-flower-app",
  authDomain: "elevate-flower-app.firebaseapp.com",
  storageBucket: "elevate-flower-app.firebasestorage.app"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png'
  };

  self.registration.showNotification(notificationTitle,
    notificationOptions);
});
