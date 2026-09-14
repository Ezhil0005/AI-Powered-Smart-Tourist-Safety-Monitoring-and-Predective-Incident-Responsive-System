import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  static const _accessTokenKey = 'access_token';

  final ApiClient _apiClient = ApiClient.instance;

  Future<void> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString(_accessTokenKey);
    _apiClient.setAccessToken(token);
  }

  bool get isAuthenticated => _apiClient.hasAccessToken;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _apiClient.post(
      '/auth/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
    ) as Map<String, dynamic>;

    final token = response['access_token'];
    if (token is! String || token.isEmpty) {
      throw const ApiException(500, 'The server returned an invalid token');
    }

    _apiClient.setAccessToken(token);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_accessTokenKey, token);
  }

  Future<void> logout() async {
    _apiClient.setAccessToken(null);
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_accessTokenKey);
  }
}