import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfitness/database.dart'; // Import your DatabaseService
import 'package:intl/intl.dart'; // Import the intl package for date formatting

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

  String _formatDateTime(DateTime dateTime) {
    // Format the date and time as "8:21 AM 7 October"
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
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (BuildContext context, int index) {
                  String workoutName = activities[index]['name'];
                  String duration = activities[index]['duration'];
                  String calories = activities[index]['calories'];
                  String? image = activities[index]['image']; // Retrieve the image URL
                  DateTime activityTime = (activities[index]['timestamp'] as Timestamp).toDate(); // Assuming Firestore stores 'timestamp'

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
                              image: AssetImage(image ?? 'assets/profile.jpg'), // Use default image if null
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              workoutName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text('$duration min  |  $calories kcal'),
                            const SizedBox(height: 5),
                            Text(
                              _formatDateTime(activityTime), // Display the formatted date and time
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
