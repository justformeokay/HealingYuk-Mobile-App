import 'package:flutter/foundation.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/session_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ApiClient _api;
  final SessionService _session;

  UserEntity? _user;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  ProfileProvider(this._api, this._session);

  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  Future<void> loadProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _api.get('/me');
      _user = UserModel.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      // Try from cache
      final cached = await _session.getUser();
      if (cached != null) {
        _user = UserModel.fromJson(cached);
      } else {
        _error = 'Failed to load profile';
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile({
    required String name,
    String? phone,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.patch('/me', data: {
        'name': name,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      });
      final updated =
          UserModel.fromJson(response['data'] as Map<String, dynamic>);
      _user = updated;
      await _session.saveUser(response['data'] as Map<String, dynamic>);
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isSaving = true;
    notifyListeners();

    try {
      await _api.post('/me/change-password', data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPassword,
      });
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }
}
