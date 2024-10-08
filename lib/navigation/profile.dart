import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfitness/widgets/bottom_navigation.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userProfileData;
  File? _profileImage;

  // Controllers for height and weight
  final TextEditingController _weightController = TextEditingController();
  double _height = 180; // Default height in cm

  // Add ValueNotifier for profile image
  ValueNotifier<File?> profileImageNotifier = ValueNotifier<File?>(null);

  bool _isEditing = false; // Track if in editing mode

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
          // Fetch image from Firestore URL or set default
          _profileImage = userProfileData?['profile_image'] == null
              ? File('assets/profile.jpg')
              : null;

          // Update ValueNotifier with the current profile image
          profileImageNotifier.value = _profileImage;

          // Set height and weight controllers with user data if available
          _height = userProfileData?['height']?.toDouble() ?? 180.0; // Default to 180 cm
          _weightController.text = userProfileData?['weight'] ?? '';
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
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Logout Failed: $e'),
      ));
    }
  }

  Future<void> _updateProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'height': _height.toInt(), // Store height as an integer
        'weight': _weightController.text,
      });
      setState(() {
        _isEditing = false; // Exit editing mode after saving
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Profile updated successfully!'),
      ));
    }
  }

  String _formatDOB(String dob) {
    DateTime dateOfBirth = DateTime.parse(dob);
    return '${dateOfBirth.day}${_getDaySuffix(dateOfBirth.day)} ${_getMonthName(dateOfBirth.month)} ${dateOfBirth.year}';
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  int _calculateAge(String dob) {
    DateTime dateOfBirth = DateTime.parse(dob);
    DateTime today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month || (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  double convertCmToFeet(double cm) {
    return cm / 30.48; // 1 foot = 30.48 cm
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Modified Header with logo.jpg only
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xff18b0e8), // Adjust the background color if needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png', // Display logo.jpg
                  height: 90, // Adjust the size as needed
                ),
              ],
            ),
          ),
          Expanded(
            child: userProfileData == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView( // Enable scrolling
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Profile Information', style: TextStyle(fontSize: 22)),
                          const SizedBox(height: 20),
                          Center(
                            child: ValueListenableBuilder<File?>( 
                              valueListenable: profileImageNotifier,
                              builder: (context, image, _) {
                                return CircleAvatar(
                                  radius: 60,
                                  backgroundImage: image != null
                                      ? FileImage(image)
                                      : const AssetImage('assets/profile.jpg') as ImageProvider,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text('First Name:', style: TextStyle(color: Colors.blue)),
                          Text('${userProfileData?['first_name'] ?? ''}'),
                          const SizedBox(height: 10), // Increased spacing
                          const Divider(),
                          Text('Last Name:', style: TextStyle(color: Colors.blue)),
                          Text('${userProfileData?['last_name'] ?? ''}'),
                          const SizedBox(height: 10), // Increased spacing
                          const Divider(),
                          Text('Email:', style: TextStyle(color: Colors.blue)),
                          Text('${userProfileData?['email'] ?? ''}'),
                          const SizedBox(height: 10), // Increased spacing
                          const Divider(),
                          Text('Date of Birth:', style: TextStyle(color: Colors.blue)),
                          Text('${_formatDOB(userProfileData?['date_of_birth'] ?? '')}'),
                          Text('Age: ${_calculateAge(userProfileData?['date_of_birth'] ?? '')}', style: TextStyle(color: Colors.blue)),
                          const SizedBox(height: 10), // Increased spacing
                          const Divider(),
                          
                          // Display Height and Weight in a Row
                          if (!_isEditing) ...[                          
                            Row(                           
                              children: [
                                Text('Height:', style: TextStyle(color: Colors.blue)),
                                const SizedBox(width: 8),
                                Text('${_height.toInt()} cm (${convertCmToFeet(_height).toStringAsFixed(1)} ft)'),
                                const SizedBox(width: 24),
                                Text('Weight:', style: TextStyle(color: Colors.blue)),
                                const SizedBox(width: 8),
                                Text('${_weightController.text} kg'),
                              ],
                            ),
                            const SizedBox(height: 25), // Increased spacing
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isEditing = true; // Enter editing mode
                                });
                              },
                              child: const Text('Edit Height/Weight'),
                            ),
                          ] else ...[
                            const Text('Height (cm):', style: TextStyle(color: Colors.blue)),
                            Slider(
                              value: _height,
                              min: 100,
                              max: 250,
                              divisions: 150,
                              label: '${_height.toInt()} cm (${convertCmToFeet(_height).toStringAsFixed(1)} ft)',
                              onChanged: (double value) {
                                setState(() {
                                  _height = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10), // Increased spacing
                            const Text('Weight (kg):', style: TextStyle(color: Colors.blue)),
                            TextField(
                              controller: _weightController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Enter weight',
                              ),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: _updateProfile,
                              child: const Text('Save Changes'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            ),
                          ],
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _logout,
                            child: const Text('Logout'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 3, // Assuming this is the ProfilePage index
        onItemTapped: (index) {
          // Handle bottom navigation
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home'); // Replace with your home route
              break;
            case 1:
              Navigator.pushNamed(context, '/records'); // Replace with your records route
              break;
            case 2:
              Navigator.pushNamed(context, '/stats'); // Replace with your stats route
              break;
            case 3:
              // Stay on the ProfilePage
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
