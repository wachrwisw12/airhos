import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.1.43:3000',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'accessToken');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // ลอง refresh token
            final success = await _refreshToken();
            if (success) {
              final newToken = await _storage.read(key: 'accessToken');
              e.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final cloneReq = await _dio.fetch(e.requestOptions);
              return handler.resolve(cloneReq);
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  late Dio _dio;
  final _storage = const FlutterSecureStorage();

  Dio get dio => _dio;

  Future<bool> _refreshToken() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];

      await _storage.write(key: 'accessToken', value: newAccessToken);
      await _storage.write(key: 'refreshToken', value: newRefreshToken);

      return true;
    } catch (e) {
      return false;
    }
  }
}
