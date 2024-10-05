import 'package:flutter/material.dart';

class RecentActivities extends StatefulWidget {
  const RecentActivities({Key? key}) : super(key: key);

  @override
  State<RecentActivities> createState() => _RecentActivitiesState();
}

class _RecentActivitiesState extends State<RecentActivities> {
  final List<Map<String, String>> activities = [];

  @override
  void initState() {
    super.initState();
    // Fetch activities when the widget is initialized
  }

  // Fetch activities logic should be added here later when implementing Firebase

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Activity', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return ActivityItem(
                    name: activity['name']!,
                    duration: activity['duration']!,
                    calories: activity['calories']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityItem extends StatelessWidget {
  final String name;
  final String duration;
  final String calories;

  const ActivityItem({
    Key? key,
    required this.name,
    required this.duration,
    required this.calories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(name),
        subtitle: Text('Duration: $duration min, Calories: $calories kcal'),
      ),
    );
  }
}
