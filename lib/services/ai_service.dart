import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/health_data_model.dart';
import '../data/local/hive_service.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  late GenerativeModel model;
  
  // Replace with your actual API key
  static const String _apiKey = 'YOUR_GOOGLE_API_KEY_HERE';

  factory AIService() {
    return _instance;
  }

  AIService._internal() {
    model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
  }

  // Generate health insights
  Future<String> generateHealthInsight(HealthDataModel healthData, UserProfileModel? userProfile) async {
    try {
      final prompt = _buildHealthPrompt(healthData, userProfile);
      
      final response = await model.generateContent([
        Content.text(prompt),
      ]);

      final insight = response.text ?? 'Unable to generate insight';
      
      // Save the insight
      await HiveService.saveAIInsight(
        '${healthData.id}_insight',
        insight,
      );
      
      return insight;
    } catch (e) {
      print('Error generating AI insight: $e');
      return 'Unable to generate insight at the moment. Please try again later.';
    }
  }

  // Generate personalized health recommendations
  Future<List<String>> generateRecommendations(List<HealthDataModel> recentData, UserProfileModel? userProfile) async {
    try {
      final prompt = _buildRecommendationPrompt(recentData, userProfile);
      
      final response = await model.generateContent([
        Content.text(prompt),
      ]);

      final recommendations = _parseRecommendations(response.text ?? '');
      return recommendations;
    } catch (e) {
      print('Error generating recommendations: $e');
      return [];
    }
  }

  // Analyze health trends
  Future<String> analyzeTrends(List<HealthDataModel> healthDataList) async {
    try {
      final prompt = _buildTrendAnalysisPrompt(healthDataList);
      
      final response = await model.generateContent([
        Content.text(prompt),
      ]);

      return response.text ?? 'Unable to analyze trends';
    } catch (e) {
      print('Error analyzing trends: $e');
      return 'Unable to analyze trends at the moment.';
    }
  }

  // Detect anomalies in health data
  Future<List<String>> detectAnomalies(HealthDataModel latestData, List<HealthDataModel> historicalData) async {
    try {
      final prompt = _buildAnomalyDetectionPrompt(latestData, historicalData);
      
      final response = await model.generateContent([
        Content.text(prompt),
      ]);

      final anomalies = _parseAnomalies(response.text ?? '');
      return anomalies;
    } catch (e) {
      print('Error detecting anomalies: $e');
      return [];
    }
  }

  // Build health analysis prompt
  String _buildHealthPrompt(HealthDataModel data, UserProfileModel? userProfile) {
    StringBuffer prompt = StringBuffer();
    
    prompt.write('You are a health analytics AI assistant. Analyze the following health data and provide concise, actionable insights:\n\n');
    
    if (userProfile != null) {
      prompt.write('User Profile:\n');
      prompt.write('- Age: ${userProfile.age}\n');
      prompt.write('- Gender: ${userProfile.gender}\n');
      prompt.write('- BMI: ${userProfile.bmi.toStringAsFixed(2)}\n');
      if (userProfile.medicalConditions.isNotEmpty) {
        prompt.write('- Medical Conditions: ${userProfile.medicalConditions.join(', ')}\n');
      }
      prompt.write('\n');
    }
    
    prompt.write('Today\'s Health Data:\n');
    if (data.stepsCount != null) prompt.write('- Steps: ${data.stepsCount?.toStringAsFixed(0)}\n');
    if (data.heartRate != null) prompt.write('- Heart Rate: ${data.heartRate?.toStringAsFixed(0)} bpm\n');
    if (data.sleepDuration != null) prompt.write('- Sleep: ${data.sleepDuration?.toStringAsFixed(1)} hours\n');
    if (data.calories != null) prompt.write('- Calories Burned: ${data.calories?.toStringAsFixed(0)} kcal\n');
    if (data.distance != null) prompt.write('- Distance: ${data.distance?.toStringAsFixed(2)} km\n');
    if (data.bloodPressureSystolic != null && data.bloodPressureDiastolic != null) {
      prompt.write('- Blood Pressure: ${data.bloodPressureSystolic?.toStringAsFixed(0)}/${data.bloodPressureDiastolic?.toStringAsFixed(0)} mmHg\n');
    }
    
    prompt.write('\nProvide 2-3 specific, actionable insights based on this data. Keep the response concise and in bullet points.');
    
    return prompt.toString();
  }

  // Build recommendation prompt
  String _buildRecommendationPrompt(List<HealthDataModel> recentData, UserProfileModel? userProfile) {
    StringBuffer prompt = StringBuffer();
    
    prompt.write('Based on the following recent health data, provide 3-5 personalized health recommendations:\n\n');
    
    if (userProfile != null) {
      prompt.write('User Age: ${userProfile.age}\n');
      prompt.write('User Goal: Maintain a healthy lifestyle\n\n');
    }
    
    prompt.write('Recent Health Data (Last 7 days):\n');
    if (recentData.isNotEmpty) {
      final avgSteps = recentData.where((d) => d.stepsCount != null)
          .fold<double>(0, (sum, d) => sum + d.stepsCount!) / 
          recentData.where((d) => d.stepsCount != null).length;
      
      final avgHeartRate = recentData.where((d) => d.heartRate != null)
          .fold<double>(0, (sum, d) => sum + d.heartRate!) / 
          recentData.where((d) => d.heartRate != null).length;
      
      final avgSleep = recentData.where((d) => d.sleepDuration != null)
          .fold<double>(0, (sum, d) => sum + d.sleepDuration!) / 
          recentData.where((d) => d.sleepDuration != null).length;
      
      prompt.write('- Average Steps: $avgSteps\n');
      prompt.write('- Average Heart Rate: $avgHeartRate bpm\n');
      prompt.write('- Average Sleep: $avgSleep hours\n');
    }
    
    prompt.write('\nProvide recommendations in a numbered list format.');
    
    return prompt.toString();
  }

  // Build trend analysis prompt
  String _buildTrendAnalysisPrompt(List<HealthDataModel> healthDataList) {
    StringBuffer prompt = StringBuffer();
    
    prompt.write('Analyze the following health trends and summarize key patterns:\n\n');
    
    if (healthDataList.length > 1) {
      final first = healthDataList.first;
      final last = healthDataList.last;
      
      if (first.stepsCount != null && last.stepsCount != null) {
        final stepsChange = ((last.stepsCount! - first.stepsCount!) / first.stepsCount! * 100).toStringAsFixed(1);
        prompt.write('Steps Change: $stepsChange%\n');
      }
      
      if (first.weight != null && last.weight != null) {
        final weightChange = (last.weight! - first.weight!).toStringAsFixed(1);
        prompt.write('Weight Change: $weightChange kg\n');
      }
      
      if (first.sleepDuration != null && last.sleepDuration != null) {
        final sleepChange = (last.sleepDuration! - first.sleepDuration!).toStringAsFixed(1);
        prompt.write('Sleep Change: $sleepChange hours\n');
      }
    }
    
    prompt.write('\nProvide a brief summary of trends and their health implications.');
    
    return prompt.toString();
  }

  // Build anomaly detection prompt
  String _buildAnomalyDetectionPrompt(HealthDataModel latestData, List<HealthDataModel> historicalData) {
    StringBuffer prompt = StringBuffer();
    
    prompt.write('Identify any anomalies or concerning patterns in this health data:\n\n');
    prompt.write('Latest Reading:\n');
    
    if (latestData.heartRate != null) prompt.write('- Heart Rate: ${latestData.heartRate} bpm\n');
    if (latestData.bloodPressureSystolic != null) {
      prompt.write('- Blood Pressure: ${latestData.bloodPressureSystolic}/${latestData.bloodPressureDiastolic} mmHg\n');
    }
    if (latestData.bodyTemperature != null) prompt.write('- Temperature: ${latestData.bodyTemperature}°C\n');
    if (latestData.bloodOxygen != null) prompt.write('- Blood Oxygen: ${latestData.bloodOxygen}%\n');
    
    prompt.write('\nIf any values are concerning, list them and suggest actions.');
    
    return prompt.toString();
  }

  // Parse recommendations from AI response
  List<String> _parseRecommendations(String response) {
    final lines = response.split('\n');
    final recommendations = <String>[];
    
    for (var line in lines) {
      if (line.trim().isNotEmpty && 
          (line.startsWith(RegExp(r'^\d+\.')) || line.startsWith('-') || line.startsWith('•'))) {
        recommendations.add(line.replaceFirst(RegExp(r'^[\d.•\-\s]+'), '').trim());
      }
    }
    
    return recommendations.take(5).toList();
  }

  // Parse anomalies from AI response
  List<String> _parseAnomalies(String response) {
    final lines = response.split('\n');
    final anomalies = <String>[];
    
    for (var line in lines) {
      if (line.trim().isNotEmpty && line.contains('concern') || line.contains('high') || line.contains('low') || line.contains('abnormal')) {
        anomalies.add(line.trim());
      }
    }
    
    return anomalies;
  }
}