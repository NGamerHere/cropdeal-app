import 'package:cropdeal/main.dart' show navigatorKey;
import 'package:cropdeal/models/BusinessType.dart';
import 'package:cropdeal/models/UserRole.dart';
import 'package:cropdeal/services/ApiClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../stateNotifiers/AppConfigNotifier.dart';

class MainLoadingScreen extends ConsumerStatefulWidget {
  const MainLoadingScreen({super.key});

  @override
  ConsumerState<MainLoadingScreen> createState() => _MainLoadingScreenState();
}

class _MainLoadingScreenState extends ConsumerState<MainLoadingScreen> {
  String currentStat = '';

  @override
  void initState() {
    super.initState();
    _downloadModelsAndNavigate();
  }

  Future<void> _downloadModelsAndNavigate() async {
    setState(() => currentStat = 'Setting up...');

    // Load user roles
    setState(() => currentStat = 'Setting up User Types...');
    final userRes =
        await ApiClient(navigatorKey: navigatorKey).get("/api/UserType");
    List<UserRole> userRoles = [];
    for (var data in userRes.data) {
      if (data != null) userRoles.add(UserRole.fromJson(data));
    }
    ref.read(appConfigProvider.notifier).setUserRoles(userRoles);

    // Load business types
    setState(() => currentStat = 'Setting up Business Types...');
    final bizRes =
        await ApiClient(navigatorKey: navigatorKey).get("/api/businessType");
    List<BusinessType> businessTypes = [];
    for (var data in bizRes.data) {
      if (data != null) businessTypes.add(BusinessType.fromJson(data));
    }
    ref.read(appConfigProvider.notifier).setBusinessTypes(businessTypes);

    if (!mounted) return;

    // Check if user is already logged in
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      setState(() => currentStat = 'Loading profile...');

      try {
        final profileRes = await ApiClient(navigatorKey: navigatorKey).get('/api/profile');
        final user = profileRes.data['user'] as Map<String, dynamic>;

        final isOnboarded = user['isOnboarded'] as bool? ?? false;
        final onboardingStep = user['onBoardingStep'] as int? ?? 0;

        // Sync SharedPreferences with fresh data
        await prefs.setBool('isOnboarded', isOnboarded);
        await prefs.setInt('userOnBoardingStep', onboardingStep);

        if (!mounted) return;

        String route;
        if (isOnboarded) {
          route = '/list';
        } else if (onboardingStep <= 1) {
          route = '/onboarding';
        } else {
          route = '/categories';
        }

        Navigator.pushReplacementNamed(context, route);
      } catch (_) {
        // Token invalid or expired — send to login
        await prefs.remove('token');
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/SplashScreenBackground.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 30,
            right: 30,
            bottom: 60,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentStat,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    minHeight: 6,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
