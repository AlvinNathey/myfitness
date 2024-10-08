import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:myfitness/pages/home/widgets/header.dart'; // Import the header
import 'package:myfitness/widgets/bottom_navigation.dart'; // Import the bottom navigation

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final Map<DateTime, List<dynamic>> _activities = {};
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instance of FirebaseAuth
  int _selectedIndex = 2; // Set the selected index for bottom navigation

  @override
  void initState() {
    super.initState();
    _fetchActivities();
  }

  Future<void> _fetchActivities() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('activities')
          .get();

      print('Number of activities fetched: ${snapshot.docs.length}');

      for (var doc in snapshot.docs) {
        DateTime date = (doc['timestamp'] as Timestamp).toDate();
        DateTime normalizedDate = DateTime(date.year, date.month, date.day);

        if (_activities[normalizedDate] == null) {
          _activities[normalizedDate] = [];
        }
        _activities[normalizedDate]!.add(doc.data());

        print('Activity on $normalizedDate: ${doc.data()}');
      }

      print('Grouped activities: $_activities');

      setState(() {});
    } else {
      print('No user is logged in.');
    }
  }

  int _getTotalCaloriesForDate(DateTime date) {
    final activitiesForDate = _activities[date];

    if (activitiesForDate != null && activitiesForDate.isNotEmpty) {
      return activitiesForDate.fold(0, (total, activity) {
        print('Activity calories: ${activity['calories']}');
        int calories = int.tryParse(activity['calories']?.toString() ?? '0') ?? 0;
        return total + calories;
      });
    }

    return 0; // Return 0 if no activities
  }

  String _formatDate(DateTime date) {
    // Format the date as "8th October, 2024"
    String day = DateFormat('d').format(date);
    String month = DateFormat('MMMM').format(date);
    String year = DateFormat('y').format(date);
    return '$day${_getDaySuffix(int.parse(day))} $month, $year';
  }

  String _getDaySuffix(int day) {
    // Determine the suffix for the day (st, nd, rd, th)
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  void _showActivitiesForDate(BuildContext context, DateTime date) {
    List<dynamic>? activities = _activities[date];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Activities on ${_formatDate(date)}'),
          content: SizedBox(
            height: 200, // Set a fixed height for the dialog
            width: double.maxFinite, // Allow the dialog to be wide enough
            child: activities != null && activities.isNotEmpty
                ? ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      var activity = activities[index];
                      return ListTile(
                        title: Text(activity['name']), // Display activity name
                        subtitle: Text('Calories: ${activity['calories']}'), // Display calories
                      );
                    },
                  )
                : const Center(child: Text('No activities recorded for this day.')),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(), // Include the header
          Expanded(
            child: ListView.builder(
              itemCount: _activities.keys.length,
              itemBuilder: (context, index) {
                DateTime date = _activities.keys.elementAt(index);
                int totalCalories = _getTotalCaloriesForDate(date);
                String formattedDate = _formatDate(date); // Get the formatted date

                return GestureDetector(
                  onTap: () => _showActivitiesForDate(context, date), // Show activities on tap
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Add margin for spacing
                    child: ListTile(
                      title: Center(child: Text(formattedDate)), // Center the date text
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // Center the subtitle content
                        children: [
                          Text('Total Calories: $totalCalories', textAlign: TextAlign.center),
                          const SizedBox(height: 8), // Add spacing
                          if (totalCalories > 200) // Check calories threshold
                            Text(
                              'Congratulations 🎉',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                              textAlign: TextAlign.center, // Center the congratulatory message
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          BottomNavigation(
            selectedIndex: _selectedIndex,
            onItemTapped: (index) {
              setState(() {
                _selectedIndex = index; // Update selected index
              });
              switch (index) {
                case 0:
                  Navigator.of(context).pushReplacementNamed('/'); // Navigate to Home
                  break;
                case 1:
                  Navigator.of(context).pushReplacementNamed('/records'); // Navigate to Records
                  break;
                case 2:
                  // Do nothing, already on Stats
                  break;
                case 3:
                  Navigator.of(context).pushReplacementNamed('/profile'); // Navigate to Profile
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
