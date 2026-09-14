import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  String? _accessToken;

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  bool get hasAccessToken => _accessToken != null;

  Map<String, String> _headers({bool authenticated = false}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authenticated && _accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    return headers;
  }

  Future<dynamic> get(
    String path, {
    bool authenticated = false,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _headers(authenticated: authenticated),
    );

    return _decode(response);
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = false,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _headers(authenticated: authenticated),
      body: jsonEncode(body ?? <String, dynamic>{}),
    );

    return _decode(response);
  }

  dynamic _decode(http.Response response) {
    dynamic data;

    if (response.body.isNotEmpty) {
      data = jsonDecode(response.body);
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    var message = 'Request failed (${response.statusCode})';

    if (data is Map<String, dynamic>) {
      final detail = data['detail'];

      if (detail is String && detail.isNotEmpty) {
        message = detail;
      }
    }

    throw ApiException(response.statusCode, message);
  }
}
