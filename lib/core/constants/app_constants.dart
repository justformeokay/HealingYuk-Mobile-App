class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl =
      'https://api-trip.karyadeveloperindonesia.com/api/v1';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUser = 'user';
  static const String keyIsLoggedIn = 'is_logged_in';

  // Pagination
  static const int defaultPageSize = 15;

  // App info
  static const String appName = 'HealingYuk';
  static const String appVersion = '1.0.0';
}
