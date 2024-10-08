import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfitness/pages/home/widgets/header.dart';
import 'package:myfitness/widgets/bottom_navigation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userProfileData;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          userProfileData = userDoc.data();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load profile: $e'),
      ));
    }
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login'); // Go to login page after sign out
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Logout Failed: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: userProfileData == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Profile Information', style: TextStyle(fontSize: 22)),
                        const SizedBox(height: 20),
                        Text('First Name: ${userProfileData?['first_name'] ?? ''}'),
                        Text('Last Name: ${userProfileData?['last_name'] ?? ''}'),
                        Text('Email: ${userProfileData?['email'] ?? ''}'),
                        Text('Date of Birth: ${userProfileData?['date_of_birth'] ?? ''}'),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _logout,
                          child: const Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          BottomNavigation(
            selectedIndex: 3,
            onItemTapped: (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, '/'); // Navigate to home without login check
                  break;
                case 1:
                  Navigator.pushReplacementNamed(context, '/records');
                  break;
                case 2:
                  Navigator.pushReplacementNamed(context, '/stats');
                  break;
                case 3:
                  break; // Stay on profile page
              }
            },
          ),
        ],
      ),
    );
  }
}
