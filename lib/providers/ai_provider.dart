import 'package:flutter/material.dart';
import '../models/health_data_model.dart';
import '../services/ai_service.dart';

class AIProvider extends ChangeNotifier {
  final AIService _aiService = AIService();
  
  String? _currentInsight;
  List<String> _recommendations = [];
  List<String> _anomalies = [];
  String? _trendAnalysis;
  bool _isLoading = false;
  String? _error;

  // Getters
  String? get currentInsight => _currentInsight;
  List<String> get recommendations => _recommendations;
  List<String> get anomalies => _anomalies;
  String? get trendAnalysis => _trendAnalysis;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Generate insight for current health data
  Future<void> generateInsight(HealthDataModel healthData, UserProfileModel? userProfile) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentInsight = await _aiService.generateHealthInsight(healthData, userProfile);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to generate insight: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Generate recommendations
  Future<void> generateRecommendations(List<HealthDataModel> recentData, UserProfileModel? userProfile) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _recommendations = await _aiService.generateRecommendations(recentData, userProfile);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to generate recommendations: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Analyze trends
  Future<void> analyzeTrends(List<HealthDataModel> healthData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _trendAnalysis = await _aiService.analyzeTrends(healthData);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to analyze trends: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Detect anomalies
  Future<void> detectAnomalies(HealthDataModel latestData, List<HealthDataModel> historicalData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _anomalies = await _aiService.detectAnomalies(latestData, historicalData);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to detect anomalies: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear all data
  void clearAll() {
    _currentInsight = null;
    _recommendations = [];
    _anomalies = [];
    _trendAnalysis = null;
    _error = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}