import 'package:package_info_plus/package_info_plus.dart';

class AppVersionHelper {
  static AppVersionHelper? _instance;
  PackageInfo? _packageInfo;

  // Private constructor
  AppVersionHelper._();

  // Singleton instance
  static AppVersionHelper get instance {
    _instance ??= AppVersionHelper._();
    return _instance!;
  }

  // Initialize package info (call this once in your app startup)
  Future<void> initialize() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  // Get app version (e.g., "1.0.0")
  String get version {
    return _packageInfo?.version ?? 'Unknown';
  }

  // Get build number (e.g., "1")
  String get buildNumber {
    return _packageInfo?.buildNumber ?? 'Unknown';
  }

  // Get app name
  String get appName {
    return _packageInfo?.appName ?? 'Unknown';
  }

  // Get package name
  String get packageName {
    return _packageInfo?.packageName ?? 'Unknown';
  }

  // Get full version string (version + build number)
  String get fullVersion {
    return '${version} (${buildNumber})';
  }

  // Static method to get version directly (async)
  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  // Static method to get full version info directly (async)
  static Future<Map<String, String>> getFullVersionInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return {
      'version': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
      'appName': packageInfo.appName,
      'packageName': packageInfo.packageName,
    };
  }

  // Check if package info is initialized
  bool get isInitialized => _packageInfo != null;
}