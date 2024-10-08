import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/activity.dart'; // Update with the correct path for activity widget
import 'widgets/current.dart'; // Update with the correct path for current programs widget
import 'widgets/header.dart'; // Update with the correct path for header widget
import 'package:myfitness/widgets/bottom_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  DocumentSnapshot? userDetails; // Variable to store user details
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser; // Get current user
    if (user != null) {
      _fetchUserDetails();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    }
  }

  // Fetch user details from Firestore
  void _fetchUserDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {
        userDetails = snapshot; // Store user details in state
        isLoading = false; // Set loading to false when data is fetched
      });
    } catch (e) {
      print('Error fetching user details: $e');
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
    }
  }

  // Method to refresh the RecentActivities widget
  void _refreshActivities() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading // Check loading state
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : Column(
              children: [
                const AppHeader(), // Header widget
                Expanded(
                  child: Column(
                    children: [
                      CurrentPrograms(onActivityAdded: _refreshActivities), // Current programs widget
                      RecentActivities(onActivityAdded: _refreshActivities), // Recent activities widget
                    ],
                  ),
                ),
                BottomNavigation(
                  selectedIndex: 0,
                  onItemTapped: (index) {
                    switch (index) {
                      case 0:
                        // Do nothing, already on Home
                        break;
                      case 1:
                        Navigator.of(context).pushNamed('/records');
                        break;
                      case 2:
                        Navigator.of(context).pushNamed('/stats');
                        break;
                      case 3:
                        Navigator.of(context).pushNamed('/profile');
                        break;
                    }
                  },
                ),
              ],
            ),
    );
  }
}
