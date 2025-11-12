import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'MyApp.dart';
import 'services/notification_service.dart'; // ✅ استدعاء NotificationService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 تهيئة Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔹 تهيئة الإشعارات
  await NotificationService.init();

  runApp(const MyApp());
}




