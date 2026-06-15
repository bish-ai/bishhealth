import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/health_data_model.dart';
import '../data/local/hive_service.dart';

class HealthService {
  static final HealthService _instance = HealthService._internal();
  late Health health;

  factory HealthService() {
    return _instance;
  }

  HealthService._internal() {
    health = Health();
  }

  // Request health permissions
  Future<bool> requestHealthPermissions() async {
    final permissions = [
      Permission.health,
      Permission.activityRecognition,
      Permission.sensors,
    ];

    final statuses = await permissions.request();

    return statuses.values.every((status) => status.isDenied == false);
  }

  // Get steps data
  Future<double> getStepsData(DateTime start, DateTime end) async {
    try {
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: start,
        endTime: end,
      );

      double totalSteps = 0;
      for (var point in healthData) {
        totalSteps += (point.value as double);
      }
      return totalSteps;
    } catch (e) {
      print('Error fetching steps: $e');
      return 0;
    }
  }

  // Get heart rate data
  Future<double?> getHeartRateData(DateTime start, DateTime end) async {
    try {
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        types: [HealthDataType.HEART_RATE],
        startTime: start,
        endTime: end,
      );

      if (healthData.isNotEmpty) {
        return (healthData.last.value as num).toDouble();
      }
      return null;
    } catch (e) {
      print('Error fetching heart rate: $e');
      return null;
    }
  }

  // Get sleep data
  Future<double> getSleepData(DateTime start, DateTime end) async {
    try {
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        types: [HealthDataType.SLEEP_IN_BED, HealthDataType.SLEEP_ASLEEP],
        startTime: start,
        endTime: end,
      );

      Duration totalSleep = Duration.zero;
      for (var point in healthData) {
        if (point is HealthDataPoint) {
          totalSleep += Duration(
            milliseconds: ((point.value as Map)['end'] as int) - 
                         ((point.value as Map)['start'] as int),
          );
        }
      }
      return totalSleep.inHours.toDouble();
    } catch (e) {
      print('Error fetching sleep data: $e');
      return 0;
    }
  }

  // Get calories burned
  Future<double> getCaloriesBurned(DateTime start, DateTime end) async {
    try {
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: start,
        endTime: end,
      );

      double totalCalories = 0;
      for (var point in healthData) {
        totalCalories += (point.value as num).toDouble();
      }
      return totalCalories;
    } catch (e) {
      print('Error fetching calories: $e');
      return 0;
    }
  }

  // Get distance covered
  Future<double> getDistanceCovered(DateTime start, DateTime end) async {
    try {
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        types: [HealthDataType.DISTANCE],
        startTime: start,
        endTime: end,
      );

      double totalDistance = 0;
      for (var point in healthData) {
        totalDistance += (point.value as num).toDouble();
      }
      return totalDistance;
    } catch (e) {
      print('Error fetching distance: $e');
      return 0;
    }
  }

  // Get weight
  Future<double?> getLatestWeight() async {
    try {
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        types: [HealthDataType.WEIGHT],
        startTime: DateTime.now().subtract(Duration(days: 30)),
        endTime: DateTime.now(),
      );

      if (healthData.isNotEmpty) {
        return (healthData.last.value as num).toDouble();
      }
      return null;
    } catch (e) {
      print('Error fetching weight: $e');
      return null;
    }
  }

  // Get blood pressure
  Future<Map<String, double>?> getLatestBloodPressure() async {
    try {
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        types: [HealthDataType.BLOOD_PRESSURE],
        startTime: DateTime.now().subtract(Duration(days: 30)),
        endTime: DateTime.now(),
      );

      if (healthData.isNotEmpty) {
        var lastReading = healthData.last.value as Map;
        return {
          'systolic': (lastReading['systolic'] as num).toDouble(),
          'diastolic': (lastReading['diastolic'] as num).toDouble(),
        };
      }
      return null;
    } catch (e) {
      print('Error fetching blood pressure: $e');
      return null;
    }
  }

  // Sync health data to local storage
  Future<void> syncHealthData() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    try {
      final steps = await getStepsData(today, now);
      final heartRate = await getHeartRateData(today, now);
      final sleepDuration = await getSleepData(today, now);
      final calories = await getCaloriesBurned(today, now);
      final distance = await getDistanceCovered(today, now);
      final weight = await getLatestWeight();
      final bloodPressure = await getLatestBloodPressure();

      final healthData = HealthDataModel(
        id: '${today.toIso8601String()}_sync',
        timestamp: now,
        stepsCount: steps > 0 ? steps : null,
        heartRate: heartRate,
        sleepDuration: sleepDuration > 0 ? sleepDuration : null,
        calories: calories > 0 ? calories : null,
        distance: distance > 0 ? distance : null,
        weight: weight,
        bloodPressureSystolic: bloodPressure?['systolic'],
        bloodPressureDiastolic: bloodPressure?['diastolic'],
        dataSource: 'Health Platform Sync',
      );

      await HiveService.saveHealthData(healthData);
    } catch (e) {
      print('Error syncing health data: $e');
    }
  }
}