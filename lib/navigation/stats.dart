import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:myfitness/pages/home/widgets/header.dart';
import 'package:myfitness/widgets/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late Map<DateTime, List<Map<String, dynamic>>> activitiesMap;
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    activitiesMap = {};
    _fetchActivities();
  }

  Future<void> _fetchActivities() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('activities').get();

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      DateTime date = (data['timestamp'] as Timestamp).toDate();
      date = DateTime(date.year, date.month, date.day);

      String? caloriesString = data['calories'] as String?;
      // ignore: unused_local_variable
      int calories = caloriesString != null ? int.parse(caloriesString) : 0;

      print('Fetched activity: $caloriesString calories on $date');

      if (activitiesMap[date] == null) {
        activitiesMap[date] = [];
      }
      activitiesMap[date]!.add(data);
    }

    setState(() {});
  }

  int _getTotalCaloriesForDay(DateTime day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    
    return activitiesMap[normalizedDay]?.map((activity) {
      String? caloriesString = activity['calories'] as String?;
      return caloriesString != null ? int.parse(caloriesString) : 0;
    }).fold(0, (a, b) => (a ?? 0) + b) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: Column(
              children: [
                TableCalendar<Map<String, dynamic>>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: selectedDay,
                  selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      this.selectedDay = selectedDay;
                    });

                    int totalCalories = _getTotalCaloriesForDay(selectedDay);
                    String celebrationMessage = totalCalories > 200
                        ? "🎉 Congratulations on your hard work! You burned $totalCalories calories."
                        : "Keep going! You burned $totalCalories calories.";

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Calories Burned"),
                          content: Text(celebrationMessage),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  calendarBuilders: CalendarBuilders(
                    todayBuilder: (context, day, focusedDay) {
                      final hasActivities = activitiesMap.containsKey(day);
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: hasActivities ? Colors.green : Colors.transparent,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                day.day.toString(),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 2,
                            left: 2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      final hasActivities = activitiesMap.containsKey(day);
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: hasActivities ? Colors.green : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(day.day.toString()),
                        ),
                      );
                    },
                    // Modify the selectedBuilder to show a small indicator
                    selectedBuilder: (context, day, focusedDay) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(day.day.toString()),
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.blue, // Color for the selected day indicator
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // Key for understanding colors
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          const Text('Recorded Activity'),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          const Text('Today'),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          const Text('Selected Date'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          BottomNavigation(
            selectedIndex: 2,
            onItemTapped: (index) {
              switch (index) {
                case 0:
                  Navigator.of(context).pushReplacementNamed('/');
                  break;
                case 1:
                  Navigator.of(context).pushReplacementNamed('/records');
                  break;
                case 2:
                  // Do nothing, already on Stats
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
