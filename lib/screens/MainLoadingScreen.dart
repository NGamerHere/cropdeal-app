import 'package:cropdeal/main.dart' show navigatorKey;
import 'package:cropdeal/models/BusinessType.dart';
import 'package:cropdeal/models/UserRole.dart';
import 'package:cropdeal/services/ApiClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../stateNotifiers/AppConfigNotifier.dart';

class MainLoadingScreen extends ConsumerStatefulWidget {
  const MainLoadingScreen({super.key});

  @override
  ConsumerState<MainLoadingScreen> createState() => _MainLoadingScreenState();
}

class _MainLoadingScreenState extends ConsumerState<MainLoadingScreen> {
  String currentStat='';
  @override
  void initState() {
    super.initState();
    _downloadModelsAndNavigate();
  }

  Future<void> _downloadModelsAndNavigate() async {
    setState(() {
      currentStat = 'Setting up translation models...';
    });
    // final modelManager = OnDeviceTranslatorModelManager();
    //
    // if (!await modelManager.isModelDownloaded(TranslateLanguage.english.bcpCode)) {
    //   await modelManager.downloadModel(TranslateLanguage.english.bcpCode);
    // }
    // if (!await modelManager.isModelDownloaded(TranslateLanguage.hindi.bcpCode)) {
    //   await modelManager.downloadModel(TranslateLanguage.hindi.bcpCode);
    // }
    // if (!await modelManager.isModelDownloaded(TranslateLanguage.telugu.bcpCode)) {
    //   await modelManager.downloadModel(TranslateLanguage.telugu.bcpCode);
    // }

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      currentStat = 'Setting up User Types...';
    });

    final res=await ApiClient(navigatorKey: navigatorKey).get("/api/UserType");
    List<UserRole> userRoles=[];

    for (var data in res.data){
      if(data != null){
        userRoles.add(UserRole.fromJson(data));
      }
    }

    ref.read(appConfigProvider.notifier).setUserRoles(userRoles);

    setState(() {
      currentStat = 'Setting up Business Types...';
    });

    final businessTypesRes=await ApiClient(navigatorKey: navigatorKey).get("/api/businessType");
    List<BusinessType> businessTypes=[];

    for (var data in businessTypesRes.data){
      if(data != null){
        businessTypes.add(BusinessType.fromJson(data));
      }
    }

    ref.read(appConfigProvider.notifier).setBusinessTypes(businessTypes);


    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/onboarding');
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
                  style: TextStyle(color: Colors.white, fontSize: 14),
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