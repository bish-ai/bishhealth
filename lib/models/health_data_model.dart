import 'package:hive/hive.dart';

part 'health_data_model.g.dart';

@HiveType(typeId: 0)
class HealthDataModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final double? heartRate;

  @HiveField(3)
  final double? stepsCount;

  @HiveField(4)
  final double? distance;

  @HiveField(5)
  final double? calories;

  @HiveField(6)
  final double? sleepDuration;

  @HiveField(7)
  final double? bloodPressureSystolic;

  @HiveField(8)
  final double? bloodPressureDiastolic;

  @HiveField(9)
  final double? bodyTemperature;

  @HiveField(10)
  final double? bloodOxygen;

  @HiveField(11)
  final double? weight;

  @HiveField(12)
  final double? height;

  @HiveField(13)
  final String? notes;

  @HiveField(14)
  final String? aiInsight;

  @HiveField(15)
  final String? dataSource;

  HealthDataModel({
    required this.id,
    required this.timestamp,
    this.heartRate,
    this.stepsCount,
    this.distance,
    this.calories,
    this.sleepDuration,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.bodyTemperature,
    this.bloodOxygen,
    this.weight,
    this.height,
    this.notes,
    this.aiInsight,
    this.dataSource,
  });

  double? get bmi {
    if (weight != null && height != null && height! > 0) {
      return weight! / (height! * height!);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'heartRate': heartRate,
      'stepsCount': stepsCount,
      'distance': distance,
      'calories': calories,
      'sleepDuration': sleepDuration,
      'bloodPressureSystolic': bloodPressureSystolic,
      'bloodPressureDiastolic': bloodPressureDiastolic,
      'bodyTemperature': bodyTemperature,
      'bloodOxygen': bloodOxygen,
      'weight': weight,
      'height': height,
      'notes': notes,
      'aiInsight': aiInsight,
      'dataSource': dataSource,
    };
  }

  factory HealthDataModel.fromJson(Map<String, dynamic> json) {
    return HealthDataModel(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      heartRate: json['heartRate'] as double?,
      stepsCount: json['stepsCount'] as double?,
      distance: json['distance'] as double?,
      calories: json['calories'] as double?,
      sleepDuration: json['sleepDuration'] as double?,
      bloodPressureSystolic: json['bloodPressureSystolic'] as double?,
      bloodPressureDiastolic: json['bloodPressureDiastolic'] as double?,
      bodyTemperature: json['bodyTemperature'] as double?,
      bloodOxygen: json['bloodOxygen'] as double?,
      weight: json['weight'] as double?,
      height: json['height'] as double?,
      notes: json['notes'] as String?,
      aiInsight: json['aiInsight'] as String?,
      dataSource: json['dataSource'] as String?,
    );
  }
}

@HiveType(typeId: 1)
class HealthMetricModel extends HiveObject {
  @HiveField(0)
  final String metricType;

  @HiveField(1)
  final double value;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final String unit;

  @HiveField(4)
  final String? status;

  HealthMetricModel({
    required this.metricType,
    required this.value,
    required this.timestamp,
    required this.unit,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'metricType': metricType,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
      'unit': unit,
      'status': status,
    };
  }
}

@HiveType(typeId: 2)
class UserProfileModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int age;

  @HiveField(3)
  final String gender;

  @HiveField(4)
  final double height;

  @HiveField(5)
  final double weight;

  @HiveField(6)
  final List<String> medicalConditions;

  @HiveField(7)
  final List<String> medications;

  @HiveField(8)
  final List<String> allergies;

  @HiveField(9)
  final DateTime createdAt;

  UserProfileModel({
    required this.userId,
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    this.medicalConditions = const [],
    this.medications = const [],
    this.allergies = const [],
    required this.createdAt,
  });

  double get bmi => weight / (height * height);

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'medicalConditions': medicalConditions,
      'medications': medications,
      'allergies': allergies,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      height: json['height'] as double,
      weight: json['weight'] as double,
      medicalConditions: List<String>.from(json['medicalConditions'] as List? ?? []),
      medications: List<String>.from(json['medications'] as List? ?? []),
      allergies: List<String>.from(json['allergies'] as List? ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}