import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/app/core/firebase/cloud_messaging.dart';
import 'package:tracking_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  configureDependencies();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(
    CloudMessaging.firebaseMessagingBackgroundHandler,
  );
  await CloudMessaging.setupFlutterNotifications();
  CloudMessaging.printDeviceToken();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const TrackingApp(),
    ),
  );
}

class TrackingApp extends StatelessWidget {
  const TrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
