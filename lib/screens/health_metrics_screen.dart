import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';
import '../widgets/metric_card.dart';

class HealthMetricsScreen extends StatefulWidget {
  const HealthMetricsScreen({Key? key}) : super(key: key);

  @override
  State<HealthMetricsScreen> createState() => _HealthMetricsScreenState();
}

class _HealthMetricsScreenState extends State<HealthMetricsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthProvider>().loadHealthData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthProvider>(
      builder: (context, healthProvider, _) {
        return RefreshIndicator(
          onRefresh: () async {
            await healthProvider.loadHealthData();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Health Metrics',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                MetricCard(
                  title: 'Heart Rate',
                  value: '${healthProvider.heartRate.toStringAsFixed(0)} bpm',
                  icon: Icons.favorite,
                ),
                MetricCard(
                  title: 'Steps',
                  value: '${healthProvider.steps}',
                  icon: Icons.directions_walk,
                ),
                MetricCard(
                  title: 'Calories',
                  value: '${healthProvider.calories.toStringAsFixed(0)} kcal',
                  icon: Icons.local_fire_department,
                ),
                MetricCard(
                  title: 'Sleep',
                  value: '${healthProvider.sleep.toStringAsFixed(1)} hrs',
                  icon: Icons.bedtime,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      healthProvider.addHealthData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Health data updated!')),
                      );
                    },
                    child: const Text('Update Metrics'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
