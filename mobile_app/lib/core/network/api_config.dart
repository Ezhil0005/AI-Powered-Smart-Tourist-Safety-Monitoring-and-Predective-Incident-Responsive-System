class ApiConfig {
  ApiConfig._();

  // Android Emulator -> host PC backend
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8003',
  );
}