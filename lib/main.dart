import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mediplan/Widgets/FullScreen_Alert/full_screen_alert.dart';
import 'services/firebase_options.dart';
import 'MyApp.dart';
import 'services/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.init();

  NotificationService.onTapCallback = (payload) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => FullScreenAlert(
          title: "Medication Reminder",
          body: payload,
        ),
      ),
    );
  };

  User? user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(
    isLoggedIn: user != null,
    navigatorKey: navigatorKey,
  ));
}

