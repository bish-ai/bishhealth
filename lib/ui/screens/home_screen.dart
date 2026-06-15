import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/health_provider.dart';
import '../../providers/ai_provider.dart';
import '../widgets/health_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/ai_insight_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    final healthProvider = context.read<HealthProvider>();
    final aiProvider = context.read<AIProvider>();
    
    // Request permissions
    await healthProvider.requestHealthPermissions();
    
    // Sync health data
    await healthProvider.syncHealthData();
    
    // Generate insights
    if (healthProvider.healthDataList.isNotEmpty) {
      await aiProvider.generateInsight(
        healthProvider.healthDataList.first,
        healthProvider.userProfile,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('BishHealth'),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => _initializeData(),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
        body: Consumer2<HealthProvider, AIProvider>(
          builder: (context, healthProvider, aiProvider, _) {
            return RefreshIndicator(
              onRefresh: () async => await healthProvider.syncHealthData(),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome message
                      Text(
                        'Today\'s Health Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 16),

                      // Health cards
                      if (healthProvider.isLoading)
                        Center(child: CircularProgressIndicator())
                      else
                        Column(
                          children: [
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              children: [
                                HealthCard(
                                  icon: Icons.favorite,
                                  label: 'Heart Rate',
                                  value: healthProvider.getTodaySummary()?.heartRate?.toStringAsFixed(0) ?? '--',
                                  unit: 'bpm',
                                  color: Colors.red,
                                ),
                                HealthCard(
                                  icon: Icons.directions_walk,
                                  label: 'Steps',
                                  value: healthProvider.getTodaySummary()?.stepsCount?.toStringAsFixed(0) ?? '--',
                                  unit: 'steps',
                                  color: Colors.blue,
                                ),
                                HealthCard(
                                  icon: Icons.local_fire_department,
                                  label: 'Calories',
                                  value: healthProvider.getTodaySummary()?.calories?.toStringAsFixed(0) ?? '--',
                                  unit: 'kcal',
                                  color: Colors.orange,
                                ),
                                HealthCard(
                                  icon: Icons.nights_stay,
                                  label: 'Sleep',
                                  value: healthProvider.getTodaySummary()?.sleepDuration?.toStringAsFixed(1) ?? '--',
                                  unit: 'hrs',
                                  color: Colors.purple,
                                ),
                              ],
                            ),
                            SizedBox(height: 24),

                            // AI Insight
                            if (aiProvider.currentInsight != null)
                              AIInsightCard(insight: aiProvider.currentInsight ?? ''),
                            
                            SizedBox(height: 24),

                            // Weekly stats
                            Text(
                              'Weekly Statistics',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(height: 12),
                            _buildWeeklyStats(context, healthProvider),

                            SizedBox(height: 24),

                            // Action buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => Navigator.pushNamed(context, '/add-data'),
                                    icon: Icon(Icons.add),
                                    label: Text('Add Data'),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => Navigator.pushNamed(context, '/history'),
                                    icon: Icon(Icons.history),
                                    label: Text('History'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWeeklyStats(BuildContext context, HealthProvider healthProvider) {
    final stats = healthProvider.getWeeklyStats();
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            StatsCard(
              label: 'Total Steps',
              value: stats['total_steps']?.toStringAsFixed(0) ?? '0',
            ),
            StatsCard(
              label: 'Total Calories',
              value: stats['total_calories']?.toStringAsFixed(0) ?? '0',
            ),
            StatsCard(
              label: 'Avg Heart Rate',
              value: stats['avg_heart_rate']?.toStringAsFixed(0) ?? '0',
            ),
            StatsCard(
              label: 'Total Sleep',
              value: '${stats['total_sleep']?.toStringAsFixed(1) ?? '0'} hrs',
            ),
          ],
        ),
      ),
    );
  }
}