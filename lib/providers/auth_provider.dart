import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../services/database_helper.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  // Cek apakah sudah login sebelumnya
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    if (email != null) {
      _user = User(
          username: prefs.getString('username')!,
          email: email,
          password: prefs.getString('password')!);
      notifyListeners();
    }
  }

  // Simpan data user di shared preferences
  Future<void> _saveUserToSharedPreferences(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', user.email);
    prefs.setString('username', user.username);
    prefs.setString('password', user.password);
  }

  // Login user
  Future<bool> login(String email, String password) async {
    User? loggedInUser = await DatabaseHelper.instance.getUser(email, password);
    if (loggedInUser != null) {
      _user = loggedInUser;
      await _saveUserToSharedPreferences(_user!);
      notifyListeners();
      return true;
    }
    return false;
  }

  // Register user
  Future<bool> register(String username, String email, String password) async {
    bool emailExists = await DatabaseHelper.instance.checkEmailExists(email);

    if (emailExists) {
      return false;
    }

    User newUser = User(username: username, email: email, password: password);
    int userId = await DatabaseHelper.instance.addUser(newUser);

    if (userId > 0) {
      _user = newUser;
      await _saveUserToSharedPreferences(_user!);
      notifyListeners();
      return true;
    }
    return false;
  }

  // Logout user dan hapus dari shared preferences
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _user = null;
    notifyListeners();
  }
}
