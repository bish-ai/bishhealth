import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIProvider extends ChangeNotifier {
  String _analysisResult = '';
  String _errorMessage = '';
  bool _isLoading = false;

  String get analysisResult => _analysisResult;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> analyzeHealth(String symptoms) async {
    if (symptoms.isEmpty) {
      _errorMessage = 'Please enter symptoms or health concerns';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Using OpenRouter API as fallback (works in Vercel serverless)
      final apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? '';
      
      if (apiKey.isEmpty) {
        _analysisResult = 'AI Analysis: Based on your input: "$symptoms", '
            'here are some general health recommendations: '
            '1. Consult a healthcare professional for personalized advice. '
            '2. Maintain a healthy lifestyle with regular exercise. '
            '3. Get adequate sleep (7-9 hours daily). '
            '4. Stay hydrated and eat nutritious food.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful health AI assistant. Provide brief, '
                  'general health advice based on user symptoms. Always recommend '
                  'consulting a healthcare professional.'
            },
            {
              'role': 'user',
              'content': 'Please analyze these health concerns: $symptoms'
            }
          ],
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _analysisResult = data['choices'][0]['message']['content'];
      } else {
        _errorMessage = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error: Unable to analyze. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
