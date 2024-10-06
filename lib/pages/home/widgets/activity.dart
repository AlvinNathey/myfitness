import 'package:flutter/material.dart';
import 'package:myfitness/database.dart'; // Import your DatabaseService

class RecentActivities extends StatefulWidget {
  const RecentActivities({super.key});

  @override
  State<RecentActivities> createState() => _RecentActivitiesState();
}

class _RecentActivitiesState extends State<RecentActivities> {
  List<Map<String, dynamic>> activities = []; // List to hold activities
  DatabaseService dbService = DatabaseService(); // Create an instance of DatabaseService

  @override
  void initState() {
    super.initState();
    _fetchActivities(); // Fetch activities when the widget is initialized
  }

  void _fetchActivities() async {
    List<Map<String, dynamic>> fetchedActivities = await dbService.fetchActivities(); // Fetch activities from Firestore
    setState(() {
      activities = fetchedActivities; // Update the state with the fetched activities
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Activity', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Expanded(
              child: activities.isNotEmpty
                  ? ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        // Safely access the fields from Firestore
                        final String name = activity['name'] ?? 'Unknown workout';
                        final String duration = activity['duration'] ?? 'N/A';
                        final String calories = activity['calories'] ?? 'N/A';
                        final String imagePath = activity['image'] ?? 'assets/default_image.png'; // Default image

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: Image.asset(
                              imagePath,
                              width: 20,
                              height: 10,
                              fit: BoxFit.cover,
                            ),
                            title: Text(name), // Display name or default
                            subtitle: Text(
                              'Duration: $duration min, Calories: $calories kcal',
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('Record your workout for data to appear here'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
