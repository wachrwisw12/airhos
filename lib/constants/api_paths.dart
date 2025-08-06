import 'env.dart';

class ApiPaths {
  static const String loginUsername = '/api/v2/userlogin';
  static const String verifyToken = '/auth/v2/verifyToken';
  static const String logout = '${Env.baseUrl}/auth/logout';

  static const String userProfile = '${Env.baseUrl}/user/profile';
  static const String hospitals = '${Env.baseUrl}/hospitals';
}
