import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Set user from auth
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  // Fetch user profile
  Future<void> fetchProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getUserProfile();

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to fetch profile';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _user = User.fromJson(response);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Update user profile
  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? profileImage,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (profileImage != null) data['profile_image'] = profileImage;

      final response = await ApiService.updateUserProfile(data);

      if (response['success'] == false) {
        _error = response['error'] ?? 'Failed to update profile';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Update local user
      if (_user != null) {
        _user = _user!.copyWith(
          name: name ?? _user!.name,
          phone: phone ?? _user!.phone,
          profileImage: profileImage ?? _user!.profileImage,
        );
      }

      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clear() {
    _user = null;
    _error = null;
    notifyListeners();
  }
}
