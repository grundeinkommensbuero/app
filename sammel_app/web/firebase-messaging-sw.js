importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyDHqWif8r-H8WoyraJbMfImdWU2Z-9dSwc",
  authDomain: "expedition-grundeinkommen-app.firebaseapp.com",
  projectId: "expedition-grundeinkommen-app",
  storageBucket: "expedition-grundeinkommen-app.appspot.com",
  messagingSenderId: "34078750980",
  appId: "1:34078750980:web:ab1f51298d65f0a2d1b851",
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
