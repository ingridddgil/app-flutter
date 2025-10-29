// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:cookie_jar/cookie_jar.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:uuid/uuid.dart';
// import '../../core/constants/app_config.dart';

// class OdooClient {
//   final Dio _dio;
//   final CookieJar _cookieJar = CookieJar();
//   final _uuid = const Uuid();

//   OdooClient._(this._dio);

//   static Future<OdooClient> create({bool allowSelfSigned = false}) async {
//     final dio = Dio(BaseOptions(
//       baseUrl: AppConfig.odooBaseUrl,
//       connectTimeout: const Duration(10),
//       receiveTimeout: const Duration(20),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       followRedirects: true,
//       validateStatus: (s) => s != null && s >= 200 && s < 400,
//     ));
//   }
// }