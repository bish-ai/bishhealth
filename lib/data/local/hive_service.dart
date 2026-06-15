import 'package:hive/hive.dart';
import '../../models/health_data_model.dart';

class HiveService {
  static const String healthDataBox = 'health_data';
  static const String userProfileBox = 'user_profile';
  static const String settingsBox = 'settings';
  static const String aiInsightsBox = 'ai_insights';

  static Future<void> init() async {
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HealthDataModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(HealthMetricModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserProfileModelAdapter());
    }

    // Open boxes
    await Hive.openBox(healthDataBox);
    await Hive.openBox(userProfileBox);
    await Hive.openBox(settingsBox);
    await Hive.openBox(aiInsightsBox);
  }

  // Health Data operations
  static Future<void> saveHealthData(HealthDataModel data) async {
    final box = Hive.box(healthDataBox);
    await box.put(data.id, data);
  }

  static List<HealthDataModel> getAllHealthData() {
    final box = Hive.box(healthDataBox);
    return box.values.cast<HealthDataModel>().toList();
  }

  static HealthDataModel? getHealthDataById(String id) {
    final box = Hive.box(healthDataBox);
    return box.get(id) as HealthDataModel?;
  }

  static Future<void> deleteHealthData(String id) async {
    final box = Hive.box(healthDataBox);
    await box.delete(id);
  }

  static List<HealthDataModel> getHealthDataByDateRange(DateTime start, DateTime end) {
    final box = Hive.box(healthDataBox);
    return box.values
        .cast<HealthDataModel>()
        .where((data) => data.timestamp.isAfter(start) && data.timestamp.isBefore(end))
        .toList();
  }

  // User Profile operations
  static Future<void> saveUserProfile(UserProfileModel profile) async {
    final box = Hive.box(userProfileBox);
    await box.put('current_user', profile);
  }

  static UserProfileModel? getUserProfile() {
    final box = Hive.box(userProfileBox);
    return box.get('current_user') as UserProfileModel?;
  }

  static Future<void> updateUserProfile(UserProfileModel profile) async {
    final box = Hive.box(userProfileBox);
    await box.put('current_user', profile);
  }

  // Settings operations
  static Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box(settingsBox);
    await box.put(key, value);
  }

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    final box = Hive.box(settingsBox);
    return box.get(key, defaultValue: defaultValue);
  }

  static Future<void> deleteSetting(String key) async {
    final box = Hive.box(settingsBox);
    await box.delete(key);
  }

  // AI Insights operations
  static Future<void> saveAIInsight(String id, String insight) async {
    final box = Hive.box(aiInsightsBox);
    await box.put(id, {
      'insight': insight,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static Map<String, dynamic>? getAIInsight(String id) {
    final box = Hive.box(aiInsightsBox);
    return box.get(id) as Map<String, dynamic>?;
  }

  static List<Map<String, dynamic>> getAllAIInsights() {
    final box = Hive.box(aiInsightsBox);
    return box.values.cast<Map<String, dynamic>>().toList();
  }

  // Clear all data
  static Future<void> clearAllData() async {
    await Hive.box(healthDataBox).clear();
    await Hive.box(userProfileBox).clear();
    await Hive.box(settingsBox).clear();
    await Hive.box(aiInsightsBox).clear();
  }
}