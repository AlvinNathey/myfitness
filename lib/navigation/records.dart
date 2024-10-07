import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfitness/pages/home/widgets/header.dart';
import 'package:myfitness/widgets/bottom_navigation.dart';
import 'package:myfitness/database.dart'; // Import your DatabaseService
import 'package:intl/intl.dart';

class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
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
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'All your activities',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.normal),
            ),
          ),
          Expanded(
            child: activities.isEmpty
                ? const Center(
                    child: Text('No activities recorded yet.'),
                  )
                : ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      String workoutName = activities[index]['name'];
                      String duration = activities[index]['duration'];
                      String calories = activities[index]['calories'];
                      String? image = activities[index]['image']; // Retrieve the image URL
                      DateTime timestamp = (activities[index]['timestamp'] as Timestamp).toDate(); // Convert timestamp to DateTime
                      String formattedTime = _formatDateTime(timestamp); // Format the DateTime

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20,left: 20),
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
                            const SizedBox(width: 20),
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
                                Text(formattedTime), // Display formatted time
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          BottomNavigation(
            selectedIndex: 1, // Set index for Records page
            onItemTapped: (index) {
              switch (index) {
                case 0:
                  Navigator.of(context).pushReplacementNamed('/');
                  break;
                case 1:
                  //does nothing, already on Records page
                  break;
                case 2:
                  Navigator.of(context).pushReplacementNamed('/stats'); // Navigate to stats page if needed
                  break;
                case 3:
                  Navigator.of(context).pushReplacementNamed('/profile');
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
