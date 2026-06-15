import 'package:flutter/material.dart';
import '../models/health_data_model.dart';
import '../data/local/hive_service.dart';
import '../services/health_service.dart';

class HealthProvider extends ChangeNotifier {
  final HealthService _healthService = HealthService();
  
  List<HealthDataModel> _healthDataList = [];
  UserProfileModel? _userProfile;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<HealthDataModel> get healthDataList => _healthDataList;
  UserProfileModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  HealthProvider() {
    _initialize();
  }

  // Initialize provider
  Future<void> _initialize() async {
    _loadUserProfile();
    _loadHealthData();
  }

  // Load user profile
  void _loadUserProfile() {
    _userProfile = HiveService.getUserProfile();
    notifyListeners();
  }

  // Save user profile
  Future<void> saveUserProfile(UserProfileModel profile) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await HiveService.saveUserProfile(profile);
      _userProfile = profile;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save profile: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load health data
  void _loadHealthData() {
    _healthDataList = HiveService.getAllHealthData();
    _healthDataList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  // Add health data
  Future<void> addHealthData(HealthDataModel data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await HiveService.saveHealthData(data);
      _loadHealthData();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add health data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update health data
  Future<void> updateHealthData(HealthDataModel data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await HiveService.saveHealthData(data);
      _loadHealthData();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update health data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete health data
  Future<void> deleteHealthData(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await HiveService.deleteHealthData(id);
      _loadHealthData();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete health data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get health data by date range
  List<HealthDataModel> getHealthDataByDateRange(DateTime start, DateTime end) {
    return HiveService.getHealthDataByDateRange(start, end)
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Sync health data from system
  Future<void> syncHealthData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _healthService.syncHealthData();
      _loadHealthData();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to sync health data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Request permissions
  Future<bool> requestHealthPermissions() async {
    try {
      return await _healthService.requestHealthPermissions();
    } catch (e) {
      _error = 'Failed to request permissions: $e';
      notifyListeners();
      return false;
    }
  }

  // Get today's summary
  HealthDataModel? getTodaySummary() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    try {
      return _healthDataList.firstWhere(
        (data) => data.timestamp.isAfter(today) && data.timestamp.isBefore(tomorrow),
        orElse: () => HealthDataModel(
          id: 'empty',
          timestamp: now,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  // Get weekly stats
  Map<String, double> getWeeklyStats() {
    final now = DateTime.now();
    final weekAgo = now.subtract(Duration(days: 7));
    
    final weekData = getHealthDataByDateRange(weekAgo, now);
    
    double totalSteps = 0;
    double totalCalories = 0;
    double avgHeartRate = 0;
    double totalSleep = 0;
    int heartRateCount = 0;

    for (var data in weekData) {
      if (data.stepsCount != null) totalSteps += data.stepsCount!;
      if (data.calories != null) totalCalories += data.calories!;
      if (data.heartRate != null) {
        avgHeartRate += data.heartRate!;
        heartRateCount++;
      }
      if (data.sleepDuration != null) totalSleep += data.sleepDuration!;
    }

    return {
      'total_steps': totalSteps,
      'total_calories': totalCalories,
      'avg_heart_rate': heartRateCount > 0 ? avgHeartRate / heartRateCount : 0,
      'total_sleep': totalSleep,
    };
  }

  // Clear all errors
  void clearError() {
    _error = null;
    notifyListeners();
  }
}