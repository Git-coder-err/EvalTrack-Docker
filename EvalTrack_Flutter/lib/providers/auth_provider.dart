import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _loading = false;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _loading;
  bool get isAuthenticated => _token != null;

  final String baseUrl = 'http://127.0.0.1:5000/api';

  AuthProvider() {
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userStr = prefs.getString('user');
    if (userStr != null) {
      _user = User.fromJson(jsonDecode(userStr));
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        _token = data['token'];
        _user = User.fromJson(data['user']);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', jsonEncode(data['user']));

        _loading = false;
        notifyListeners();
        return {'success': true, 'user': _user};
      } else {
        _loading = false;
        notifyListeners();
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      _loading = false;
      notifyListeners();
      return {'success': false, 'message': 'Connection error'};
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> payload) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        _token = data['token'];
        _user = User.fromJson(data['user']);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', jsonEncode(data['user']));

        _loading = false;
        notifyListeners();
        return {'success': true, 'user': _user};
      } else {
        _loading = false;
        notifyListeners();
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      _loading = false;
      notifyListeners();
      return {'success': false, 'message': 'Connection error'};
    }
  }

  Future<Map<String, dynamic>> changePassword(String newPassword) async {
    if (_user == null || _token == null)
      return {'success': false, 'message': 'Not authenticated'};

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({'id': _user!.id, 'new_password': newPassword}),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        // Update local user state
        _user = User(
          id: _user!.id,
          name: _user!.name,
          email: _user!.email,
          role: _user!.role,
          status: _user!.status,
          program: _user!.program,
          yearLevel: _user!.yearLevel,
          studentType: _user!.studentType,
          mustChangePassword: false,
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(_user!.toJson()));
        notifyListeners();
        return {'success': true};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Update failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error'};
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    notifyListeners();
  }
}
