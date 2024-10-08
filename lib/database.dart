import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for user authentication

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new activity with the current timestamp and return the document ID
  Future<String> addActivity(String name, String duration, String calories, String? selectedImage) async {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      DocumentReference docRef = await _firestore
          .collection('users') // Reference to users collection
          .doc(user.uid) // Document for the current user
          .collection('activities') // Sub-collection for activities
          .add({
        'name': name,
        'duration': duration,
        'calories': calories,
        'image': selectedImage, // Add the image field
        'timestamp': FieldValue.serverTimestamp(), // Store the current time
      });
      return docRef.id; // Return the document ID
    } else {
      throw Exception("User not logged in"); // Handle case when user is not logged in
    }
  }

  // Fetch all activities for the current user and order them by timestamp
  Future<List<Map<String, dynamic>>> fetchActivities() async {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('users') // Reference to users collection
          .doc(user.uid) // Document for the current user
          .collection('activities') // Sub-collection for activities
          .orderBy('timestamp', descending: true) // Fetch in descending order of time
          .get();

      return snapshot.docs.map((doc) => {
        'id': doc.id, // Include the document ID in the returned map
        ...doc.data() as Map<String, dynamic>
      }).toList();
    } else {
      throw Exception("User not logged in"); // Handle case when user is not logged in
    }
  }

  // Fetch activities for a specific user by their user ID
  Future<List<Map<String, dynamic>>> fetchActivitiesByUserId(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('users') // Reference to users collection
        .doc(userId) // Document for the specified user
        .collection('activities') // Sub-collection for activities
        .orderBy('timestamp', descending: true) // Fetch in descending order of time
        .get();

    return snapshot.docs.map((doc) => {
      'id': doc.id, // Include the document ID in the returned map
      ...doc.data() as Map<String, dynamic>
    }).toList();
  }

  // Example of updating an activity
  Future<void> updateActivity(String id, String updatedDuration, String updatedCalories, DateTime updatedTimestamp) async {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      await _firestore
          .collection('users') // Reference to users collection
          .doc(user.uid) // Document for the current user
          .collection('activities') // Sub-collection for activities
          .doc(id) // Document ID of the activity to update
          .update({
        'duration': updatedDuration,
        'calories': updatedCalories,
        'timestamp': updatedTimestamp, // Update timestamp if needed
      });
    } else {
      throw Exception("User not logged in"); // Handle case when user is not logged in
    }
  }

  // Example of deleting an activity
  Future<void> deleteActivity(String id) async {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      await _firestore
          .collection('users') // Reference to users collection
          .doc(user.uid) // Document for the current user
          .collection('activities') // Sub-collection for activities
          .doc(id) // Document ID of the activity to delete
          .delete();
    } else {
      throw Exception("User not logged in"); // Handle case when user is not logged in
    }
  }
}
