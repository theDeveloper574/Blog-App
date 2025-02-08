import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String BASE_URL = "http://192.168.100.6:5001/api";
const String ImgBaseUrl = "http://192.168.100.6:5001/";
const Map<String, dynamic> defHeaders = {'Content-Type': "application/json"};

class Api {
  final Dio _dio;
  Api()
      : _dio = Dio(
          BaseOptions(
            baseUrl: BASE_URL,
            headers: defHeaders,
            connectTimeout: const Duration(seconds: 10), // Connection timeout
            receiveTimeout: const Duration(seconds: 30), // Receive timeout
            sendTimeout: const Duration(seconds: 10), // Send timeout
          ),
        ) {
    _dio.interceptors.add(
      PrettyDioLogger(
        responseBody: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        request: true,
      ),
    );
  }
  Dio get sendRequest => _dio;
}

class ApiResponse {
  bool success;
  dynamic data;
  String? message;
  ApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ApiResponse.fromResponse(Response response) {
    final data = response.data as Map<String, dynamic>;
    return ApiResponse(
      success: data["success"],
      data: data["data"],
      message: data["message"] ?? "an error occurred",
    );
  }
}

// Api() {
//   _dio.options.baseUrl = BASE_URL;
//   _dio.options.headers = defHeaders;
//
//   _dio.interceptors.add(PrettyDioLogger(
//     responseBody: true,
//     requestBody: true,
//     requestHeader: true,
//     responseHeader: true,
//     request: true,
//   ));
// }
