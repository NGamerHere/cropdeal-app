import 'package:device_info_plus/device_info_plus.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';


class DeviceIdGenerator {
  static Future<String> getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? deviceId=prefs.getString('deviceID');
    if(deviceId != null){
       return deviceId;
    }

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String identifier = '';

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        identifier = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        identifier = iosInfo.identifierForVendor ?? '';
      } else if (Platform.isWindows) {
        WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
        identifier = '${windowsInfo.computerName}_${windowsInfo.userName}_${windowsInfo.majorVersion}_${windowsInfo.minorVersion}';
      } else if (Platform.isMacOS) {
        MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
        identifier = macInfo.systemGUID ?? '';
      } else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
        identifier = linuxInfo.machineId ?? '';
      } else if (Platform.isFuchsia) {
        identifier = 'fuchsia_device';
      } else {
        identifier = 'web_or_unknown_device';
      }
    } catch (e) {
      print('Error getting device info: $e');
      identifier = 'fallback_${DateTime.now().millisecondsSinceEpoch}';
    }

    if (identifier.isEmpty) {
      identifier = 'empty_identifier_${DateTime.now().millisecondsSinceEpoch}';
    }

    // Hash the identifier for privacy and consistency
    var bytes = utf8.encode(identifier);
    var digest = sha256.convert(bytes);
    String finalDeviceId=digest.toString();
    await prefs.setString("deviceId", finalDeviceId);
    return finalDeviceId;
  }
  static Future<Map<String, String>> getBasicDeviceInfo() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      Map<String, String> basicInfo = {};

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        basicInfo = {
          'platform': 'Android',
          'model': androidInfo.model,
          'brand': androidInfo.brand,
          'version': androidInfo.version.release,
          'sdk': androidInfo.version.sdkInt.toString(),
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        basicInfo = {
          'platform': 'iOS',
          'model': iosInfo.model,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
        };
      } else if (Platform.isWindows) {
        WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
        basicInfo = {
          'platform': 'Windows',
          'computerName': windowsInfo.computerName,
          'version': '${windowsInfo.majorVersion}.${windowsInfo.minorVersion}',
          'buildNumber': windowsInfo.buildNumber.toString(),
        };
      } else if (Platform.isMacOS) {
        MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
        basicInfo = {
          'platform': 'macOS',
          'model': macInfo.model,
          'version': '${macInfo.majorVersion}.${macInfo.minorVersion}.${macInfo.patchVersion}',
        };
      } else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
        basicInfo = {
          'platform': 'Linux',
          'name': linuxInfo.name,
          'version': ?linuxInfo.version,
        };
      } else {
        basicInfo = {
          'platform': 'Web/Unknown',
        };
      }

      return basicInfo;
    } catch (e) {
      return {
        'platform': 'Error',
        'error': e.toString(),
      };
    }
  }
}