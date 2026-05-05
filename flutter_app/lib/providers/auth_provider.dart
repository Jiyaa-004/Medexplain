import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthToken? _authToken;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  // Getters
  AuthToken? get authToken => _authToken;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  User? get user => _authToken?.user;
  String? get accessToken => _authToken?.accessToken;

  AuthProvider() {
    _initializeAuth();
  }

  // Initialize authentication state from SharedPreferences
  Future<void> _initializeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token != null) {
        _authToken = AuthToken(
          accessToken: token,
          tokenType: prefs.getString('token_type') ?? 'bearer',
          expiresIn: prefs.getInt('expires_in') ?? 3600,
          user: User(
            id: prefs.getInt('user_id') ?? 0,
            name: prefs.getString('user_name') ?? '',
            email: prefs.getString('user_email') ?? '',
            phone: prefs.getString('user_phone'),
            profileImage: prefs.getString('user_profile_image'),
            createdAt: DateTime.parse(prefs.getString('user_created_at') ??
                DateTime.now().toIso8601String()),
          ),
        );
        _isAuthenticated = true;
      }
    } catch (e) {
      debugPrint('Error initializing auth: $e');
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.login(email, password);

      if (response['success'] == false || response['access_token'] == null) {
        _error = response['error'] ?? 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _authToken = AuthToken.fromJson(response);
      _isAuthenticated = true;

      // Save to SharedPreferences
      await _saveToPreferences(_authToken!);

      _isLoading = false;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Signup
  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.signup(name, email, password);

      if (response['success'] == false || response['access_token'] == null) {
        _error = response['error'] ?? 'Signup failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _authToken = AuthToken.fromJson(response);
      _isAuthenticated = true;

      // Save to SharedPreferences
      await _saveToPreferences(_authToken!);

      _isLoading = false;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    if (_authToken?.refreshToken == null) {
      await logout();
      return false;
    }

    try {
      final response =
          await ApiService.refreshAccessToken(_authToken!.refreshToken!);

      if (response['success'] == false || response['access_token'] == null) {
        await logout();
        return false;
      }

      _authToken = AuthToken.fromJson(response);
      await _saveToPreferences(_authToken!);
      notifyListeners();
      return true;
    } catch (e) {
      await logout();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _authToken = null;
    _isAuthenticated = false;
    _error = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('token_type');
    await prefs.remove('expires_in');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_phone');
    await prefs.remove('user_profile_image');
    await prefs.remove('user_created_at');

    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Save token to SharedPreferences
  Future<void> _saveToPreferences(AuthToken token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('access_token', token.accessToken);
    await prefs.setString('token_type', token.tokenType);
    await prefs.setInt('expires_in', token.expiresIn);
    await prefs.setInt('user_id', token.user.id);
    await prefs.setString('user_name', token.user.name);
    await prefs.setString('user_email', token.user.email);

    if (token.user.phone != null) {
      await prefs.setString('user_phone', token.user.phone!);
    }

    if (token.user.profileImage != null) {
      await prefs.setString('user_profile_image', token.user.profileImage!);
    }

    await prefs.setString(
        'user_created_at', token.user.createdAt.toIso8601String());
  }
}
