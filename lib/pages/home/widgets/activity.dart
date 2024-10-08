import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfitness/database.dart'; // Import your DatabaseService
import 'package:intl/intl.dart'; // Import the intl package for date formatting

// Model class for Activity
class Activity {
  final String name;
  final String duration;
  final String calories;
  final String image;
  final DateTime timestamp;

  Activity({
    required this.name,
    required this.duration,
    required this.calories,
    required this.image,
    required this.timestamp,
  });

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Activity(
      name: data['name'] ?? 'Unknown',
      duration: data['duration'] ?? '0',
      calories: data['calories'] ?? '0',
      image: data['image'] ?? 'assets/profile.jpg',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}

class RecentActivities extends StatefulWidget {
  final Function onActivityAdded; // Callback to refresh activities

  const RecentActivities({super.key, required this.onActivityAdded});

  @override
  State<RecentActivities> createState() => _RecentActivitiesState();
}

class _RecentActivitiesState extends State<RecentActivities> {
  List<Activity> activities = []; // List to hold activities
  DatabaseService dbService = DatabaseService(); // Create an instance of DatabaseService
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchActivities(); // Fetch activities when the widget is initialized
  }

  void _fetchActivities() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    try {
      List<Map<String, dynamic>> fetchedActivitiesData = await dbService.fetchActivities();

      // Create Activity instances from the fetched data
      List<Activity> fetchedActivities = fetchedActivitiesData.map((data) {
        return Activity(
          name: data['name'] ?? 'Unknown',
          duration: data['duration'] ?? '0',
          calories: data['calories'] ?? '0',
          image: data['image'] ?? 'assets/profile.jpg',
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();

      setState(() {
        activities = fetchedActivities; // Update the state with the fetched activities
        _isLoading = false; // Stop loading
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading even on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch activities: $e")),
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('h:mm a d MMMM').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading indicator
                : Expanded(
                    child: ListView.builder(
                      itemCount: activities.length > 4 ? 4 : activities.length, // Limit to 4 records
                      itemBuilder: (BuildContext context, int index) {
                        Activity activity = activities[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              // Display the workout image
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: AssetImage(activity.image), // Use the image from the Activity model
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activity.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text('${activity.duration} min  |  ${activity.calories} kcal'),
                                  const SizedBox(height: 5),
                                  Text(
                                    _formatDateTime(activity.timestamp), // Display the formatted date and time
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
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