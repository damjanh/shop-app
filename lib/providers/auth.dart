import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

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
    } catch (error) {
      throw error;
    }
  }
}
