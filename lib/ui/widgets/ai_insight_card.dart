import 'package:flutter/material.dart';

class AIInsightCard extends StatelessWidget {
  final String insight;

  const AIInsightCard({Key? key, required this.insight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF6366F1).withOpacity(0.1),
      border: Border.all(
        color: Color(0xFF6366F1).withOpacity(0.3),
        width: 1,
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF6366F1),
                  ),
                  child: Icon(
                    Icons.lightbulb,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'AI Insight',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              insight,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}