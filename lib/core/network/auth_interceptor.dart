import 'package:dio/dio.dart';
import '../errors/exceptions.dart';
import '../services/session_service.dart';

/// Injects Bearer token and auto-refreshes on 401.
class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final SessionService _session;

  AuthInterceptor(this._dio, this._session);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _session.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        // Retry original request with new token
        final token = await _session.getAccessToken();
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $token';
        try {
          final response = await _dio.fetch(opts);
          handler.resolve(response);
          return;
        } catch (_) {}
      }
      // Refresh failed — clear session
      await _session.clearSession();
    }
    handler.next(err);
  }

  Future<bool> _tryRefresh() async {
    final refreshToken = await _session.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );
      final data = response.data['data'];
      await _session.saveTokens(
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
