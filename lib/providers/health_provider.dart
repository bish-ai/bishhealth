import 'package:flutter/foundation.dart';
import 'dart:math';

class HealthProvider extends ChangeNotifier {
  double _heartRate = 72.0;
  int _steps = 5000;
  double _calories = 250.0;
  double _sleep = 7.5;
  List<Map<String, dynamic>> _healthHistory = [];

  double get heartRate => _heartRate;
  int get steps => _steps;
  double get calories => _calories;
  double get sleep => _sleep;
  List<Map<String, dynamic>> get healthHistory => _healthHistory;

  Future<void> loadHealthData() async {
    // Simulate API call to fetch health data
    await Future.delayed(const Duration(seconds: 1));
    _generateRandomHealthData();
    notifyListeners();
  }

  void addHealthData() {
    _generateRandomHealthData();
    _healthHistory.add({
      'heartRate': _heartRate,
      'steps': _steps,
      'calories': _calories,
      'sleep': _sleep,
      'timestamp': DateTime.now(),
    });
    notifyListeners();
  }

  void _generateRandomHealthData() {
    final random = Random();
    _heartRate = 60 + random.nextDouble() * 40; // 60-100 bpm
    _steps = 3000 + random.nextInt(15000);
    _calories = 200 + random.nextDouble() * 600;
    _sleep = 5 + random.nextDouble() * 4;
  }
}
