import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../components/AppVersionHelper.dart';
import '../components/DeviceIdGenerator.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  static GlobalKey<NavigatorState>? _navigatorKey;

  factory ApiClient({GlobalKey<NavigatorState>? navigatorKey}) {
    assert(
    _navigatorKey != null || navigatorKey != null,
    'A navigatorKey must be provided on the first instantiation of ApiClient.',
    );
    _navigatorKey ??= navigatorKey;
    return _instance;
  }

  late final Dio _dio;

  String get baseUrl => _dio.options.baseUrl;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${dotenv.env['API_BASE_URL']!}',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 600),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print("🔄 Interceptor triggered for: ${options.path}");
          try {
            if (options.contentType == null && options.data is! FormData) {
              options.contentType = 'application/json';
            }

            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('token');
            if (token != null && token.isNotEmpty) {
              options.headers["Authorization"] = "Bearer $token";
              print("✅ Authorization header added");
            }

            final deviceId = await DeviceIdGenerator.getDeviceId();
            final deviceInfo = await DeviceIdGenerator.getBasicDeviceInfo();
            options.headers['device-id'] = deviceId;
            options.headers['device-info'] = deviceInfo['platform'];

            final versionInfo = await AppVersionHelper.getFullVersionInfo();
            options.headers.addAll({
              'X-Version': versionInfo['version']!,
              'X-Build-Number': versionInfo['buildNumber']!,
              'X-App-Name': versionInfo['appName']!,
              'X-Package-Name': versionInfo['packageName']!,
            });

            final hospitalId = prefs.getString('hospital_id');
            final userId = prefs.getString('user_id');
            if (hospitalId != null &&
                userId != null &&
                !options.path.startsWith('/hospital/')) {
              final originalPath = options.path;
              options.path = '/hospital/$hospitalId/user/$userId$originalPath';
              print("🔄 Path transformed: $originalPath → ${options.path}");
            }
          } catch (e) {
            print("❌ Error in request interceptor: $e");
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          print("✅ [${response.statusCode}] ${response.requestOptions.uri}");
          handler.next(response);
        },
        onError: (DioException e, handler) async {
          final statusCode = e.response?.statusCode;
          print("❌ [$statusCode] ${e.requestOptions.uri}");
          print("🧨 Error: ${e.message}");
          handler.next(e);
        },
      ),
    );
  }

  Future<Response> _makeRequest(
      String path,
      Future<Response> Function() requestFunction,
      ) async {
    try {
      return await requestFunction();
    } on DioException catch (e) {
      _handleStatusCode(e);
      rethrow;
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) =>
      _makeRequest(path, () => _dio.get(path, queryParameters: queryParams));

  Future<Response> post(String path, {dynamic data}) =>
      _makeRequest(path, () => _dio.post(path, data: data));

  Future<Response> put(String path, {dynamic data, Options? options}) =>
      _makeRequest(path, () => _dio.put(path, data: data, options: options));

  Future<Response> putMultipart(String path, FormData formData) =>
      _makeRequest(path, () => _dio.put(
        path,
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
        ),
      ));

  Future<Response> delete(String path) =>
      _makeRequest(path, () => _dio.delete(path));

  Future<Response> getBinary(String path) => _makeRequest(
    path,
        () => _dio.get(
      path,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'Accept': 'application/pdf'},
      ),
    ),
  );

  void _handleStatusCode(DioException e) {
    final context = _navigatorKey?.currentContext;
    if (context == null) return;

    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;
    print("Error : $responseData ");
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.unknown) {
      // _showPopup(
      //   context,
      //   "Server Unavailable",
      //   "Cannot connect to the server. Please check your internet connection.",
      //   exitApp: true,
      // );
    } else if (statusCode == 403) {
      Navigator.of(context).pushReplacementNamed('/logout');
    } else if (statusCode == 402) {
      Navigator.of(context).pushReplacementNamed('/subscription-expired');
    } else if (statusCode == 404 || statusCode == 405) {
      _showPopup(context, "Not found", "The requested resource was not found.");
    } else if (statusCode == 502) {
      _showPopup(
        context,
        "Server Down",
        "Cannot connect to the server. Please try again later.",
        exitApp: true,
      );
    } else if (statusCode == 401 ) {
      return;
    } else {
      // This part now handles generic errors, including 400.
      if(responseData is List){
        return ;
      }
      String message;
      String title = 'Something went wrong';
      if (responseData is Map<String, dynamic>) {
        message =
            responseData['message'] ??
                responseData['error'] ??
                'An unknown error occurred.';
      } else {
        message = responseData?.toString() ?? 'An unknown error occurred.';
      }
      _showPopup(context, title, message);
    }
  }

  void _showPopup(
      BuildContext context,
      String title,
      String message, {
        bool exitApp = false,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(ctx).pop();
              if (exitApp) {
                SystemNavigator.pop();
              }
            },
          ),
        ],
      ),
    );
  }
}