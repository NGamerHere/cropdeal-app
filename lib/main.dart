import 'package:cropdeal/screens/LoginScreen.dart';
import 'package:cropdeal/screens/MainLoadingScreen.dart';
import 'package:cropdeal/screens/OnBoardingScreen.dart';
import 'package:cropdeal/screens/featureScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainLoadingScreen(),
      theme: ThemeData(
        fontFamily: 'CustomFont',
      ),
      routes: {
        '/loading': (context) => MainLoadingScreen(),
        '/features': (context) => FeaturesScreen(),
        '/onboarding': (context) => OnBoardingScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
