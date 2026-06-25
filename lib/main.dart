import 'package:cropdeal/screens/CategoryScreen.dart';
import 'package:cropdeal/screens/LoginScreen.dart';
import 'package:cropdeal/screens/MainLoadingScreen.dart';
import 'package:cropdeal/screens/OnBoardingScreen.dart';
import 'package:cropdeal/screens/featureScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final helloWorldProvider = Provider((_) => 'Hello world');

void main() async {
  await dotenv.load();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const MainLoadingScreen(),
      theme: ThemeData(fontFamily: 'CustomFont'),
      routes: {
        '/loading': (context) => MainLoadingScreen(),
        '/features': (context) => FeaturesScreen(),
        '/onboarding': (context) => OnBoardingScreen(),
        '/login': (context) => LoginScreen(),
        '/categories': (context) => const CategoryScreen(),
        '/list': (context) => Scaffold(
          appBar: AppBar(title: const Text('Products')),
          body: const Center(child: Text('List page - coming soon')),
        ),
      },
    );
  }
}
