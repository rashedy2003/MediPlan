import 'package:flutter/material.dart';
import 'package:mediplan/Routes/routes.dart';
import 'package:mediplan/Widgets/Home_Screen/Home_screen.dart';
import 'package:mediplan/Widgets/Welcome_screen/Welcome_Screen.dart';

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.isLoggedIn, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: isLoggedIn ? const Home_screen() : const WelcomeScreen(),
      routes: appRoutes,
    );
  }
}
