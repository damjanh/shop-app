import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signUp(String email, String password) async {
    const url = "signUp";
    const key = "AIzaSyAa0sDY2O6AN-se1imE0FPXKVSLV05kNhs";
    return _authenticate(email, password, url, key);
  }

  Future<void> logIn(String email, String password) async {
    const url = "signInWithPassword";
    const key = "AIzaSyAa0sDY2O6AN-se1imE0FPXKVSLV05kNhs";
    return _authenticate(email, password, url, key);
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment, String apiKey) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey";
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      final expiresIn = responseData['expiresIn'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(expiresIn)));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user_data', json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      }));
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user_data')) {
      return false;
    }
    final userData = json.decode(prefs.getString('user_data')) as Map<String, Object>;
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _expiryDate = expiryDate;
    _userId = userData['userId'];
    _token = userData['token'];
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeDiff = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeDiff), logout);
  }
}
