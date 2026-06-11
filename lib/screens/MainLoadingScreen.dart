import 'package:flutter/material.dart';

class MainLoadingScreen extends StatefulWidget {
  const MainLoadingScreen({super.key});

  @override
  State<MainLoadingScreen> createState() => _MainLoadingScreenState();
}

class _MainLoadingScreenState extends State<MainLoadingScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/MainLoadingScreen.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}