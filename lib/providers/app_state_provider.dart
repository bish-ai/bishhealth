import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isInitialized = false;
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _isFirstTime = true;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isFirstTime => _isFirstTime;

  // Initialize
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    _notificationsEnabled = _prefs.getBool('notificationsEnabled') ?? true;
    _isFirstTime = _prefs.getBool('isFirstTime') ?? true;
    _isInitialized = true;
    notifyListeners();
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  // Toggle notifications
  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    await _prefs.setBool('notificationsEnabled', _notificationsEnabled);
    notifyListeners();
  }

  // Mark first time as done
  Future<void> completeFirstTime() async {
    _isFirstTime = false;
    await _prefs.setBool('isFirstTime', false);
    notifyListeners();
  }

  // Get setting value
  dynamic getSetting(String key, {dynamic defaultValue}) {
    return _prefs.get(key) ?? defaultValue;
  }

  // Save setting
  Future<void> saveSetting(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }
    notifyListeners();
  }

  // Clear all settings
  Future<void> clearAllSettings() async {
    await _prefs.clear();
    _isDarkMode = false;
    _notificationsEnabled = true;
    _isFirstTime = true;
    notifyListeners();
  }
}