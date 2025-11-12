import 'package:flutter/material.dart';
import 'package:mediplan/Widgets/Add_Medication_Screen/Add_Medication.dart';
import 'package:mediplan/Widgets/Home_Screen/Home_screen.dart';

import 'package:mediplan/Widgets/login_screen/login_screen.dart';
import 'package:mediplan/Widgets/SignUp_screen/SignUp_screen.dart';
import 'package:mediplan/Widgets/Welcome_screen/Welcome_Screen.dart';




final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const WelcomeScreen(),
  '/login': (context) => const Login(),
  '/signup': (context) => const SignUp(),
  '/Home': (context) => const Home_screen(),
  '/addMedication': (context) => const AddMedication(),
};


