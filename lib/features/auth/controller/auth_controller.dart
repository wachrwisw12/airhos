import 'dart:async';
import 'package:arihos/constants/api_paths.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../core/utils/dio_client.dart';

final _secureStorage = const FlutterSecureStorage();

class AuthState {
  final bool isLoading;
  final String? token;
  final bool isAuthenticated;
  final String? error;
  final Map<String, dynamic>? user; // เก็บข้อมูล user จาก token

  AuthState({
    this.isLoading = false,
    this.token,
    this.isAuthenticated = false,
    this.error,
    this.user,
  });

  bool get isLoggedIn => isAuthenticated;

  @override
  String toString() {
    return 'AuthState(isLoading: $isLoading, token: $token, error: $error, user: $user)';
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref),
);

class AuthController extends StateNotifier<AuthState> {
  final StreamController<AuthState> _streamController =
      StreamController<AuthState>.broadcast();

  @override
  Stream<AuthState> get stream => _streamController.stream;
  final Ref ref;

  AuthController(this.ref) : super(AuthState(isLoading: true)) {
    _loadtoken();
  }

  void _emit(AuthState newState) {
    state = newState;
    _streamController.add(newState);
  }

  Future<void> _loadtoken() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final token = await _secureStorage.read(key: 'accessToken');
      if (token != null && !JwtDecoder.isExpired(token)) {
        print(token);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        final user = decodedToken['user'] as Map<String, dynamic>?;

        _emit(
          AuthState(
            isLoading: false,
            token: token,
            isAuthenticated: true,
            user: user,
          ),
        );
        print("token is $token");
      } else {
        _emit(AuthState(isLoading: false));
        print("token is invalid or expired");
      }
    } catch (e) {
      _emit(AuthState(isLoading: false, token: null));
      print("error loading token: $e");
    }
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<void> loginWithUser(String username, String password) async {
    final dio = DioClient().dio;
    _emit(AuthState(isLoading: true));
    try {
      final response = await dio.post(
        ApiPaths.loginUsername,
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        final accessToken = response.data['accessToken'];
        if (accessToken != null &&
            accessToken is String &&
            accessToken.isNotEmpty) {
          await _secureStorage.write(key: 'accessToken', value: accessToken);

          Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
          final user = decodedToken['user'] as Map<String, dynamic>?;

          _emit(
            AuthState(
              isLoading: false,
              token: accessToken,
              isAuthenticated: true,
              user: user,
            ),
          );
        }
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _emit(
          AuthState(
            isLoading: false,
            error: 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง',
          ),
        );
      } else {
        _emit(
          AuthState(isLoading: false, error: 'เกิดข้อผิดพลาด: ${e.message}'),
        );
      }
    } catch (e) {
      _emit(
        AuthState(
          isLoading: false,
          error: 'ข้อผิดพลาดไม่คาดคิด: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'accessToken');
    _emit(
      AuthState(
        isLoading: false,
        token: null,
        isAuthenticated: false,
        user: null,
      ),
    );
  }
}
